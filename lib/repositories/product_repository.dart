import 'dart:convert';
import 'package:http/http.dart' as http;

import '../features/products/data/models/product_model.dart';

class ProductRepository {
  final String baseUrl = "https://dummyjson.com/products";

  /// Fetch products with pagination
  /// [limit] = number of products per page
  /// [skip] = offset
  Future<List<Product>> fetchProducts({int limit = 10, int skip = 0}) async {
    final url = Uri.parse("$baseUrl?limit=$limit&skip=$skip");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productsJson = data['products'] as List<dynamic>;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products: ${response.body}");
    }
  }

  /// Search products by query
  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse("$baseUrl/search?q=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productsJson = data['products'] as List<dynamic>;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to search products: ${response.body}");
    }
  }

  Future<Product> getSingleProduct(int id) async {
    final url = Uri.parse("https://dummyjson.com/products/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception("Failed to fetch product: ${response.body}");
    }
  }


  /// Get products by category
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse("$baseUrl/category/$category");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productsJson = data['products'] as List<dynamic>;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load category products: ${response.body}");
    }
  }

  /// Fetch all categories
  Future<List<String>> fetchCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = jsonDecode(response.body);
      return categoriesJson.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load categories: ${response.body}");
    }
  }
}