import 'package:flutter/widgets.dart';

class FeaturedCardData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData iconData;
  final Widget screen;

  const FeaturedCardData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.iconData,
    required this.screen,
  });
}
