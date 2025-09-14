import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../core/storage/hive_boxes.dart';

class AuthRepository {
  final _authBox = Hive.box(HiveBoxes.settings);

  /// Login with username and password
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("https://dummyjson.com/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "expiresInMins": 30, // optional
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final accessToken = data["accessToken"];
      final refreshToken = data["refreshToken"];

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No accessToken received from API");
      }

      // ✅ Save session tokens in Hive
      await _authBox.put("accessToken", accessToken);
      await _authBox.put("refreshToken", refreshToken);
      await _authBox.put("user", data);

      print("✅ AccessToken saved: $accessToken");

      return data;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  /// Register a new user
  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final url = Uri.parse("https://dummyjson.com/users/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Save user info only (no token)
      await _authBox.put("user", data);

      print("ℹ️ Registered user saved (no token)");

      return data;
    } else {
      throw Exception("Registration failed: ${response.body}");
    }
  }

  /// Logout and clear session
  Future<void> logout() async {
    await _authBox.delete("accessToken");
    await _authBox.delete("refreshToken");
    await _authBox.delete("user");
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final token = _authBox.get("accessToken");
    return token != null && token.isNotEmpty;
  }

  /// Get stored user data
  Map<String, dynamic>? getUser() {
    return _authBox.get("user");
  }
}
