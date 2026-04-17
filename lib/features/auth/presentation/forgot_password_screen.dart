import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args["email"] != null) {
      emailCtrl.text = args["email"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            text: "Forgot password",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 58.h),
              CustomText(
                  text: "Forget Your Password?",
                  fontSize: 24.h,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff0D0D0D)),
              CustomText(
                maxline: 2,
                text:
                    "Don't worry! It happens. Please enter the email associated with your account.",
                fontSize: 12.h,
                bottom: 29.h,
                top: 5.h,
              ),
              CustomTextField(
                controller: emailCtrl,
                hintText: "Enter Your Email",
                labelText: "Email",
                isEmail: true,
                onChanged: (_) => _auth.forgotError(''),
              ),

              // ── API error ──
              Obx(() => _auth.forgotError.value.isNotEmpty
                  ? _ErrorBanner(message: _auth.forgotError.value)
                  : const SizedBox()),

              const Spacer(),
              Obx(() => CustomButtonGradiant(
                    title: "SEND CODE",
                    loading: _auth.forgotLoading.value,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.handleForgotPassword(emailCtrl.text.trim());
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
