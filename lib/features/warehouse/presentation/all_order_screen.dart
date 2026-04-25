import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/warehouse/presentation/controllers/warehouse_order_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final WarehouseOrderController _ctrl =
      Get.find<WarehouseOrderController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadAllOrders(refresh: true);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'WA_assigned':
        return AppColors.primaryColor;
      case 'packed':
        return const Color(0xff7B1FA2);
      case 'driver_assigned':
        return const Color(0xff1565C0);
      case 'delivered':
        return const Color(0xffE07B00);
      case 'completed':
        return const Color(0xff2E7D32);
      case 'approved':
        return const Color(0xff00838F);
      default:
        return Colors.grey;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'WA_assigned':
        return const Color(0xffE7F9FF);
      case 'packed':
        return const Color(0xffF3E5F5);
      case 'driver_assigned':
        return const Color(0xffE3F2FD);
      case 'delivered':
        return const Color(0xffFFF3E0);
      case 'completed':
        return const Color(0xffE8F5E9);
      case 'approved':
        return const Color(0xffE0F7FA);
      default:
        return Colors.grey.shade100;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'WA_assigned':
        return 'WA Assigned';
      case 'driver_assigned':
        return 'Driver Assigned';
      default:
        return status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
        title: CustomText(
            text: "All Orders",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (_ctrl.isAllOrdersLoading.value) {
                  return _buildShimmer();
                }
                if (_ctrl.allOrders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }
                return RefreshIndicator(
                  onRefresh: () => _ctrl.loadAllOrders(refresh: true),
                  child: ListView.builder(
                    controller: _ctrl.allOrdersScrollController,
                    padding: EdgeInsets.zero,
                    itemCount: _ctrl.allOrders.length +
                        (_ctrl.isAllOrdersPaginationLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _ctrl.allOrders.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final order = _ctrl.allOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
        .format(order.createdAt.toLocal());
    final shortId = order.id.length > 6
        ? order.id.substring(order.id.length - 6).toUpperCase()
        : order.id.toUpperCase();

    final isActionable = order.status == 'WA_assigned';

    return Container(
      margin:
          EdgeInsets.only(bottom: 16.h, top: 2.h, left: 2.w, right: 2.w),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: '#${order.sid}', fontSize: 15.h,
                      fontWeight: FontWeight.w600),
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
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: _statusBg(order.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: _statusLabel(order.status),
                    fontSize: 9.h,
                    color: _statusColor(order.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                // View Pick List button for WA-actionable orders
                if (isActionable)
                  CustomButton(
                    height: 25.h,
                    width: 115.w,
                    fontSize: 10.h,
                    borderRadius: 8.r,
                    loaderIgnore: true,
                    title: 'View Pick List',
                    onpress: () => Get.toNamed(
                      AppRoutes.pickListScreen,
                      arguments: order,
                    ),
                  )
                else
                  CustomText(
                    text:
                        '\$${order.totalPrice.toStringAsFixed(2)}',
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 16.h),
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
