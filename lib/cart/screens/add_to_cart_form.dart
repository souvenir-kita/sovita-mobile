import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/display/screens/homescreen.dart';

class AddToCartForm extends StatefulWidget {
  final String productPk;

  const AddToCartForm({super.key, required this.productPk});

  @override
  State<AddToCartForm> createState() => _AddToCartFormState();
}

class _AddToCartFormState extends State<AddToCartForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitForm(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      if (_formKey.currentState!.validate()) {
        final response = await request.postJson(
          "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/cart/add_product_to_cart_with_note/${widget.productPk}/",
          jsonEncode(<String, String>{
            'amount': _amountController.text,
            'note': _noteController.text,
          }),
        );
        if (context.mounted) {
          if (response['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Produk berhasil dimasukkan ke keranjang!"),
            ));
            Navigator.popUntil(context, ModalRoute.withName('/'));
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeScreen()),
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Terdapat kesalahan, silakan coba lagi."),
            ));
          }
        }
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 20.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter the amount",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Amount is required";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Enter a valid positive number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Note Field
              TextFormField(
                controller: _noteController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Note",
                  hintText: "Add a note (optional)",
                ),
                maxLength: 144,
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitForm(request),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
