import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/wishlist/model/product_wishlist.dart';
import 'package:sovita/wishlist/model/wishlisted_product.dart';

Future<List<WishlistedProduct>> fetchWislist(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/wishlist/json/');
    if (response is List) {
      List<WishlistedProduct> listWishlistedProducts = [];
      List<WishlistedProduct> highPriorityProducts = [];
      List<WishlistedProduct> medPriorityProducts = [];
      List<WishlistedProduct> lowPriorityProducts = [];
      for (var d in response) {
        if (d != null) {
          Wishlist wishlist = Wishlist.fromJson(d);
          var product = await fetchProductDetails(request, wishlist.fields.product);
          if (wishlist.fields.priority == 3) {
            highPriorityProducts.add(WishlistedProduct(product: product, wishlist: wishlist));
          } else if (wishlist.fields.priority == 2) {
            medPriorityProducts.add(WishlistedProduct(product: product, wishlist: wishlist));
          } else {
            lowPriorityProducts.add(WishlistedProduct(product: product, wishlist: wishlist));
          }
        }
      }
      listWishlistedProducts.addAll(highPriorityProducts);
      listWishlistedProducts.addAll(medPriorityProducts);
      listWishlistedProducts.addAll(lowPriorityProducts);
      print(listWishlistedProducts);
      return listWishlistedProducts;
    } else {
      throw Exception("Unexpected response format: Expected a list.");
    }
  } catch (e) {
    throw Exception("Failed to fetch products: $e");
  }
}
