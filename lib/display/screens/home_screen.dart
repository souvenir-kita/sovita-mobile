import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/cart/screens/cart_screen.dart';
import 'package:sovita/adminview/screens/adminmain.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/display/screens/productdetail.dart';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/cart/screens/cart_screen.dart';
import 'package:sovita/adminview/screens/adminmain.dart';
import 'package:sovita/adminview/helper/fetch_product.dart';
import 'package:sovita/display/screens/productdetail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Sovita Mobile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final response = await request.logout(
                        "http://127.0.0.1:8000/authentication/api-logout/");
                    String message = response["message"];
                    if (context.mounted) {
                      if (response['status']) {
                        request.cookies.remove("isAdmin");
                        String uname = response["username"];
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message Sampai jumpa, $uname."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Logout"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                  child: const Text("Cart"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminPage()),
                    );
                  },
                  child: const Text("Admin"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data produk.',
                      style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => Card(
                      color: const Color.fromARGB(255, 29, 29, 29),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "${snapshot.data![index].fields.name}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.network(
                                "http://127.0.0.1:8000/media/${snapshot.data![index].fields.picture}",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 50,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                "Price: \$${snapshot.data![index].fields.price}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
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
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}