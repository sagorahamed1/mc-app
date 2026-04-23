import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class ManageReturnSreen extends StatefulWidget {
  const ManageReturnSreen({super.key});

  @override
  State<ManageReturnSreen> createState() => _ManageReturnSreenState();
}

class _ManageReturnSreenState extends State<ManageReturnSreen> {
  late final DriverController _ctrl;
  final Map<String, TextEditingController> _deliveryControllers = {};
  final Map<String, TextEditingController> _returnControllers = {};
  final Map<String, TextEditingController> _commentControllers = {};
  final RxDouble _refundAmount = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<DriverController>();
    final orderId = Get.arguments as String;
    ever(_ctrl.currentOrder, (_) => _initControllers());
    _ctrl.fetchOrderById(orderId);
  }

  void _initControllers() {
    final order = _ctrl.currentOrder.value;
    if (order == null) return;
    for (final p in order.products) {
      _deliveryControllers.putIfAbsent(
        p.id,
        () => TextEditingController(text: p.unit.toString()),
      );
      _returnControllers.putIfAbsent(p.id, () {
        final c = TextEditingController(text: p.unitReturn.toString());
        c.addListener(_recalculate);
        return c;
      });
      _commentControllers.putIfAbsent(p.id, () => TextEditingController());
    }
    _recalculate();
  }

  void _recalculate() {
    final order = _ctrl.currentOrder.value;
    if (order == null) return;
    double refund = 0;
    for (final p in order.products) {
      final qty = double.tryParse(_returnControllers[p.id]?.text ?? '0') ?? 0;
      refund += qty * p.unitPrice;
    }
    _refundAmount.value = refund;
  }

  @override
  void dispose() {
    for (final c in _deliveryControllers.values) {
      c.dispose();
    }
    for (final c in _returnControllers.values) {
      c.removeListener(_recalculate);
      c.dispose();
    }
    for (final c in _commentControllers.values) {
      c.dispose();
    }
    super.dispose();
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
            text: "Manage Returns",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Obx(() {
        if (_ctrl.isOrderLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final order = _ctrl.currentOrder.value;
        if (order == null) {
          return const Center(child: Text('Failed to load order'));
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: order.products.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      _buildProductCard(order.products[index]),
                ),
                SizedBox(height: 20.h),
                _buildFinancialSummary(order),
                SizedBox(height: 20.h),
                CustomButtonGradiant(
                  title: "CONFIRM & PRINT",
                  onpress: () => showPrintDialog(order, _buildProductsPayload(order)),
                ),
                SizedBox(height: 150.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(OrderProductItem item) {
    final deliveryCtrl = _deliveryControllers[item.id] ??
        TextEditingController(text: item.unit.toString());
    final returnCtrl = _returnControllers[item.id] ??
        TextEditingController(text: item.unitReturn.toString());
    final commentCtrl =
        _commentControllers[item.id] ?? TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 5.5.h, bottom: 5.5.h, left: 2.w, right: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 1.5,
            offset: const Offset(0.5, 0.5),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "Company Name: ${item.product.name}",
                color: Colors.black,
                fontWeight: FontWeight.w600),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Item No.", fontSize: 10.h),
                CustomText(text: "Delivery Quantity", fontSize: 10.h),
                CustomText(text: "Return Quantity", fontSize: 10.h),
              ],
            ),
            const Divider(),
            ItemRow(
              itemNo: item.product.itemNo,
              deliveryController: deliveryCtrl,
              returnController: returnCtrl,
            ),
            const SizedBox(height: 10),
            CustomText(text: "Comment on return", fontSize: 12),
            TextField(
              controller: commentCtrl,
              maxLines: 2,
              style: TextStyle(fontSize: 10.h),
              decoration: InputDecoration(
                hintText: "Enter your comment here",
                filled: true,
                fillColor: const Color(0xffEBEBEB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(OrderModel order) {
    return Obx(() {
      final refund = _refundAmount.value;
      final afterRefund = order.totalPrice - refund;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Total Amount", fontSize: 12.h),
              CustomText(
                  text: "\$${order.totalPrice.toStringAsFixed(2)}",
                  fontSize: 12.h),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Refund Amount", fontSize: 12.h),
              CustomText(
                  text: "\$${refund.toStringAsFixed(2)}",
                  fontSize: 12.h,
                  color: Colors.red),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "After Refund", fontSize: 12.h),
              CustomText(
                  text: "\$${afterRefund.toStringAsFixed(2)}",
                  fontSize: 12.h,
                  color: Colors.green),
            ],
          ),
        ],
      );
    });
  }

  List<Map<String, dynamic>> _buildProductsPayload(OrderModel order) {
    return order.products.map((p) {
      return {
        '_id': p.id,
        'unitReturn': int.tryParse(_returnControllers[p.id]?.text ?? '0') ?? 0,
        'returnComment': _commentControllers[p.id]?.text ?? '',
      };
    }).toList();
  }

  void showPrintDialog(OrderModel order, List<Map<String, dynamic>> products) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                SizedBox(height: 18.h),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: CustomText(
                    text: "Are there any more \nchanges?",
                    fontSize: 24.h,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 40.h),
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
                      title: "Need change",
                      onpress: () => Get.back(),
                    ),
                    SizedBox(width: 16.w),
                    Obx(() => CustomButton(
                          width: 90.w,
                          height: 40.h,
                          borderRadius: 10.r,
                          color: const Color(0xff182E6F),
                          loaderIgnore: true,
                          fontSize: 14.h,
                          title: "Print",
                          loading: _ctrl.isManageReturnsLoading.value,
                          onpress: () async {
                            final success = await _ctrl.manageReturns(
                              orderId: order.id,
                              products: products,
                            );
                            if (success) {
                              Get.back();
                              Get.toNamed(AppRoutes.confirmationScreen, arguments: order);
                            }
                          },
                        )),
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

class ItemRow extends StatelessWidget {
  final String itemNo;
  final TextEditingController deliveryController;
  final TextEditingController returnController;

  const ItemRow({
    required this.itemNo,
    required this.deliveryController,
    required this.returnController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: itemNo, fontSize: 12),
          SizedBox(
            width: 100.w,
            height: 26.h,
            child: TextField(
              readOnly: true,
              controller: deliveryController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 10.h),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "0",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            height: 26.h,
            child: TextField(
              controller: returnController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 10.h),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "0",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
