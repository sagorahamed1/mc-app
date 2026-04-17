import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';

import 'package:mc/shared/widgets/custom_text.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
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
              text: "Delivery Detail",
              fontWeight: FontWeight.w500,
              fontSize: 18.h)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customColumn("Order Id", "#123456"),
            _customColumn("Store's Id", "#64511"),
            _customColumn("Store's Name", "Max"),
            _customColumn("Store's Address", "5th North Avenue"),
            _customColumn("Pickup Date", "10/10/2025"),
            _customColumn("Expected Date", "10/11/2025"),
            _customColumn("Tracking Number", "#452142"),

            SizedBox(height: 45.h),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        title: "See Direction",
                        loaderIgnore: true,
                        onpress: () {},
                        color: const Color(0xff767676),
                        boderColor: Colors.transparent)),
                SizedBox(width: 12.w),
                Expanded(
                    child: CustomButton(
                        title: "View Invoice",
                        loaderIgnore: true,
                        onpress: () {},
                        color: const Color(0xffC2B067),
                        boderColor: Colors.transparent)),
              ],
            ),

            SizedBox(height: 16.h),
            CustomButton(title: "Edit Quantity", onpress: () {
              Get.toNamed(AppRoutes.confirmationScreen);
            }),
            SizedBox(height: 16.h),
            CustomButton(title: "I Have Arrived", onpress: () {

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                            text: "Are there any returns",
                            fontSize: 16.h,
                            fontWeight: FontWeight.w600,
                            top: 20.h,
                            bottom: 12.h,
                            color: const Color(0xff592B00)),
                        // const Divider(),
                        SizedBox(height: 12.h),
                        CustomText(
                          maxline: 2,
                          bottom: 20.h,
                          text: "",
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                  height: 50.h,
                                  title: "Print",
                                  onpress: () {
                                    Get.back();
                                  },
                                  color: Colors.transparent,
                                  fontSize: 11.h,
                                  loaderIgnore: true,
                                  boderColor: Colors.black,
                                  titlecolor: Colors.black),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                  loading: false,
                                  loaderIgnore: true,
                                  height: 50.h,
                                  title: "Yes",
                                  onpress: () {
                                    Get.toNamed(AppRoutes.manageReturnSreen);
                                  },
                                  fontSize: 11.h),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );


            }),
          ],
        ),
      ),
    );
  }

  _customColumn(String title, subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        CustomText(text: "$title", fontWeight: FontWeight.w600, fontSize: 16),
        CustomText(
            text: "$subTitle", fontSize: 12.h, color: AppColors.textColor5c5c5c)
      ],
    );
  }
}
