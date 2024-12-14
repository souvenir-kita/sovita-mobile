import 'package:flutter/material.dart';
import 'package:sovita/adminview/screens/adminmain.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/cart/screens/cart_screen.dart';
import 'package:sovita/display/screens/home_screen.dart';
import 'package:sovita/promo/screens/promo_screen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: request.cookies.containsKey("isAdmin") &&
                  request.cookies["isAdmin"]!.value == "1" 
          ? [
          _buildDrawerHeader(context),
          _builSearchListTile(context),
          _buildHomeListTile(context),
          _buildAdminListTile(context),
          _buildPromoListTile(context),
          _buildWishlistTile(context),
          _buildCartListTile(context),
          _buildProfilListTile(context),
          _buildLogoutListTile(context),
        ] : [
          _buildDrawerHeader(context),
          _builSearchListTile(context),
          _buildHomeListTile(context),
          _buildWishlistTile(context),
          _buildCartListTile(context),
          _buildProfilListTile(context),
          _buildLogoutListTile(context),
        ], 
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sovita',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Our Souvenirs, Your Unforgettable Memories!",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _builSearchListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: const Text('Search'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
    );
  }


  Widget _buildHomeListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.home_outlined),
      title: const Text('Beranda'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }

  Widget _buildAdminListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.admin_panel_settings),
      title: const Text('Admin'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      },
    );
  }

  Widget _buildPromoListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.discount),
      title: const Text('Promo'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PromoPage()),
        );
      },
    );
  }

  Widget _buildWishlistTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star),
      title: const Text('Wishlist'),
      onTap: () {
        // Navigator.push(
        //   // context,
        //   // MaterialPageRoute(builder: (context) => const PromoPage()),
        // );
      },
    );
  }

  Widget _buildCartListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.shopping_cart_checkout),
      title: const Text('Cart'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      },
    );
  }

  Widget _buildProfilListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle_sharp),
      title: const Text('Profile'),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const PromoPage()),
        // );
      },
    );
  }

  Widget _buildLogoutListTile(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return ListTile(
      leading: const Icon(Icons.logout_outlined),
      title: const Text('Logout'),
            onTap: () async {
              final response = await request
                  .logout("http://127.0.0.1:8000/authentication/api-logout/");
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
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
    );
  }

}