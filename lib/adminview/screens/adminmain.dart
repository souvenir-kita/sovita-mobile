import 'package:flutter/material.dart';
import 'package:sovita/adminview/screens/productlist.dart';
import 'package:sovita/adminview/screens/productform.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman ProductForm
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductForm()),
                );
              },
              child: const Text("Add a new Product"),
            ),
            const SizedBox(height: 16), // Jarak antara tombol
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman ProductList
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductList()),
                );
              },
              child: const Text("View Product List"),
            ),
          ],
        ),
      ),
    );
  }
}
