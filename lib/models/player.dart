import 'package:flutter/material.dart';

class Player {
  final int id;
  final String name;
  final int number;
  final String position;
  final int performance; // 0-100 scoring
  final int energy; // 0-100 percentage
  final double speed; // km/h
  final String teamName;
  final List<String> topShots; // URLs or asset paths to top shot images
  final int goals; // Number of goals in current season
  final int assists; // Number of assists in current season
  final Color teamColor; // Team primary color
  final double rating; // Player rating (0.0-10.0)

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.performance,
    required this.energy,
    required this.speed,
    required this.teamName,
    this.topShots = const [],
    this.goals = 0,
    this.assists = 0,
    required this.teamColor,
    required this.rating,
  });
}
