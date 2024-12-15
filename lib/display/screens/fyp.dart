import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/helper/fetch_product_fyp.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/display/screens/product_card.dart';
import 'package:sovita/display/screens/productdetail.dart';
import 'package:sovita/display/screens/allproducts.dart';
import 'package:sovita/display/screens/category_product.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Daftar objek GridItemModel dengan value yang lebih lengkap
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
      appBar: AppBar(
        backgroundColor: Color(0xFFF09027),
        title: Image.asset('lib/assets/title.png', width: 100),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 20, height: 30),
                      Text('Cari Produk')
                    ],
                  ),
                ),
              ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GridItem(item: items[index]),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0x80D9D9D9),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.35,
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
                      Expanded(
                        child: FutureBuilder<List<Product>>(
                          future: fetchProductRandom(request),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                          builder: (context) =>
                                              ProductDetailPage(
                                            product: snapshot.data![index],
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(15),
                                    child: ProductCard(
                                        product: snapshot.data![index]),
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
            ],
          ),
        ),
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
        if(item.value == 1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryProductPage(categoryValue: 1)));
        }
        if(item.value == 2){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryProductPage(categoryValue: 2)));
        }
        if(item.value == 3){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryProductPage(categoryValue: 3)));
        }
        if(item.value == 4){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryProductPage(categoryValue: 4)));
        }
        if(item.value == 5){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryProductPage(categoryValue: 5)));
        }
        if (item.value == 6) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AllProducts()));
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
