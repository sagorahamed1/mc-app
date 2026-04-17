import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLogged = await PrefsHelper.getBool(AppConstants.isLogged);
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final role = await PrefsHelper.getString(AppConstants.role);

    if (isLogged && token.isNotEmpty) {
      if (role == 'merchandiser') {
        Get.offAllNamed(AppRoutes.merchandiserBottomNavBar);
      } else if (role == 'driver') {
        Get.offAllNamed(AppRoutes.driverBottomNavBar);
      } else {
        Get.offAllNamed(AppRoutes.wareHouseBottomNavBar);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            RotationTransition(
              turns: _controller,
              child: Assets.images.splashLoading.image(
                width: 60.w,
                height: 60.h,
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
