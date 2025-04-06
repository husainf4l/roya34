import 'dart:math';
import 'package:flutter/material.dart';

class NeuralNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final Random random = Random(42);
    final List<Offset> nodes = [];

    for (int i = 0; i < 15; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double radius = random.nextDouble() * size.width * 0.4;
      nodes.add(Offset(
        size.width / 2 + cos(angle) * radius,
        size.height / 2 + sin(angle) * radius,
      ));
    }

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if (random.nextDouble() > 0.7) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    for (final node in nodes) {
      canvas.drawCircle(node, 2, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
