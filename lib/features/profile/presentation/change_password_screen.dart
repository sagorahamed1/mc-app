import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final AuthController _auth = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentPassCtrl = TextEditingController();
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController rePassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            text: "Change Password",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              CustomTextField(
                controller: currentPassCtrl,
                labelText: "Current Password",
                hintText: "Enter current password",
                isPassword: true,
                contentPaddingVertical: 14.h,
                onChanged: (_) => _auth.changePasswordError(''),
              ),
              CustomTextField(
                controller: newPassCtrl,
                labelText: "New Password",
                hintText: "Enter new password",
                isPassword: true,
                contentPaddingVertical: 14.h,
                onChanged: (_) => _auth.changePasswordError(''),
              ),
              CustomTextField(
                controller: rePassCtrl,
                labelText: "Re-enter Password",
                hintText: "Re-enter new password",
                isPassword: true,
                contentPaddingVertical: 14.h,
                onChanged: (_) => _auth.changePasswordError(''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != newPassCtrl.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              // ── API error ──
              Obx(() => _auth.changePasswordError.value.isNotEmpty
                  ? _ErrorBanner(message: _auth.changePasswordError.value)
                  : const SizedBox()),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.forgotPasswordScreen,
                      arguments: {"email": ""}),
                  child: CustomText(
                      text: "Forgot Password",
                      color: Colors.blue,
                      fontSize: 12.h),
                ),
              ),

              const Spacer(),

              Obx(() => CustomButton(
                    title: "Update Password",
                    loading: _auth.changePasswordLoading.value,
                    loaderIgnore: false,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.changePassword(
                          currentPassword: currentPassCtrl.text.trim(),
                          password: newPassCtrl.text.trim(),
                          confirmPassword: rePassCtrl.text.trim(),
                        );
                      }
                    },
                  )),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 16.h),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
