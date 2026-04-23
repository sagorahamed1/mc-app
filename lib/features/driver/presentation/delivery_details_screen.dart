import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  late final OrderModel order;
  final DriverController _ctrl = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    order = Get.arguments as OrderModel;
  }

  String _formatDate(DateTime dt) =>
      DateFormat('dd/MM/yyyy').format(dt.toLocal());

  String _shortId(String id) =>
      id.length > 6 ? '#${id.substring(id.length - 6).toUpperCase()}' : '#$id';

  String _statusLabel(String status) {
    switch (status) {
      case 'driver_assigned':
        return 'Assigned';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Completed';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final isAssigned = order.status == 'driver_assigned';
    final isDelivered = order.status == 'delivered';
    final isCompleted = order.status == 'completed';

    return Scaffold(
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
            text: "Delivery Detail",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Info ───────────────────────────────────────────────
            _infoRow("Order Id", _shortId(order.id)),
            _infoRow("Store Id", order.store.storeNumber),
            _infoRow("Store Name", order.store.name),
            _infoRow("Store Address", order.store.address),
            _infoRow("Store Phone", order.store.phone),
            _infoRow("Order Date", _formatDate(order.createdAt)),
            _infoRow("Pallet No",
                order.palletNo.isNotEmpty ? order.palletNo : '—'),
            _infoRow("Total Price",
                "\$${order.totalPrice.toStringAsFixed(2)}"),
            _infoRow(
              "Status",
              _statusLabel(order.status),
              valueColor: _statusColor(order.status),
            ),

            // ── Products ─────────────────────────────────────────────────
            if (order.products.isNotEmpty) ...[
              SizedBox(height: 20.h),
              CustomText(
                  text: "Products",
                  fontWeight: FontWeight.w600,
                  fontSize: 16.h),
              SizedBox(height: 8.h),
              ...order.products.map((item) => Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 1.5,
                            offset: const Offset(0.5, 0.5)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: item.product.name, fontSize: 14.h),
                              CustomText(
                                  text: item.product.itemNo,
                                  fontSize: 11.h,
                                  color: AppColors.textColor5c5c5c),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                                text: "Qty: ${item.unit}",
                                fontSize: 12.h,
                                color: AppColors.primaryColor),
                            CustomText(
                                text:
                                    "\$${item.unitPrice.toStringAsFixed(2)}/unit",
                                fontSize: 11.h,
                                color: AppColors.textColor5c5c5c),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],

            // ── Common Buttons (all statuses) ─────────────────────────────
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        title: "See Direction",
                        loaderIgnore: true,
                        onpress: () => Get.toNamed(
                            AppRoutes.seeDirectionScreen,
                            arguments: order),
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

            // ── Status-based Buttons ──────────────────────────────────────

            // driver_assigned → Delivered + I Have Arrived
            if (isAssigned) ...[
              SizedBox(height: 16.h),
              Obx(() => CustomButton(
                    title: "Delivered",
                    loading: _ctrl.isDeliverLoading.value,
                    onpress: () async {
                      final success =
                          await _ctrl.deliverOrder(order.id);
                      if (success) Get.back();
                    },
                  )),
              SizedBox(height: 16.h),
              CustomButton(
                title: "I Have Arrived",
                loaderIgnore: true,
                onpress: () => _showArrivedDialog(),
              ),
            ],

            // delivered → Complete + I Have Arrived
            if (isDelivered) ...[
              SizedBox(height: 16.h),
              CustomButton(
                title: "Complete",
                loaderIgnore: true,
                onpress: () {
                  Get.toNamed(AppRoutes.confirmationScreen, arguments: order);
                },
              ),
              SizedBox(height: 16.h),
              CustomButton(
                title: "I Have Arrived",
                loaderIgnore: true,
                onpress: () => _showArrivedDialog(),
              ),
            ],

            // completed → Print
            if (isCompleted) ...[

              SizedBox(height: 16.h),
              CustomButton(
                title: "I Have Arrived",
                loaderIgnore: true,
                onpress: () => _showArrivedDialog(),
              ),
            ],

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        CustomText(text: title, fontWeight: FontWeight.w600, fontSize: 16),
        CustomText(
            text: value,
            fontSize: 12.h,
            color: valueColor ?? AppColors.textColor5c5c5c),
      ],
    );
  }

  void _showArrivedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      height: 50.h,
                      title: "No",
                      onpress: () => Get.back(),
                      color: Colors.transparent,
                      fontSize: 11.h,
                      loaderIgnore: true,
                      boderColor: Colors.black,
                      titlecolor: Colors.black),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomButton(
                      loading: false,
                      loaderIgnore: true,
                      height: 50.h,
                      title: "Yes",
                      onpress: () =>
                          Get.toNamed(AppRoutes.manageReturnSreen, arguments: order.id),
                      fontSize: 11.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
