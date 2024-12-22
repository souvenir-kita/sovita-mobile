import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sovita/widget/navigation_menu.dart';
import 'package:http/http.dart' as http;

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _description = "";
  String _location = "";
  File? _selectedImage;
  Uint8List? _webImage;

  String? _category;

  final List<String> _categories = [
    'FnB',
    'Dekorasi',
    'Pakaian/Kain',
    'Lulur & Aromateraphy',
    'Aksesoris'
  ];

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (kIsWeb) {
      var bytes = await image.readAsBytes();
      setState(() {
        _webImage = bytes;
      });
    } else {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _webImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image")),
        );
        return;
      }

      try {
        final bytes = kIsWeb ? _webImage! : await _selectedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        
        final Map<String, String> formData = {
          'name': _name,
          'price': _price.toString(),
          'description': _description,
          'category': _category!,
          'location': _location,
          'image': base64Image,
        };

        final uri = Uri.parse("https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/adminview/create-flutter/");
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: formData,
        );

        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product successfully added!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message'] ?? 'Failed to add product'}")),
          );
        }
      } catch (e) {
        print("Error details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('lib/assets/title.png', width: 100),
        centerTitle: true,
        backgroundColor: const Color(0xFFF09027),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
            ),
          ),
          child: Padding(
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
                          hintText: "Product Name",
                          labelText: "Product Name",
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _name = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Product's name cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Price",
                          labelText: "Price",
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _price = int.tryParse(value!) ?? 0;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Product's Price cannot be empty!";
                          }
                          final number = int.tryParse(value);
                          if (number == null) {
                            return "Product's price cannot be a string!";
                          }
                          if (number < 1) {
                            return "Product's price cannot be zero or negative!";
                          }
                          if (number > 1000000000000) {
                            return "Product's price cannot be too high!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
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
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Product's description cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Category",
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        value: _category,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Select a category'),
                          ),
                          ..._categories.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            _category = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a category";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Location",
                          labelText: "Location",
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _location = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Product's location cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          MaterialButton(
                            color: Colors.white,
                            child: const Text(
                              "Pick Image (1:1 is recommended)",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _pickImage,
                          ),
                          if (_selectedImage != null || _webImage != null)
                            kIsWeb
                                ? Image.memory(_webImage!, height: 100)
                                : Image.file(_selectedImage!, height: 100),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF09027),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            "Add Product",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
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
        ),
      ),
    );
  }
}
