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
                    PulsingIcon(
                      icon: CupertinoIcons.sparkles,
                      color: AppTheme.aiBlue,
                    ),
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
}
