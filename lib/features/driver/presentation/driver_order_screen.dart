

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class DriverOrderScreen extends StatefulWidget {
  const DriverOrderScreen({super.key});

  @override
  State<DriverOrderScreen> createState() => _DriverOrderScreenState();
}

class _DriverOrderScreenState extends State<DriverOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const SizedBox(),
          title: CustomText(
              text: "Orders", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [




            SizedBox(height: 10.h),


            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h, top: 2.h, left: 2.w, right: 2.w),
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
              
                                CustomText(text: "Store #102", fontSize: 16.h),
                                CustomText(text: "5th North Avenue, Dhaka-1240", fontSize: 12.h, color: AppColors.textColor5c5c5c),
                                CustomText(text: "08/08/25 at 4:30 PM", fontSize: 10.h, color: const Color(0xff59B5F7), top: 4.h),
              
                              ],
                            ),
              
              
              
              
                            const Spacer(),
              
              
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
              
              
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE7F9FF),
                                      borderRadius: BorderRadius.circular(16.r)
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 8.h, vertical: 3.h),
                                      child: CustomText(text: "Upcoming", color: AppColors.primaryColor),
                                    ),
                                  ),
                                ),
              
              
                                SizedBox(height: 26.h),
              

                                if(index == 4)
                                CustomButton(
                                    height: 25.h,
                                    width: 125.h,
                                    fontSize: 10.h,
                                    borderRadius: 8.r,
                                    loaderIgnore: true,
                                    title: "Upload Sticker", onpress: (){}),
                              ],
                            )
              
              
              
              
              
              
              
                          ],
                        ),
                      ),
                    );
                  }),
            ),



          ],
        ),
      ),


    );
  }
}
