import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/landing.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/promo/screens/promo_screen.dart';
import 'package:sovita/promo/widgets/promo_card.dart';
import 'package:sovita/display/screens/homescreen.dart';
import 'package:sovita/widget/navigation_menu.dart';

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
            primarySwatch: Colors.orange,
          ).copyWith(secondary: Colors.orange[100]),
        ),
        // home: const LoginPage(),
        initialRoute: '/auth',
        routes: {
          '/': (context) => const NavigationMenu(),
          '/login': (context) => const LoginPage(),
          '/auth': (context) => const LandingScreen(),
        },
      ),
    );
  }
}
