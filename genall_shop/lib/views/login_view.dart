import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:genall_shop/controller/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_mjlh3hcy.json',
                height: 200,
              ),
              const SizedBox(height: 40),

              Obx(
                () => Text(
                  controller.isLoginMode.value
                      ? "Welcome To GenX"
                      : "Create A GenX",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(label: "Email", icon: Icons.email_outlined),
              const SizedBox(height: 20),

              Obx(
                () => _buildTextField(
                  label: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isHidden: controller.isPasswordHidden.value,
                  onSuffixIconPressed: controller.togglePasswordVisibility,
                ),
              ),

              const SizedBox(height: 30),

              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: controller.login,
                        child: Text(
                          controller.isLoginMode.value ? "Login" : "Sign Up",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: controller.toggleMode,
                child: Obx(
                  () => Text(
                    controller.isLoginMode.value
                        ? "Don't have an account? Create one"
                        : "Already have an account? Login",
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isHidden = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      obscureText: isPassword ? isHidden : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
                onPressed: onSuffixIconPressed,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
