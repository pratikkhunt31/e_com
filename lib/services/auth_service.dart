import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService{
  static const String baseUrl = "https://dummyjson.com/auth";
  static const _storage = FlutterSecureStorage();

  /// Save token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: "auth_token", value: token);
  }

  /// Get stored token
  static Future<String?> getToken() async {
    return await _storage.read(key: "auth_token");
  }

  /// Clear token
  static Future<void> clearToken() async {
    await _storage.delete(key: "auth_token");
  }

  /// Login API
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // store token securely
      await saveToken(data["token"]);
      return data;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  /// Register API 
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("https://dummyjson.com/users/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Simulate token since DummyJSON doesn’t provide one on register
      await saveToken("dummy_token_${data['id']}");
      return data;
    } else {
      throw Exception("Register failed: ${response.body}");
    }
  }

  /// Logout
  static Future<void> logout() async {
    await clearToken();
  }
}