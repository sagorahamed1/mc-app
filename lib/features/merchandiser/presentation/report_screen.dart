


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

import 'package:mc/shared/widgets/custom_text_field.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController heritageUnitsController = TextEditingController();
  final TextEditingController backstockUnitsController = TextEditingController();
  final TextEditingController planogramController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    heritageUnitsController.dispose();
    backstockUnitsController.dispose();
    planogramController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            CustomText(
              text: "Whom Did You Speak To?",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CustomTextField(
              controller: nameController,
              hintText: "enter a name here",
            ),

            CustomText(
              text: "What was his role in this store?",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CustomTextField(
              controller: roleController,
              hintText: "enter his role here",
            ),

            CustomText(
              text: "How many units are on the shelf for Heritage now?",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CustomTextField(
              controller: heritageUnitsController,
              hintText: "enter unit here",
              keyboardType: TextInputType.number,
            ),

            CustomText(
              text: "How many units do you have in backstock?",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CustomTextField(
              controller: backstockUnitsController,
              hintText: "enter unit here",
              keyboardType: TextInputType.number,
            ),

            CustomText(
              text: "Is the rack following planogram?",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CustomTextField(
              controller: planogramController,
              hintText: "enter your opinion"
            ),

            CustomText(
              text: "Upload Shelf Image",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              height: 80.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...selectedImages.asMap().entries.map((entry) {
                    int index = entry.key;
                    File image = entry.value;
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
                              onTap: () => removeImage(index),
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
                  }).toList(),
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid,
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
            ),
            SizedBox(height: 40.h),
            CustomButtonGradiant(
              title: "SUBMIT",
              onpress: () {
                Get.back();
              },
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}