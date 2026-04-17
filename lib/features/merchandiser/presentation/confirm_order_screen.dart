

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  // Sample data - replace with actual data from previous screen
  final String orderNumber = "Order #1234";
  final String storeName = "Alexandra Store";
  final String storeId = "#124456";
  final String dateTime = "08/08/25 at 4:30 PM";

  final List<Map<String, dynamic>> products = [
    {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    },
    {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    },
    {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    },
    {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    }, {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    },
    {
      "name": "Cocacola",
      "id": "coca_2L",
      "unit": 120,
      "price": 120,
    },
  ];

  double get totalAmount {
    return products.fold(0, (sum, item) => sum + (item['price'] as num));
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Order Information
                  Center(
                    child: Column(
                      children: [
                        CustomText(
                          text: orderNumber,
                          fontSize: 16.h,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: "Store Name : $storeName",
                          fontSize: 14.h,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: "Store ID : $storeId",
                          fontSize: 14.h,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: "Date & Time : $dateTime",
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
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1.h,
                            color: Colors.grey.shade300,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
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
                                      text: product['name'],
                                      fontSize: 13.h,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: product['id'],
                                      fontSize: 13.h,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: "${product['unit']}",
                                      fontSize: 13.h,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: "\$${product['price']}",
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
                      text: "\$${totalAmount.toInt()}",
                      fontSize: 12.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  title: "SUBMIT",
                  onpress: () {

                    Get.back();
                    Get.back();

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}