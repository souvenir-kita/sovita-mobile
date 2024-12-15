import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sovita/cart/screens/cart_screen.dart';
import 'package:sovita/display/screens/fyp.dart';
import 'package:sovita/adminview/screens/adminmain.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  // List of screens corresponding to each navigation item
  final List<Widget> _pages = [
    ForYouPage(), 
    CartScreen(), 
    Container(), // Wishlist (Placeholder, replace later)
    AdminPage(), // Profile (Placeholder, replace later)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 218, 243, 255),
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Iconsax.profile), label: 'Profil'),
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