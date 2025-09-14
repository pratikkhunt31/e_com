import 'package:e_com/features/products/screen/prduct_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../features/cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        elevation: 0,
        actions: [
          // Cart Button
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: "Cart",
            onPressed: () {
              Get.to(() => const CartScreen());
            },
          ),

          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: const ProductListScreen(),
    );
  }
}
