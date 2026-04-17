import 'package:get/get.dart';
import 'package:mc/features/auth/presentation/controllers/auth_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}