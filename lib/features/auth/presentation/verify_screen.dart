import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController pinCtrl = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _auth.startCountdown();
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
            text: "Verify", fontWeight: FontWeight.w500, fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 58.h),
            CustomText(
                text: "Enter Verification Code",
                fontSize: 24.h,
                fontWeight: FontWeight.w600,
                color: const Color(0xff0D0D0D)),
            CustomText(
              maxline: 2,
              text:
                  "Enter the verification code we've just sent to your email to continue",
              fontSize: 12.h,
              bottom: 29.h,
              top: 5.h,
            ),

            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: pinCtrl,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 50,
                inactiveColor: AppColors.borderColor,
                selectedColor: AppColors.primaryColor,
                activeColor: AppColors.borderColor,
                disabledColor: AppColors.borderColor,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: false,
              onChanged: (_) => _auth.verifyError(''),
            ),

            SizedBox(height: 8.h),

            // ── API error ──
            Obx(() => _auth.verifyError.value.isNotEmpty
                ? _ErrorBanner(message: _auth.verifyError.value)
                : const SizedBox()),

            SizedBox(height: 8.h),

            // ── Resend row ──
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: _auth.isCountingDown.value
                          ? "Resend in ${_auth.countdown.value}s"
                          : "Didn't get the code?",
                      color: _auth.isCountingDown.value
                          ? Colors.red
                          : Colors.black,
                    ),
                    GestureDetector(
                      onTap: _auth.isCountingDown.value
                          ? null
                          : () {
                              pinCtrl.clear();
                              _auth.verifyError('');
                              _auth.resendOtp();
                            },
                      child: Obx(() => _auth.resendLoading.value
                          ? SizedBox(
                              height: 14.h,
                              width: 14.h,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.red),
                            )
                          : CustomText(
                              text: "Resend",
                              color: _auth.isCountingDown.value
                                  ? Colors.grey
                                  : Colors.red,
                            )),
                    ),
                  ],
                )),

            const Spacer(),
            Obx(() => CustomButtonGradiant(
                  title: "VERIFY",
                  loading: _auth.verifyLoading.value,
                  onpress: () {
                    if (pinCtrl.text.length == 6) {
                      _auth.verifyOtp(pinCtrl.text.trim());
                    } else {
                      _auth.verifyError('Please enter the 6-digit code');
                    }
                  },
                )),
            SizedBox(height: 100.h),
          ],
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
      margin: EdgeInsets.only(bottom: 4.h),
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
