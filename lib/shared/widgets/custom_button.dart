//
//
//
// import 'package:flutter/material.dart';
//
// class CustomGradientButton extends StatelessWidget {
//   final String? title;
//   final String? title;
//   const CustomGradientButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//
//         print("Button tapped");
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black, Colors.blue],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Text(
//           "SEND CODE",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'custom_text.dart';

class CustomButtonGradiant extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final Color? boderColor;
  final Color? titlecolor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool loading;
  final bool loaderIgnore;

  CustomButtonGradiant({
    super.key,
    required this.title,
    required this.onpress,
    this.color,
    this.boderColor,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.loading = false,
    this.loaderIgnore = false,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? () {} : onpress,
      child: Container(
        width: width?.w ?? double.infinity,
        height: height ?? 50.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          border: Border.all(color: boderColor ?? AppColors.primaryColor),
          gradient: const LinearGradient(
            colors: [Color(0xff020202), Color(0xff2D56CF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loaderIgnore ? const SizedBox() : SizedBox(width: 30.w),
            Center(
              child: CustomText(
                text: title,
                fontSize: fontSize ?? 16.h,
                color: titlecolor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
            if (loading) ...[
              SizedBox(width: 10.w),
              SizedBox(
                height: 18.h,
                width: 18.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ] else
              loaderIgnore ? const SizedBox() : SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}




class CustomButton extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final Color? boderColor;
  final Color? titlecolor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool loading;
  final bool loaderIgnore;

  CustomButton({
    super.key,
    required this.title,
    required this.onpress,
    this.color,
    this.boderColor,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.loading = false,
    this.loaderIgnore = false,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? () {} : onpress,
      child: Container(
        width: width?.w ?? double.infinity,
        height: height ?? 50.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          border: Border.all(color: boderColor ?? AppColors.primaryColor),
          color: color ?? AppColors.primaryColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loaderIgnore ? const SizedBox() : SizedBox(width: 30.w),
            Center(
              child: CustomText(
                text: title,
                fontSize: fontSize ?? 16.h,
                color: titlecolor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
            if (loading) ...[
              SizedBox(width: 10.w),
              SizedBox(
                height: 18.h,
                width: 18.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ] else
              loaderIgnore ? const SizedBox() : SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}
