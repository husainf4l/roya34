import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../models/player.dart';
import '../services/mock_data_service.dart';

class LiveViewScreen extends StatefulWidget {
  const LiveViewScreen({super.key});

  @override
  State<LiveViewScreen> createState() => _LiveViewScreenState();
}

class _LiveViewScreenState extends State<LiveViewScreen>
    with SingleTickerProviderStateMixin {
  bool _isVideoLoading = true;
  bool _isAnalyzing = false;
  List<Player> _activePlayers = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Simulate video loading
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVideoLoading = false;
      });

      // After video loads, simulate AI analysis start
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isAnalyzing = true;
        });

        // Simulate AI analysis completion
        Future.delayed(const Duration(seconds: 3), () async {
          // Use await to properly get players
          final players = await MockDataService.getPlayers();

          if (mounted) {
            setState(() {
              _isAnalyzing = false;
              _activePlayers = players.take(5).toList();
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.black,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Hero(
        tag: 'back_button',
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.black.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                CupertinoIcons.chevron_right,
                color: AppTheme.white,
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
              color: AppTheme.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              CupertinoIcons.settings_solid,
              color: AppTheme.white,
              size: 18,
            ),
          ),
          onPressed: () {
            // Settings action
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video feed background
        _buildVideoFeed(),

        // Overlay controls and UI
        Column(
          children: [
            Expanded(
              child: Container(), // Push content to bottom
            ),
            _buildOverlayControls(),
          ],
        ),

        // AI analysis overlay
        if (_isAnalyzing) _buildAIAnalysisOverlay(),

        // Loading overlay
        if (_isVideoLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildVideoFeed() {
    if (_isVideoLoading) {
      return Container(
        color: AppTheme.black,
      );
    }

    return Container(
      color: const Color(0xFF1A2025), // Dark background for video
      child: Center(
        // Using a container with an icon instead of trying to load an image
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_outlined,
              color: AppTheme.white.withOpacity(0.2),
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              "بث المباراة",
              style: GoogleFonts.cairo(
                color: AppTheme.white.withOpacity(0.3),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayControls() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: AppTheme.black.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border.all(
              color: AppTheme.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Match info
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "مباراة ودية",
                      style: GoogleFonts.cairo(
                        color: AppTheme.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "الهلال vs النصر",
                    style: GoogleFonts.cairo(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.aiBlue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.doc_text,
                      color: AppTheme.aiBlue,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active players
              if (_activePlayers.isNotEmpty) _buildActivePlayers(),

              const SizedBox(height: 24),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: CupertinoIcons.camera_viewfinder,
                    label: "زاوية ١",
                    isActive: true,
                  ),
                  _buildControlButton(
                    icon: CupertinoIcons.camera,
                    label: "زاوية ٢",
                  ),
                  _buildControlButton(
                    icon: CupertinoIcons.timer,
                    label: "إعادة",
                    gradient: AppTheme.accentGradient,
                  ),
                  _buildControlButton(
                    icon: CupertinoIcons.person_2,
                    label: "اللاعبون",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivePlayers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اللاعبون في الملعب",
          style: GoogleFonts.cairo(
            color: AppTheme.white.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _activePlayers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final player = _activePlayers[index];
              return _buildPlayerBubble(player);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerBubble(Player player) {
    final Color performanceColor = _getPerformanceColor(player.performance);
    final bool isActive = player.performance > 70;

    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 70,
      child: Column(
        children: [
          // Player avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: performanceColor.withOpacity(isActive ? 0.8 : 0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    player.number.toString(),
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            player.name.split(" ")[0], // First name only
            style: GoogleFonts.cairo(
              color: AppTheme.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    LinearGradient? gradient,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
            color: isActive
                ? AppTheme.primaryGreen
                : AppTheme.white.withOpacity(0.1),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Button action
              },
              borderRadius: BorderRadius.circular(28),
              child: Center(
                child: Icon(
                  icon,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.cairo(
            color: AppTheme.white.withOpacity(isActive ? 1.0 : 0.7),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppTheme.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "جاري تحميل البث المباشر...",
              style: GoogleFonts.cairo(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAnalysisOverlay() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          // AI scanning visualization
          Positioned.fill(
            child: CustomPaint(
              painter: AIScanPainter(
                animation: _animationController,
              ),
            ),
          ),

          // Central analysis indicator
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.aiBlue.withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.aiBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.aiBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "جاري تحليل الملعب بالذكاء الاصطناعي",
                    style: GoogleFonts.cairo(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
}

class AIScanPainter extends CustomPainter {
  final Animation<double> animation;

  AIScanPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw scanning lines
    for (double i = 0; i < 10; i++) {
      final double animValue = (animation.value + i / 10) % 1.0;
      final double opacity = (1 - animValue) * 0.4;
      paint.color = AppTheme.aiBlue.withOpacity(opacity);

      final double y = size.height * animValue;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw grid
    paint.color = AppTheme.aiBlue.withOpacity(0.1);
    paint.strokeWidth = 0.5;

    // Vertical grid lines
    for (double x = 0; x < size.width; x += size.width / 20) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal grid lines
    for (double y = 0; y < size.height; y += size.height / 20) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AIScanPainter oldDelegate) => true;
}
