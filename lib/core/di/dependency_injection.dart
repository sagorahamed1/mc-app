import 'package:get/get.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/product_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/report_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/order_controller.dart';
import 'package:mc/features/warehouse/presentation/controllers/warehouse_order_controller.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/features/notification/presentation/controllers/notification_controller.dart';
import 'package:mc/features/profile/presentation/controllers/setting_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => MerchandiserController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => WarehouseOrderController(), fenix: true);
    Get.lazyPut(() => DriverController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => SettingController(), fenix: true);
  }
}