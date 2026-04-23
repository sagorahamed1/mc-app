import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class PickListScreen extends StatefulWidget {
  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {
  late final OrderModel _order;
  final Map<String, bool> _checked = {};
  final Map<String, TextEditingController> _qtyControllers = {};
  final Map<String, TextEditingController> _lotControllers = {};

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as OrderModel;
    for (final item in _order.products) {
      _checked[item.id] = true;
      _qtyControllers[item.id] = TextEditingController();
      _lotControllers[item.id] = TextEditingController(
        text: item.lotNo > 0 ? item.lotNo.toString() : '',
      );
    }

  }

  @override
  void dispose() {
    for (final c in _qtyControllers.values) c.dispose();
    for (final c in _lotControllers.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortId = _order.id.length > 6
        ? _order.id.substring(_order.id.length - 6)
        : _order.id;

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

                  // Order ID row
                  Row(
                    children: [
                      CustomText(
                        text: "Order ID: ",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                      CustomText(
                        text: "#$shortId",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Product cards
                  ...(_order.products.map((item) {
                    final isChecked = _checked[item.id] ?? false;
                    return StatefulBuilder(
                      builder: (context, setCardState) {
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
                              // Items + checkbox row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              "Items: ${item.product.name.replaceAll(' ', '_')}",
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text:
                                              "Inventory: ${item.product.name}",
                                          fontSize: 12.h,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isChecked,
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

                              SizedBox(height: 8.h),

                              // Quantity row
                              Row(
                                children: [
                                  CustomText(
                                    text: "Quantity: ",
                                    fontSize: 12.h,
                                    color: isChecked
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    height: 28.h,
                                    child: TextField(
                                      controller: _qtyControllers[item.id],
                                      enabled: isChecked,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isChecked
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: isChecked
                                              ? AppColors.primaryColor
                                                  .withValues(alpha: 0.5)
                                              : Colors.grey.shade300,
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 4.w),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          borderSide: BorderSide(
                                            color: isChecked
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
                                    text: "Out of ${item.unit}",
                                    fontSize: 12.h,
                                    color: isChecked
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300,
                                  ),
                                ],
                              ),

                              SizedBox(height: 8.h),

                              // LOT No. row
                              Row(
                                children: [
                                  CustomText(
                                    text: "LOT No.: ",
                                    fontSize: 12.h,
                                    color: isChecked
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                  SizedBox(
                                    width: 80.w,
                                    height: 28.h,
                                    child: TextField(
                                      controller: _lotControllers[item.id],
                                      enabled: isChecked,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isChecked
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: isChecked
                                              ? AppColors.primaryColor
                                                  .withValues(alpha: 0.5)
                                              : Colors.grey.shade300,
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 4.w),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          borderSide: BorderSide(
                                            color: isChecked
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
            child: CustomButtonGradiant(
              title: "READY FOR INSPECTION",
              onpress: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
