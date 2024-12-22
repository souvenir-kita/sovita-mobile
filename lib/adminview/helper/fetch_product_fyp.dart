import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/adminview/models/product.dart';

Future<List<Product>> fetchProductRandom(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/adminview/json-random/');

    if (response is List) {
      List<Product> listProduct = [];
      for (var d in response) {
        if (d != null) {
          listProduct.add(Product.fromJson(d));
        }
      }
      return listProduct;
    } else {
      throw Exception("Unexpected response format: Expected a list.");
    }
  } catch (e) {
    throw Exception("Failed to fetch products: $e");
  }
}
