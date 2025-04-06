import 'package:flutter/cupertino.dart';
import '../config/app_theme.dart';
import '../screens/live_view_screen.dart';
import '../screens/players_screen.dart';
import '../screens/replay_screen.dart';
import '../screens/player_recognition_screen.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

class QuickActions {
  static const List<QuickAction> actions = [
    QuickAction(
      title: 'بث مباشر',
      icon: CupertinoIcons.tv_fill,
      color: AppTheme.aiBlue,
      screen: LiveViewScreen(),
    ),
    QuickAction(
      title: 'اللاعبون',
      icon: CupertinoIcons.person_2_fill,
      color: AppTheme.aiSoftPurple,
      screen: PlayersScreen(),
    ),
    QuickAction(
      title: 'الإعادة',
      icon: CupertinoIcons.arrow_counterclockwise_circle_fill,
      color: AppTheme.accentGold,
      screen: ReplayScreen(),
    ),
    QuickAction(
      title: 'التعرف',
      icon: CupertinoIcons.eye_fill,
      color: Color(0xFF20C997),
      screen: PlayerRecognitionScreen(),
    ),
  ];
}
