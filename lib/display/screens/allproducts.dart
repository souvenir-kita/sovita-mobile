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
  final String? filter;
  const AllProducts({super.key, this.search, this.filter});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  late Future<List<Product>> _products;

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

  List<Product> _applyFilter(List<Product> products) {
    if (widget.filter == null) return products;

    final filterParts = widget.filter!.split(':');
    final filterType = filterParts[0];
    final order = filterParts.length > 1 ? filterParts[1] : 'asc';

    switch (filterType) {
      case 'price':
        products.sort((a, b) => 
            order == 'asc' ?  int.parse(double.parse(a.fields.price).toStringAsFixed(0)).compareTo( int.parse(double.parse(b.fields.price).toStringAsFixed(0))) 
                            : int.parse(double.parse(b.fields.price).toStringAsFixed(0)).compareTo( int.parse(double.parse(a.fields.price).toStringAsFixed(0))));
        break;
      case 'alphabet':
        products.sort((a, b) =>
            order == 'asc' ? a.fields.name.compareTo(b.fields.name) : b.fields.name.compareTo(a.fields.name));
        break;
      case 'time':
        products.sort((a, b) =>
            order == 'asc' ? a.fields.dateCreated.compareTo(b.fields.dateCreated) : b.fields.dateCreated.compareTo(a.fields.dateCreated));
        break;
    }

    return products;
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: const SearchBarForm(fromAllProductScreen: true),
                    ),
                  ],
                ),
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
                      // Apply filter after fetching the products
                      List<Product> filteredProducts =
                          _applyFilter(snapshot.data);
          
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
            ],
          ),
        ),
      ),
    );
  }
}