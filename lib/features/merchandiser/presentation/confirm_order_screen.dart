import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/presentation/controllers/product_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController ctrl = Get.find<ProductController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final storeName = args['storeName'] as String? ?? ctrl.store.value?.name ?? '—';
    final storeNumber = args['storeNumber'] as String? ?? '';
    final visitDate = args['visitDate'] as DateTime? ?? DateTime.now();
    final dateTimeStr = DateFormat("dd/MM/yy 'at' hh:mm a").format(visitDate.toLocal());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Confirm Order",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final selectedProducts = ctrl.selectedProducts;
        final double totalAmount = selectedProducts.fold(0.0, (sum, p) {
          final qty = ctrl.quantities[p.id] ?? 0;
          return sum + (p.price * qty);
        });

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: Column(
                        children: [
                          CustomText(
                            text: "Store Name : $storeName",
                            fontSize: 14.h,
                            color: Colors.grey.shade700,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: "Store ID : ${storeNumber.isNotEmpty ? storeNumber : '—'}",
                            fontSize: 14.h,
                            color: Colors.grey.shade700,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: "Date & Time : $dateTimeStr",
                            fontSize: 14.h,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Products Table
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: "Product Name",
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: "ID No.",
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: "Unit",
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: "Price",
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Table Rows
                          if (selectedProducts.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: CustomText(
                                  text: "No products selected",
                                  fontSize: 13.h,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedProducts.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1.h,
                                color: Colors.grey.shade300,
                              ),
                              itemBuilder: (context, index) {
                                final product = selectedProducts[index];
                                final qty = ctrl.quantities[product.id] ?? 0;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 12.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: product.name,
                                          fontSize: 13.h,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: product.itemNo,
                                          fontSize: 13.h,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: "$qty",
                                          fontSize: 13.h,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: "\$${(product.price * qty).toStringAsFixed(2)}",
                                          fontSize: 13.h,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            // Bottom Section with Total and Submit
            Container(
              padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 100.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Total Amount",
                        fontSize: 12.h,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: "\$${totalAmount.toStringAsFixed(2)}",
                        fontSize: 12.h,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ctrl.isSubmitting.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : CustomButton(
                          title: "SUBMIT",
                          onpress: () async {
                            final success = await ctrl.submitOrder();
                            if (success) {
                              Get.back();
                              Get.back();
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
