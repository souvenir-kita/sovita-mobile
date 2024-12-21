import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final url = Uri.parse(
          'http://10.0.2.2:8000/cart/add_with_note/${widget.productPk}/');

      final response = await http.post(
        url,
        body: {
          'cart_amount': _amountController.text,
          'cart_note': _noteController.text,
        },
      );

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart!')),
        );
        Navigator.of(context).pop(); // Close the modal
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _isSubmitting ? null : _submitForm,
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