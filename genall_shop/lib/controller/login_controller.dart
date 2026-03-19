import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  var isLoginMode = true.obs;

  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

void login() async {
  isLoading.value = true;
  await Future.delayed(const Duration(seconds: 2));
  isLoading.value = false;

  // This is the landing trigger
  // 'offAllNamed' removes the login page from history so user can't go back to it
  Get.offAllNamed('/home'); 
}
}
