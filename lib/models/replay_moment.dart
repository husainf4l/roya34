import 'package:flutter/material.dart';
import 'player.dart';

/// Represents a significant moment in a match replay.
class ReplayMoment {
  /// Unique identifier for the moment
  final String id;

  /// Title describing the moment
  final String title;

  /// Detailed description of what happened
  final String description;

  /// Match time display (e.g., "45:20")
  final String timestamp;

  /// Position in the video timeline
  final Duration position;

  /// Players involved in this moment
  final List<Player> involvedPlayers;

  /// Type of moment (goal, save, etc.)
  final ReplayMomentType type;

  /// Optional thumbnail image URL
  final String? thumbnailUrl;

  /// Match minute when the moment occurred
  final int minute;

  /// Creates a new ReplayMoment instance.
  const ReplayMoment({
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

  /// Returns the type as a localized string for display.
  String get typeString => type.arabicLabel;

  /// Creates a copy of this ReplayMoment with the given fields replaced with new values.
  ReplayMoment copyWith({
    String? id,
    String? title,
    String? description,
    String? timestamp,
    Duration? position,
    List<Player>? involvedPlayers,
    ReplayMomentType? type,
    String? thumbnailUrl,
    int? minute,
  }) {
    return ReplayMoment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      position: position ?? this.position,
      involvedPlayers: involvedPlayers ?? this.involvedPlayers,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      minute: minute ?? this.minute,
    );
  }
}

/// Types of significant moments that can occur in a match.
enum ReplayMomentType { goal, save, foul, tackle, pass, assist, other }

/// Extension to provide UI-related properties based on moment type.
extension ReplayMomentTypeExtension on ReplayMomentType {
  /// Returns the appropriate color for UI elements based on the moment type.
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

  /// Returns the appropriate icon for UI elements based on the moment type.
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

  /// Returns the Arabic label for the moment type.
  String get arabicLabel {
    switch (this) {
      case ReplayMomentType.goal:
        return 'هدف';
      case ReplayMomentType.save:
        return 'تصدي';
      case ReplayMomentType.foul:
        return 'مخالفة';
      case ReplayMomentType.tackle:
        return 'تدخل';
      case ReplayMomentType.pass:
        return 'تمريرة';
      case ReplayMomentType.assist:
        return 'تمريرة حاسمة';
      case ReplayMomentType.other:
        return 'لقطة';
    }
  }
}
