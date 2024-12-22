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
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomeScreen(),
          CartScreen(), // Automatically rebuilds when navigated to
          WishlistPage(), // Wishlist (Placeholder)
          const ProfilPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(128, 129, 128, 128),
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
            _pageController.jumpToPage(index); // Navigate to the selected page
          });
        },
      ),
    );
  }
}
