import 'package:flutter/material.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/screens/add_to_cart_form.dart';
import 'package:sovita/cart/screens/cart_form.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Product: ${product.fields.name}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${product.fields.name}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              "Price: \$${product.fields.price}",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              "Desc:\n${product.fields.description}",
              style: const TextStyle(color: Colors.black),
              softWrap: true,
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${product.fields.category}",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              "Location: ${product.fields.location}",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 29, 29, 29),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Back to Product List"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => AddToCartForm(productPk: product.pk),
        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 29, 29, 29),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Add to cart"),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
