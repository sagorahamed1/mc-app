import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class EditInformationScreen extends StatefulWidget {
  const EditInformationScreen({super.key});

  @override
  State<EditInformationScreen> createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find<AuthController>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final dobCtrl = TextEditingController();

  File? _selectedImage;
  String _existingImagePath = '';

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    nameCtrl.text = await PrefsHelper.getString(AppConstants.name);
    phoneCtrl.text = await PrefsHelper.getString(AppConstants.phone);
    addressCtrl.text = await PrefsHelper.getString(AppConstants.address);
    dobCtrl.text = await PrefsHelper.getString(AppConstants.dateOfBirth);
    _existingImagePath = await PrefsHelper.getString(AppConstants.image);
    setState(() {});
  }

  @override
  void dispose() {
    nameCtrl.dispose();
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
            text: "Edit Information",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Profile image picker ──
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Stack(
                    children: [
                      _selectedImage != null
                          ? CircleAvatar(
                              radius: 85.r,
                              backgroundImage: FileImage(_selectedImage!),
                            )
                          : CustomNetworkImage(
                              imageUrl: ApiConstants.imageBaseUrl +
                                  _existingImagePath,
                              height: 100.h,
                              width: 100.w,
                              boxShape: BoxShape.circle,
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border:
                                Border.all(color: AppColors.primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6.r),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                controller: nameCtrl,
                hintText: "Enter your name",
                labelText: "Name",
                onChanged: (_) => _auth.updateError(''),
              ),
              CustomTextField(
                controller: phoneCtrl,
                hintText: "Enter phone number",
                labelText: "Phone Number",
                keyboardType: TextInputType.phone,
                onChanged: (_) => _auth.updateError(''),
              ),
              CustomTextField(
                controller: addressCtrl,
                hintText: "Enter your address",
                labelText: "Address",
                onChanged: (_) => _auth.updateError(''),
              ),
              CustomTextField(
                controller: dobCtrl,
                hintText: "YYYY-MM-DD",
                labelText: "Date of Birth",
                readOnly: true,
                onTap: _pickDate,
                onChanged: (_) => _auth.updateError(''),
              ),

              // ── API error ──
              Obx(() => _auth.updateError.value.isNotEmpty
                  ? _ErrorBanner(message: _auth.updateError.value)
                  : const SizedBox()),

              SizedBox(height: 20.h),

              Obx(() => CustomButtonGradiant(
                    title: "UPDATE",
                    loading: _auth.updateLoading.value,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.updateProfile(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          dateOfBirth: dobCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          imageFile: _selectedImage,
                        );
                      }
                    },
                  )),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Date picker ──
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dobCtrl.text) ?? DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      final formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() => dobCtrl.text = formatted);
    }
  }

  // ── Image picker bottom sheet ──
  void _showImagePickerOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(18.r),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 6.2,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50.w),
                      CustomText(text: 'Gallery'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50.w),
                      CustomText(text: 'Camera'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    setState(() => _selectedImage = File(picked.path));
  }
}

// ── Inline error banner ──
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 16.h),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
