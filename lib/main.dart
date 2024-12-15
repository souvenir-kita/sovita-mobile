import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/display/screens/fyp.dart';
import 'package:sovita/display/screens/product_card.dart';
import 'package:sovita/promo/screens/promo_screen.dart';
import 'package:sovita/promo/screens/promo_detail_overhauled.dart';
import 'package:sovita/widget/navigation_menu.dart';
// import 'package:sovita/display/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Sovenir Kita',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        home: const NavigationMenu(),
      ),
    );
  }
}