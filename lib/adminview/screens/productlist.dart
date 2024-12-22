import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/adminview/screens/productcardadmin.dart';
import 'package:sovita/display/screens/productdetail.dart';
import 'package:sovita/adminview/screens/editproduct.dart';
import 'package:sovita/adminview/screens/deleteproduct.dart';
import 'package:sovita/widget/search_bar.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    final request = context.read<CookieRequest>();
    setState(() {
      _products = fetchProduct(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF09027),
        title: Image.asset('lib/assets/title.png', width: 100),
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
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: const SearchBarForm(fromAllProductScreen: true),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada produk ditemukan.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 3 / 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        final product = snapshot.data[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: ProductCard(product: product),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
