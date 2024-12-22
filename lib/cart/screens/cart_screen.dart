import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/cart/helper/cart_action.dart';
import 'package:sovita/cart/helper/converter.dart';
import 'package:sovita/cart/helper/fetching.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/models/cart_product.dart';
import 'package:sovita/cart/widgets/app_bar.dart';
import 'package:sovita/cart/widgets/other.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, bool> _selectedProducts = {}; // Tracks selected products
  final Map<String, double> _productPrices = {}; // Tracks product prices
  double _totalPrice = 0.0; // Tracks total price of selected products

  void _calculateTotalPrice() {
    _totalPrice = 0.0;
    _selectedProducts.forEach((cartProductId, isSelected) {
      if (isSelected) {
        _totalPrice += _productPrices[cartProductId] ?? 0.0;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: GradientAppBar(
        title: "My Cart",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: FutureBuilder<List<CartProduct>>(
          future: fetchCartProduct(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Your cart is empty!"));
            } else {
              final cartProducts = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final cartProduct = cartProducts[index];
                        return FutureBuilder<Product>(
                          future: fetchProductDetail(
                              request, cartProduct.fields.product),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (productSnapshot.hasError) {
                              return ListTile(
                                title:
                                    const Text("Error loading product details"),
                                subtitle: Text(
                                    "Product ID: ${cartProduct.fields.product}"),
                              );
                            } else {
                              final product = productSnapshot.data!;
                              final double totalProductPrice = product.fields.priceAsDouble *
                                  cartProduct.fields.amount;

                              // Store product price in the map for later calculations
                              _productPrices[cartProduct.pk] = totalProductPrice;

                              return Card(
                                color: Colors.white70,
                                margin: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Image.network(
                                    "http://127.0.0.1:8000/media/${product.fields.picture}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.fields.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            rp(totalProductPrice),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 6, 50, 101),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rp(product.fields.priceAsDouble),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 119, 119, 120),
                                        ),
                                      ),
                                      Text(
                                        "Note: ${cartProduct.fields.note ?? '-'}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => updateAmount(
                                                    request,
                                                    cartProduct.pk,
                                                    false,
                                                    context,
                                                    setState),
                                                child: const Icon(Icons.remove),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0),
                                                child: Text(cartProduct
                                                    .fields.amount
                                                    .toString()),
                                              ),
                                              GestureDetector(
                                                onTap: () => updateAmount(
                                                    request,
                                                    cartProduct.pk,
                                                    true,
                                                    context,
                                                    setState),
                                                child: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => deleteCartProduct(
                                                    request,
                                                    cartProduct.pk,
                                                    context,
                                                    setState),
                                                child: const Text(
                                                  "Hapus",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () => editNote(
                                                    request,
                                                    cartProduct.pk,
                                                    cartProduct.fields.note ??
                                                        '',
                                                    context,
                                                    setState),
                                                child: const Text(
                                                  "Edit note",
                                                  style: TextStyle(
                                                      color: Colors.teal),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Checkbox(                                    
                                    value: _selectedProducts[cartProduct.pk] ??
                                        false,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _selectedProducts[cartProduct.pk] =
                                            value ?? false;
                                        _calculateTotalPrice();
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Total: ${rp(_totalPrice)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _totalPrice > 0
                              ? () {
                                  // Handle pseudo-checkout logic here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Ter-check out!"),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text("Checkout"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
