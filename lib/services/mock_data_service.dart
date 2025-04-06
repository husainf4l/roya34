import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../models/replay_moment.dart';

class MockDataService {
  static const String _baseUrl = 'http://192.168.1.244:3000/match';

  // Helper method for handling API requests
  static Future<dynamic> _fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load data from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from $endpoint: $e');
      // Return empty data rather than crashing
      if (endpoint.contains('player')) {
        return [];
      } else if (endpoint.contains('moment')) {
        return [];
      } else {
        return {};
      }
    }
  }

  // Current game info
  static Future<Map<String, dynamic>> getCurrentGameInfo() async {
    final data = await _fetchData('current-game');
    return data;
  }

  static Future<List<Player>> getPlayers() async {
    final data = await _fetchData('players');
    return _safeParsePlayerList(data);
  }

  static Future<List<Player>> getActivePlayers() async {
    final data = await _fetchData('active-players');
    return _safeParsePlayerList(data);
  }

  static Future<List<ReplayMoment>> getAllReplayMoments() async {
    final data = await _fetchData('replay-moments');
    return (data as List)
        .map((momentJson) => ReplayMoment.fromJson(momentJson))
        .toList();
  }

  static Future<List<Player>> getFeaturedPlayers() async {
    final data = await _fetchData('featured-players');
    return _safeParsePlayerList(data);
  }

  static Future<List<ReplayMoment>> getTopMoments() async {
    final data = await _fetchData('top-moments');
    return (data as List)
        .map((momentJson) => ReplayMoment.fromJson(momentJson))
        .toList();
  }

  // Helper method to safely parse player data
  static List<Player> _safeParsePlayerList(dynamic data) {
    List<Player> players = [];
    if (data is List) {
      for (var playerJson in data) {
        try {
          players.add(Player.fromJson(playerJson));
        } catch (e) {
          print('Error parsing player data: $e');
          print('Problematic JSON: $playerJson');
        }
      }
    }
    return players;
  }
}
