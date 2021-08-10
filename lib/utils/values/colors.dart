import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  /// Primary Swatch
  static const Color PRIMARY_SWATCH = Colors.brown;

  /// Primary Color
  static const Color PRIMARY_COLOR = Color(0xFFF9A825);

  /// Acccent Color
  static const Color ACCENT_COLOR = Colors.yellow;

  /// Gradient color for the theme
  static const List<Color> GRADIENT_COLOR = [
    Colors.black87,
    Color.fromRGBO(41, 41, 41, 1),
    Color.fromRGBO(48, 41, 47, 1),
    Color.fromRGBO(178, 97, 27, 1),
    Color.fromRGBO(197, 108, 30, 1),
    Color.fromRGBO(234, 128, 36, 1),
    Color.fromRGBO(239, 158, 89, 1),
    Colors.white
  ];

  /// Gradient color for bottom sheet of order screen
  static const List<Color> BOTTOM_SHEET_NAVIGATION_COLOR = [
    Color.fromRGBO(141, 89, 43, 1),
    Color.fromRGBO(240, 150, 74, 1),
    Color.fromRGBO(141, 89, 43, 1),
  ];

  /// Secondary color for text
  static final TEXT_SECONDARY = Colors.grey.shade600;

  static const List<Color> ORANGE_GRADIENT = [
    Color(0xFFFF9844),
    Color(0xFFFE8853),
    Color(0xFFFD7267),
  ];
}
