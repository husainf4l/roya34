import '../config/app_theme.dart';
import '../models/player.dart';
import '../models/replay_moment.dart';

/// Provides mock data for the application.
/// This service simulates data that would normally come from an API or database.
class MockDataService {
  // Private constructor to prevent instantiation
  MockDataService._();

  // Constants for game info keys
  static const String kHomeTeam = 'homeTeam';
  static const String kAwayTeam = 'awayTeam';
  static const String kHomeScore = 'homeScore';
  static const String kAwayScore = 'awayScore';
  static const String kCurrentTime = 'currentTime';
  static const String kMatchPhase = 'matchPhase';

  /// Returns information about the current game.
  static Map<String, dynamic> getCurrentGameInfo() {
    return {
      kHomeTeam: 'الهلال',
      kAwayTeam: 'النصر',
      kHomeScore: 2,
      kAwayScore: 1,
      kCurrentTime: '78:24', // Format: MM:SS
      kMatchPhase: 'الشوط الثاني',
    };
  }

  /// Returns a list of all players.
  static List<Player> getPlayers() {
    return [
      Player(
        id: 1,
        name: 'محمد العبدالله',
        number: 10,
        position: 'مهاجم',
        performance: 92,
        energy: 84,
        speed: 32.4,
        teamName: 'الهلال',
        topShots: [
          'assets/images/players/player1_shot1.jpg',
          'assets/images/players/player1_shot2.jpg',
          'assets/images/players/player1_shot3.jpg',
        ],
        goals: 12,
        assists: 8,
        teamColor: AppTheme.primaryGreen,
        rating: 8.7,
      ),
      Player(
        id: 2,
        name: "أحمد الشمراني",
        number: 7,
        position: "جناح أيمن",
        performance: 88,
        energy: 79,
        speed: 34.2,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player2_shot1.jpg',
          'assets/images/players/player2_shot2.jpg',
        ],
        goals: 8,
        assists: 14,
        teamColor: AppTheme.primaryGreen,
        rating: 8.4,
      ),
      Player(
        id: 3,
        name: "خالد المحمد",
        number: 8,
        position: "وسط ميدان",
        performance: 85,
        energy: 82,
        speed: 29.8,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player3_shot1.jpg',
          'assets/images/players/player3_shot2.jpg',
        ],
        goals: 5,
        assists: 11,
        teamColor: AppTheme.primaryGreen,
        rating: 7.9,
      ),
      Player(
        id: 4,
        name: "عبدالله القحطاني",
        number: 6,
        position: "وسط دفاعي",
        performance: 74,
        energy: 88,
        speed: 27.5,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player4_shot1.jpg',
        ],
        goals: 1,
        assists: 4,
        teamColor: AppTheme.primaryGreen,
        rating: 7.2,
      ),
      Player(
        id: 5,
        name: "فهد العتيبي",
        number: 3,
        position: "ظهير أيسر",
        performance: 82,
        energy: 76,
        speed: 31.9,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player5_shot1.jpg',
          'assets/images/players/player5_shot2.jpg',
        ],
        goals: 2,
        assists: 7,
        teamColor: AppTheme.primaryGreen,
        rating: 7.8,
      ),
      Player(
        id: 6,
        name: "سعود الدوسري",
        number: 29,
        position: "ظهير أيمن",
        performance: 79,
        energy: 81,
        speed: 30.2,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player6_shot1.jpg',
        ],
        goals: 3,
        assists: 5,
        teamColor: AppTheme.primaryGreen,
        rating: 7.5,
      ),
      Player(
        id: 7,
        name: "سلطان الغامدي",
        number: 4,
        position: "قلب دفاع",
        performance: 80,
        energy: 90,
        speed: 26.8,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player7_shot1.jpg',
        ],
        goals: 2,
        assists: 1,
        teamColor: AppTheme.primaryGreen,
        rating: 7.6,
      ),
      Player(
        id: 8,
        name: "بندر العنزي",
        number: 5,
        position: "قلب دفاع",
        performance: 77,
        energy: 85,
        speed: 26.5,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player8_shot1.jpg',
        ],
        goals: 1,
        assists: 0,
        teamColor: AppTheme.primaryGreen,
        rating: 7.4,
      ),
      Player(
        id: 9,
        name: "ياسر الشهراني",
        number: 1,
        position: "حارس مرمى",
        performance: 86,
        energy: 75,
        speed: 22.1,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player9_shot1.jpg',
        ],
        goals: 0,
        assists: 0,
        teamColor: AppTheme.primaryGreen,
        rating: 8.2,
      ),
      Player(
        id: 10,
        name: "ناصر السهلي",
        number: 14,
        position: "جناح أيسر",
        performance: 81,
        energy: 72,
        speed: 33.0,
        teamName: "الهلال",
        topShots: [
          'assets/images/players/player10_shot1.jpg',
          'assets/images/players/player10_shot2.jpg',
        ],
        goals: 6,
        assists: 9,
        teamColor: AppTheme.primaryGreen,
        rating: 7.7,
      ),
      Player(
        id: 11,
        name: "تركي العمار",
        number: 11,
        position: "مهاجم",
        performance: 65,
        energy: 54,
        speed: 28.8,
        teamName: "النصر",
        topShots: [
          'assets/images/players/player11_shot1.jpg',
        ],
        goals: 7,
        assists: 3,
        teamColor: AppTheme.accentGold,
        rating: 6.8,
      ),
      Player(
        id: 12,
        name: "سعد الحارثي",
        number: 19,
        position: "وسط هجومي",
        performance: 58,
        energy: 67,
        speed: 29.1,
        teamName: "النصر",
        topShots: [
          'assets/images/players/player12_shot1.jpg',
        ],
        goals: 4,
        assists: 6,
        teamColor: AppTheme.accentGold,
        rating: 6.5,
      ),
    ];
  }

  /// Returns a list of currently active players in the match.
  static List<Player> getActivePlayers() {
    // Return a subset of players for live match
    return getPlayers().sublist(0, 5);
  }

  /// Returns all available replay moments.
  static List<ReplayMoment> getAllReplayMoments() {
    final List<Player> players = getPlayers();

    return [
      ReplayMoment(
        id: '1',
        title: "هدف رائع من العبدالله",
        description: "هدف من مهاجم الفريق بعد تمريرة متقنة",
        timestamp: "12:34",
        position: const Duration(minutes: 22, seconds: 15),
        involvedPlayers: [players[0], players[1]],
        type: ReplayMomentType.goal,
        thumbnailUrl: null,
        minute: 12,
      ),
      ReplayMoment(
        id: '2',
        title: "تدخل قوي من الغامدي",
        description: "تدخل دفاعي قوي لإنقاذ هجمة خطيرة",
        timestamp: "23:10",
        position: const Duration(minutes: 33, seconds: 42),
        involvedPlayers: [players[6], players[10]],
        type: ReplayMomentType.tackle,
        thumbnailUrl: null,
        minute: 23,
      ),
      ReplayMoment(
        id: '3',
        title: "إنقاذ من الشهراني",
        description: "تصدي رائع من حارس المرمى لكرة قوية",
        timestamp: "40:22",
        position: const Duration(minutes: 40, seconds: 22),
        involvedPlayers: [players[8]],
        type: ReplayMomentType.save,
        thumbnailUrl: null,
        minute: 40,
      ),
      ReplayMoment(
        id: '4',
        title: "تمريرة حاسمة من المحمد",
        description: "تمريرة بينية رائعة فتحت دفاع الخصم",
        timestamp: "55:17",
        position: const Duration(minutes: 55, seconds: 17),
        involvedPlayers: [players[2], players[9]],
        type: ReplayMomentType.assist,
        thumbnailUrl: null,
        minute: 55,
      ),
      ReplayMoment(
        id: '5',
        title: "مخالفة من العتيبي",
        description: "مخالفة واضحة وبطاقة صفراء",
        timestamp: "67:35",
        position: const Duration(minutes: 67, seconds: 35),
        involvedPlayers: [players[4], players[11]],
        type: ReplayMomentType.foul,
        thumbnailUrl: null,
        minute: 67,
      ),
      ReplayMoment(
        id: '6',
        title: "هدف التعادل للنصر",
        description: "هدف التعادل في الدقائق الأخيرة",
        timestamp: "88:12",
        position: const Duration(minutes: 88, seconds: 12),
        involvedPlayers: [players[11]],
        type: ReplayMomentType.goal,
        thumbnailUrl: null,
        minute: 88,
      ),
    ];
  }

  /// Returns a list of featured players based on rating.
  static List<Player> getFeaturedPlayers() {
    // Return top players with highest ratings
    final players = getPlayers();
    players.sort((a, b) => b.rating.compareTo(a.rating));
    return players.sublist(0, 6); // Return top 6 players
  }

  /// Returns a filtered list of the most important replay moments.
  static List<ReplayMoment> getTopMoments() {
    final allMoments = getAllReplayMoments();
    // Filter by important types (goals, assists, saves)
    final importantMoments = allMoments
        .where((moment) =>
            moment.type == ReplayMomentType.goal ||
            moment.type == ReplayMomentType.assist ||
            moment.type == ReplayMomentType.save)
        .toList();

    return importantMoments;
  }
}
