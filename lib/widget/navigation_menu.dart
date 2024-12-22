import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sovita/cart/screens/cart_screen.dart';
import 'package:sovita/display/screens/homescreen.dart';
import 'package:sovita/profil/screen/profil.dart';
import 'package:sovita/wishlist/screens/wishlist.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(), 
    CartScreen(), 
    WishlistPage(), // Wishlist (Placeholder, replace later)
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color.fromARGB(128, 129, 128, 128),
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
