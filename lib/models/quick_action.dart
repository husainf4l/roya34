import 'package:flutter/material.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
