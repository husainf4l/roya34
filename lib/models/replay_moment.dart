import 'package:flutter/material.dart';
import 'player.dart';

enum ReplayMomentType {
  goal,
  assist,
  save,
  tackle,
  foul,
  yellowCard,
  redCard,
  penalty,
  corner,
  freeKick,
  highlight
}

extension ReplayMomentTypeExtension on ReplayMomentType {
  String get arabicLabel {
    switch (this) {
      case ReplayMomentType.goal:
        return 'هدف';
      case ReplayMomentType.assist:
        return 'تمريرة حاسمة';
      case ReplayMomentType.save:
        return 'تصدي';
      case ReplayMomentType.tackle:
        return 'تدخل';
      case ReplayMomentType.foul:
        return 'خطأ';
      case ReplayMomentType.yellowCard:
        return 'بطاقة صفراء';
      case ReplayMomentType.redCard:
        return 'بطاقة حمراء';
      case ReplayMomentType.penalty:
        return 'ركلة جزاء';
      case ReplayMomentType.corner:
        return 'ركلة ركنية';
      case ReplayMomentType.freeKick:
        return 'ركلة حرة';
      case ReplayMomentType.highlight:
        return 'لقطة مميزة';
    }
  }
}

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

  factory ReplayMoment.fromJson(Map<String, dynamic> json) {
    // Parse duration from seconds
    final int durationInSeconds = json['position'] ?? 0;
    final Duration position = Duration(seconds: durationInSeconds);

    // Parse involved players
    List<Player> players = [];
    if (json['involvedPlayers'] != null) {
      players = (json['involvedPlayers'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList();
    }

    return ReplayMoment(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      position: position,
      involvedPlayers: players,
      type: _parseReplayMomentType(json['type']),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      minute: json['minute'] ?? 0,
    );
  }

  // Helper method to parse ReplayMomentType
  static ReplayMomentType _parseReplayMomentType(dynamic typeValue) {
    if (typeValue is int) {
      try {
        return ReplayMomentType.values[typeValue];
      } catch (e) {
        return ReplayMomentType.goal; // Default
      }
    } else if (typeValue is String) {
      try {
        return ReplayMomentType.values.firstWhere(
          (type) => type.name.toLowerCase() == typeValue.toLowerCase(),
          orElse: () => ReplayMomentType.goal,
        );
      } catch (e) {
        return ReplayMomentType.goal; // Default
      }
    }
    return ReplayMomentType.goal; // Default
  }
}
