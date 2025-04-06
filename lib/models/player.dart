import 'package:flutter/material.dart';

/// Represents a player in a sports team with their stats and information.
class Player {
  /// Unique identifier for the player
  final int id;

  /// Player's full name
  final String name;

  /// Jersey number
  final int number;

  /// Position on the field
  final String position;

  /// Performance rating from 0-100
  final int performance;

  /// Energy level from 0-100 percentage
  final int energy;

  /// Player's speed in km/h
  final double speed;

  /// Name of the team the player belongs to
  final String teamName;

  /// URLs or asset paths to player's highlight images
  final List<String> topShots;

  /// Number of goals in current season
  final int goals;

  /// Number of assists in current season
  final int assists;

  /// Team's primary color for UI elements
  final Color teamColor;

  /// Player rating on scale of 0.0-10.0
  final double rating;

  /// Creates a new Player instance.
  const Player({
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

  /// Creates a copy of this Player with the given fields replaced with new values.
  Player copyWith({
    int? id,
    String? name,
    int? number,
    String? position,
    int? performance,
    int? energy,
    double? speed,
    String? teamName,
    List<String>? topShots,
    int? goals,
    int? assists,
    Color? teamColor,
    double? rating,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      position: position ?? this.position,
      performance: performance ?? this.performance,
      energy: energy ?? this.energy,
      speed: speed ?? this.speed,
      teamName: teamName ?? this.teamName,
      topShots: topShots ?? this.topShots,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      teamColor: teamColor ?? this.teamColor,
      rating: rating ?? this.rating,
    );
  }
}
