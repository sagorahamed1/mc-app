import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/presentation/controllers/report_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController _ctrl = Get.find<ReportController>();
  final ImagePicker _picker = ImagePicker();
  late final String _visitId;

  @override
  void initState() {
    super.initState();
    _visitId = Get.arguments as String? ?? '';
    _ctrl.loadQuestions();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      _ctrl.addImages(images.map((x) => File(x.path)).toList());
    }
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
          text: "Report",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Dynamic questions
              ..._ctrl.questions.map((q) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: q.question,
                      fontSize: 14.h,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 4.h),
                    TextField(
                      controller: _ctrl.answerControllers[q.id],
                      maxLines: 2,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: "Write your answer here...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }),

              // Image upload section
              CustomText(
                text: "Upload Shelf Image",
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 4.h),
              Obx(() => SizedBox(
                    height: 80.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._ctrl.selectedImages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final image = entry.value;
                          return Container(
                            width: 70.w,
                            height: 70.h,
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 4.h,
                                  right: 4.w,
                                  child: GestureDetector(
                                    onTap: () => _ctrl.removeImage(index),
                                    child: Container(
                                      padding: EdgeInsets.all(2.r),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16.r,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 70.w,
                            height: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.grey.shade600,
                              size: 30.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              SizedBox(height: 40.h),

              Obx(() {
                final busy = _ctrl.isUploading.value || _ctrl.isSubmitting.value;
                if (busy) {
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                            color: AppColors.primaryColor),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: _ctrl.isUploading.value
                              ? "Uploading images..."
                              : "Submitting report...",
                          fontSize: 13.h,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }
                return CustomButtonGradiant(
                  title: "SUBMIT",
                  onpress: () async {
                    final success = await _ctrl.submitReport(_visitId);
                    if (success) {
                      Get.back();
                    }
                  },
                );
              }),

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }
}
