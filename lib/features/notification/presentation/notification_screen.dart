

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/utils/app_colors.dart';

import 'package:mc/shared/widgets/custom_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: CustomText(
            text: "Notifications", fontSize: 18.h, fontWeight: FontWeight.w500),
      ),



      body: Padding(
        padding:  EdgeInsets.all(20.r),
        child: Column(
          children: [



            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10.h, left: 2.w, right: 2.w, bottom: 4.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 1.5,
                            offset: const Offset(0.5, 0.5)
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.r)
                  ),

                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 23.h, horizontal: 10.w),
                    child: Row(
                      children: [

                        const Icon(Icons.notifications, color: AppColors.primaryColor),

                        CustomText(text: "You got assigned by manager", left: 4.w),


                        Spacer(),



                        CustomText(text: "4:30 PM", fontSize: 10.h, color: Colors.grey)


                      ],
                    ),
                  ),
                );
              },),
            )




          ],
        ),
      ),

    );
  }
}
