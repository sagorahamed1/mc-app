

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_button.dart';
import 'custom_text.dart';

class CustomScheduleCard extends StatelessWidget {
  final String id;
  final String status;
  final Color statusColor;
  final String storeName;
  final String address;
  final String schedule;
  final String lastVisited;
  final String btnName;
  final String startWithin;
  final VoidCallback onClockIn;

  const CustomScheduleCard({
    super.key,
    required this.id,
    required this.status,
    required this.statusColor,
    required this.storeName,
    required this.address,
    required this.schedule,
    required this.lastVisited,
    required this.startWithin,
    required this.onClockIn, required this.btnName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 1.w, right: 1.w, top: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 1.5,
            offset: const Offset(0.5, 0.5),
          ),
        ],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ID + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "#$id", fontSize: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    child: Center(
                      child: CustomText(
                        text: status,
                        color: statusColor,
                        fontSize: 10.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 5.h),

            /// STORE NAME + START TIME
            CustomText(text: storeName, fontSize: 16.h),

            SizedBox(height: 5.h),

            /// ADDRESS + BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: address, fontSize: 12.h),
                    CustomText(text: "Schedule: $schedule", fontSize: 11.h),
                    CustomText(text: "Last Visited: $lastVisited", fontSize: 11.h),
                  ],
                ),
                CustomButton(
                  width: 90.w,
                  height: 30.h,
                  borderRadius: 10.r,
                  loaderIgnore: true,
                  fontSize: 10.h,
                  title: "$btnName",
                  onpress: onClockIn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
