import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/warehouse/presentation/controllers/warehouse_order_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class WareHousePendingOrderScreen extends StatelessWidget {
  final String type;
  const WareHousePendingOrderScreen({super.key, required this.type});

  bool get _isPending => type == "Pending";

  @override
  Widget build(BuildContext context) {
    final WarehouseOrderController ctrl =
        Get.find<WarehouseOrderController>();

    final orders = _isPending ? ctrl.pendingOrders : ctrl.completedOrders;
    final isLoading =
        _isPending ? ctrl.isPendingLoading : ctrl.isCompletedLoading;
    final isPaginationLoading = _isPending
        ? ctrl.isPendingPaginationLoading
        : ctrl.isCompletedPaginationLoading;
    final scrollCtrl = _isPending
        ? ctrl.pendingScrollController
        : ctrl.completedScrollController;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        title: CustomText(
          text: "$type Orders",
          fontWeight: FontWeight.w500,
          fontSize: 18.h,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (orders.isEmpty) {
                  return Center(
                    child: Text("No $type orders found"),
                  );
                }
                return ListView.builder(
                  controller: scrollCtrl,
                  itemCount:
                      orders.length + (isPaginationLoading.value ? 1 : 0),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    if (index == orders.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final order = orders[index];
                    return _WarehouseOrderCard(
                      order: order,
                      isPending: _isPending,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarehouseOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isPending;

  const _WarehouseOrderCard({
    required this.order,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
        .format(order.createdAt.toLocal());
    final shortId = order.id.length > 6
        ? order.id.substring(order.id.length - 6)
        : order.id;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 2.h, left: 2.w, right: 2.w),
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
                CustomText(text: "#$shortId", fontSize: 16.h),
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
            isPending
                ? CustomButton(
                    height: 25.h,
                    width: 125.h,
                    fontSize: 10.h,
                    borderRadius: 8.r,
                    loaderIgnore: true,
                    title: "View Pick List",
                    onpress: () {
                      Get.toNamed(AppRoutes.pickListScreen, arguments: order);
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text: order.displayStatus,
                          fontSize: 10.h,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: "\$${order.totalPrice.toStringAsFixed(2)}",
                        fontSize: 12.h,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
