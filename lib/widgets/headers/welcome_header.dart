import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../effects/pulsing_icon.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
                  AppTheme.aiSoftPurple.withOpacity(0.4),
                  AppTheme.aiBlue.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppTheme.aiBlue.withOpacity(0.5),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.aiBlue.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PulsingIcon(
                      icon: CupertinoIcons.sparkles,
                      color: AppTheme.aiBlue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "مرحباً بك في نظام رؤية الذكي",
                      style: GoogleFonts.cairo(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            color: AppTheme.aiBlue.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ],
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
}
