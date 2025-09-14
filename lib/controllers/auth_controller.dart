import 'package:get/get.dart';
import '../features/auth/data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var isLoading = false.obs;


  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final userData = await _authRepository.login(username, password);
      Get.snackbar("Success", "Welcome ${userData["firstName"] ?? username}");
      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String username, String password, String email) async {
    try {
      isLoading.value = true;
      final userData = await _authRepository.register(username, password, email);
      Get.snackbar("Success", "User ${userData["username"]} registered");
      Get.offAllNamed("/login");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed("/login");
  }

  bool isLoggedIn() => _authRepository.isLoggedIn();
}
