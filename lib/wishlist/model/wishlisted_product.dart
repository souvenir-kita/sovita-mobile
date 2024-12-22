import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/wishlist/model/product_wishlist.dart';

class WishlistedProduct {
  final Product product;
  final Wishlist wishlist;

  WishlistedProduct({required this.product, required this.wishlist});
}
