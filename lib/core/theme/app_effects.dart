// lib/core/theme/app_effects.dart
import 'package:flutter/material.dart';

class AppBlur {
  static const double none = 0.0;
  static const double sm = 4.0;
  static const double standard = 8.0; // DEFAULT in JSON
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double blur2xl = 40.0;
  static const double blur3xl = 64.0;
}

class AppShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> shadow2xs = [
    BoxShadow(color: Color(0x0C000000), offset: Offset(0, 1), blurRadius: 0, spreadRadius: 0),
  ];

  static const List<BoxShadow> shadowXs = [
    BoxShadow(color: Color(0x0C000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: 0),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 1), blurRadius: 3, spreadRadius: 0),
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: -1),
  ];

  static const List<BoxShadow> shadowDefault = [
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 4), blurRadius: 6, spreadRadius: -1),
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: -2),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 10), blurRadius: 15, spreadRadius: -3),
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 4), blurRadius: 6, spreadRadius: -4),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -6),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
    BoxShadow(color: Color(0x19000000), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -6),
  ];

  static const List<BoxShadow> shadow2xl = [
    BoxShadow(color: Color(0x3F000000), offset: Offset(0, 25), blurRadius: 50, spreadRadius: -12),
  ];

  // Inner shadow requires custom implementation in Flutter typically using BoxShadow on a Stack or CustomPainter,
  // but here is the raw mapping if needed.
  static const BoxShadow shadowInner = BoxShadow(
    color: Color(0x0C000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: 0,
  );
}