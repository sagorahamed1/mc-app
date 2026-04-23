import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late final OrderModel order;
  final DriverController _ctrl = Get.find<DriverController>();
  final TextEditingController _nameCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Each entry is either a picked File or null (empty slot)
  final List<File?> _stickers = [null];

  @override
  void initState() {
    super.initState();
    order = Get.arguments as OrderModel;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _stickers[index] = File(picked.path));
    }
  }

  void _addSlot() => setState(() => _stickers.add(null));

  void _removeSlot(int index) => setState(() => _stickers.removeAt(index));

  Future<void> _onMarkComplete() async {
    if (_nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter receiver name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final pickedFiles =
        _stickers.whereType<File>().toList();

    final success = await _ctrl.completeOrder(
      orderId: order.id,
      receiverName: _nameCtrl.text.trim(),
      stickerFiles: pickedFiles,
    );

    if (success) {
      Get.back();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            text: "Confirmation",
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),

            // ── Receiver Name ────────────────────────────────────────────
            CustomTextField(
              controller: _nameCtrl,
              hintText: "Enter receiver name",
              labelText: "Receiver Name",
            ),

            SizedBox(height: 24.h),

            // ── Stickers ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: "Upload Stickers",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h),
                GestureDetector(
                  onTap: _addSlot,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add,
                            color: AppColors.primaryColor, size: 16.r),
                        SizedBox(width: 4.w),
                        CustomText(
                            text: "Add Sticker",
                            color: AppColors.primaryColor,
                            fontSize: 12.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _stickers.length,
              itemBuilder: (context, index) {
                final file = _stickers[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 1.5,
                          offset: const Offset(0.5, 0.5)),
                    ],
                  ),
                  child: GestureDetector(
                      onTap: () => _pickImage(index),
                    child: Row(
                      children: [
                        // Image preview or placeholder
                        Container(
                          height: 30.h,
                          width: 40.w,
                          margin: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: file != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.file(file,
                                fit: BoxFit.cover),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined,
                                  color: Colors.grey.shade400,
                                  size: 24.r),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Expanded(
                          child: CustomText(
                            textAlign: TextAlign.start,
                            text: file != null
                                ? 'Sticker ${index + 1} selected'
                                : 'Tap to upload sticker ${index + 1}',
                            fontSize: 12.h,
                            color: file != null
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                        ),

                        // Change button if image selected
                        if (file != null)
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: AppColors.primaryColor, size: 18.r),
                            onPressed: () => _pickImage(index),
                          ),

                        // Remove button (always except when only 1 empty slot)
                        if (_stickers.length > 1)
                          IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.red.shade400, size: 18.r),
                            onPressed: () => _removeSlot(index),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            // ── Mark As Complete ─────────────────────────────────────────
            Obx(() => CustomButton(
                  title: "Mark As Complete",
                  loading: _ctrl.isCompleteLoading.value,
                  onpress: _onMarkComplete,
                )),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
