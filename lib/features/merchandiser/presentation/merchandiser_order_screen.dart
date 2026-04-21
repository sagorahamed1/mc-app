import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/order_controller.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MerchandiserOrderScreen extends StatefulWidget {
  const MerchandiserOrderScreen({super.key});

  @override
  State<MerchandiserOrderScreen> createState() =>
      _MerchandiserOrderScreenState();
}

class _MerchandiserOrderScreenState extends State<MerchandiserOrderScreen> {
  final OrderController _ctrl = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    final storeId = Get.arguments as String? ?? '';
    _ctrl.loadOrders(storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
              color: Color(0xffEBEBEB),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
        title: CustomText(
          text: "Orders",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }
        return ListView.builder(
          controller: _ctrl.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: _ctrl.orders.length +
              (_ctrl.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _ctrl.orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _OrderCard(order: _ctrl.orders[index]);
          },
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  Color _statusBgColor() {
    if (order.status == 'delivered' && order.hasSticker) {
      return const Color(0xffE6F9EF);
    } else if (order.status == 'delivered' && !order.hasSticker) {
      return const Color(0xffFFF3E0);
    }
    return const Color(0xffE8F0FE);
  }

  Color _statusTextColor() {
    if (order.status == 'delivered' && order.hasSticker) {
      return const Color(0xff1B8C4E);
    } else if (order.status == 'delivered' && !order.hasSticker) {
      return const Color(0xffE65100);
    }
    return const Color(0xff3B5BDB);
  }

  String _formattedDate() {
    return DateFormat("dd/MM/yy 'at' hh:mm a").format(order.createdAt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Store #${order.store.storeNumber}",
                      fontSize: 15.h,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: order.store.address,
                      fontSize: 12.h,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: _formattedDate(),
                      fontSize: 12.h,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusBgColor(),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: order.displayStatus,
                  fontSize: 11.h,
                  color: _statusTextColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (order.status == 'delivered' && !order.hasSticker) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.orderConfirmScreen,
                  arguments: order,
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: "Upload Sticker",
                    fontSize: 12.h,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
