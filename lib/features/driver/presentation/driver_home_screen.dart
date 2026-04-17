

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  List summery = [
    {"icon": Assets.icons.pandingIcon.svg(), "title": "Pending"},
    {"icon": Assets.icons.completedIcon.svg(), "title": "Completed"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 60.h, bottom: 20.h, left: 20.w, right: 20.w),
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/homeScreenBg.png"),
                      fit: BoxFit.cover)),
              child: Row(
                children: [
                  CustomNetworkImage(
                      imageUrl:
                      "https://randomuser.me/api/portraits/women/1.jpg",
                      height: 50.h,
                      width: 50.w,
                      boxShape: BoxShape.circle),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "Welcome!",
                          color: Colors.white,
                          fontSize: 12.h),
                      CustomText(text: "Sagor Ahamed", color: Colors.white),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.notificationScreen);
                      },
                      child: const Icon(Icons.notifications, color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  CustomText(
                      text: "Today's Summary",
                      fontWeight: FontWeight.w500,
                      bottom: 16.h),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: summery.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.80,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.5,
                                  offset: const Offset(0.5, 0.5))
                            ],
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 16.w),
                            Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: summery[index]["icon"]),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                    text: "28${index == 3 ? "%" : ""}",
                                    fontSize: 32.h,
                                    color: AppColors.primaryColor),
                                CustomText(
                                  text: "${summery[index]['title']}",
                                )
                              ],
                            ),
                            SizedBox(width: 16.w)
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Upcoming Order", fontWeight: FontWeight.w500),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.allOrderScreen);
                          },
                          child: CustomText(
                              text: "View More",
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor))
                    ],
                  ),



                  SizedBox(height: 10.h),


                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.deliveryDetailsScreen);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 1.5,
                                      offset: const Offset(0.5, 0.5))
                                ],
                                borderRadius: BorderRadius.circular(8.r)),

                            child: Padding(
                              padding:  EdgeInsets.all(12.5.r),
                              child: Row(
                                children: [



                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      CustomText(text: "Store #102", fontSize: 16.h),
                                      CustomText(text: "5th North Avenue, Dhaka-1240", fontSize: 12.h, color: AppColors.textColor5c5c5c),
                                      CustomText(text: "08/08/25 at 4:30 PM", fontSize: 10.h, color: const Color(0xff59B5F7), top: 4.h),

                                    ],
                                  ),




                                  const Spacer(),


                                  Column(
                                    children: [


                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffE7F9FF),
                                          borderRadius: BorderRadius.circular(16.r)
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: 8.h, vertical: 3.h),
                                            child: CustomText(text: "Upcoming", color: AppColors.primaryColor),
                                          ),
                                        ),
                                      ),


                                      SizedBox(height: 26.h),


                                      CustomButton(
                                          height: 25.h,
                                          width: 125.h,
                                          fontSize: 10.h,
                                          borderRadius: 8.r,
                                          loaderIgnore: true,
                                          title: "Start Delivery", onpress: (){}),
                                    ],
                                  )







                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
