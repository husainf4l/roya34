import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../models/replay_moment.dart';
import '../models/player.dart';
import '../services/mock_data_service.dart';
import 'live_view_screen.dart';
import 'players_screen.dart';
import 'replay_screen.dart';
import 'player_recognition_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late List<Player> _featuredPlayers;
  late List<ReplayMoment> _topMoments;

  int _activeCardIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppTheme.modernEasing,
    );

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.modernEasing,
      ),
    );

    // Get mock data using static methods
    _featuredPlayers = MockDataService.getFeaturedPlayers();
    _topMoments = MockDataService.getTopMoments();

    // Listen to page changes for card carousel
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_activeCardIndex != next) {
        setState(() {
          _activeCardIndex = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppleVisionAppBar(),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            );
          },
          child: _buildVisionProBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppleVisionAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.white.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                widget.title,
                style: GoogleFonts.cairo(
                  color: AppTheme.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        _buildGlassIconButton(
          icon: CupertinoIcons.settings,
          onTap: () {
            // Settings action
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildGlassIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.white.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppTheme.black.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisionProBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF0F7FF),
            const Color(0xFFF8FAFF),
            const Color(0xFFFDFDFF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildWelcomeHeader(),
              const SizedBox(height: 20),

              // Featured card carousel
              _buildFeaturedCarousel(),
              const SizedBox(height: 30),

              // Quick action buttons
              _buildQuickActionRow(),
              const SizedBox(height: 30),

              // Featured players
              _buildSectionHeader(
                  "أبرز اللاعبين", CupertinoIcons.person_2_fill),
              _buildPlayerCardsRow(),
              const SizedBox(height: 30),

              // Top moments
              _buildSectionHeader("لحظات مميزة", CupertinoIcons.star_fill),
              _buildTopMomentsGrid(),
              const SizedBox(height: 30),

              // Main navigation section
              _buildMainNavigationSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.aiSoftPurple.withOpacity(0.25),
                  AppTheme.aiBlue.withOpacity(0.25)
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppTheme.white.withOpacity(0.4),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.aiSoftPurple.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPulsingIcon(CupertinoIcons.sparkles, AppTheme.aiBlue),
                    const SizedBox(width: 10),
                    Text(
                      "مرحباً بك في نظام رؤية الذكي",
                      style: GoogleFonts.cairo(
                        color: AppTheme.black.withOpacity(0.8),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "اكتشف عالم كرة القدم بتقنية الذكاء الاصطناعي",
                  style: GoogleFonts.cairo(
                    color: AppTheme.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildFeaturedCard(index);
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: AppTheme.shortAnimation,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _activeCardIndex == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _activeCardIndex == index
                    ? AppTheme.aiBlue
                    : AppTheme.mediumGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(int index) {
    final List<Map<String, dynamic>> featuredCards = [
      {
        'title': 'بث مباشر',
        'subtitle': 'متابعة المباراة مع تحليل AI',
        'gradient': const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
        'iconData': CupertinoIcons.tv_fill,
        'screen': const LiveViewScreen(),
      },
      {
        'title': 'تحليل اللاعبين',
        'subtitle': 'تعرف على إحصائيات وأداء اللاعبين',
        'gradient': const [AppTheme.aiSoftPurple, Color(0xFFB492FF)],
        'iconData': CupertinoIcons.person_2_fill,
        'screen': const PlayersScreen(),
      },
      {
        'title': 'اللحظات المميزة',
        'subtitle': 'شاهد أفضل اللحظات من المباراة',
        'gradient': const [AppTheme.accentGold, Color(0xFFFFD166)],
        'iconData': CupertinoIcons.arrow_counterclockwise_circle_fill,
        'screen': const ReplayScreen(),
      },
    ];

    final card = featuredCards[index];

    return AnimatedPadding(
      duration: AppTheme.shortAnimation,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: _activeCardIndex == index ? 0 : 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: GestureDetector(
          onTap: () => _navigateWithTransition(card['screen']),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: card['gradient'],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: card['gradient'][0].withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Modern orbital animation for AI effect
                Positioned(
                  right: -50,
                  bottom: -50,
                  child: _buildOrbitalRing(220, 15, reverse: true),
                ),
                Positioned(
                  left: -30,
                  top: -30,
                  child: _buildOrbitalRing(180, 20),
                ),

                // Neural network effect
                Positioned.fill(
                  child: _buildNeuralNetworkEffect(),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              card['iconData'],
                              size: 32,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        card['title'],
                        style: GoogleFonts.cairo(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card['subtitle'],
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "استكشف",
                                  style: GoogleFonts.cairo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  CupertinoIcons.chevron_left,
                                  size: 16,
                                  color: AppTheme.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionRow() {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'بث مباشر',
        'icon': CupertinoIcons.tv_fill,
        'color': AppTheme.aiBlue,
        'screen': const LiveViewScreen(),
      },
      {
        'title': 'اللاعبون',
        'icon': CupertinoIcons.person_2_fill,
        'color': AppTheme.aiSoftPurple,
        'screen': const PlayersScreen(),
      },
      {
        'title': 'الإعادة',
        'icon': CupertinoIcons.arrow_counterclockwise_circle_fill,
        'color': AppTheme.accentGold,
        'screen': const ReplayScreen(),
      },
      {
        'title': 'التعرف',
        'icon': CupertinoIcons.eye_fill,
        'color': const Color(0xFF20C997),
        'screen': const PlayerRecognitionScreen(),
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _navigateWithTransition(action['screen']),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: action['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: action['color'].withOpacity(0.3),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: action['color'].withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          action['icon'],
                          size: 20,
                          color: action['color'],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  action['title'],
                  style: GoogleFonts.cairo(
                    color: AppTheme.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.aiBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.aiBlue.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppTheme.aiBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.cairo(
              color: AppTheme.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              "المزيد",
              style: GoogleFonts.cairo(
                color: AppTheme.aiBlue,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardsRow() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _featuredPlayers.length,
        itemBuilder: (context, index) {
          final player = _featuredPlayers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.white.withOpacity(0.5),
                      width: 0.5,
                    ),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              player.teamColor.withOpacity(0.7),
                              player.teamColor,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: player.teamColor.withOpacity(0.1),
                            border: Border.all(
                              color: player.teamColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              player.number.toString(),
                              style: GoogleFonts.cairo(
                                color: player.teamColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        player.name,
                        style: GoogleFonts.cairo(
                          color: AppTheme.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        player.position,
                        style: GoogleFonts.cairo(
                          color: AppTheme.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: player.teamColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${player.rating}",
                          style: GoogleFonts.cairo(
                            color: player.teamColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopMomentsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: _topMoments.length.clamp(0, 4),
        itemBuilder: (context, index) {
          final moment = _topMoments[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.white.withOpacity(0.5),
                    width: 0.5,
                  ),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Stack(
                  children: [
                    // Placeholder for a moment thumbnail
                    // In a real app, you'd use an actual image
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.aiBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      height: 80,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.play_circle_fill,
                          size: 32,
                          color: AppTheme.aiBlue.withOpacity(0.7),
                        ),
                      ),
                    ),

                    // Moment details
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moment.title,
                              style: GoogleFonts.cairo(
                                color: AppTheme.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${moment.minute}'",
                              style: GoogleFonts.cairo(
                                color: AppTheme.aiBlue,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Type indicator (goal, assist, etc)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getMomentTypeColor(moment.type),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          moment.type.arabicLabel,
                          style: GoogleFonts.cairo(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getMomentTypeColor(ReplayMomentType type) {
    switch (type) {
      case ReplayMomentType.goal:
        return AppTheme.aiBlue;
      case ReplayMomentType.assist:
        return AppTheme.accentGold;
      case ReplayMomentType.save:
        return AppTheme.aiSoftPurple;
      default:
        return AppTheme.aiGreen;
    }
  }

  Widget _buildMainNavigationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.black.withOpacity(0.7),
                  AppTheme.black.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: AppTheme.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Logo placeholder
                      Hero(
                        tag: 'logo',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.aiBlue,
                                AppTheme.aiSoftPurple,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "رؤية",
                              style: GoogleFonts.cairo(
                                color: AppTheme.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "رؤية للذكاء الاصطناعي",
                              style: GoogleFonts.cairo(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "تقنية الذكاء الاصطناعي لتحليل المباريات",
                              style: GoogleFonts.cairo(
                                color: AppTheme.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation buttons
                _buildAppleVisionButton(
                  icon: CupertinoIcons.tv_fill,
                  label: "العرض المباشر",
                  onPressed: () {
                    _navigateWithTransition(const LiveViewScreen());
                  },
                ),
                _buildAppleVisionButton(
                  icon: CupertinoIcons.person_2_fill,
                  label: "اللاعبون",
                  onPressed: () {
                    _navigateWithTransition(const PlayersScreen());
                  },
                ),
                _buildAppleVisionButton(
                  icon: CupertinoIcons.arrow_counterclockwise_circle_fill,
                  label: "الإعادة",
                  onPressed: () {
                    _navigateWithTransition(const ReplayScreen());
                  },
                ),
                _buildAppleVisionButton(
                  icon: CupertinoIcons.eye_fill,
                  label: "التعرف على اللاعبين",
                  onPressed: () {
                    _navigateWithTransition(const PlayerRecognitionScreen());
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleVisionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: AppTheme.white.withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                // Icon container with glass effect
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.cairo(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 14,
                  color: AppTheme.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for visual effects

  Widget _buildPulsingIcon(IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Transform.scale(
            scale: value,
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrbitalRing(double size, double duration,
      {bool reverse = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: duration.round()),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: reverse ? -value * 2 * 3.14159 : value * 2 * 3.14159,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: size / 2 - 4,
                  child: _buildOrbitalNode(),
                ),
                Positioned(
                  bottom: size * 0.1,
                  right: size * 0.1,
                  child: _buildOrbitalNode(isSmall: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrbitalNode({bool isSmall = false}) {
    final double size = isSmall ? 6 : 8;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.aiBlue.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNeuralNetworkEffect() {
    return CustomPaint(
      painter: NeuralNetworkPainter(),
    );
  }

  void _navigateWithTransition(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.05);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: AppTheme.mediumAnimation,
      ),
    );
  }
}

// Custom Painter for Neural Network Effect
class NeuralNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Create a network of nodes
    final Random random = Random(42); // Fixed seed for consistent pattern
    final List<Offset> nodes = [];

    // Generate random nodes
    for (int i = 0; i < 15; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double radius = random.nextDouble() * size.width * 0.4;
      nodes.add(Offset(
        size.width / 2 + cos(angle) * radius,
        size.height / 2 + sin(angle) * radius,
      ));
    }

    // Draw connections between nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        // Only connect some nodes for a cleaner look
        if (random.nextDouble() > 0.7) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    // Draw nodes
    for (final node in nodes) {
      canvas.drawCircle(node, 2, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
