import 'package:get/get.dart';

// Simple model for our products
class Product {
  final String name;
  final double price;
  Product({required this.name, required this.price});
}

class CartController extends GetxController {
  // Observable list of products in the cart
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
    Get.snackbar(
      "Added to Cart", 
      "${product.name} added successfully!",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Calculate total price in dollars
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }
}