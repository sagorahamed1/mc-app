


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MissingStickerScreen extends StatefulWidget {
  const MissingStickerScreen({super.key});

  @override
  State<MissingStickerScreen> createState() => _MissingStickerScreenState();
}

class _MissingStickerScreenState extends State<MissingStickerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? invoiceImage;
  File? stickerImage;
  String? selectedInvoice;
  bool? hasReturns;

  List<String> invoiceNumbers = [
    "INV-001",
    "INV-002",
    "INV-003",
    "INV-004",
  ];

  Future<void> pickInvoiceImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        invoiceImage = File(image.path);
      });
    }
  }

  Future<void> pickStickerImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        stickerImage = File(image.path);
      });
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
          text: "Missing Sticker",
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
              text: "Select Invoice Number",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButton<String>(
                value: selectedInvoice,
                hint: CustomText(
                  text: "enter a name here",
                  fontSize: 14.h,
                  color: Colors.grey.shade400,
                ),
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: invoiceNumbers.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CustomText(text: value, fontSize: 14.h),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedInvoice = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: "Upload Invoice",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: pickInvoiceImage,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: invoiceImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    invoiceImage!,
                    fit: BoxFit.cover,
                    height: 200.h,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Assets.images.uploadimage.image(),

                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: "Upload Sticker",
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: pickStickerImage,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: stickerImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    stickerImage!,
                    fit: BoxFit.cover,
                    height: 200.h,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.uploadimage.image(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
            CustomButtonGradiant(
              title: "SUBMIT",
              onpress: () {

              },
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}