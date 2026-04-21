


import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mc/features/splash/presentation/splash_screen.dart';
import 'package:mc/features/auth/presentation/login_screen.dart';
import 'package:mc/features/auth/presentation/forgot_password_screen.dart';
import 'package:mc/features/auth/presentation/reset_password_screen.dart';
import 'package:mc/features/auth/presentation/verify_screen.dart';
import 'package:mc/features/driver/presentation/driver_bottom_nav_bar.dart';
import 'package:mc/features/driver/presentation/confirmation_screen.dart';
import 'package:mc/features/driver/presentation/delivery_details_screen.dart';
import 'package:mc/features/driver/presentation/manage_return_screen.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_bottom_nav_bar.dart';
import 'package:mc/features/merchandiser/presentation/assigned_stores_screen.dart';
import 'package:mc/features/merchandiser/presentation/confirm_order_screen.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_home_screen.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_order_screen.dart';
import 'package:mc/features/merchandiser/presentation/missing_sticker_screen.dart';
import 'package:mc/features/merchandiser/presentation/order_confirm_screen.dart';
import 'package:mc/features/merchandiser/presentation/see_order_screen.dart';
import 'package:mc/features/merchandiser/presentation/product_screen.dart';
import 'package:mc/features/merchandiser/presentation/read_update_screen.dart';
import 'package:mc/features/merchandiser/presentation/report_screen.dart';
import 'package:mc/features/notification/presentation/notification_screen.dart';
import 'package:mc/features/profile/presentation/change_password_screen.dart';
import 'package:mc/features/profile/presentation/edit_information_screen.dart';
import 'package:mc/features/profile/presentation/general_information_screen.dart';
import 'package:mc/features/profile/presentation/privacy_policy_screen.dart';
import 'package:mc/features/profile/presentation/setting_screen.dart';
import 'package:mc/features/warehouse/presentation/warehouse_bottom_nav_bar.dart';
import 'package:mc/features/warehouse/presentation/all_order_screen.dart';
import 'package:mc/features/warehouse/presentation/pick_list_screen.dart';



class AppRoutes {
  static const String splashScreen = "/SplashScreen";
  static const String loginScreen = "/LoginScreen";
  static const String resetPasswordScreen = "/ResetPasswordScreen";
  static const String forgotPasswordScreen = "/ForgotPasswordScreen";
  static const String verifyScreen = "/VerifyScreen";
  static const String merchandiserHomeScreen = "/MerchandiserHomeScreen";
  static const String merchandiserBottomNavBar = "/MerchandiserBottomNavBar";
  static const String assignedStoresScreen = "/AssignedStoresScreen";
  static const String settingScreen = "/SettingScreen";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String privacyPolicyAllScreen = "/PrivacyPolicyAllScreen";
  static const String wareHouseBottomNavBar = "/WareHouseBottomNavBar";
  static const String allOrderScreen = "/AllOrderScreen";
  static const String pickListScreen = "/PickListScreen";
  static const String driverBottomNavBar = "/DriverBottomNavBar";
  static const String deliveryDetailsScreen = "/DeliveryDetailsScreen";
  static const String manageReturnSreen = "/ManageReturnSreen";
  static const String confirmationScreen = "/ConfirmationScreen";
  static const String productScreen = "/ProductScreen";
  static const String notificationScreen = "/NotificationScreen";
  static const String readUpdateScreen = "/ReadUpdateScreen";
  static const String generalInformationScreen = "/GeneralInformationScreen";
  static const String editInformationScreen = "/EditInformationScreen";
  static const String missingStickerScreen = "/MissingStickerScreen";
  static const String reportScreen = "/ReportScreen";
  static const String confirmOrderScreen = "/ConfirmOrderScreen";
  static const String merchandiserOrderScreen = "/MerchandiserOrderScreen";
  static const String orderConfirmScreen = "/OrderConfirmScreen";
  static const String seeOrderScreen = "/SeeOrderScreen";



  static List<GetPage> get routes => [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () =>  LoginScreen()),
    GetPage(name: resetPasswordScreen, page: () =>  ResetPasswordScreen()),
    GetPage(name: forgotPasswordScreen, page: () =>  ForgotPasswordScreen()),
    GetPage(name: verifyScreen, page: () =>  VerifyScreen()),
    GetPage(name: merchandiserHomeScreen, page: () =>  MerchandiserHomeScreen()),
    GetPage(name: merchandiserBottomNavBar, page: () =>  MerchandiserBottomNavBar()),
    GetPage(name: assignedStoresScreen, page: () =>  AssignedStoresScreen()),
    GetPage(name: settingScreen, page: () =>  SettingScreen()),
    GetPage(name: changePasswordScreen, page: () =>  ChangePasswordScreen()),
    GetPage(name: privacyPolicyAllScreen, page: () =>  PrivacyPolicyAllScreen()),
    GetPage(name: wareHouseBottomNavBar, page: () =>  WareHouseBottomNavBar()),
    GetPage(name: allOrderScreen, page: () =>  AllOrderScreen()),
    GetPage(name: pickListScreen, page: () =>  PickListScreen()),
    GetPage(name: driverBottomNavBar, page: () =>  DriverBottomNavBar()),
    GetPage(name: deliveryDetailsScreen, page: () =>  DeliveryDetailsScreen()),
    GetPage(name: manageReturnSreen, page: () =>  ManageReturnSreen()),

    GetPage(name: confirmationScreen, page: () =>  ConfirmationScreen()),
    GetPage(name: productScreen, page: () =>  ProductScreen()),
    GetPage(name: notificationScreen, page: () =>  NotificationScreen()),
    GetPage(name: readUpdateScreen, page: () =>  ReadUpdateScreen()),
    GetPage(name: generalInformationScreen, page: () =>  GeneralInformationScreen()),
    GetPage(name: editInformationScreen, page: () =>  EditInformationScreen()),
    GetPage(name: missingStickerScreen, page: () =>  MissingStickerScreen()),
    GetPage(name: reportScreen, page: () =>  ReportScreen()),
    GetPage(name: confirmOrderScreen, page: () =>  ConfirmOrderScreen()),
    GetPage(name: merchandiserOrderScreen, page: () => const MerchandiserOrderScreen()),
    GetPage(name: orderConfirmScreen, page: () => const OrderConfirmScreen()),
    GetPage(name: seeOrderScreen, page: () => const SeeOrderScreen()),

  ];
}
