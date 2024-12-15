import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/display/screens/product_card.dart';
import 'package:sovita/display/screens/productdetail.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';

class CategoryProductPage extends StatelessWidget {
  final int categoryValue; // Tambahkan parameter kategori

  const CategoryProductPage({super.key, required this.categoryValue});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Fungsi untuk mencocokkan kategori
    String getCategoryName(int value) {
      switch (value) {
        case 1:
          return "FnB";
        case 2:
          return "Dekorasi";
        case 3:
          return "Aksesoris";
        case 4:
          return "Pakaian/Kain";
        case 5:
          return "Lulur & Aromateraphy";
        default:
          return "";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF09027),
        title: const Text('Produk Kategori'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Product>>(
          future: fetchProduct(request), // Menggunakan fetchProduct biasa
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Tidak ada produk yang tersedia.'));
            } else {
              // Filter data berdasarkan kategori
              String categoryName = getCategoryName(categoryValue);

              List<Product> filteredProducts = snapshot.data!
                  .where((product) => product.fields.category == categoryName)
                  .toList();
              if (filteredProducts.isEmpty) {
                return const Center(
                    child: Text('Tidak ada produk dalam kategori ini.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            product: filteredProducts[index],
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: ProductCard(product: filteredProducts[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
