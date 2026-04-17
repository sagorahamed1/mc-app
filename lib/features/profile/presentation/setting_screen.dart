

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';

import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              text: "Setting", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.all(20.r),
        child: Column(
          children: [


            _customCard(Assets.icons.lock.svg(), "Change Password", (){
              Get.toNamed(AppRoutes.changePasswordScreen);
            }),


            SizedBox(height: 22.h),


            _customCard(Assets.icons.termsIcons.svg(), "Terms & Condition", (){

              Get.toNamed(AppRoutes.privacyPolicyAllScreen, arguments: {
                "title" : "Terms of service",
              });

            }),






            SizedBox(height: 22.h),


            _customCard(Assets.icons.privacy.svg(), "Privacy Policy", (){

              Get.toNamed(AppRoutes.privacyPolicyAllScreen, arguments: {
                "title" : "Privacy Policy",
              });
            }),






            SizedBox(height: 22.h),


            _customCard(Assets.icons.about.svg(), "About Us", (){


              Get.toNamed(AppRoutes.privacyPolicyAllScreen, arguments: {
                "title" : "About Us",
              });

            }),



          ],
        ),
      ),

    );
  }


  Widget _customCard(Widget icon, String title, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 1.5,
              offset: const Offset(0.5, 0.5),
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
        ),


        child: Padding(
          padding:  EdgeInsets.all(13.r),
          child: Row(
            children: [


              icon,

              SizedBox(width: 12.w),

              CustomText(text: "${title}"),

              const Spacer(),


              const Icon(Icons.arrow_right)


            ],
          ),
        ),
      ),
    );

  }
}
