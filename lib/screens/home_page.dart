import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../models/replay_moment.dart';
import '../models/player.dart';
import '../services/mock_data_service.dart';
import 'live_view_screen.dart';
import 'players_screen.dart';
import 'replay_screen.dart';
import 'player_recognition_screen.dart';
import '../widgets/cards/featured_card.dart';
import '../widgets/headers/welcome_header.dart';
import '../widgets/headers/section_header.dart';
import '../utils/navigation_utils.dart';
import '../widgets/buttons/quick_action_button.dart';
import '../widgets/app_bars/modern_glass_app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late Future<List<Player>> _featuredPlayersFuture;
  late Future<List<ReplayMoment>> _topMomentsFuture;
  List<Player> _featuredPlayers = [];
  List<ReplayMoment> _topMoments = [];

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

    // Initialize futures
    _featuredPlayersFuture = MockDataService.getFeaturedPlayers();
    _topMomentsFuture = MockDataService.getTopMoments();

    // Load data asynchronously
    _loadData();

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

  Future<void> _loadData() async {
    try {
      final players = await _featuredPlayersFuture;
      final moments = await _topMomentsFuture;

      if (mounted) {
        setState(() {
          _featuredPlayers = players;
          _topMoments = moments;
        });
      }
    } catch (e) {
      // Handle error state if needed
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "فشل في تحميل البيانات",
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white, // Ensuring white text on error
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        appBar: const ModernGlassAppBar(),
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

  Widget _buildVisionProBody() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF050A1A), // Solid dark color instead of gradient
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A2542), // Darker shadow
            blurRadius: 8,
          ),
        ],
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
    return const WelcomeHeader();
  }

  Widget _buildFeaturedCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: AppConstants.featuredCards.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildFeaturedCard(index);
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(AppConstants.featuredCards.length, (index) {
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
    final card = AppConstants.featuredCards[index];

    return FeaturedCard(
      title: card.title,
      subtitle: card.subtitle,
      gradient: card.gradient,
      icon: card.iconData,
      onTap: () => _navigateWithTransition(card.screen),
      isActive: _activeCardIndex == index,
    );
  }

  Widget _buildQuickActionRow() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: AppConstants.quickActions.length,
        itemBuilder: (context, index) {
          final action = AppConstants.quickActions[index];
          return QuickActionButton(
            action: action,
            onTap: () => _navigateWithTransition(action.screen),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return SectionHeader(
      title: title,
      icon: icon,
      onMoreTap: () {},
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
                    color: AppTheme.darkGrey.withOpacity(
                        0.4), // Darker background for better contrast
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
                                color: player.teamColor, // Already contrasting
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
                          color: Colors
                              .white, // Changed to white for dark background
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
                          color: Colors.white.withOpacity(
                              0.7), // Changed to white with opacity
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
                  color:
                      AppTheme.darkGrey.withOpacity(0.4), // Darker background
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
                                color: Colors.white, // Changed to white
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${moment.minute}'",
                              style: GoogleFonts.cairo(
                                color: AppTheme.aiBlue, // Already bright blue
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

  void _navigateWithTransition(Widget screen) {
    Navigator.push(
      context,
      NavigationUtils.slideUpRoute(screen: screen),
    );
  }
}
