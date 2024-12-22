import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/widget/navigation_menu.dart';

class EditProductForm extends StatefulWidget {
  final Product product; // Use Product directly.

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
    // Initialize fields using the Product instance.
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
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  onChanged: (value) {
                    setState(() {
                      _price = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null) {
                      return 'Valid price required';
                    }
                    if (parsedValue < 1) {
                      return 'Price must be at least 1';
                    }
                    if (parsedValue > 1000000000000) {
                      return 'Price cannot exceed 1,000,000,000,000';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Product Description'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  initialValue: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  initialValue: _location,
                  onChanged: (value) {
                    setState(() {
                      _location = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        'http://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/adminview/update-flutter/${widget.product.pk}/',
                        jsonEncode(<String, dynamic>{
                          'name': _name,
                          'price': _price,
                          'description': _description,
                          'category': _category,
                          'location': _location,
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Product updated successfully!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => NavigationMenu()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to update')),
                        );
                      }
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
