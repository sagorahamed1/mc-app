import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/features/warehouse/presentation/controllers/warehouse_order_controller.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class WareHouseHomeScreen extends StatefulWidget {
  const WareHouseHomeScreen({super.key});

  @override
  State<WareHouseHomeScreen> createState() => _WareHouseHomeScreenState();
}

class _WareHouseHomeScreenState extends State<WareHouseHomeScreen> {
  final WarehouseOrderController _ctrl = Get.find<WarehouseOrderController>();
  final AuthController _auth = Get.find<AuthController>();

  List<Map<String, dynamic>> get _summary => [
    {"icon": Assets.icons.pandingIcon.svg(), "title": "Pending", "value": _ctrl.dashPending.value.toString()},
    {"icon": Assets.icons.completedIcon.svg(), "title": "Completed", "value": _ctrl.dashCompleted.value.toString()},
    {"icon": Assets.icons.unitIcon.svg(), "title": "Total Unit", "value": _ctrl.dashTotalUnits.value.toString()},
    {"icon": Assets.icons.averageScore.svg(), "title": "Average Score", "value": _ctrl.dashAvgMark.value.toStringAsFixed(1)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(top: 60.h, bottom: 20.h, left: 20.w, right: 20.w),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/homeScreenBg.png"),
                  fit: BoxFit.cover,
                ),
              ),
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
                      imageUrl: ApiConstants.imageBaseUrl + _auth.userImage.value,
                      height: 50.h,
                      width: 50.w,
                      boxShape: BoxShape.circle,
                    );
                  }),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Welcome!", color: Colors.white, fontSize: 12.h),
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
                        return CustomText(text: _auth.userName.value, color: Colors.white);
                      }),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  CustomText(text: "Today's Summary", fontWeight: FontWeight.w500, bottom: 16.h),

                  // Summary grid
                  Obx(() {
                    if (_ctrl.isDashboardLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = _summary;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.80,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 16.w),
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: item["icon"],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: item["value"],
                                    fontSize: 32.h,
                                    color: AppColors.primaryColor,
                                  ),
                                  CustomText(text: item['title']),
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

                  // Recent orders header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Recent Orders", fontWeight: FontWeight.w500),
                      GestureDetector(
                        onTap: () =>
                            Get.toNamed(AppRoutes.allOrderScreen)?.then((_) {
                          _ctrl.fetchDashboard();
                          _ctrl.loadRecentOrders();
                        }),
                        child: CustomText(
                          text: "View All",
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Recent orders list
                  Obx(() {
                    if (_ctrl.isRecentLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_ctrl.recentOrders.isEmpty) {
                      return const Center(child: Text("No recent orders"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ctrl.recentOrders.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final order = _ctrl.recentOrders[index];
                        final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
                            .format(order.createdAt.toLocal());
                        final shortId =  order.id;
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.h),
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
                            padding: EdgeInsets.all(12.5.r),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: order., fontSize: 12.h),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: order.store.name,
                                      fontSize: 12.h,
                                      color: const Color(0xff333333),
                                    ),
                                    CustomText(
                                      text: dateStr,
                                      fontSize: 10.h,
                                      color: AppColors.textColor5c5c5c,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CustomButton(
                                  height: 25.h,
                                  width: 125.h,
                                  fontSize: 10.h,
                                  borderRadius: 8.r,
                                  loaderIgnore: true,
                                  title: "View Pick List",
                                  onpress: () => Get.toNamed(
                                    AppRoutes.pickListScreen,
                                    arguments: order,
                                  ),
                                ),
                              ],
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
