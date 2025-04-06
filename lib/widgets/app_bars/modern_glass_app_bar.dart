import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../buttons/glass_icon_button.dart';
import '../buttons/menu_option_button.dart';
import '../../services/auth_service.dart';
import '../../screens/login_screen.dart';

class ModernGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernGlassAppBar({super.key});

  void _showSuperMenu(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Super Menu",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return _buildSuperMenu(context);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -0.2), end: const Offset(0, 0))
              .animate(anim1),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildSuperMenu(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 56.0, right: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: AppTheme.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.white.withOpacity(0.2),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: _buildMenuContent(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUserProfileSection(),
        _buildMenuOptions(context),
        _buildLogoutOption(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                "م",
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
                  "محمد عبدالله",
                  style: GoogleFonts.cairo(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "المدير الفني",
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
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuOption(
          context: context,
          icon: CupertinoIcons.chart_bar_alt_fill,
          title: "التحليلات والإحصائيات",
          color: AppTheme.aiBlue,
        ),
        _buildMenuOption(
          context: context,
          icon: CupertinoIcons.calendar,
          title: "جدول المباريات",
          color: AppTheme.aiSoftPurple,
        ),
        _buildMenuOption(
          context: context,
          icon: CupertinoIcons.gear,
          title: "الإعدادات",
          color: AppTheme.accentGold,
        ),
        _buildMenuOption(
          context: context,
          icon: CupertinoIcons.bell_fill,
          title: "الإشعارات",
          color: const Color(0xFF20C997),
          badge: "3",
        ),
        _buildMenuOption(
          context: context,
          icon: CupertinoIcons.question_circle,
          title: "المساعدة والدعم",
          color: AppTheme.aiBlue,
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    String? badge,
  }) {
    return MenuOptionButton(
      icon: icon,
      title: title,
      color: color,
      badge: badge,
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "سيتم فتح $title قريبًا",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: color,
          ),
        );
      },
    );
  }

  Widget _buildLogoutOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            _showLogoutDialog(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.power,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "تسجيل الخروج",
                    style: GoogleFonts.cairo(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "تسجيل الخروج",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "هل أنت متأكد من رغبتك في تسجيل الخروج؟",
              style: GoogleFonts.cairo(),
            ),
            actions: [
              TextButton(
                child: Text(
                  "إلغاء",
                  style: GoogleFonts.cairo(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "تأكيد",
                  style: GoogleFonts.cairo(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  await AuthService.logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم تسجيل الخروج بنجاح",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "رؤية ",
              style: GoogleFonts.cairo(
                color: AppTheme.aiBlue,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            Text(
              "34",
              style: GoogleFonts.cairo(
                color: const Color(0xFF20C997),
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        GlassIconButton(
          icon: CupertinoIcons.list_bullet,
          onTap: () => _showSuperMenu(context),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
