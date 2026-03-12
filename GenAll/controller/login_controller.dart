import 'package:get/get.dart';

class LoginController extends GetxController {

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    isLoading.value = true;
    

    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    Get.snackbar(
      "Success", 
      "Welcome Back!",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}