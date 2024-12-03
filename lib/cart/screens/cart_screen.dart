import 'package:flutter/material.dart';
import 'package:sovita/cart/helper/fetching.dart';
import 'package:sovita/cart/models/cart.dart';
import 'package:sovita/display/models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartProduct>> cartProducts;

  @override
  void initState() {
    super.initState();
    cartProducts = fetchCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: FutureBuilder<List<CartProduct>>(
        future: cartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Your cart is empty!"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cartProduct = snapshot.data![index];

                return FutureBuilder<Product>(
                  future: fetchProductDetails(cartProduct.fields.product),
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
                            "$baseUrl/media/images/${product.fields.picture}",
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
