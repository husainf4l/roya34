import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final double iconSize;
  final Color iconColor;
  final double opacity;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.padding = const EdgeInsets.only(right: 12.0),
    this.iconSize = 22,
    this.iconColor = AppTheme.black,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.black.withOpacity(opacity),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppTheme.white.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
