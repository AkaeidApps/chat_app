import 'package:get/get.dart';
import '../../../config/app_routes.dart';

class WelcomeController extends GetxController {
  void goToPhoneLogin() {
    Get.toNamed(AppRoutes.PHONE_LOGIN);
  }

  void goToEmailLogin() {
    Get.toNamed(AppRoutes.EMAIL_LOGIN);
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }
}
