import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mc/shared/widgets/custom_text.dart';

class ReadUpdateScreen extends StatelessWidget {
  const ReadUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: CustomText(
            text: "Reads Updates", fontSize: 18.h, fontWeight: FontWeight.w500),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: 10.h, left: 2.w, right: 2.w, bottom: 4.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 1.5,
                              offset: const Offset(0.5, 0.5))
                        ],
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 23.h, horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: "🚨 Urgent: Stock Reconciliation Required", fontSize: 15.h , fontWeight: FontWeight.w500),
                          CustomText(
                            textAlign: TextAlign.start,
                              text:
                                  "Attention Merchandisers, We have noticed mismatches between warehouse stock levels and store reports. Please recheck all assigned stores this week and ensure that stock reconciliation is done before Friday, 6:00 PM. Failure to update reports may cause delays in supply chain operations.",
                              maxline: 100),


                          CustomText(text: "Super Admin", fontSize: 17.h, fontWeight: FontWeight.w700),

                          SizedBox(height: 10.h),

                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                                text: " 09:00 AM  01.09.2025",
                                fontSize: 10.h,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
