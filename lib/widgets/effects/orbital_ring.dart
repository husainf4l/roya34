import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class OrbitalRing extends StatelessWidget {
  final double size;
  final double duration;
  final bool reverse;

  const OrbitalRing({
    super.key,
    required this.size,
    required this.duration,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: duration.round()),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: reverse ? -value * 2 * 3.14159 : value * 2 * 3.14159,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: size / 2 - 4,
                  child: _buildNode(),
                ),
                Positioned(
                  bottom: size * 0.1,
                  right: size * 0.1,
                  child: _buildNode(isSmall: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNode({bool isSmall = false}) {
    final double nodeSize = isSmall ? 6 : 8;
    return Container(
      width: nodeSize,
      height: nodeSize,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.aiBlue.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
