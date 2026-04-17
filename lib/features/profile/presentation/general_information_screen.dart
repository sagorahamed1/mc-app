import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class GeneralInformationScreen extends StatefulWidget {
  const GeneralInformationScreen({super.key});

  @override
  State<GeneralInformationScreen> createState() =>
      _GeneralInformationScreenState();
}

class _GeneralInformationScreenState extends State<GeneralInformationScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  String imagePath = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    nameCtrl.text = await PrefsHelper.getString(AppConstants.name);
    emailCtrl.text = await PrefsHelper.getString(AppConstants.email);
    phoneCtrl.text = await PrefsHelper.getString(AppConstants.phone);
    addressCtrl.text = await PrefsHelper.getString(AppConstants.address);
    dobCtrl.text = await PrefsHelper.getString(AppConstants.dateOfBirth);
    imagePath = await PrefsHelper.getString(AppConstants.image);
    setState(() {});
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    dobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            text: "General Information",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            CustomNetworkImage(
              imageUrl: ApiConstants.imageBaseUrl + imagePath,
              height: 100.h,
              width: 100.w,
              boxShape: BoxShape.circle,
            ),
            SizedBox(height: 24.h),
            CustomTextField(
                controller: nameCtrl,
                hintText: "Name",
                labelText: "Name",
                readOnly: true),
            CustomTextField(
                controller: emailCtrl,
                hintText: "Email",
                labelText: "Email",
                isEmail: true,
                readOnly: true),
            CustomTextField(
                controller: phoneCtrl,
                hintText: "Phone Number",
                labelText: "Phone Number",
                readOnly: true),
            CustomTextField(
                controller: addressCtrl,
                hintText: "Address",
                labelText: "Address",
                readOnly: true),
            CustomTextField(
                controller: dobCtrl,
                hintText: "Date of Birth",
                labelText: "Date of Birth",
                readOnly: true),
            SizedBox(height: 20.h),
            CustomButtonGradiant(
              title: "EDIT INFORMATION",
              loaderIgnore: true,
              onpress: () => Get.toNamed(AppRoutes.editInformationScreen),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
