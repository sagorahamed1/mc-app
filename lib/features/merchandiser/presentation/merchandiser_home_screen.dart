import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_schedule_card.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class MerchandiserHomeScreen extends StatefulWidget {
  const MerchandiserHomeScreen({super.key});

  @override
  State<MerchandiserHomeScreen> createState() => _MerchandiserHomeScreenState();
}

class _MerchandiserHomeScreenState extends State<MerchandiserHomeScreen> {
  final AuthController _auth = Get.find<AuthController>();

  bool? hasReturns;
  List actions = [
    {"icon": Assets.icons.placeOrder.svg(), "title": "Place Order"},
    {"icon": Assets.icons.report.svg(), "title": "Report"},
    {
      "icon": Assets.icons.missingInvoices.svg(),
      "title": "Missing invoices/stickers"
    },
    {
      "icon": Assets.icons.downloadPreviousSales.svg(),
      "title": "Download  previous sales data"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 60.h, bottom: 20.h, left: 20.w, right: 20.w),
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/homeScreenBg.png"),
                      fit: BoxFit.cover)),
              child: Row(
                children: [
                  Obx(() => CustomNetworkImage(
                    border: Border.all(color: Colors.grey, width: 0.5.r),
                      imageUrl: ApiConstants.imageBaseUrl + _auth.userImage.value,
                      height: 50.h,
                      width: 50.w,
                      boxShape: BoxShape.circle)),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "Welcome!",
                          color: Colors.white,
                          fontSize: 12.h),
                      Obx(() => CustomText(
                          text: _auth.userName.value,
                          color: Colors.white)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.notificationScreen);
                      },
                      child:
                          const Icon(Icons.notifications, color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.readUpdateScreen);
                    },
                    child: Container(
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
                        padding: EdgeInsets.all(20.r),
                        child: Row(
                          children: [
                            Assets.icons.messageIcon.svg(),
                            SizedBox(width: 10.w),
                            CustomText(text: "Reads Updates", fontSize: 16.h)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Recent Schedule", fontWeight: FontWeight.w500),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.assignedStoresScreen);
                          },
                          child: CustomText(
                              text: "View More",
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor))
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _RecentScheduleCard(),



                  SizedBox(height: 16.h),
                  Container(
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
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280.w,
                            child: CustomText(
                                textAlign: TextAlign.center,
                                maxline: 3,
                                text:
                                    "Did this store receive the previous Carrier delivery?",
                                fontSize: 18.h),
                          ),
                          CustomText(
                            text: "Order Date & Time: 08/08/25 at 4:30 PM",
                            fontSize: 10.h,
                            color: const Color(0xff5C5C5C),
                            top: 6.h,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  width: 90.w,
                                  height: 30.h,
                                  borderRadius: 10.r,
                                  loaderIgnore: true,
                                  color: const Color(0xff5C5C5C),
                                  boderColor: Colors.transparent,
                                  fontSize: 10.h,
                                  title: "No",
                                  onpress: () {}),
                              SizedBox(width: 16.w),
                              CustomButton(
                                  width: 90.w,
                                  height: 30.h,
                                  borderRadius: 10.r,
                                  loaderIgnore: true,
                                  fontSize: 10.h,
                                  title: "Yes",
                                  onpress: () {

                                    showReturnsDialog();


                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CustomText(text: "Actions"),
                      CustomText(
                          text: " (required)",
                          fontSize: 10.h,
                          color: Colors.grey),
                    ],
                  ),
                  ListView.builder(
                      itemCount: actions.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Get.toNamed(AppRoutes.productScreen);
                            } else if (index == 1) {
                              //
                              Get.toNamed(AppRoutes.reportScreen);
                            } else if(index == 2){
                              Get.toNamed(AppRoutes.missingStickerScreen);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 12.h),
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
                              padding: EdgeInsets.all(20.r),
                              child: Row(
                                children: [
                                  actions[index]["icon"],
                                  SizedBox(width: 10.w),
                                  CustomText(
                                      text: "${actions[index]["title"]}",
                                      fontSize: 16.h)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  void showReturnsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: const Color(0xffFFFFFF),
            ),

            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h),
                CustomText(
                  text: "Are there any returns?",
                  fontSize: 24.h,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: 130.w,
                      height: 40.h,
                      borderRadius: 10.r,
                      loaderIgnore: true,
                      color: const Color(0xffEBEBEB),
                      boderColor: Colors.transparent,
                      fontSize: 14.h,
                      titlecolor: Colors.black,
                      title: "No",
                      onpress: () {
                        setState(() {
                          hasReturns = false;
                        });
                        Get.back();
                      },
                    ),
                    SizedBox(width: 16.w),
                    CustomButton(
                      width: 130.w,
                      height: 40.h,
                      borderRadius: 10.r,
                      color: const Color(0xff182E6F),
                      loaderIgnore: true,
                      fontSize: 14.h,
                      title: "Yes",
                      onpress: () {
                        setState(() {
                          hasReturns = true;
                        });
                        Get.toNamed(AppRoutes.manageReturnSreen);
                        // Navigate to returns screen
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentScheduleCard extends StatelessWidget {
  _RecentScheduleCard();

  final MerchandiserController _ctrl = Get.find<MerchandiserController>();

  Color _statusColor(String status) {
    switch (status) {
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return const Color(0xff305CDE);
    }
  }

  String _formatSchedule(DateTime dt) =>
      DateFormat('MMM dd, hh:mm a').format(dt.toLocal());

  String _formatLastVisited(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd/MM/yy \'at\' hh:mm a').format(dt.toLocal());
  }

  void _showRescheduleDialog(BuildContext context, String visitId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Reschedule Reason"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                  controller: reasonCtrl,
                  hintText: "Type reason here...",
                  maxLine: 6),
              SizedBox(height: 20.h),
              Obx(() => CustomButtonGradiant(
                    title: _ctrl.loadingIds.contains(visitId)
                        ? "Submitting..."
                        : "Submit",
                    onpress: () {
                      final reason = reasonCtrl.text.trim();
                      if (reason.isEmpty) return;
                      Navigator.pop(ctx);
                      _ctrl.submitReschedule(visitId, reason);
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
      if (_ctrl.isLoading.value && _ctrl.visits.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_ctrl.visits.isEmpty) {
        return const SizedBox.shrink();
      }

      final visit = _ctrl.visits.first;
      final isLoading = _ctrl.loadingIds.contains(visit.id);
      final isTimeOver =
          visit.status == 'pending' && DateTime.now().isAfter(visit.dateTime);

      String btnName;
      VoidCallback onTap;

      if (visit.status == 'completed') {
        btnName = 'Completed';
        onTap = () {};
      } else if (isTimeOver) {
        btnName = isLoading ? '...' : 'Contact Manager';
        onTap = () => _showRescheduleDialog(context, visit.id);
      } else if (visit.status == 'ongoing') {
        btnName = isLoading ? '...' : 'Clock Out';
        onTap = isLoading ? () {} : () => _ctrl.clockOut(visit.id);
      } else {
        btnName = isLoading ? '...' : 'Clock In';
        onTap = isLoading ? () {} : () => _ctrl.clockIn(visit.id);
      }

      return CustomScheduleCard(
        id: visit.store.storeNumber,
        status: visit.displayStatus,
        statusColor: _statusColor(visit.status),
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
