import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MerchandiserHomeScreen extends StatefulWidget {
  const MerchandiserHomeScreen({super.key});

  @override
  State<MerchandiserHomeScreen> createState() => _MerchandiserHomeScreenState();
}

class _MerchandiserHomeScreenState extends State<MerchandiserHomeScreen> {

  bool? hasReturns;
  List actions = [
    {"icon": Assets.icons.placeOrder.svg(), "title": "Place Order"},
    {"icon": Assets.icons.report.svg(), "title": "Report"},
    {
      "icon": Assets.icons.missingInvoices.svg(),
      "title": "Missing invoices/stickers"
    },
    {
      "icon": Assets.icons.downloadPreviousSales.svg(),
      "title": "Download  previous sales data"
    }
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
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.notificationScreen);
                      },
                      child:
                          const Icon(Icons.notifications, color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.readUpdateScreen);
                    },
                    child: Container(
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
                        padding: EdgeInsets.all(20.r),
                        child: Row(
                          children: [
                            Assets.icons.messageIcon.svg(),
                            SizedBox(width: 10.w),
                            CustomText(text: "Reads Updates", fontSize: 16.h)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Recent Schedule", fontWeight: FontWeight.w500),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.assignedStoresScreen);
                          },
                          child: CustomText(
                              text: "View More",
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor))
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
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
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "#123456", fontSize: 10.h),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffE7F9FF),
                                    borderRadius: BorderRadius.circular(100.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 4.h),
                                  child: Center(
                                    child: CustomText(
                                        text: "Upcoming",
                                        color: const Color(0xff305CDE),
                                        fontSize: 10.h),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                  text: "Alexandra Store", fontSize: 16.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: "Start Within:", fontSize: 10.h),
                                  Row(
                                    children: [
                                      CustomText(
                                          text: "00:15",
                                          fontSize: 10.h,
                                          color: AppColors.primaryColor),
                                      CustomText(text: "min", fontSize: 8.h),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: "5th North Avenue,Baridhara DOHS",
                                      fontSize: 12.h),
                                  CustomText(
                                      text: "Schedule: 08:00AM - 10.00 AM",
                                      fontSize: 11.h),
                                  CustomText(
                                      text: "Last Visited: 08/08/25 at 4:30 PM",
                                      fontSize: 11.h),
                                ],
                              ),
                              CustomButton(
                                  width: 90.w,
                                  height: 30.h,
                                  borderRadius: 10.r,
                                  loaderIgnore: true,
                                  fontSize: 10.h,
                                  title: "Clock In",
                                  onpress: () {})
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
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
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280.w,
                            child: CustomText(
                                textAlign: TextAlign.center,
                                maxline: 3,
                                text:
                                    "Did this store receive the previous Carrier delivery?",
                                fontSize: 18.h),
                          ),
                          CustomText(
                            text: "Order Date & Time: 08/08/25 at 4:30 PM",
                            fontSize: 10.h,
                            color: const Color(0xff5C5C5C),
                            top: 6.h,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  width: 90.w,
                                  height: 30.h,
                                  borderRadius: 10.r,
                                  loaderIgnore: true,
                                  color: const Color(0xff5C5C5C),
                                  boderColor: Colors.transparent,
                                  fontSize: 10.h,
                                  title: "No",
                                  onpress: () {}),
                              SizedBox(width: 16.w),
                              CustomButton(
                                  width: 90.w,
                                  height: 30.h,
                                  borderRadius: 10.r,
                                  loaderIgnore: true,
                                  fontSize: 10.h,
                                  title: "Yes",
                                  onpress: () {

                                    showReturnsDialog();


                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CustomText(text: "Actions"),
                      CustomText(
                          text: " (required)",
                          fontSize: 10.h,
                          color: Colors.grey),
                    ],
                  ),
                  ListView.builder(
                      itemCount: actions.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Get.toNamed(AppRoutes.productScreen);
                            } else if (index == 1) {
                              //
                              Get.toNamed(AppRoutes.reportScreen);
                            } else if(index == 2){
                              Get.toNamed(AppRoutes.missingStickerScreen);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 12.h),
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
                              padding: EdgeInsets.all(20.r),
                              child: Row(
                                children: [
                                  actions[index]["icon"],
                                  SizedBox(width: 10.w),
                                  CustomText(
                                      text: "${actions[index]["title"]}",
                                      fontSize: 16.h)
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




  void showReturnsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: const Color(0xffFFFFFF),
            ),

            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h),
                CustomText(
                  text: "Are there any returns?",
                  fontSize: 24.h,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: 130.w,
                      height: 40.h,
                      borderRadius: 10.r,
                      loaderIgnore: true,
                      color: const Color(0xffEBEBEB),
                      boderColor: Colors.transparent,
                      fontSize: 14.h,
                      titlecolor: Colors.black,
                      title: "No",
                      onpress: () {
                        setState(() {
                          hasReturns = false;
                        });
                        Get.back();
                      },
                    ),
                    SizedBox(width: 16.w),
                    CustomButton(
                      width: 130.w,
                      height: 40.h,
                      borderRadius: 10.r,
                      color: const Color(0xff182E6F),
                      loaderIgnore: true,
                      fontSize: 14.h,
                      title: "Yes",
                      onpress: () {
                        setState(() {
                          hasReturns = true;
                        });
                        Get.toNamed(AppRoutes.manageReturnSreen);
                        // Navigate to returns screen
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
