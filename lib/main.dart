import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mc/core/di/dependency_injection.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/theme/app_theme.dart';
import 'package:mc/features/splash/presentation/splash_screen.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: GetMaterialApp(
            title: 'MC',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splashScreen,
            initialBinding: DependencyInjection(),
            getPages: AppRoutes.routes,
            theme: lightTheme(),
            themeMode: ThemeMode.light,
            home: child,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}