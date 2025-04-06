import 'package:flutter/material.dart';

class PulsingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;

  const PulsingIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 20,
    this.duration = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Transform.scale(
            scale: value,
            child: Icon(
              icon,
              color: color,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
