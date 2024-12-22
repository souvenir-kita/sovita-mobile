import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/widget/navigation_menu.dart';

class WishlistForm extends StatefulWidget {
  final Product product;
  const WishlistForm({super.key, required this.product});

  @override
  State<WishlistForm> createState() => _WishlistFormState();
}

class _WishlistFormState extends State<WishlistForm> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  // ignore: prefer_final_fields
  int _priority = 2;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah wishlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Description",
                      labelText: "Description",
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _description = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Prioritas",
                      hintText: "Pilih Prioritas",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    value: _priority, // Nilai awal dropdown
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text("1 - Rendah"),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text("2 - Sedang"),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text("3 - Tinggi"),
                      ),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _priority = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Prioritas tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 29, 29, 29),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final response = await request.postJson(
                              "http://127.0.0.1:8000/wishlist/add-wishlist/",
                              jsonEncode(<String, String>{
                                'productId': widget.product.pk,
                                'description': _description,
                                'priority': _priority.toString()
                              }),
                            );
                            // print("Response status: ${response.statusCode}");
                            // print("Response body: ${response.body}");

                            final responseData = jsonDecode(response.body);
                            // print("Form data being sent: ${jsonEncode(formData)}");
                            if (responseData['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Wishlist berhasil ditambahkan!")),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationMenu()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Error: ${responseData['message'] ?? 'Failed to add wishlist'}")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Berhasil menambahkan produk ke Wishlist!")),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Add to Wishlist",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
