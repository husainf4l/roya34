import 'package:flutter/material.dart';
import 'player.dart';

class ReplayMoment {
  final String id;
  final String title;
  final String description;
  final String timestamp; // Match time display
  final Duration position; // Position in the video
  final List<Player> involvedPlayers;
  final ReplayMomentType type;
  final String? thumbnailUrl; // Optional - could be null for placeholders
  final int minute; // Match minute when the moment occurred

  ReplayMoment({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.position,
    required this.involvedPlayers,
    required this.type,
    this.thumbnailUrl,
    required this.minute,
  });

  // Getter to access the type as a string for display
  String get typeString => type.arabicLabel;
}

enum ReplayMomentType { goal, save, foul, tackle, pass, assist, other }

// Extension to get UI-related properties based on moment type
extension ReplayMomentTypeExtension on ReplayMomentType {
  Color get color {
    switch (this) {
      case ReplayMomentType.goal:
        return Colors.blue;
      case ReplayMomentType.save:
        return Colors.purple;
      case ReplayMomentType.foul:
        return Colors.red;
      case ReplayMomentType.tackle:
        return Colors.orange;
      case ReplayMomentType.pass:
        return Colors.teal;
      case ReplayMomentType.assist:
        return Colors.amber;
      case ReplayMomentType.other:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case ReplayMomentType.goal:
        return Icons.sports_soccer;
      case ReplayMomentType.save:
        return Icons.bookmark_border;
      case ReplayMomentType.foul:
        return Icons.warning;
      case ReplayMomentType.tackle:
        return Icons.shield;
      case ReplayMomentType.pass:
        return Icons.swap_horiz;
      case ReplayMomentType.assist:
        return Icons.arrow_forward;
      case ReplayMomentType.other:
        return Icons.sports;
    }
  }

  String get arabicLabel {
    switch (this) {
      case ReplayMomentType.goal:
        return "هدف";
      case ReplayMomentType.save:
        return "تصدي";
      case ReplayMomentType.foul:
        return "مخالفة";
      case ReplayMomentType.tackle:
        return "تدخل";
      case ReplayMomentType.pass:
        return "تمريرة";
      case ReplayMomentType.assist:
        return "تمريرة حاسمة";
      case ReplayMomentType.other:
        return "لقطة";
    }
  }
}
