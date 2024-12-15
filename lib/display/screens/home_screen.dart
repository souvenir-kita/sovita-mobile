import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/display/screens/allproducts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sovita"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sovita Mobile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  // Navigasi ke halaman ProductForm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllProducts()),
                  );
                },
                child: const Text("All Products"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
