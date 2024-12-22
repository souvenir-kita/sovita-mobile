import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/widget/navigation_menu.dart';

class EditProductForm extends StatefulWidget {
  final Product product;

  const EditProductForm({super.key, required this.product});

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _price;
  late String _description;
  late String _category;
  late String _location;

  @override
  void initState() {
    super.initState();
    _name = widget.product.fields.name;
    _price =
        int.parse(double.parse(widget.product.fields.price).toStringAsFixed(0));
    _description = widget.product.fields.description;
    _category = widget.product.fields.category;
    _location = widget.product.fields.location;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('lib/assets/title.png', width: 100),
        centerTitle: true,
        backgroundColor: const Color(0xFFF09027),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Product Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      buildTextField(
                        "Product Name",
                        Icons.shopping_bag,
                        initialValue: _name,
                        onChanged: (value) => setState(() => _name = value),
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        "Price",
                        Icons.attach_money,
                        initialValue: _price.toString(),
                        onChanged: (value) => setState(() => _price = int.tryParse(value) ?? 0),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        "Description",
                        Icons.description,
                        initialValue: _description,
                        onChanged: (value) => setState(() => _description = value),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        "Category",
                        Icons.category,
                        initialValue: _category,
                        onChanged: (value) => setState(() => _category = value),
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        "Location",
                        Icons.location_on,
                        initialValue: _location,
                        onChanged: (value) => setState(() => _location = value),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final Map<String, dynamic> formData = {
                                'name': _name,
                                'price': _price.toString(),
                                'description': _description,
                                'category': _category,
                                'location': _location,
                              };

                              try {
                                final response = await request.post(
                                  'https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/adminview/update-flutter/${widget.product.pk}/',
                                  jsonEncode(formData)
                                );

                                if (response['status'] == 'success') {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Product updated successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => NavigationMenu()),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${response['message'] ?? 'Failed to update product'}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF09027),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon, {
    String? initialValue,
    void Function(String)? onChanged,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFF09027)),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF09027), width: 2),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }
}
