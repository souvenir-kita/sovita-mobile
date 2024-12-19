import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/helper/fetch_product_fyp.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/display/widgets/product_card.dart';
import 'package:sovita/display/screens/productdetail.dart';
import 'package:sovita/display/screens/allproducts.dart';
import 'package:sovita/display/screens/category_product.dart';
import 'package:sovita/widget/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    List<GridItemModel> items = [
      GridItemModel(label: "FnB", value: 1, icon: "lib/icons/fnb.png"),
      GridItemModel(
          label: "Dekorasi", value: 2, icon: "lib/icons/dekorasi.png"),
      GridItemModel(
          label: "Aksesoris", value: 3, icon: "lib/icons/aksesoris.png"),
      GridItemModel(label: "Pakaian", value: 4, icon: "lib/icons/pakaian.png"),
      GridItemModel(
          label: "Bodycare", value: 5, icon: "lib/icons/aromaterapi.png"),
      GridItemModel(label: "Semua", value: 6, icon: "lib/icons/all.png"),
    ];

    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          fetchProductRandom(request),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF09027), 
                      Color(0xFFF09027).withOpacity(0.8), 
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Product> products = snapshot.data![0];

            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(child: SearchBarForm()),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 20, 3, 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0x80D9D9D9),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(items.length, (index) {
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GridItem(item: items[index]),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0x80D9D9D9),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 0, 0),
                            child: Text(
                              "Produk Populer",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: products.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                          product: products[index]),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: ProductCard(product: products[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}

class GridItemModel {
  final String label;
  final int value;
  final String icon;

  GridItemModel({required this.label, required this.value, required this.icon});
}

class GridItem extends StatelessWidget {
  final GridItemModel item;

  const GridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.value == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CategoryProductPage(categoryValue: 1)));
        }
        if (item.value == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CategoryProductPage(categoryValue: 2)));
        }
        if (item.value == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CategoryProductPage(categoryValue: 3)));
        }
        if (item.value == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CategoryProductPage(categoryValue: 4)));
        }
        if (item.value == 5) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CategoryProductPage(categoryValue: 5)));
        }
        if (item.value == 6) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AllProducts()));
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8CBEAA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(item.icon, width: 30),
              SizedBox(height: 8),
              Text(
                item.label,
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
