import 'package:flutter/cupertino.dart';
import '../models/quick_action.dart';
import '../models/featured_card.dart';
import '../config/app_theme.dart';
import '../screens/live_view_screen.dart';
import '../screens/players_screen.dart';
import '../screens/replay_screen.dart';
import '../screens/player_recognition_screen.dart';

class AppConstants {
  static const List<QuickAction> quickActions = [
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

  static const List<FeaturedCardData> featuredCards = [
    FeaturedCardData(
      title: 'بث مباشر',
      subtitle: 'متابعة المباراة مع تحليل ai',
      gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      iconData: CupertinoIcons.tv_fill,
      screen: LiveViewScreen(),
    ),
    FeaturedCardData(
      title: 'تحليل اللاعبين',
      subtitle: 'تعرف على إحصائيات وأداء اللاعبين',
      gradient: [AppTheme.aiSoftPurple, Color(0xFFB492FF)],
      iconData: CupertinoIcons.person_2_fill,
      screen: PlayersScreen(),
    ),
    FeaturedCardData(
      title: 'اللحظات المميزة',
      subtitle: 'شاهد أفضل اللحظات من المباراة',
      gradient: [AppTheme.accentGold, Color(0xFFFFD166)],
      iconData: CupertinoIcons.arrow_counterclockwise_circle_fill,
      screen: ReplayScreen(),
    ),
  ];
}
