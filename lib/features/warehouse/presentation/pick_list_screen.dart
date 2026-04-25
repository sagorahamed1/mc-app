import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/warehouse/presentation/controllers/warehouse_order_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class PickListScreen extends StatefulWidget {
  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {
  late final OrderModel _order;
  final WarehouseOrderController _ctrl = Get.find<WarehouseOrderController>();

  // per product item id → whether it's included
  final Map<String, bool> _checked = {};
  // per product item id → qty text controller
  final Map<String, TextEditingController> _qtyControllers = {};
  // per product item id → selected lot index inside productLots
  final Map<String, int> _selectedLotIndex = {};

  late final TextEditingController _palletNoController;

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as OrderModel;
    _palletNoController = TextEditingController(text: _order.palletNo);
    for (final item in _order.products) {
      _checked[item.id] = true;
      _qtyControllers[item.id] = TextEditingController(
        text: item.unit > 0 ? item.unit.toString() : '',
      );
      // default to the lot that matches item.lotNo, else first
      final lots = item.product.productLots;
      final matchIdx = lots.indexWhere((l) => l.lotNo == item.lotNo);
      _selectedLotIndex[item.id] = matchIdx >= 0 ? matchIdx : 0;
    }
  }

  @override
  void dispose() {
    _palletNoController.dispose();
    for (final c in _qtyControllers.values) c.dispose();
    super.dispose();
  }


  List<Map<String, dynamic>> _buildProductsPayload() {
    return _order.products
        .where((item) => _checked[item.id] == true)
        .map((item) {
          final lots = item.product.productLots;
          final idx = _selectedLotIndex[item.id] ?? 0;
          final lotNo = lots.isNotEmpty
              ? lots[idx < lots.length ? idx : 0].lotNo
              : item.lotNo;
          return {
            '_id': item.id,
            'unit': int.tryParse(_qtyControllers[item.id]?.text ?? '0') ?? 0,
            'lotNo': lotNo,
          };
        })
        .toList();
  }

  Future<void> _submit() async {
    final products = _buildProductsPayload();
    if (products.isEmpty) return;
    final success = await _ctrl.packOrder(
      orderId: _order.id,
      palletNo: _palletNoController.text.trim(),
      products: products,
    );
    if (success) {
      _ctrl.loadPendingOrders(refresh: true);
      Get.back();
    }
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
          text: "Pick List",
          fontWeight: FontWeight.w500,
          fontSize: 18.h,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Order ID
                  Row(
                    children: [
                      CustomText(
                        text: "Order ID: ",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                      CustomText(
                        text: "#${_order.sid}",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Pallet No.
                  Row(
                    children: [
                      CustomText(
                        text: "Pallet No: ",
                        fontSize: 12.h,
                        fontWeight: FontWeight.w500,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _palletNoController,
                          style: TextStyle(fontSize: 12.sp),
                          decoration: InputDecoration(
                            hintText: "e.g. PAL-ORDER-001",
                            hintStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade400),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 8.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.4)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.4)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Product cards
                  ...(_order.products.map((item) {
                    return StatefulBuilder(
                      builder: (context, setCardState) {
                        final isProductChecked = _checked[item.id] ?? false;
                        final lots = item.product.productLots;
                        final selectedIdx = _selectedLotIndex[item.id] ?? 0;
                        final maxUnits = item.unitNeed;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name + include checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Item No: ${item.product.itemNo}",
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text: "Item Name: ${item.product.name}",
                                          fontSize: 12.h,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isProductChecked,
                                    activeColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    onChanged: (val) {
                                      setCardState(() {
                                        _checked[item.id] = val ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              // Lot chips
                              if (lots.isNotEmpty) ...[
                                CustomText(
                                  text: "Select LOT:",
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                  color: isProductChecked
                                      ? Colors.black
                                      : Colors.grey.shade400,
                                ),
                                SizedBox(height: 8.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: lots.asMap().entries.map((entry) {
                                    final lotIdx = entry.key;
                                    final lot = entry.value;
                                    final isLotSelected = selectedIdx == lotIdx;
                                    final active = isLotSelected && isProductChecked;
                                    return GestureDetector(
                                      onTap: isProductChecked
                                          ? () {
                                              setCardState(() {
                                                _selectedLotIndex[item.id] = lotIdx;
                                                final ctrl = _qtyControllers[item.id];
                                                if (ctrl != null) {
                                                  final v = int.tryParse(ctrl.text) ?? 0;
                                                  if (v > item.unitNeed) {
                                                    ctrl.text = item.unitNeed.toString();
                                                    ctrl.selection = TextSelection.collapsed(
                                                        offset: ctrl.text.length);
                                                  }
                                                }
                                              });
                                            }
                                          : null,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: active
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: active
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "LOT ${lot.lotNo}",
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: active
                                                    ? Colors.white
                                                    : (isProductChecked
                                                        ? Colors.black87
                                                        : Colors.grey.shade400),
                                              ),
                                            ),
                                            Text(
                                              "${lot.units} units",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: active
                                                    ? Colors.white.withValues(alpha: 0.85)
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 10.h),
                              ],

                              // Quantity row
                              Row(
                                children: [
                                  CustomText(
                                    text: "Quantity: ",
                                    fontSize: 12.h,
                                    color: isProductChecked
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    height: 28.h,
                                    child: TextField(
                                      controller: _qtyControllers[item.id],
                                      enabled: isProductChecked,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (val) {
                                        final n = int.tryParse(val) ?? 0;
                                        if (n > maxUnits) {
                                          final ctrl = _qtyControllers[item.id]!;
                                          ctrl.text = maxUnits.toString();
                                          ctrl.selection = TextSelection.collapsed(
                                            offset: ctrl.text.length,
                                          );
                                        }
                                      },
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isProductChecked
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: isProductChecked
                                              ? AppColors.primaryColor
                                                  .withValues(alpha: 0.5)
                                              : Colors.grey.shade300,
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.h, horizontal: 4.w),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          borderSide: BorderSide(
                                            color: isProductChecked
                                                ? AppColors.primaryColor
                                                    .withValues(alpha: 0.4)
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text: "Out of $maxUnits",
                                    fontSize: 12.h,
                                    color: isProductChecked
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  })),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: 40.h, top: 8.h),
            child: Obx(() => CustomButtonGradiant(
                  title: _ctrl.isPackLoading.value
                      ? "Submitting..."
                      : "READY FOR INSPECTION",
                  onpress: _ctrl.isPackLoading.value ? () {} : _submit,
                )),
          ),
        ],
      ),
    );
  }
}
