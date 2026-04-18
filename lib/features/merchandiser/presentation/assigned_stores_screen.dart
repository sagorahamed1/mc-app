import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/features/merchandiser/data/models/visit_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_schedule_card.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class AssignedStoresScreen extends StatelessWidget {
  const AssignedStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MerchandiserController>();

    return Scaffold(
      appBar: AppBar(
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
          text: "Assigned Store",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.visits.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.visits.isEmpty) {
          return const Center(child: Text("No assigned stores found"));
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchVisits(refresh: true),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.visits.length +
                  (controller.isPaginationLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.visits.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _AssignedVisitCard(visit: controller.visits[index]);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _AssignedVisitCard extends StatelessWidget {
  final VisitModel visit;

  const _AssignedVisitCard({required this.visit});

  String _formatSchedule(DateTime dt) =>
      DateFormat('MMM dd, hh:mm a').format(dt.toLocal());

  String _formatLastVisited(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd/MM/yy \'at\' hh:mm a').format(dt.toLocal());
  }

  Color get _statusColor {
    switch (visit.status) {
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return const Color(0xff305CDE);
    }
  }

  void _showRescheduleDialog(BuildContext context) {
    final controller = Get.find<MerchandiserController>();
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Reschedule Reason"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: reasonCtrl,
                hintText: "Type reason here...",
                maxLine: 6,
              ),
              SizedBox(height: 20.h),
              Obx(() => CustomButtonGradiant(
                    title: controller.loadingIds.contains(visit.id)
                        ? "Submitting..."
                        : "Submit",
                    onpress: () {
                      final reason = reasonCtrl.text.trim();
                      if (reason.isEmpty) return;
                      Navigator.pop(ctx);
                      controller.submitReschedule(visit.id, reason);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MerchandiserController>();

    return Obx(() {
      final isLoading = controller.loadingIds.contains(visit.id);

      String btnName;
      VoidCallback onTap;

      if (visit.status == 'completed') {
        btnName = 'Completed';
        onTap = () {};
      } else if (visit.isTimeOver) {
        btnName = isLoading ? '...' : 'Contact Manager';
        onTap = () => _showRescheduleDialog(context);
      } else if (visit.status == 'ongoing') {
        btnName = isLoading ? '...' : 'Clock Out';
        onTap = isLoading ? () {} : () => controller.clockOut(visit.id);
      } else {
        btnName = isLoading ? '...' : 'Clock In';
        onTap = isLoading ? () {} : () => controller.clockIn(visit.id);
      }

      return CustomScheduleCard(
        id: visit.store.storeNumber,
        status: visit.displayStatus,
        statusColor: _statusColor,
        storeName: visit.store.name,
        address: visit.store.address,
        schedule: _formatSchedule(visit.dateTime),
        lastVisited: _formatLastVisited(visit.lastVisitAt),
        scheduledTime: visit.dateTime,
        btnName: btnName,
        onClockIn: onTap,
      );
    });
  }
}
