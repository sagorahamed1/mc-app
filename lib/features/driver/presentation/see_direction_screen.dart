import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class SeeDirectionScreen extends StatefulWidget {
  const SeeDirectionScreen({super.key});

  @override
  State<SeeDirectionScreen> createState() => _SeeDirectionScreenState();
}

class _SeeDirectionScreenState extends State<SeeDirectionScreen> {
  static const String _apiKey = 'AIzaSyAX3YRL9gQ9gCkV5CsTDqUXaWTf6BVFfyA';
  static const Color _routeBlue = Color(0xff4285F4);

  late final OrderModel _order;
  late final LatLng _storeLocation;   // fixed from API, never changes

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  LatLng? _currentPosition;
  LatLng? _pendingOrigin;             // queues latest position while fetch runs
  StreamSubscription<Position>? _positionSub;

  bool _isLoadingRoute = false;
  bool _firstRouteDone = false;       // fit bounds only on first load
  double? _distanceKm;
  String? _duration;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as OrderModel;
    _storeLocation = LatLng(_order.store.lat, _order.store.lng);
    _addStoreMarker();
    _initLocation();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Store marker (fixed) ─────────────────────────────────────────────────

  void _addStoreMarker() {
    _markers.add(Marker(
      markerId: const MarkerId('store'),
      position: _storeLocation,
      infoWindow: InfoWindow(
        title: _order.store.name,
        snippet: _order.store.address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  // ── Location permission & stream ──────────────────────────────────────────

  Future<void> _initLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        Get.snackbar('Location', 'Please enable location services',
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      if (mounted) {
        Get.snackbar('Location', 'Location permission denied',
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    // Immediate fix
    final initial = await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
    );
    _onPositionUpdate(initial);

    // Live stream — triggers every 15 m of movement
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    ).listen(_onPositionUpdate);
  }

  void _onPositionUpdate(Position pos) {
    final latlng = LatLng(pos.latitude, pos.longitude);
    if (mounted) setState(() => _currentPosition = latlng);
    _fetchRoute(latlng);
  }

  // ── Directions API ────────────────────────────────────────────────────────

  Future<void> _fetchRoute(LatLng origin) async {
    // While a fetch is in flight, just queue the latest position
    if (_isLoadingRoute) {
      _pendingOrigin = origin;
      return;
    }
    if (mounted) setState(() => _isLoadingRoute = true);

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${_storeLocation.latitude},${_storeLocation.longitude}'
        '&mode=driving'
        '&alternatives=false'
        '&key=$_apiKey',
      );

      final response = await http.get(uri);
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final leg = routes[0]['legs'][0] as Map<String, dynamic>;

          // Decode every step's polyline for maximum detail
          final allPoints = <LatLng>[];
          for (final step in (leg['steps'] as List)) {
            allPoints.addAll(
              _decodePolyline(step['polyline']['points'] as String),
            );
          }

          final distMeters = (leg['distance']['value'] as num).toInt();
          final durationText = leg['duration']['text'] as String;

          if (mounted) {
            setState(() {
              _distanceKm = distMeters / 1000;
              _duration = durationText;
              _polylines
                ..clear()
                // ── White halo (border) ──────────────────────────────────
                ..add(Polyline(
                  polylineId: const PolylineId('route_border'),
                  points: allPoints,
                  color: Colors.white,
                  width: 12,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                  zIndex: 1,
                ))
                // ── Google blue route on top ─────────────────────────────
                ..add(Polyline(
                  polylineId: const PolylineId('route'),
                  points: allPoints,
                  color: _routeBlue,
                  width: 7,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                  zIndex: 2,
                ));
            });

            if (!_firstRouteDone) {
              // First load → show full route from origin to destination
              _firstRouteDone = true;
              _fitBounds(origin);
            } else {
              // Subsequent updates → keep camera on user
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(origin),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Direction fetch error: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
      // Process any position that arrived while we were fetching
      if (_pendingOrigin != null) {
        final next = _pendingOrigin!;
        _pendingOrigin = null;
        _fetchRoute(next);
      }
    }
  }

  // ── Google Encoded Polyline Algorithm decoder ─────────────────────────────

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0, lat = 0, lng = 0;
    while (index < encoded.length) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  // Fit camera to show both origin and store
  void _fitBounds(LatLng origin) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            origin.latitude < _storeLocation.latitude
                ? origin.latitude
                : _storeLocation.latitude,
            origin.longitude < _storeLocation.longitude
                ? origin.longitude
                : _storeLocation.longitude,
          ),
          northeast: LatLng(
            origin.latitude > _storeLocation.latitude
                ? origin.latitude
                : _storeLocation.latitude,
            origin.longitude > _storeLocation.longitude
                ? origin.longitude
                : _storeLocation.longitude,
          ),
        ),
        80,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
        title: CustomText(
            text: "See Direction",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Stack(
        children: [
          // ── Full-screen map ──────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _storeLocation,
              zoom: 14,
            ),
            markers: Set.from(_markers),
            polylines: Set.from(_polylines),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            trafficEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_currentPosition != null && _firstRouteDone) {
                _fitBounds(_currentPosition!);
              }
            },
          ),

          // ── Route-updating pill (top center) ────────────────────────────
          if (_isLoadingRoute)
            Positioned(
              top: 12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 13.h,
                        width: 13.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _routeBlue,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      CustomText(
                        text: 'Updating route…',
                        fontSize: 11.h,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Bottom card ──────────────────────────────────────────────────
          Positioned(
            bottom: 24.h,
            left: 16.w,
            right: 16.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: _distanceKm != null ? _routeCard() : _waitingCard(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom cards ──────────────────────────────────────────────────────────

  Widget _routeCard() {
    return Container(
      key: const ValueKey('route'),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoTile(
            icon: Icons.directions_car_rounded,
            value: '${_distanceKm!.toStringAsFixed(1)} km',
            label: 'Distance',
          ),
          Container(height: 40.h, width: 1, color: Colors.grey.shade200),
          _infoTile(
            icon: Icons.access_time_rounded,
            value: _duration ?? '—',
            label: 'Duration',
          ),
          Container(height: 40.h, width: 1, color: Colors.grey.shade200),
          _infoTile(
            icon: Icons.store_rounded,
            value: _order.store.name,
            label: 'Destination',
            maxline: 2,
          ),
        ],
      ),
    );
  }

  Widget _waitingCard() {
    return Container(
      key: const ValueKey('wait'),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 16.h,
            width: 16.h,
            child: const CircularProgressIndicator(
                strokeWidth: 2, color: _routeBlue),
          ),
          SizedBox(width: 10.w),
          CustomText(text: 'Getting your location…', fontSize: 13.h),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String value,
    required String label,
    int? maxline,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _routeBlue, size: 22.r),
        SizedBox(height: 4.h),
        SizedBox(
          width: 78.w,
          child: CustomText(
            text: value,
            fontWeight: FontWeight.w600,
            fontSize: 12.h,
            textAlign: TextAlign.center,
            maxline: maxline,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
        CustomText(text: label, fontSize: 10.h, color: Colors.grey),
      ],
    );
  }
}
