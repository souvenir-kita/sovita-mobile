import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk Form
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedRole = "buyer";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey, // Sambungkan Form dengan GlobalKey
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter your age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Age is required';
                        }
                        final int? age = int.tryParse(value);
                        if (age == null || age <= 0) {
                          return 'Age must be a positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Phone number must only contain digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Select Role:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  RadioListTile<String>(
                    title: const Text('Admin'),
                    value: 'admin',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Buyer'),
                    value: 'buyer',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String username = _usernameController.text;
                          String password1 = _passwordController.text;
                          String password2 = _confirmPasswordController.text;
                          String role = _selectedRole;
                          String address = _addressController.text;
                          String phoneNumber = _phoneNumberController.text;
                          String age = _ageController.text;

                          final response = await request.postJson(
                            "http://127.0.0.1:8000/authentication/api-register/",
                            jsonEncode({
                              "username": username,
                              "password1": password1,
                              "password2": password2,
                              "role": role,
                              "address": address,
                              "age": age,
                              "phone_number": phoneNumber
                            }),
                          );

                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Successfully registered!'),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to register!'),
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Register'),
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