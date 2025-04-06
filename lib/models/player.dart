import 'package:flutter/material.dart';

class Player {
  final int id;
  final String name;
  final int number;
  final String position;
  final int performance;
  final int energy;
  final double speed;
  final String teamName;
  final List<String> topShots;
  final int goals;
  final int assists;
  final Color teamColor;
  final double rating;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.performance,
    required this.energy,
    required this.speed,
    required this.teamName,
    required this.topShots,
    required this.goals,
    required this.assists,
    required this.teamColor,
    required this.rating,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    try {
      // Parse id to int - API is sending string IDs
      int id;
      try {
        if (json['id'] is int) {
          id = json['id'];
        } else if (json['id'] is String) {
          id = int.parse(json['id']);
        } else {
          id = 0;
          print('Warning: unexpected id type: ${json['id']}');
        }
      } catch (e) {
        print('Error parsing id: $e');
        id = 0;
      }

      // Parse number - could be int in API
      int number;
      try {
        if (json['number'] is int) {
          number = json['number'];
        } else if (json['number'] is String) {
          number = int.parse(json['number']);
        } else {
          number = 0;
        }
      } catch (e) {
        print('Error parsing number: $e');
        number = 0;
      }

      // Parse performance - could be int in API or nested map
      int performance;
      try {
        if (json['performance'] is int) {
          performance = json['performance'];
        } else if (json['performance'] is String) {
          performance = int.parse(json['performance']);
        } else if (json['performance'] is Map) {
          // Handle nested map structure
          var perfMap = json['performance'] as Map<String, dynamic>;
          if (perfMap.containsKey('value') && perfMap['value'] != null) {
            if (perfMap['value'] is int) {
              performance = perfMap['value'];
            } else if (perfMap['value'] is String) {
              performance = int.parse(perfMap['value']);
            } else {
              performance = 0;
            }
          } else {
            performance = 0;
          }
        } else {
          performance = 0;
        }
      } catch (e) {
        print('Error parsing performance: $e');
        performance = 0;
      }

      // Parse energy - could be int in API or nested map
      int energy;
      try {
        if (json['energy'] is int) {
          energy = json['energy'];
        } else if (json['energy'] is String) {
          energy = int.parse(json['energy']);
        } else if (json['energy'] is Map) {
          // Handle nested map structure
          var energyMap = json['energy'] as Map<String, dynamic>;
          if (energyMap.containsKey('value') && energyMap['value'] != null) {
            if (energyMap['value'] is int) {
              energy = energyMap['value'];
            } else if (energyMap['value'] is String) {
              energy = int.parse(energyMap['value']);
            } else {
              energy = 0;
            }
          } else {
            energy = 0;
          }
        } else {
          energy = 0;
        }
      } catch (e) {
        print('Error parsing energy: $e');
        energy = 0;
      }

      // Parse speed - could be double or int in API
      double speed;
      try {
        if (json['speed'] is double) {
          speed = json['speed'];
        } else if (json['speed'] is int) {
          speed = (json['speed'] as int).toDouble();
        } else if (json['speed'] is String) {
          speed = double.parse(json['speed']);
        } else {
          speed = 0.0;
        }
      } catch (e) {
        print('Error parsing speed: $e');
        speed = 0.0;
      }

      // Parse goals - could be int in API
      int goals;
      try {
        if (json['goals'] is int) {
          goals = json['goals'];
        } else if (json['goals'] is String) {
          goals = int.parse(json['goals']);
        } else {
          goals = 0;
        }
      } catch (e) {
        print('Error parsing goals: $e');
        goals = 0;
      }

      // Parse assists - could be int in API
      int assists;
      try {
        if (json['assists'] is int) {
          assists = json['assists'];
        } else if (json['assists'] is String) {
          assists = int.parse(json['assists']);
        } else {
          assists = 0;
        }
      } catch (e) {
        print('Error parsing assists: $e');
        assists = 0;
      }

      // Parse rating - could be double or int in API
      double rating;
      try {
        if (json['rating'] is double) {
          rating = json['rating'];
        } else if (json['rating'] is int) {
          rating = (json['rating'] as int).toDouble();
        } else if (json['rating'] is String) {
          rating = double.parse(json['rating']);
        } else {
          rating = 0.0;
        }
      } catch (e) {
        print('Error parsing rating: $e');
        rating = 0.0;
      }

      // Parse teamColor - from hex string to Flutter Color
      Color teamColor;
      try {
        if (json['teamColor'] is String) {
          String hexColor = json['teamColor'].toString();
          // Remove '#' if present
          if (hexColor.startsWith('#')) {
            hexColor = hexColor.substring(1);
          }
          // Parse hex color
          teamColor = Color(int.parse('FF$hexColor', radix: 16));
        } else {
          // Default color if parsing fails
          teamColor = Colors.blue;
        }
      } catch (e) {
        print('Error parsing teamColor: $e');
        teamColor = Colors.blue;
      }

      // Parse topShots array
      List<String> topShots = [];
      try {
        if (json['topShots'] is List) {
          topShots = (json['topShots'] as List)
              .map((shot) => shot.toString())
              .toList();
        }
      } catch (e) {
        print('Error parsing topShots: $e');
      }

      return Player(
        id: id,
        name: json['name']?.toString() ?? '',
        number: number,
        position: json['position']?.toString() ?? '',
        performance: performance,
        energy: energy,
        speed: speed,
        teamName: json['teamName']?.toString() ?? '',
        topShots: topShots,
        goals: goals,
        assists: assists,
        teamColor: teamColor,
        rating: rating,
      );
    } catch (e) {
      print('Fatal error in Player.fromJson: $e');
      // Return a placeholder player as a fallback
      return Player(
        id: 0,
        name: 'Unknown Player',
        number: 0,
        position: 'Unknown',
        performance: 0,
        energy: 0,
        speed: 0.0,
        teamName: 'Unknown',
        topShots: [],
        goals: 0,
        assists: 0,
        teamColor: Colors.grey,
        rating: 0.0,
      );
    }
  }
}
