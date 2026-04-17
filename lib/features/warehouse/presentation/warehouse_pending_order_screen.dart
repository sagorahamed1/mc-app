



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';

import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class WareHousePendingOrderScreen extends StatefulWidget {
  final String type;
  const WareHousePendingOrderScreen({super.key, required this.type});

  @override
  State<WareHousePendingOrderScreen> createState() => _WareHousePendingOrderScreenState();
}

class _WareHousePendingOrderScreenState extends State<WareHousePendingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          leading: SizedBox(),
          title: CustomText(
              text: "${widget.type} Orders", fontWeight: FontWeight.w500, fontSize: 18.h)),



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

                              CustomText(text: "#123456", fontSize: 16.h),
                              CustomText(text: "08/08/25 at 4:30 PM", fontSize: 10.h, color: AppColors.textColor5c5c5c),

                            ],
                          ),




                          const Spacer(),


                          widget.type  == "Pending" ?
                          CustomButton(
                              height: 25.h,
                              width: 125.h,
                              fontSize: 10.h,
                              borderRadius: 8.r,
                              loaderIgnore: true,
                              title: "View Pick List", onpress: (){
                                Get.toNamed(AppRoutes.pickListScreen);
                          }) :


                              Column(
                                children: [

                                  CustomText(text: "80%", color: AppColors.primaryColor),
                                  CustomText(text: "Completed")

                                ],
                              )







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
