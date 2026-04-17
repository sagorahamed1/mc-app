





import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';
import 'package:mc/shared/widgets/custom_text.dart';



class EditInformationScreen extends StatefulWidget {
  const EditInformationScreen({super.key});

  @override
  State<EditInformationScreen> createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  TextEditingController nameCtrl = TextEditingController();

  TextEditingController phoneNumberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              decoration: const BoxDecoration(
                  color: Color(0xffEBEBEB),
                  shape: BoxShape.circle
              ),
              child: const Center(
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: CustomText(
              text: "General Information", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.all(20.r),
        child: Column(
          children: [


            GestureDetector(
              onTap: () {
                showImagePickerOption(context);
              },
              child: SizedBox(
                height: 100.h,
                width: 100.w,
                child: Stack(
                  children: [

                    _image != null ?
                    CircleAvatar(
                        radius: 85.r,
                        backgroundImage: MemoryImage(_image!)) :

                    CustomNetworkImage(imageUrl: "https://randomuser.me/api/portraits/women/65.jpg", height: 100.h, width: 100.w, boxShape: BoxShape.circle),


                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: AppColors.primaryColor),
                              shape: BoxShape.circle
                            ),

                            child: Padding(
                              padding:  EdgeInsets.all(6.r),
                              child: const Icon(Icons.edit, color: Colors.white),
                            )))
                  ],
                ),
              ),
            ),



            SizedBox(height: 45.h),

            CustomTextField(controller: nameCtrl, hintText: "name", labelText: "Name"),
            CustomTextField(controller: phoneNumberCtrl, hintText: "number", labelText: "Phone Number"),



            const Spacer(),


            CustomButtonGradiant(title: "EDIT INFORMATION", onpress: (){}),


            SizedBox(height: 100.h)

          ],
        ),
      ),

    );
  }


  //==================================> ShowImagePickerOption Function <===============================
  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                            ),
                            CustomText(text: 'Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50.w,
                            ),
                            CustomText(text: 'Camera')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Uint8List? _image;

  File? selectedIMage;

  //==================================> Gallery <===============================
  Future _pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    selectedIMage = File(returnImage.path);
    _image = File(returnImage.path).readAsBytesSync();
    setState(() {
    });
    Get.back();
  }

//==================================> Camera <===============================
  Future _pickImageFromCamera() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;

    Get.back();
    selectedIMage = File(returnImage.path);
    _image = File(returnImage.path).readAsBytesSync();
    setState(() {});

  }
}
