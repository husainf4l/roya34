import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../config/app_theme.dart';
import '../models/player.dart';
import '../services/mock_data_service.dart';

class PlayerRecognitionScreen extends StatefulWidget {
  const PlayerRecognitionScreen({super.key});

  @override
  State<PlayerRecognitionScreen> createState() =>
      _PlayerRecognitionScreenState();
}

class _PlayerRecognitionScreenState extends State<PlayerRecognitionScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false;
  bool _playerDetected = false;
  Player? _detectedPlayer;
  Map<String, dynamic> _gameInfo = {};
  int _selectedTopShotIndex = 0;

  // Animation controllers
  late AnimationController _pulseAnimationController;
  late AnimationController _scanAnimationController;

  @override
  void initState() {
    super.initState();

    // Get current game info
    _gameInfo = MockDataService.getCurrentGameInfo();

    // Setup animations
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // No cameras found
      return;
    }

    // Use the first back camera
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });

        // Wait a bit and then simulate player detection
        _startPlayerDetection();
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startPlayerDetection() {
    // In a real app, this would be based on continuous image processing
    // For now, we'll simulate detection after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = true;
        });

        // Simulate detection process
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isAnalyzing = false;
              _playerDetected = true;
              _selectedTopShotIndex = 0;

              // Pick a random player from our mock data
              final players = MockDataService.getPlayers();
              _detectedPlayer = players[math.Random().nextInt(players.length)];
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _pulseAnimationController.dispose();
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Hero(
            tag: 'back_button',
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppTheme.white,
                    size: 16,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          title: Text(
            "تعرف على اللاعبين",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.question,
                    color: AppTheme.white,
                    size: 16,
                  ),
                ),
                onPressed: () {
                  // Show help instructions
                  _showInstructions();
                },
              ),
            ),
          ],
        ),
        body: _buildBody(),
        bottomSheet: _playerDetected ? _buildPlayerInfoSheet() : null,
      ),
    );
  }

  Widget _buildBody() {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Preview
        CameraPreview(_cameraController!),

        // Scanning overlay
        _buildScanningOverlay(),

        // Status text
        if (_isAnalyzing) _buildAnalyzingIndicator(),

        // Game info overlay at top
        _buildGameInfoOverlay(),
      ],
    );
  }

  Widget _buildGameInfoOverlay() {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Match time
            Column(
              children: [
                Text(
                  _gameInfo['matchPhase'] ?? 'الشوط الأول',
                  style: GoogleFonts.cairo(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _gameInfo['currentTime'] ?? '00:00',
                    style: GoogleFonts.cairo(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Score
            Row(
              children: [
                Text(
                  _gameInfo['homeTeam'] ?? 'الفريق الأول',
                  style: GoogleFonts.cairo(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${_gameInfo['homeScore'] ?? 0} - ${_gameInfo['awayScore'] ?? 0}",
                    style: GoogleFonts.cairo(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _gameInfo['awayTeam'] ?? 'الفريق الثاني',
                  style: GoogleFonts.cairo(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Darkened background
        Container(
          color: Colors.black.withOpacity(0.3),
        ),

        // Target area
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnimationController,
            builder: (context, child) {
              return Container(
                width: 250 + 20 * _pulseAnimationController.value,
                height: 250 + 20 * _pulseAnimationController.value,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(
                        0.7 - 0.3 * _pulseAnimationController.value),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_playerDetected && !_isAnalyzing)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ضع اللاعب داخل الإطار",
                      style: GoogleFonts.cairo(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Scanning line (only when analyzing)
        if (_isAnalyzing)
          AnimatedBuilder(
              animation: _scanAnimationController,
              builder: (context, _) {
                return Positioned(
                  top: 100 + 200 * _scanAnimationController.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: AppTheme.primaryGreen.withOpacity(0.8),
                  ),
                );
              }),
      ],
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            "جاري التعرف على اللاعب...",
            style: GoogleFonts.cairo(
              color: AppTheme.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoSheet() {
    if (_detectedPlayer == null) return const SizedBox.shrink();

    final player = _detectedPlayer!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Handle indicator
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: AppTheme.darkGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Player number and avatar
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

              const SizedBox(width: 15),

              // Player details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and team
                    Text(
                      player.name,
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          player.position,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: AppTheme.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.darkGrey.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          player.teamName,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Season stats
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.sportscourt,
                          color: AppTheme.darkGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${player.goals} أهداف",
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          CupertinoIcons.arrow_right_circle,
                          color: AppTheme.darkGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${player.assists} تمريرات حاسمة",
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Performance stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                label: "الأداء",
                value: "${player.performance}%",
                color: _getPerformanceColor(player.performance),
                icon: CupertinoIcons.chart_bar_fill,
              ),
              _buildStatItem(
                label: "الطاقة",
                value: "${player.energy}%",
                color: _getEnergyColor(player.energy),
                icon: CupertinoIcons.heart_fill,
              ),
              _buildStatItem(
                label: "السرعة",
                value: "${player.speed} كم/س",
                color: _getSpeedColor(player.speed),
                icon: CupertinoIcons.speedometer,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Top shots section
          if (player.topShots.isNotEmpty) _buildTopShotsSection(player),

          const SizedBox(height: 20),

          // Actions button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Reset detection to allow for another player
                setState(() {
                  _playerDetected = false;
                  _detectedPlayer = null;
                  _selectedTopShotIndex = 0;
                  _startPlayerDetection();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "تعرف على لاعب آخر",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopShotsSection(Player player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "أبرز اللقطات",
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.darkGrey.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Main image
                Image.asset(
                  player.topShots[_selectedTopShotIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for when image doesn't exist
                    return Container(
                      color: AppTheme.darkGrey.withOpacity(0.2),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          color: AppTheme.darkGrey,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),

                // Navigation buttons
                if (player.topShots.length > 1)
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTopShotIndex =
                                  (_selectedTopShotIndex - 1) %
                                      player.topShots.length;
                              if (_selectedTopShotIndex < 0)
                                _selectedTopShotIndex += player.topShots.length;
                            });
                          },
                          child: Container(
                            width: 40,
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.chevron_right,
                                  color: AppTheme.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Next button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTopShotIndex =
                                  (_selectedTopShotIndex + 1) %
                                      player.topShots.length;
                            });
                          },
                          child: Container(
                            width: 40,
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.chevron_left,
                                  color: AppTheme.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Shot indicators
                if (player.topShots.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        player.topShots.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _selectedTopShotIndex
                                ? AppTheme.primaryGreen
                                : AppTheme.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: AppTheme.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(int performance) {
    if (performance >= 85) return AppTheme.successGreen;
    if (performance >= 70) return AppTheme.primaryGreen;
    if (performance >= 50) return Colors.orange;
    return Colors.red;
  }

  Color _getEnergyColor(int energy) {
    if (energy >= 80) return AppTheme.successGreen;
    if (energy >= 60) return AppTheme.primaryGreen;
    if (energy >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getSpeedColor(double speed) {
    if (speed >= 32) return Colors.blue;
    if (speed >= 28) return AppTheme.primaryGreen;
    if (speed >= 25) return AppTheme.successGreen;
    return AppTheme.darkGrey;
  }

  void _showInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "كيفية استخدام تعرف على اللاعبين",
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildInstructionItem(
              number: 1,
              text: "وجّه الكاميرا نحو اللاعب المراد التعرف عليه",
            ),
            _buildInstructionItem(
              number: 2,
              text: "تأكد من وجود اللاعب داخل الإطار الأخضر",
            ),
            _buildInstructionItem(
              number: 3,
              text: "انتظر حتى يتم التعرف على اللاعب وعرض معلوماته",
            ),
            _buildInstructionItem(
              number: 4,
              text: "للتعرف على لاعب آخر، اضغط على زر \"تعرف على لاعب آخر\"",
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "فهمت",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem({required int number, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryGreen,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: AppTheme.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
