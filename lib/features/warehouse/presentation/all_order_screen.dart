

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
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
                  color: Color(0xffEBEBEB),
                  shape: BoxShape.circle
              ),
              child: const Center(
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: CustomText(
              text: "All Orders", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [

            SizedBox(height: 10.h),


            Expanded(child:   ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 1.5,
                              offset: const Offset(0.5, 0.5))
                        ],
                        borderRadius: BorderRadius.circular(8.r)),

                    child: Padding(
                      padding:  EdgeInsets.all(12.5.r),
                      child: Row(
                        children: [



                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              CustomText(text: "#123456", fontSize: 16.h),
                              CustomText(text: "08/08/25 at 4:30 PM", fontSize: 10.h, color: AppColors.textColor5c5c5c),

                            ],
                          ),




                          const Spacer(),


                          CustomButton(
                              height: 25.h,
                              width: 125.h,
                              fontSize: 10.h,
                              borderRadius: 8.r,
                              loaderIgnore: true,
                              title: "View Pick List", onpress: (){})







                        ],
                      ),
                    ),
                  );
                }))

          ],
        ),
      ),

    );
  }
}
