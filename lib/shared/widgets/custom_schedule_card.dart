import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc/core/utils/app_colors.dart';

import 'custom_button.dart';
import 'custom_text.dart';

class CustomScheduleCard extends StatefulWidget {
  final String id;
  final String status;
  final Color statusColor;
  final String storeName;
  final String address;
  final String schedule;
  final String lastVisited;
  final String btnName;
  final DateTime scheduledTime;
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
    required this.scheduledTime,
    required this.onClockIn,
    required this.btnName,
  });

  @override
  State<CustomScheduleCard> createState() => _CustomScheduleCardState();
}

class _CustomScheduleCardState extends State<CustomScheduleCard> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calcRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _remaining = _calcRemaining());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Duration _calcRemaining() {
    final diff = widget.scheduledTime.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _startWithin {
    if (_remaining == Duration.zero) return '0s';

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    // >= 24h: show days + hours
    if (days >= 1) {
      return hours > 0 ? '${days}d ${hours}h' : '${days}d';
    }
    // >= 60min: show hours + minutes
    if (_remaining.inHours >= 1) {
      return minutes > 0 ? '${_remaining.inHours}h ${minutes}m' : '${_remaining.inHours}h';
    }
    // >= 60s: show minutes + seconds
    if (_remaining.inMinutes >= 1) {
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
    // < 60s: show seconds only
    return '${seconds}s';
  }

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
            offset: const Offset(0.3, 0.3),
          ),
        ],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: ID + Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: widget.id,
                    fontSize: 10.h,
                    color: AppColors.textColor5c5c5c),
                Container(
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    child: CustomText(
                      text: widget.status,
                      color: widget.statusColor,
                      fontSize: 10.h,
                    ),
                  ),
                ),
              ],
            ),

            // Row 2: Store name + Start Within countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: widget.storeName, fontSize: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: "Start Within:", fontSize: 10.h, top: 6.h),
                    CustomText(
                      text: _startWithin,
                      fontSize: 10.h,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            ),

            // Row 3: Address/Schedule/LastVisited + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: widget.address,
                          fontSize: 12.h,
                          color: AppColors.textColor5c5c5c,
                          top: 8.h),
                      CustomText(
                          text: "Schedule: ${widget.schedule}",
                          fontSize: 11.h,
                          color: AppColors.textColor333333,
                          bottom: 6.h,
                          top: 6.h),
                      CustomText(
                          text: "Last Visited: ${widget.lastVisited}",
                          fontSize: 11.h,
                          color: AppColors.textColor333333),
                    ],
                  ),
                ),
                CustomButton(
                  width: 110.w,
                  height: 30.h,
                  borderRadius: 10.r,
                  loaderIgnore: true,
                  fontSize: 10.h,
                  title: widget.btnName,
                  onpress: widget.onClockIn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
