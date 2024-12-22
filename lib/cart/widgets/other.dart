import 'package:flutter/material.dart';

var bgGradient = LinearGradient(
  colors: [
    Color(0xFFF09027), 
    Color(0xFF8CBEAA), 
  ],
  stops: [0.1276, 0.7177],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  transform:
      GradientRotation(153 * (3.14159265359 / 180)), 
);

