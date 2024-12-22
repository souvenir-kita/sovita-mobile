import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GradientAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFC89A45),
            Color(0xFFB5592A),
            Color(0xFFB5592A),
          ],
          stops: [0.0384, 0.6095, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: GradientRotation(260 * (3.14159265359 / 180)),
        ),
      ),
      child: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white),),
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Remove shadow for a clean gradient look
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
