import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (authController.isLoggedIn()) {
        Get.offAllNamed("/home");
      } else {
        Get.offAllNamed("/login");
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
