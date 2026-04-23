import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';

class DriverController extends GetxController {
  // ── Dashboard ─────────────────────────────────────────────────────────
  final RxInt dashPending = 0.obs;
  final RxInt dashCompleted = 0.obs;
  final RxBool isDashboardLoading = false.obs;

  // ── Home upcoming (driver_assigned, limit 5) ──────────────────────────
  final RxList<OrderModel> upcomingOrders = <OrderModel>[].obs;
  final RxBool isUpcomingLoading = false.obs;

  // ── Order screen (all driver orders, paginated) ───────────────────────
  final RxList<OrderModel> orderScreenOrders = <OrderModel>[].obs;
  final RxBool isOrderScreenLoading = false.obs;
  final RxBool isOrderScreenPaginationLoading = false.obs;
  final ScrollController orderScreenScroll = ScrollController();
  int _orderScreenPage = 1;
  bool _orderScreenHasMore = true;

  static const int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
    loadUpcomingOrders();
    orderScreenScroll.addListener(_onOrderScreenScroll);
    loadOrderScreenOrders();
  }

  @override
  void onClose() {
    orderScreenScroll.dispose();
    super.onClose();
  }

  void _onOrderScreenScroll() {
    if (orderScreenScroll.position.pixels >=
            orderScreenScroll.position.maxScrollExtent - 200 &&
        !isOrderScreenPaginationLoading.value &&
        _orderScreenHasMore) {
      _fetchOrders(
        page: _orderScreenPage + 1,
        list: orderScreenOrders,
        append: true,
        pageRef: (p) => _orderScreenPage = p,
        hasMoreRef: (v) => _orderScreenHasMore = v,
        paginationLoading: isOrderScreenPaginationLoading,
      );
    }
  }

  Future<void> fetchDashboard() async {
    isDashboardLoading(true);
    final response = await ApiClient.getData(ApiConstants.driverDashboard);
    if (response.statusCode == 200) {
      final data = response.body['data'] ?? {};
      dashPending(data['pendingOrders'] ?? 0);
      dashCompleted(data['completedOrders'] ?? 0);
    }
    isDashboardLoading(false);
  }

  Future<void> loadUpcomingOrders() async {
    isUpcomingLoading(true);
    final response = await ApiClient.getData(
      '${ApiConstants.orderEndPoint}?page=1&limit=10&status=driver_assigned',
    );
    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      upcomingOrders.assignAll(data.map((e) => OrderModel.fromJson(e)));
    }
    isUpcomingLoading(false);
  }

  Future<void> loadOrderScreenOrders({bool refresh = false}) async {
    if (refresh) {
      _orderScreenPage = 1;
      _orderScreenHasMore = true;
      orderScreenOrders.clear();
    }
    await _fetchOrders(
      page: 1,
      list: orderScreenOrders,
      append: false,
      pageRef: (p) => _orderScreenPage = p,
      hasMoreRef: (v) => _orderScreenHasMore = v,
      mainLoading: isOrderScreenLoading,
    );
  }

  Future<void> _fetchOrders({
    required int page,
    required RxList<OrderModel> list,
    required bool append,
    required void Function(int) pageRef,
    required void Function(bool) hasMoreRef,
    RxBool? mainLoading,
    RxBool? paginationLoading,
  }) async {
    if (!append) mainLoading?.call(true);
    if (append) paginationLoading?.call(true);

    final uri = '${ApiConstants.orderEndPoint}?page=$page&limit=$_limit';
    final response = await ApiClient.getData(uri);

    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final pagination = response.body['pagination'] ?? {};
      final orders = data.map((e) => OrderModel.fromJson(e)).toList();
      if (append) {
        list.addAll(orders);
      } else {
        list.assignAll(orders);
      }
      pageRef(page);
      hasMoreRef(page < (pagination['totalPages'] ?? 1));
    }

    if (!append) mainLoading?.call(false);
    if (append) paginationLoading?.call(false);
  }

  // ── Single order detail ───────────────────────────────────────────────
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);
  final RxBool isOrderLoading = false.obs;

  Future<void> fetchOrderById(String orderId) async {
    isOrderLoading(true);
    currentOrder.value = null;
    final response = await ApiClient.getData(ApiConstants.getOrderById(orderId));
    if (response.statusCode == 200) {
      currentOrder.value = OrderModel.fromJson(response.body['data']);
    } else {
      ToastMessageHelper.showToastMessage(
        response.body?['message'] ?? 'Failed to load order',
        title: 'Error',
      );
    }
    isOrderLoading(false);
  }

  // ── Actions ───────────────────────────────────────────────────────────
  final RxBool isManageReturnsLoading = false.obs;
  final RxBool isDeliverLoading = false.obs;
  final RxBool isCompleteLoading = false.obs;

  Future<bool> manageReturns({
    required String orderId,
    required List<Map<String, dynamic>> products,
  }) async {
    isManageReturnsLoading(true);
    final body = jsonEncode({'products': products});
    final response = await ApiClient.patch(
      ApiConstants.manageReturns(orderId),
      body,
    );
    isManageReturnsLoading(false);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    ToastMessageHelper.showToastMessage(
      response.body?['message'] ?? 'Failed to submit returns',
      title: 'Error',
    );
    return false;
  }

  Future<bool> deliverOrder(String orderId) async {
    isDeliverLoading(true);
    final response = await ApiClient.patch(
      ApiConstants.deliverOrder(orderId),
      null,
    );
    isDeliverLoading(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      loadUpcomingOrders();
      loadOrderScreenOrders(refresh: true);
      return true;
    }
    ToastMessageHelper.showToastMessage(
      response.body?['message'] ?? 'Failed to update order',
      title: 'Error',
    );
    return false;
  }

  Future<bool> completeOrder({
    required String orderId,
    required String receiverName,
    List<File> stickerFiles = const [],
  }) async {
    isCompleteLoading(true);

    // Upload stickers first if any
    List<String> stickerUrls = [];
    if (stickerFiles.isNotEmpty) {
      stickerUrls = await _uploadStickers(stickerFiles);
      if (stickerUrls.isEmpty) {
        isCompleteLoading(false);
        return false;
      }
    }

    final body = <String, dynamic>{'receiverName': receiverName};
    if (stickerUrls.isNotEmpty) body['stickers'] = stickerUrls;

    final response = await ApiClient.patch(
      ApiConstants.completeOrder(orderId),
      jsonEncode(body),
    );
    isCompleteLoading(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      loadUpcomingOrders();
      loadOrderScreenOrders(refresh: true);
      return true;
    }
    ToastMessageHelper.showToastMessage(
      response.body?['message'] ?? 'Failed to complete order',
      title: 'Error',
    );
    return false;
  }

  Future<List<String>> _uploadStickers(List<File> files) async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.uploadMultiple);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    for (final file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }
    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final decoded = jsonDecode(body);
        return List<String>.from(decoded['data'] ?? []);
      }
    } catch (e) {
      debugPrint('Sticker upload error: $e');
    }
    ToastMessageHelper.showToastMessage('Sticker upload failed', title: 'Error');
    return [];
  }
}
