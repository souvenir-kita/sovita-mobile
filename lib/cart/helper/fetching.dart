import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/models/cart_product.dart';

Future<Product> fetchProductDetail(
  CookieRequest request, String productId) async {
  // web: 127.0.0.1
  final response =
      await request.get('http://10.0.2.2:8000/adminview/json/$productId/');

  var data = response;
  if (data[0] == null) {
    throw "produk gagal";
  }

  Product d = Product.fromJson(data[0]);

  return d;
}

Future<void> addCertainCartProduct(CookieRequest request) async {
  // web: 127.0.0.1
  await request.get('http://10.0.2.2:8000/cart/inc_amount/d2532d21-2cf1-4df7-95f2-b9a262ff9e56/');
}

Future<List<CartProduct>> fetchCartProduct(CookieRequest request) async {
  // web: 127.0.0.1
  final response = await request.get('http://10.0.2.2:8000/cart/user-cart-products/');

  var data = response;

  List<CartProduct> listCartProduct = [];
  for (var d in data) {
    if (d != null) {
      listCartProduct.add(CartProduct.fromJson(d));
    }
  }
  return listCartProduct;
}
