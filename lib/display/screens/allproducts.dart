import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/display/widgets/product_card.dart';
import 'package:sovita/display/screens/productdetail.dart';

import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/widget/search_bar.dart';

class AllProducts extends StatefulWidget {
  final String? search;
  const AllProducts({super.key, this.search});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  late Future<List<dynamic>> _products;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    final request = context.read<CookieRequest>();
    setState(() {
      _products = (widget.search == null)
          ? fetchProduct(request)
          : fetchSearchProduct(request, widget.search);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // Ubah ukuran sesuai kebutuhan
                    child: const SearchBarForm(fromAllProductScreen: true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: (widget.search == null)
                    ? fetchProduct(request)
                    : fetchSearchProduct(request, widget.search),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: ProductCard(product: snapshot.data![index]),
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
