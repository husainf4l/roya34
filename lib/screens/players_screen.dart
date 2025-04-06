import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../models/player.dart';
import '../services/mock_data_service.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen>
    with SingleTickerProviderStateMixin {
  late List<Player> players;
  late AnimationController _animationController;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.mediumAnimation,
    );

    // Simulate API call with delayed response
    Future.delayed(const Duration(milliseconds: 800), () async {
      // Use await to properly get players
      final loadedPlayers = await MockDataService.getPlayers();

      if (mounted) {
        setState(() {
          players = loadedPlayers;
          _isLoading = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Player> get filteredPlayers {
    if (_searchQuery.isEmpty) {
      return players;
    }
    return players.where((player) {
      return player.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightGrey,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "اللاعبون",
        style: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppTheme.black,
        ),
      ),
      centerTitle: true,
      leading: Hero(
        tag: 'back_button',
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.white,
                shape: BoxShape.circle,
                boxShadow: AppTheme.softShadow,
              ),
              child: Icon(
                CupertinoIcons.chevron_right,
                color: AppTheme.primaryGreen,
                size: 18,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.softShadow,
            ),
            child: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: AppTheme.darkGrey,
              size: 18,
            ),
          ),
          onPressed: () {
            // Filter action
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    return SafeArea(
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildPlayersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.softShadow,
            ),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryGreen,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحليل بيانات اللاعبين...",
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.softShadow,
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            fontSize: 15,
            color: AppTheme.black,
          ),
          decoration: InputDecoration(
            hintText: "بحث عن لاعب...",
            hintTextDirection: TextDirection.rtl,
            hintStyle: GoogleFonts.cairo(
              fontSize: 15,
              color: AppTheme.darkGrey.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: AppTheme.darkGrey.withOpacity(0.7),
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: AppTheme.darkGrey.withOpacity(0.7),
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersList() {
    if (filteredPlayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_2_fill,
              size: 54,
              color: AppTheme.darkGrey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "لا يوجد لاعبين مطابقين للبحث",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: filteredPlayers.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final player = filteredPlayers[index];

        // Calculate staggered animation delay
        final Animation<double> animation =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index / filteredPlayers.length) * 0.5,
              min(((index + 1) / filteredPlayers.length) * 0.5 + 0.5, 1.0),
              curve: AppTheme.modernEasing,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - animation.value)),
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            );
          },
          child: _buildPlayerCard(player),
        );
      },
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        boxShadow: AppTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Show player details
            },
            child: Stack(
              children: [
                // Background gradient with AI indicators
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // AI Analysis indicator
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.aiSoftPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.aiSoftPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.waveform_path,
                          color: AppTheme.aiBlue,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "تحليل ذكي",
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.aiBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Player content
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Player avatar with performance ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Performance indicator ring
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _getPerformanceColor(player.performance),
                                  _getPerformanceColor(player.performance)
                                      .withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: AppTheme.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          // Player number
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.white,
                            child: Text(
                              player.number.toString(),
                              style: GoogleFonts.cairo(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Player info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              player.position,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Performance indicators
                            Row(
                              children: [
                                _buildStatIndicator(
                                  icon: CupertinoIcons.heart_fill,
                                  value: "${player.energy}%",
                                  color: _getEnergyColor(player.energy),
                                ),
                                const SizedBox(width: 16),
                                _buildStatIndicator(
                                  icon: CupertinoIcons.speedometer,
                                  value: "${player.speed} كم/س",
                                  color: _getSpeedColor(player.speed),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action indicator
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          CupertinoIcons.chevron_left,
                          color: AppTheme.darkGrey,
                          size: 16,
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

  Widget _buildStatIndicator({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(int performance) {
    if (performance >= 85) return AppTheme.aiGreen;
    if (performance >= 70) return AppTheme.aiBlue;
    if (performance >= 50) return AppTheme.aiAmber;
    return Colors.redAccent;
  }

  Color _getEnergyColor(int energy) {
    if (energy >= 80) return AppTheme.aiGreen;
    if (energy >= 60) return AppTheme.aiBlue;
    if (energy >= 40) return AppTheme.aiAmber;
    return Colors.redAccent;
  }

  Color _getSpeedColor(double speed) {
    if (speed >= 30) return AppTheme.aiGreen;
    if (speed >= 25) return AppTheme.aiBlue;
    if (speed >= 20) return AppTheme.aiAmber;
    return Colors.redAccent;
  }
}
