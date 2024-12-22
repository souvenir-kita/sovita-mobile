import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/display/screens/productdetail.dart';
import 'package:sovita/widget/search_bar.dart';
import 'package:sovita/wishlist/model/product_wishlist.dart';
import 'package:sovita/wishlist/model/wishlisted_product.dart';
import 'package:sovita/wishlist/screens/wishlist_edit.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<String> priorityLevels = ["Semua", "Rendah", "Normal", "Tinggi"];
  late List<String> categories;
  String? _selectedPriority;
  String? _selectedCategory;
  late Future<List<WishlistedProduct>> _wishlistedProducts;
  late List<WishlistedProduct> wishlistedProducts;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _wishlistedProducts = fetchWislist(request);
  }

  void fetchWishlistData() {
    final request = Provider.of<CookieRequest>(context, listen: false);
    setState(() {
      _wishlistedProducts = fetchWislist(request);
      _selectedCategory = "Semua";
    });
  }

  void removeFromWishlist(productId) async {
    try {
      final request = Provider.of<CookieRequest>(context, listen: false);
      await request.post(
        'http://127.0.0.1:8000/wishlist/remove-wishlist/$productId/',
        {},
      );
      fetchWishlistData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  Future<List<WishlistedProduct>> fetchWislist(CookieRequest request) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/wishlist/json/');
      if (response is List) {
        List<WishlistedProduct> listWishlistedProducts = [];
        List<WishlistedProduct> highPriorityProducts = [];
        List<WishlistedProduct> medPriorityProducts = [];
        List<WishlistedProduct> lowPriorityProducts = [];
        for (var d in response) {
          if (d != null) {
            Wishlist wishlist = Wishlist.fromJson(d);
            var product =
                await fetchProductDetails(request, wishlist.fields.product);
            if (wishlist.fields.priority == 3) {
              highPriorityProducts
                  .add(WishlistedProduct(product: product, wishlist: wishlist));
            } else if (wishlist.fields.priority == 2) {
              medPriorityProducts
                  .add(WishlistedProduct(product: product, wishlist: wishlist));
            } else {
              lowPriorityProducts
                  .add(WishlistedProduct(product: product, wishlist: wishlist));
            }
          }
        }
        listWishlistedProducts.addAll(highPriorityProducts);
        listWishlistedProducts.addAll(medPriorityProducts);
        listWishlistedProducts.addAll(lowPriorityProducts);
        return listWishlistedProducts;
      } else {
        throw Exception("Unexpected response format: Expected a list.");
      }
    } catch (e) {
      throw Exception("Failed to fetch products: $e");
    }
  }

  List<String> getCategories(List<WishlistedProduct> wishlistedProducts) {
    List<String> categories = ["Semua"];
    for (WishlistedProduct wishlistedProduct in wishlistedProducts) {
      if (!categories.contains(wishlistedProduct.product.fields.category)) {
        categories.add(wishlistedProduct.product.fields.category);
      }
    }
    return categories;
  }

  List<WishlistedProduct> getFilteredProducts() {
    List<WishlistedProduct> filteredProducts = wishlistedProducts;

    if (_selectedPriority != null && _selectedPriority != "Semua") {
      int priorityValue = priorityLevels.indexOf(_selectedPriority!);
      filteredProducts = filteredProducts
          .where((product) => product.wishlist.fields.priority == priorityValue)
          .toList();
    }

    if (_selectedCategory != null && _selectedCategory != "Semua") {
      filteredProducts = filteredProducts
          .where((product) =>
              product.product.fields.category == _selectedCategory!)
          .toList();
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _wishlistedProducts,
        builder: (context, AsyncSnapshot<List<WishlistedProduct>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF09027),
                      const Color(0xFFF09027).withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            wishlistedProducts = snapshot.data as List<WishlistedProduct>;

            return SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(child: SearchBarForm()),
                    const SizedBox(height: 10),
                    if (snapshot.data!.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 80, color: Colors.grey),
                              SizedBox(height: 20),
                              Text(
                                'Wishlist Anda kosong',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedPriority,
                                  items: priorityLevels
                                      .map((priority) => DropdownMenuItem(
                                            value: priority,
                                            child: Text(priority),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Prioritas",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  items: getCategories(wishlistedProducts)
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Kategori",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0x80D9D9D9),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: wishlistedProducts.length < 2
                              ? MediaQuery.of(context).size.width * 0.9
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(9, 10, 9, 10),
                                child: Text(
                                  "Wishlist Anda",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(12, 10, 12, 0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 3 / 5,
                                ),
                                itemCount: getFilteredProducts().length,
                                itemBuilder: (_, index) {
                                  final product = getFilteredProducts()[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    // height: MediaQuery.of(context).size.width * (4 / 3) / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                              child: Image.network(
                                                "http://127.0.0.1:8000/media/${product.product.fields.picture}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  );
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: Text(
                                              product.product.fields.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              "Rp${product.product.fields.price}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              product
                                                  .wishlist.fields.description.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                              maxLines: 4,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  removeFromWishlist(
                                                      product.product.pk);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        const CircleBorder()),
                                                child: const Icon(
                                                    Icons.remove_circle,
                                                    size: 16,
                                                    color: Colors.red),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  fetchWishlistData();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WishlistEdit(
                                                                product: product
                                                                    .product)),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        const CircleBorder()),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 16,
                                                  color: Colors.yellowAccent,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailPage(
                                                              product: product
                                                                  .product),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        const CircleBorder()),
                                                child: const Icon(
                                                  Icons.info,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ])
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Wishlist Anda kosong',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
