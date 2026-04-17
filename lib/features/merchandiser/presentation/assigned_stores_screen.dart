

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';

class AssignedStoresScreen extends StatefulWidget {
  const AssignedStoresScreen({super.key});

  @override
  State<AssignedStoresScreen> createState() => _AssignedStoresScreenState();
}

class _AssignedStoresScreenState extends State<AssignedStoresScreen> {
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
        title: CustomText(text: "Assigned Store", fontSize: 18.h, fontWeight: FontWeight.w500),

      ),



      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [


            Expanded(child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 16.h, left: 4.w, right: 4.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 1.5,
                          offset: const Offset(0.5, 0.5)
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.r)
                ),

                child: Padding(
                  padding:  EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          CustomText(text: "#123456", fontSize: 10.h),



                          Container(
                            decoration:  BoxDecoration(
                                color: const Color(0xffE7F9FF),
                                borderRadius: BorderRadius.circular(100.r)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              child: Center(
                                child: CustomText(text: "Upcoming", color: const Color(0xff305CDE), fontSize: 10.h),
                              ),
                            ),
                          )



                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          CustomText(text: "Alexandra Store", fontSize: 16.h),




                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Start Within:", fontSize: 10.h),
                              Row(
                                children: [
                                  CustomText(text: "00:15", fontSize: 10.h, color: AppColors.primaryColor),
                                  CustomText(text: "min", fontSize: 8.h),
                                ],
                              ),
                            ],
                          )


                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              CustomText(text: "5th North Avenue,Baridhara DOHS", fontSize: 12.h),
                              CustomText(text: "Schedule: 08:00AM - 10.00 AM", fontSize: 11.h),
                              CustomText(text: "Last Visited: 08/08/25 at 4:30 PM", fontSize: 11.h),
                            ],
                          ),



                          CustomButton(
                              width: 120.w,
                              height: 30.h,
                              borderRadius: 10.r,
                              loaderIgnore: true,
                              fontSize: 10.h,
                              title: index.isEven ? "Contact Manager" : "Clock In", onpress:
                              (){
                            TextEditingController reasonCtrl = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text("Reason"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextField(
                                          controller: reasonCtrl,
                                          hintText: "Type here...",
                                          maxLine: 6,
                                        ),
                                        SizedBox(height: 20.h),
                                        CustomButtonGradiant(
                                          title: "Submit",
                                          onpress: () {
                                            // your submit logic here
                                            String reason = reasonCtrl.text.trim();
                                            if (reason.isNotEmpty) {
                                              Navigator.pop(context); // close dialog
                                              // handle submission
                                              print("Reason: $reason");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          )

                            ],
                      )


                    ],
                  ),
                ),
              );
            },))



          ],
        ),
      ),
    );
  }
}
