import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/models/cart_product.dart';

Future<Product> fetchProductDetail(
    CookieRequest request, String productId) async {
  final response =
      await request.get('http://127.0.0.1:8000/adminview/json/$productId/');

  var data = response;
  if (data[0] == null) {
    throw "produk gagal";
  }

  Product d = Product.fromJson(data[0]);

  return d;
}

Future<List<CartProduct>> fetchCartProduct(CookieRequest request) async {
  final response = await request.get('http://127.0.0.1:8000/cart/user-cart-products');

  var data = response;

  List<CartProduct> listCartProduct = [];
  for (var d in data) {
    if (d != null) {
      listCartProduct.add(CartProduct.fromJson(d));
    }
  }
  return listCartProduct;
}
