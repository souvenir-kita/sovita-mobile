import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/cart/helper/fetching.dart';
import 'package:sovita/cart/models/cart_product.dart';
import 'package:sovita/adminview/models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: FutureBuilder<List<CartProduct>>(
        future: fetchCartProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Your cart is empty!"));
          } else {
            // final request1 = context.watch<CookieRequest>();
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cartProduct = snapshot.data![index];

                return FutureBuilder<Product>(
                  future: fetchProductDetail(request, cartProduct.fields.product),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (productSnapshot.hasError) {
                      return ListTile(
                        title: const Text("Error loading product details"),
                        subtitle: Text("Product ID: ${cartProduct.fields.product}"),
                      );
                    } else {
                      final product = productSnapshot.data!;
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(
                            "http://127.0.0.1:8000/media/${product.fields.picture}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.fields.name),
                          subtitle: Text("Price: ${product.fields.price}"),
                          trailing: Text("x${cartProduct.fields.amount}"),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
