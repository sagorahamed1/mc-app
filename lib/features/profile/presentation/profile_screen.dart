import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_text.dart';

import 'package:mc/core/services/storage_service.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/shared/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/profileBg.png"),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                SizedBox(height: 100.h),
                Obx(() => CustomNetworkImage(
                    imageUrl: ApiConstants.imageBaseUrl + auth.userImage.value,
                    height: 100.h,
                    width: 100.w,
                    boxShape: BoxShape.circle)),
                Obx(() => CustomText(
                    text: auth.userName.value,
                    fontSize: 18.h,
                    fontWeight: FontWeight.w500,
                    bottom: 16.h,
                    top: 8.h,
                    color: Colors.white)),
              ],
            ),
          ),



          SizedBox(height: 100.h),



          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [



                ///======= General Info=========>>>

                GestureDetector(
                  onTap: () {

                    Get.toNamed(AppRoutes.generalInformationScreen);

                  },
                  child: Row(
                    children: [


                      Assets.icons.man.svg(),

                      SizedBox(width: 12.w),

                      CustomText(text: "General Info"),

                     const Spacer(),


                     const Icon(Icons.keyboard_arrow_right_rounded)


                    ],
                  ),
                ),
               const Divider(color: AppColors.primaryColor),





                SizedBox(height: 24.h),



                ///==========Setting =====>
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.settingScreen);
                  },
                  child: Row(
                    children: [


                      Assets.icons.setting.svg(),

                      SizedBox(width: 12.w),

                      CustomText(text: "Setting"),

                      const Spacer(),


                      const Icon(Icons.keyboard_arrow_right_rounded)


                    ],
                  ),
                ),
                const Divider(color: AppColors.primaryColor),






                SizedBox(height: 24.h),



                ///==========Setting =====>
                GestureDetector(
                  onTap: () {




                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                  text: "Log Out",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w600,
                                  top: 20.h,
                                  bottom: 12.h,
                                  color: const Color(0xff592B00)),
                              const Divider(),
                              SizedBox(height: 12.h),
                              CustomText(
                                maxline: 2,
                                bottom: 20.h,
                                text: "Do you want to log out your profile?",
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomButton(
                                        height: 50.h,
                                        title: "Cancel",
                                        onpress: () {
                                          Get.back();
                                        },
                                        color: Colors.transparent,
                                        fontSize: 11.h,
                                        loaderIgnore: true,
                                        boderColor: Colors.black,
                                        titlecolor: Colors.black),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    flex: 1,
                                    child: CustomButton(
                                        loading: false,
                                        loaderIgnore: true,
                                        height: 50.h,
                                        title: "Log Out",
                                        onpress: () async{
                                          await PrefsHelper.remove(AppConstants.name);
                                          await PrefsHelper.remove(AppConstants.email);
                                          await PrefsHelper.remove(AppConstants.image);
                                          await PrefsHelper.remove(AppConstants.address);
                                          await PrefsHelper.remove(AppConstants.number);
                                          await PrefsHelper.remove(AppConstants.bearerToken);
                                          await PrefsHelper.remove(AppConstants.isLogged);
                                          await PrefsHelper.remove(AppConstants.rating);
                                          await PrefsHelper.remove(AppConstants.userId);
                                          await PrefsHelper.remove(AppConstants.role);
                                          await PrefsHelper.remove(AppConstants.dateOfBirth);
                                          Get.offAllNamed(AppRoutes.loginScreen);
                                        },
                                        fontSize: 11.h),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );



                  },
                  child: Row(
                    children: [


                      Assets.icons.logOut.svg(),

                      SizedBox(width: 12.w),

                      CustomText(text: "Log Out"),

                      const Spacer(),


                      const Icon(Icons.keyboard_arrow_right_rounded)


                    ],
                  ),
                ),
                const Divider(color: AppColors.primaryColor),



              ],
            ),
          )







        ],
      ),
    );
  }
}
