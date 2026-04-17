

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

import 'package:mc/shared/widgets/custom_text.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {

  TextEditingController nameCtrl = TextEditingController();


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
              text: "Confirmation",
              fontWeight: FontWeight.w500,
              fontSize: 18.h)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(height: 32.h),

            CustomTextField(controller: nameCtrl, hintText: "name", labelText: "Receiver Name"),


            CustomText(text: "Upload sticker", fontWeight: FontWeight.w500),


            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              children: [
                // First item: "Coca Cola" with image preview and upload button
                _buildUploadItem('Coca Cola', 'image5.png', _imageFile),

                // Second item: "Coca Cola" with image preview and upload button
                _buildUploadItem('Coca Cola', 'image5.png', _imageFile),

                // Third item: "Coca Cola" with upload button
                _buildUploadItem('Coca Cola', 'Upload photo', _imageFile),
              ],
            ),

            SizedBox(height: 16.h),
            CustomButtonGradiant(title: "Mark Complete", onpress: () {}),
            SizedBox(height: 16.h),
            CustomButton(title: "Mark Complete Without Sticker", onpress: () {}, color: Color(0xff856A00), boderColor: Colors.transparent),
          ],
        ),
      ),
    );
  }




  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Update the image file when selected
      });
    }
  }


  Widget _buildUploadItem(String title, String image, File? imageFile) {
    return Card(
      color: Colors.white,
      margin:  EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Text (e.g., Coca Cola)
          SizedBox(width: 8.w),
          CustomText(text: title),

          const Spacer(),

          // Display image or text (e.g., image file or 'Upload photo')
          imageFile == null
              ? CustomText(text: image) // Show 'Upload photo' if no image is selected
              : Image.file(imageFile, width: 50.w, height: 50.h, fit: BoxFit.cover), // Show selected image

          // Upload Button with arrow icon
          IconButton(
            icon: Icon(
              imageFile == null ? Icons.cloud_upload_outlined : Icons.arrow_upward,
              color: imageFile == null ? Colors.blue : Colors.black,
            ),
            onPressed: _pickImage, // Trigger file picker
          ),
        ],
      ),
    );
  }

}
