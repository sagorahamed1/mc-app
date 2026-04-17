import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
            text: "Sign In", fontWeight: FontWeight.w500, fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 128.h),
              CustomText(
                  text: "Welcome Back!",
                  fontSize: 24.h,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff0D0D0D)),
              CustomText(
                  text: "Make sure that you already have an account.",
                  fontSize: 12.h,
                  bottom: 29.h,
                  top: 5.h),
              CustomTextField(
                controller: emailCtrl,
                hintText: "Enter Your Email",
                labelText: "Email",
                isEmail: true,
                onChanged: (_) => _auth.loginError(''),
              ),
              CustomTextField(
                controller: passwordCtrl,
                hintText: "Password",
                labelText: "Password",
                isPassword: true,
                onChanged: (_) => _auth.loginError(''),
              ),

              // ── API error ──
              Obx(() => _auth.loginError.value.isNotEmpty
                  ? _ErrorBanner(message: _auth.loginError.value)
                  : const SizedBox()),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.forgotPasswordScreen,
                    arguments: {"email": emailCtrl.text},
                  ),
                  child: CustomText(
                      text: "Forgot Password",
                      color: AppColors.primaryColor),
                ),
              ),

              const Spacer(),
              Obx(() => CustomButtonGradiant(
                    title: "SIGN IN",
                    loading: _auth.logInLoading.value,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.handleLogIn(
                          emailCtrl.text.trim(),
                          passwordCtrl.text.trim(),
                        );
                      }
                    },
                  )),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Inline error banner widget ──
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
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
