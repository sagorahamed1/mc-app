


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';
import 'package:mc/shared/widgets/custom_text.dart';



class GeneralInformationScreen extends StatelessWidget {
   GeneralInformationScreen({super.key});
  
  
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneNumberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              text: "General Information", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.all(20.r),
        child: Column(
          children: [

            
            CustomNetworkImage(imageUrl: "https://randomuser.me/api/portraits/women/65.jpg", height: 100.h, width: 100.w, boxShape: BoxShape.circle),
            
            

            SizedBox(height: 45.h),

            CustomTextField(controller: nameCtrl, hintText: "name", labelText: "Name", readOnly: true),
            CustomTextField(controller: emailCtrl, hintText: "email", labelText: "Email", readOnly: true),
            CustomTextField(controller: phoneNumberCtrl, hintText: "number", labelText: "Phone Number", readOnly: true),
            
            
            
           const Spacer(),
            
            
            CustomButtonGradiant(title: "EDIT INFORMATION", onpress: (){
              Get.toNamed(AppRoutes.editInformationScreen);
            }),

            
            SizedBox(height: 100.h)

          ],
        ),
      ),

    );
  }


  Widget _customCard(Widget icon, String title, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 1.5,
              offset: const Offset(0.5, 0.5),
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
        ),


        child: Padding(
          padding:  EdgeInsets.all(13.r),
          child: Row(
            children: [


              icon,

              SizedBox(width: 12.w),

              CustomText(text: "${title}"),

              const Spacer(),


              const Icon(Icons.arrow_right)


            ],
          ),
        ),
      ),
    );

  }
}
