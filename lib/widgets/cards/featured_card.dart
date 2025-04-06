import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../widgets/effects/orbital_ring.dart';
import '../../widgets/effects/neural_network.dart';

class FeaturedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: AppTheme.shortAnimation,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: isActive ? 0 : 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(
                color: gradient[1].withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -50,
                  bottom: -50,
                  child: OrbitalRing(size: 220, duration: 15, reverse: true),
                ),
                Positioned(
                  left: -30,
                  top: -30,
                  child: OrbitalRing(size: 180, duration: 20),
                ),
                const Positioned.fill(
                  child: NeuralNetwork(),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildIconContainer(),
                      const SizedBox(height: 24),
                      _buildTitle(),
                      const SizedBox(height: 8),
                      _buildSubtitle(),
                      const SizedBox(height: 20),
                      _buildExploreButton(),
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

  Widget _buildIconContainer() {
    return ClipRRect(
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
            icon,
            size: 32,
            color: AppTheme.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppTheme.white,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.white.withOpacity(0.85),
      ),
    );
  }

  Widget _buildExploreButton() {
    return ClipRRect(
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
    );
  }
}
