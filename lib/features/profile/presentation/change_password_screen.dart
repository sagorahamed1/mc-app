import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  // AuthController authController = Get.find<AuthController>();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController currentPassCtrl = TextEditingController();
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController rePassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              decoration: const BoxDecoration(
                  color: Color(0xffEBEBEB),
                  shape: BoxShape.circle
              ),
              child: const Center(
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: CustomText(
              text: "Change Password", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              CustomTextField(
                  controller: currentPassCtrl,
                  labelText: "Current Password",
                  hintText: "Old password",
                  isPassword: true,
                  contentPaddingVertical: 14.h),
              CustomTextField(
                  controller: newPassCtrl,
                  labelText: "New Password",
                  hintText: "New password",
                  isPassword: true,
                  contentPaddingVertical: 14.h),
              CustomTextField(
                  controller: rePassCtrl,
                  labelText: "Re-enter Password",
                  hintText: "Re-enter new password",
                  isPassword: true,
                  contentPaddingVertical: 14.h,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != newPassCtrl.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },


              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(text: "Forget Password")),
              Spacer(),
              CustomButton(
                  title: "Update Password",
                  onpress: () {

                    if(globalKey.currentState!.validate()){



                    }


                  }),
              SizedBox(height: 80.h)
            ],
          ),
        ),
      ),
    );
  }
}
