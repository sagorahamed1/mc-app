import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/order_controller.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MerchandiserHistoryScreen extends StatefulWidget {
  const MerchandiserHistoryScreen({super.key});

  @override
  State<MerchandiserHistoryScreen> createState() =>
      _MerchandiserHistoryScreenState();
}

class _MerchandiserHistoryScreenState
    extends State<MerchandiserHistoryScreen> {
  final OrderController _ctrl = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    final merch = Get.find<MerchandiserController>();
    final storeId =
        merch.visits.isNotEmpty ? merch.visits.first.store.id : '';
    _ctrl.loadOrders(storeId, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        title: CustomText(
          text: "Order History",
          fontWeight: FontWeight.w500,
          fontSize: 18.h,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.orders.isEmpty) {
          return const Center(child: Text("No order history found"));
        }
        return ListView.builder(
          controller: _ctrl.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          itemCount: _ctrl.orders.length +
              (_ctrl.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _ctrl.orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _HistoryOrderCard(order: _ctrl.orders[index]);
          },
        );
      }),
    );
  }
}

class _HistoryOrderCard extends StatelessWidget {
  final OrderModel order;

  const _HistoryOrderCard({required this.order});

  Color get _statusColor {
    if (order.status == 'delivered' && order.hasSticker) {
      return const Color(0xff1B8C4E);
    } else if (order.status == 'delivered' && !order.hasSticker) {
      return const Color(0xffE65100);
    }
    return const Color(0xff3B5BDB);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
        .format(order.createdAt.toLocal());

    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 1.w, right: 1.w, top: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 1.5,
            offset: const Offset(0.3, 0.3),
          ),
        ],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID + Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: order.store.storeNumber,
                  fontSize: 10.h,
                  color: const Color(0xff5C5C5C),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  child: CustomText(
                    text: order.displayStatus,
                    color: _statusColor,
                    fontSize: 10.h,
                  ),
                ),
              ],
            ),

            // Store name
            CustomText(text: order.store.name, fontSize: 16.h),

            SizedBox(height: 8.h),

            // Address + date + button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: order.store.address,
                        fontSize: 12.h,
                        color: const Color(0xff5C5C5C),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: "Total: \$${order.totalPrice.toStringAsFixed(2)}",
                        fontSize: 11.h,
                        color: const Color(0xff333333),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: "Date: $dateStr",
                        fontSize: 11.h,
                        color: const Color(0xff333333),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.seeOrderScreen,
                    arguments: order,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: CustomText(
                      text: "See Order",
                      fontSize: 10.h,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
