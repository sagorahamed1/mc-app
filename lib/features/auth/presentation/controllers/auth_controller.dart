import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/services/storage_service.dart';

class AuthController extends GetxController {

  // ─────────────────────── User Profile (reactive) ───────────────────────
  final RxString userName = ''.obs;
  final RxString userImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName(await PrefsHelper.getString(AppConstants.name));
    userImage(await PrefsHelper.getString(AppConstants.image));
  }

  // ─────────────────────── Login ───────────────────────
  final RxBool logInLoading = false.obs;
  final RxString loginError = ''.obs;

  Future<void> handleLogIn(String email, String password) async {
    loginError('');
    logInLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.signInEndPoint,
      {"email": email, "password": password},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final user = response.body['data']['user'];
      final tokens = response.body['data']['tokens'];

      await Future.wait([
        PrefsHelper.setString(AppConstants.userId, user['_id'] ?? ''),
        PrefsHelper.setString(AppConstants.name, user['name'] ?? ''),
        PrefsHelper.setString(AppConstants.email, user['email'] ?? ''),
        PrefsHelper.setString(AppConstants.phone, user['phone'] ?? ''),
        PrefsHelper.setString(AppConstants.address, user['address'] ?? ''),
        PrefsHelper.setString(AppConstants.image, user['profileImage'] ?? ''),
        PrefsHelper.setString(AppConstants.role, user['role'] ?? ''),
        PrefsHelper.setString(AppConstants.bearerToken, tokens['accessToken'] ?? ''),
        PrefsHelper.setString(AppConstants.refreshToken, tokens['refreshToken'] ?? ''),
        PrefsHelper.setBool(AppConstants.isLogged, true),
      ]);

      userName(user['name'] ?? '');
      userImage(user['profileImage'] ?? '');

      final role = user['role'] as String;
      if (role == 'merchandiser') {
        Get.offAllNamed(AppRoutes.merchandiserBottomNavBar);
      } else if (role == 'driver') {
        Get.offAllNamed(AppRoutes.driverBottomNavBar);
      } else {
        Get.offAllNamed(AppRoutes.wareHouseBottomNavBar);
      }
    } else {
      loginError(_extractMessage(response.body, 'Login failed'));
    }

    logInLoading(false);
  }

  // ─────────────────────── Forgot Password ───────────────────────
  final RxBool forgotLoading = false.obs;
  final RxString forgotError = ''.obs;

  Future<void> handleForgotPassword(String email) async {
    forgotError('');
    forgotLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.forgotPasswordPoint,
      {"email": email},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = response.body['data']['resetPasswordToken'] ?? '';
      await PrefsHelper.setString(AppConstants.bearerToken, token);
      Get.toNamed(AppRoutes.verifyScreen);
    } else {
      forgotError(_extractMessage(response.body, 'Failed to send code'));
    }

    forgotLoading(false);
  }

  // ─────────────────────── Verify OTP ───────────────────────
  final RxBool verifyLoading = false.obs;
  final RxString verifyError = ''.obs;

  Future<void> verifyOtp(String otp) async {
    verifyError('');
    verifyLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.verifyEmailEndPoint,
      {"otp": otp},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(AppRoutes.resetPasswordScreen);
    } else {
      verifyError(_extractMessage(response.body, 'Invalid OTP code'));
    }

    verifyLoading(false);
  }

  // ─────────────────────── Resend OTP ───────────────────────
  final RxBool resendLoading = false.obs;

  Future<void> resendOtp() async {
    resendLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.resendOtpEndPoint,
      {},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      startCountdown();
    }

    resendLoading(false);
  }

  // ─────────────────────── Reset Password ───────────────────────
  final RxBool resetLoading = false.obs;
  final RxString resetError = ''.obs;

  Future<void> resetPassword(String password, String confirmPassword) async {
    resetError('');

    if (password != confirmPassword) {
      resetError("Passwords don't match");
      return;
    }

    resetLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.setPasswordEndPoint,
      {"password": password, "confirmPassword": confirmPassword},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      resetError(_extractMessage(response.body, 'Reset failed'));
    }

    resetLoading(false);
  }

  // ─────────────────────── Change Password ───────────────────────
  final RxBool changePasswordLoading = false.obs;
  final RxString changePasswordError = ''.obs;

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String confirmPassword,
  }) async {
    changePasswordError('');
    changePasswordLoading(true);

    final response = await ApiClient.postData(
      ApiConstants.changePassword,
      {
        "currentPassword": currentPassword,
        "password": password,
        "confirmPassword": confirmPassword,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.back();
    } else {
      changePasswordError(_extractMessage(response.body, 'Failed to change password'));
    }

    changePasswordLoading(false);
  }

  // ─────────────────────── Update Profile ───────────────────────
  final RxBool updateLoading = false.obs;
  final RxString updateError = ''.obs;

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String dateOfBirth,
    required String address,
    File? imageFile,
  }) async {
    updateError('');
    updateLoading(true);

    final fields = {
      'name': name,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'address': address,
    };

    final response = await ApiClient.putMultipartData(
      ApiConstants.updateProfileEndPoint,
      fields,
      multipartBody: imageFile != null ? [MultipartBody('profileImage', imageFile)] : [],
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.body['data'];
      final user = data is Map && data['user'] != null ? data['user'] : data;

      final newImage = user['profileImage']?.toString() ?? await PrefsHelper.getString(AppConstants.image);

      await Future.wait([
        PrefsHelper.setString(AppConstants.name, name),
        PrefsHelper.setString(AppConstants.phone, phone),
        PrefsHelper.setString(AppConstants.address, address),
        PrefsHelper.setString(AppConstants.dateOfBirth, dateOfBirth),
        PrefsHelper.setString(AppConstants.image, newImage),
      ]);

      userName(name);
      userImage(newImage);

      Get.back();
    } else {
      updateError(_extractMessage(response.body, 'Update failed'));
    }

    updateLoading(false);
  }

  // ─────────────────────── Logout ───────────────────────
  Future<void> handleLogout() async {
    await ApiClient.postData(
      ApiConstants.logoutEndPoint,
      {},
    );
    await _clearLocalData();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  Future<void> _clearLocalData() async {
    await Future.wait([
      PrefsHelper.remove(AppConstants.userId),
      PrefsHelper.remove(AppConstants.name),
      PrefsHelper.remove(AppConstants.email),
      PrefsHelper.remove(AppConstants.phone),
      PrefsHelper.remove(AppConstants.address),
      PrefsHelper.remove(AppConstants.image),
      PrefsHelper.remove(AppConstants.role),
      PrefsHelper.remove(AppConstants.bearerToken),
      PrefsHelper.remove(AppConstants.refreshToken),
      PrefsHelper.remove(AppConstants.isLogged),
    ]);
  }

  // ─────────────────────── OTP Countdown ───────────────────────
  final RxInt countdown = 180.obs;
  final RxBool isCountingDown = false.obs;

  void startCountdown() {
    isCountingDown(true);
    countdown(180);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown(countdown.value - 1);
      } else {
        timer.cancel();
        isCountingDown(false);
      }
    });
  }

  // ─────────────────────── Helper ───────────────────────
  String _extractMessage(dynamic body, String fallback) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
    return fallback;
  }
}
