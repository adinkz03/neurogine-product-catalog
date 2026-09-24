import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/products';

  ProductRepository({http.Client? client}) : client = client ?? http.Client();

  Future<ProductResponse> fetchProducts({int limit = 20, int skip = 0}) async {
    final response = await client.get(
      Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products from server');
    }
  }

  Future<ProductResponse> searchProducts(String query) async {
    final response = await client.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch product details');
    }
  }
}
