import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/widget/navigation_menu.dart';

class DeleteProduct extends StatefulWidget {
  final Product product; // Pass the entire Product object.

  const DeleteProduct({super.key, required this.product});

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  Future<void> deleteProduct(BuildContext context) async {
    try {
      final request = context.read<CookieRequest>();
      final productId = widget.product.pk;
      final response = await request.post(
        'http://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/adminview/delete-flutter/$productId/',{}
      );

      if (response['status'] == 'success') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      } else {
        throw Exception(response['error']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete the product "${widget.product.fields.name}"?',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await deleteProduct(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete Product'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back without deleting
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
