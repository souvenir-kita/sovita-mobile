import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/adminview/screens/adminmain.dart';
import 'package:sovita/display/screens/home_screen.dart';
import 'package:sovita/forum/screens/forum.dart';
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
        title: 'Sovita Mobile',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        home: ForumPage(productId: "3cbce4bf-088a-4405-aa46-131e77ea7d19"),
      ),
    );
  }
}
