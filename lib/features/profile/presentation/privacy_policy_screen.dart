import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/features/profile/presentation/controllers/setting_controller.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class PrivacyPolicyAllScreen extends StatefulWidget {
  const PrivacyPolicyAllScreen({super.key});

  @override
  State<PrivacyPolicyAllScreen> createState() => _PrivacyPolicyAllScreenState();
}

class _PrivacyPolicyAllScreenState extends State<PrivacyPolicyAllScreen> {
  final SettingController _ctrl = Get.find<SettingController>();

  @override
  void initState() {
    super.initState();
    _ctrl.fetchContent(Get.arguments['key'] as String);
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
            text: Get.arguments['title'] as String,
            fontWeight: FontWeight.w500,
            fontSize: 18.h),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.content.isEmpty) {
          return Center(
            child: CustomText(
              text: 'No content available.',
              fontSize: 14.h,
              color: Colors.grey,
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Html(
            data: _ctrl.content.value,
            style: {
              'body': Style(
                fontSize: FontSize(14.sp),
                color: Colors.black87,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'h2': Style(
                fontSize: FontSize(16.sp),
                fontWeight: FontWeight.w700,
                color: Colors.black,
                margin: Margins.only(top: 16, bottom: 6),
              ),
              'h3': Style(
                fontSize: FontSize(14.sp),
                fontWeight: FontWeight.w600,
                color: Colors.black,
                margin: Margins.only(top: 10, bottom: 4),
              ),
              'p': Style(
                fontSize: FontSize(13.sp),
                lineHeight: LineHeight(1.6),
                margin: Margins.only(bottom: 8),
              ),
              'li': Style(
                fontSize: FontSize(13.sp),
                lineHeight: LineHeight(1.6),
              ),
              'strong': Style(fontWeight: FontWeight.w600),
            },
          ),
        );
      }),
    );
  }
}
