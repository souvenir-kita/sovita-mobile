import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/models/cart.dart';

Future<Product> fetchProductDetail(CookieRequest request, String productId) async {
    final response = await request.get('http://127.0.0.1:8000/adminview/json/$productId/');
    
    var data = response;

    Product d = Product.fromJson(data[0]);
        
    return d;
  }

Future<List<CartProduct>> fetchCartProduct(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/cart/json/');
    
    var data = response;
    
    List<CartProduct> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(CartProduct.fromJson(d));
      }
    }
    return listMood;
  }