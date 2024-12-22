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
  final _formKey = GlobalKey<FormState>();
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color.fromARGB(255, 48, 48, 48).withOpacity(0.7),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Expanded(
                              child: Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Add invisible icon button to balance the layout
                            const SizedBox(width: 48.0),  // Same width as IconButton
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hint: 'Enter your username',
                        ),
                        const SizedBox(height: 12.0),
                        _buildPasswordField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
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
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: 'Enter your age',
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
                        _buildTextField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
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
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          hint: 'Enter your address',
                        ),
                        const SizedBox(height: 12.0),
                        const Text(
                          'Select Role:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        _buildRoleSelection(),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _handleRegister(request, context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return _buildTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Admin', style: TextStyle(color: Colors.white)),
          value: 'admin',
          groupValue: _selectedRole,
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Buyer', style: TextStyle(color: Colors.white)),
          value: 'buyer',
          groupValue: _selectedRole,
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
      ],
    );
  }

  Future<void> _handleRegister(
      CookieRequest request, BuildContext context) async {
    String username = _usernameController.text;
    String password1 = _passwordController.text;
    String password2 = _confirmPasswordController.text;
    String role = _selectedRole;
    String address = _addressController.text;
    String phoneNumber = _phoneNumberController.text;
    String age = _ageController.text;

    final response = await request.postJson(
      "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/authentication/api-register/",
      jsonEncode({
        "username": username,
        "password1": password1,
        "password2": password2,
        "role": role,
        "address": address,
        "age": age,
        "phone_number": phoneNumber,
      }),
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully registered!'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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