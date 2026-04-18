import 'package:get/get.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';
import 'package:mc/features/merchandiser/presentation/controllers/product_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => MerchandiserController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}