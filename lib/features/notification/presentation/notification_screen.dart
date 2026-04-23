import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/notification/data/models/notification_model.dart';
import 'package:mc/features/notification/presentation/controllers/notification_controller.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _ctrl = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadNotifications(refresh: true);
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return DateFormat('h:mm a').format(local);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM yyyy').format(local);
  }

  @override
  Widget build(BuildContext context) {
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
            text: "Notifications",
            fontSize: 18.h,
            fontWeight: FontWeight.w500),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Obx(() {
          if (_ctrl.isLoading.value) {
            return _buildShimmer();
          }
          if (_ctrl.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 56.r, color: Colors.grey.shade400),
                  SizedBox(height: 12.h),
                  CustomText(
                      text: 'No notifications yet',
                      fontSize: 14.h,
                      color: Colors.grey),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _ctrl.loadNotifications(refresh: true),
            child: ListView.builder(
              controller: _ctrl.scrollController,
              padding: EdgeInsets.zero,
              itemCount: _ctrl.notifications.length +
                  (_ctrl.isPaginationLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _ctrl.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _NotificationCard(
                  notification: _ctrl.notifications[index],
                  timeLabel: _formatTime(_ctrl.notifications[index].createdAt),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
          height: 72.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final String timeLabel;

  const _NotificationCard({
    required this.notification,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 2.w, right: 2.w, bottom: 4.h),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? AppColors.primaryColor.withValues(alpha: 0.04)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 1.5,
            offset: const Offset(0.5, 0.5),
          ),
        ],
        borderRadius: BorderRadius.circular(8.r),
        border: notification.isUnread
            ? Border(
                left: BorderSide(
                    color: AppColors.primaryColor, width: 3.w))
            : null,
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              height: 38.r,
              width: 38.r,
              decoration: BoxDecoration(
                color: notification.isUnread
                    ? AppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_rounded,
                color: notification.isUnread
                    ? AppColors.primaryColor
                    : Colors.grey.shade500,
                size: 20.r,
              ),
            ),

            SizedBox(width: 10.w),

            // Title + message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: notification.title,
                    fontSize: 13.h,
                    fontWeight: notification.isUnread
                        ? FontWeight.w600
                        : FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: notification.message,
                    fontSize: 11.h,
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.start,
                    maxline: 2,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Time + unread dot
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                    text: timeLabel,
                    fontSize: 10.h,
                    color: Colors.grey),
                if (notification.isUnread) ...[
                  SizedBox(height: 6.h),
                  Container(
                    height: 8.r,
                    width: 8.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
