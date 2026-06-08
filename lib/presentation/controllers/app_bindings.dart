// lib/presentation/controllers/app_bindings.dart
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'home_controller.dart';
import 'booking_controller.dart';
import 'location_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
    Get.lazyPut<LocationController>(() => LocationController(), fenix: true);
  }
}
