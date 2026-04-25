import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
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
  final AuthController _auth = Get.find<AuthController>();
  final DriverController _ctrl = Get.find<DriverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
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
                  Obx(() {
                    if (_auth.isUserLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.4),
                        highlightColor: Colors.white.withOpacity(0.8),
                        child: Container(
                          height: 50.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      );
                    }
                    return CustomNetworkImage(
                      border: Border.all(color: Colors.grey, width: 0.5.r),
                      imageUrl:
                          "${ApiConstants.imageBaseUrl}/" + _auth.userImage.value,
                      height: 50.h,
                      width: 50.w,
                      boxShape: BoxShape.circle,
                    );
                  }),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "Welcome!", color: Colors.white, fontSize: 12.h),
                      Obx(() {
                        if (_auth.isUserLoading.value) {
                          return Shimmer.fromColors(
                            baseColor: Colors.white.withOpacity(0.4),
                            highlightColor: Colors.white.withOpacity(0.8),
                            child: Container(
                              height: 14.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          );
                        }
                        return CustomText(
                            text: _auth.userName.value, color: Colors.white);
                      }),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                      child:
                          const Icon(Icons.notifications, color: Colors.white)),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // ── Today's Summary ──────────────────────────────────
                  CustomText(
                      text: "Today's Summary",
                      fontWeight: FontWeight.w500,
                      bottom: 16.h),
                  Obx(() {
                    if (_ctrl.isDashboardLoading.value) {
                      return _SummaryShimmer();
                    }
                    final items = [
                      {
                        "icon": Assets.icons.pandingIcon.svg(),
                        "title": "Pending",
                        "value": _ctrl.dashPending.value.toString()
                      },
                      {
                        "icon": Assets.icons.completedIcon.svg(),
                        "title": "Completed",
                        "value": _ctrl.dashCompleted.value.toString()
                      },
                    ];
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.80,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h),
                      itemBuilder: (context, index) {
                        final item = items[index];
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
                                  child: item["icon"] as Widget),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                      text: item["value"] as String,
                                      fontSize: 32.h,
                                      color: AppColors.primaryColor),
                                  CustomText(text: item['title'] as String),
                                ],
                              ),
                              SizedBox(width: 16.w),
                            ],
                          ),
                        );
                      },
                    );
                  }),

                  SizedBox(height: 10.h),

                  // ── Upcoming Orders ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Upcoming Order",
                          fontWeight: FontWeight.w500),
                      GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.driverOrderScreen)
                              ?.then((_) {
                            _ctrl.fetchDashboard();
                            _ctrl.loadUpcomingOrders();
                          }),
                          child: CustomText(
                              text: "View More",
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor)),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Obx(() {
                    if (_ctrl.isUpcomingLoading.value) {
                      return Column(
                        children: List.generate(
                            3, (_) => _OrderCardShimmer()),
                      );
                    }
                    if (_ctrl.upcomingOrders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: CustomText(
                              text: "No upcoming orders",
                              color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ctrl.upcomingOrders.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final order = _ctrl.upcomingOrders[index];
                        final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
                            .format(order.createdAt.toLocal());
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                              AppRoutes.deliveryDetailsScreen,
                              arguments: order)?.then((_) {
                            _ctrl.fetchDashboard();
                            _ctrl.loadUpcomingOrders();
                          }),
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
                              padding: EdgeInsets.all(12.5.r),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          text: order.store.storeNumber,
                                          fontSize: 16.h),
                                      CustomText(
                                          text: order.store.address,
                                          fontSize: 12.h,
                                          color: AppColors.textColor5c5c5c),
                                      CustomText(
                                          text: dateStr,
                                          fontSize: 10.h,
                                          color: const Color(0xff59B5F7),
                                          top: 4.h),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE7F9FF),
                                            borderRadius:
                                                BorderRadius.circular(16.r)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h, vertical: 3.h),
                                          child: CustomText(
                                              text: "Upcoming",
                                              color: AppColors.primaryColor),
                                        ),
                                      ),
                                      SizedBox(height: 26.h),
                                      CustomButton(
                                          height: 25.h,
                                          width: 95.h,
                                          fontSize: 10.h,
                                          borderRadius: 8.r,
                                          loaderIgnore: true,
                                          title: "Start Delivery",
                                          onpress: () {}),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

// ── Shimmer widgets ──────────────────────────────────────────────────────────

class _SummaryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.80,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
}

class _OrderCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.5.r),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 16.h,
                    width: 100.w,
                    color: Colors.white),
                SizedBox(height: 6.h),
                Container(
                    height: 12.h,
                    width: 160.w,
                    color: Colors.white),
                SizedBox(height: 6.h),
                Container(
                    height: 10.h,
                    width: 120.w,
                    color: Colors.white),
              ],
            ),
            const Spacer(),
            Container(
                height: 25.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r))),
          ],
        ),
      ),
    );
  }
}
