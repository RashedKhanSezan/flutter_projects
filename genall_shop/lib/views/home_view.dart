import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:genall_shop/controller/nav_controller.dart';
import 'package:genall_shop/controller/cart_controller.dart';
import 'package:genall_shop/views/cart_view.dart';
import 'product_grid_view.dart'; 

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final NavController navEmail = Get.put(NavController());
  final CartController cartController = Get.put(CartController());


  final List<Widget> screens = [
    ProductGridView(), 
    CartView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GenAll Shop",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
              ),
              accountName: const Text("Rashed Mosharraf"), //
              accountEmail: const Text("developer@genall.com"),
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),

              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("My Orders"),
              onTap: () {},
            ),
            const Spacer(), 
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
              
                Get.offAllNamed('/login');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

   
      body: Obx(() => screens[navEmail.selectedIndex.value]),

     
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navEmail.selectedIndex.value,
          onTap: navEmail.changeIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Shop",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_basket),
                  Positioned(
                    right: 0,
                    child: Obx(
                      () => cartController.cartItems.isEmpty
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${cartController.cartItems.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
