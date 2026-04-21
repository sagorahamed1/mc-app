import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class SeeOrderScreen extends StatelessWidget {
  const SeeOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments as OrderModel;
    final dateStr = DateFormat("dd/MM/yy 'at' hh:mm a")
        .format(order.createdAt.toLocal());
    final shortId =
        order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id;

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
          text: "See Order",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),

            // Order info block
            Center(
              child: Column(
                children: [
                  CustomText(
                    text: "Order ID : #$shortId",
                    fontSize: 14.h,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "Store Name : ${order.store.name}",
                    fontSize: 14.h,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "Store ID : #${order.store.storeNumber}",
                    fontSize: 14.h,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "Date & Time : $dateStr",
                    fontSize: 14.h,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Table header
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
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
                      textAlign: TextAlign.center,
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

            // Table rows
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.products.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final item = order.products[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: item.product.name,
                          fontSize: 13.h,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: item.product.itemNo,
                          fontSize: 13.h,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: "${item.unit}",
                          fontSize: 13.h,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text:
                              "\$${(item.unitPrice * item.unit).toStringAsFixed(0)}",
                          fontSize: 13.h,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
