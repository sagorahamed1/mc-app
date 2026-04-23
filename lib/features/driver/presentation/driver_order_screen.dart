import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class DriverOrderScreen extends StatefulWidget {
  const DriverOrderScreen({super.key});

  @override
  State<DriverOrderScreen> createState() => _DriverOrderScreenState();
}

class _DriverOrderScreenState extends State<DriverOrderScreen> {
  final DriverController _ctrl = Get.find<DriverController>();

  Color _statusColor(String status) {
    switch (status) {
      case 'driver_assigned':
        return AppColors.primaryColor;
      case 'delivered':
        return const Color(0xffE07B00);
      case 'completed':
        return const Color(0xff2E7D32);
      default:
        return Colors.grey;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'driver_assigned':
        return const Color(0xffE7F9FF);
      case 'delivered':
        return const Color(0xffFFF3E0);
      case 'completed':
        return const Color(0xffE8F5E9);
      default:
        return Colors.grey.shade100;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'driver_assigned':
        return 'Assigned';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: CustomText(
            text: "Orders", fontWeight: FontWeight.w500, fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _ctrl.loadOrderScreenOrders(refresh: true),
                child: Obx(() {
                  if (_ctrl.isOrderScreenLoading.value) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 6,
                      itemBuilder: (_, __) => _OrderCardShimmer(),
                    );
                  }
                  if (_ctrl.orderScreenOrders.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: 200.h),
                        Center(
                          child: CustomText(
                              text: "No orders found", color: Colors.grey),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    controller: _ctrl.orderScreenScroll,
                    padding: EdgeInsets.zero,
                    itemCount: _ctrl.orderScreenOrders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _ctrl.orderScreenOrders.length) {
                        return Obx(() =>
                            _ctrl.isOrderScreenPaginationLoading.value
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h),
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : const SizedBox.shrink());
                      }

                      final order = _ctrl.orderScreenOrders[index];
                      final dateStr =
                          DateFormat("dd/MM/yy 'at' hh:mm a")
                              .format(order.createdAt.toLocal());
                      final isAssigned = order.status == 'driver_assigned';

                      return GestureDetector(
                        onTap: () => Get.toNamed(
                            AppRoutes.deliveryDetailsScreen,
                            arguments: order)?.then((_) =>
                            _ctrl.loadOrderScreenOrders(refresh: true)),
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 16.h,
                              top: 2.h,
                              left: 2.w,
                              right: 2.w),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: isAssigned
                                              ? const Color(0xffE7F9FF)
                                              : _statusBg(order.status),
                                          borderRadius:
                                              BorderRadius.circular(16.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.h, vertical: 3.h),
                                        child: CustomText(
                                            text: isAssigned
                                                ? "Upcoming"
                                                : _statusLabel(order.status),
                                            color: isAssigned
                                                ? AppColors.primaryColor
                                                : _statusColor(order.status),
                                            fontSize: 11.h),
                                      ),
                                    ),
                                    if (isAssigned) ...[
                                      SizedBox(height: 10.h),
                                      CustomButton(
                                          height: 25.h,
                                          width: 100.h,
                                          fontSize: 10.h,
                                          borderRadius: 8.r,
                                          loaderIgnore: true,
                                          title: "Start Delivery",
                                          onpress: () {}),
                                    ],
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
              ),
            ),
          ],
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
        margin: EdgeInsets.only(bottom: 16.h, top: 2.h),
        padding: EdgeInsets.all(12.5.r),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 16.h, width: 100.w, color: Colors.white),
                SizedBox(height: 6.h),
                Container(
                    height: 12.h, width: 160.w, color: Colors.white),
                SizedBox(height: 6.h),
                Container(
                    height: 10.h, width: 120.w, color: Colors.white),
              ],
            ),
            const Spacer(),
            Container(
                height: 25.h,
                width: 80.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r))),
          ],
        ),
      ),
    );
  }
}
