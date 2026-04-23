import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/order_controller.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class OrderConfirmScreen extends StatefulWidget {
  const OrderConfirmScreen({super.key});

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  final OrderController _ctrl = Get.find<OrderController>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _receiverCtrl = TextEditingController();

  late final OrderModel _order;
  final Map<String, File?> _stickerFiles = {};
  final Map<String, String?> _stickerUrls = {};
  final Map<String, bool> _uploading = {};

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as OrderModel;
    for (final p in _order.products) {
      _stickerFiles[p.id] = null;
      _stickerUrls[p.id] = null;
      _uploading[p.id] = false;
    }
  }

  @override
  void dispose() {
    _receiverCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload(String productItemId) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _stickerFiles[productItemId] = File(picked.path);
      _uploading[productItemId] = true;
    });

    final url = await _ctrl.uploadStickerImage(File(picked.path));

    setState(() {
      _uploading[productItemId] = false;
      _stickerUrls[productItemId] = url;
    });

    if (url == null) {
      ToastMessageHelper.showToastMessage('Upload failed', title: 'Error');
    }
  }

  Future<void> _submit() async {
    if (_receiverCtrl.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter receiver name',
          title: 'Error');
      return;
    }

    final stickerUrls = _stickerUrls.values.whereType<String>().toList();

    final success = await _ctrl.submitConfirmation(
      orderId: _order.id,
      receiverName: _receiverCtrl.text.trim(),
      stickerUrls: stickerUrls,
    );

    if (success) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
              color: Color(0xffEBEBEB),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
        title: CustomText(
          text: "Confirmation",
          fontSize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Receiver Name
                  CustomText(
                    text: "Receiver Name",
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _receiverCtrl,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: "enter name",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13.sp),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
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

                  SizedBox(height: 24.h),

                  CustomText(
                    text: "Upload sticker",
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 12.h),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _order.products.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final item = _order.products[index];
                        final isUploading = _uploading[item.id] == true;
                        final uploadedFile = _stickerFiles[item.id];
                        final uploadedUrl = _stickerUrls[item.id];

                        String fileLabel;
                        if (isUploading) {
                          fileLabel = "Uploading...";
                        } else if (uploadedFile != null) {
                          fileLabel = uploadedFile.path.split('/').last;
                        } else {
                          fileLabel = "Upload photo";
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: item.product.name,
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              CustomText(
                                text: fileLabel,
                                fontSize: 12.h,
                                color: uploadedUrl != null
                                    ? Colors.green
                                    : Colors.grey.shade500,
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: isUploading
                                    ? null
                                    : () => _pickAndUpload(item.id),
                                child: isUploading
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : Container(
                                        width: 32.w,
                                        height: 32.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: uploadedUrl != null
                                                ? Colors.green
                                                : AppColors.primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_upward_rounded,
                                          size: 16.r,
                                          color: uploadedUrl != null
                                              ? Colors.green
                                              : AppColors.primaryColor,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          // Submit button
          Obx(() => Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, bottom: 40.h),
                child: _ctrl.isSubmitting.value
                    ? Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor))
                    : CustomButtonGradiant(
                        title: "Submit",
                        onpress: _submit,
                      ),
              )),
        ],
      ),
    );
  }
}
