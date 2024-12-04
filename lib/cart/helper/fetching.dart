import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sovita/cart/models/cart.dart';
import 'package:sovita/adminview/models/product.dart';

// Define base URL for your backend API
const String baseUrl = "http://127.0.0.1:8000";

Future<List<CartProduct>> fetchCartProducts() async {
  final response = await http.get(Uri.parse("$baseUrl/cart/json"));

  if (response.statusCode == 200) {
    return cartProductFromJson(response.body);
  } else {
    throw Exception("Failed to load cart products");
  }
}

Future<Product> fetchProductDetails(String productId) async {
  final response = await http.get(Uri.parse("$baseUrl/adminview/json/$productId/"));

  if (response.statusCode == 200) {
    return Product.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load product details");
  }
}
