import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/features/merchandiser/data/models/visit_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/shared/widgets/custom_schedule_card.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';
import 'package:mc/shared/widgets/custom_button.dart';

class MerchandiserScheduleScreen extends StatelessWidget {
  const MerchandiserScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MerchandiserController>();

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: CustomText(
          text: "My Schedule",
          fontWeight: FontWeight.w500,
          fontSize: 18.h,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.visits.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.visits.isEmpty) {
          return const Center(child: Text("No schedule found"));
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchVisits(refresh: true),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
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
                final visit = controller.visits[index];
                return _ScheduleCardWrapper(visit: visit);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _ScheduleCardWrapper extends StatelessWidget {
  final VisitModel visit;

  const _ScheduleCardWrapper({required this.visit});

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

  String get _btnName {
    if (visit.status == 'completed') return 'Completed';
    if (visit.isTimeOver) return 'Contact Manager';
    if (visit.status == 'ongoing') return 'Clock Out';
    return 'Clock In';
  }

  void _onButtonTap(BuildContext context) {
    final controller = Get.find<MerchandiserController>();

    if (visit.status == 'completed') return;

    if (visit.isTimeOver) {
      _showRescheduleDialog(context, controller);
      return;
    }

    if (visit.status == 'ongoing') {
      controller.clockOut(visit.id);
    } else {
      controller.clockIn(visit.id);
    }
  }

  void _showRescheduleDialog(
      BuildContext context, MerchandiserController controller) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
    return Obx(() {
      final controller = Get.find<MerchandiserController>();
      final isLoading = controller.loadingIds.contains(visit.id);

      return CustomScheduleCard(
        id: visit.store.storeNumber,
        status: visit.displayStatus,
        statusColor: _statusColor,
        storeName: visit.store.name,
        address: visit.store.address,
        schedule: _formatSchedule(visit.dateTime),
        lastVisited: _formatLastVisited(visit.lastVisitAt),
        scheduledTime: visit.dateTime,
        btnName: isLoading ? '...' : _btnName,
        onClockIn: () => _onButtonTap(context),
      );
    });
  }
}
