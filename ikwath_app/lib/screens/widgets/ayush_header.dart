import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';
import 'ble_pill.dart';

/// Official Ministry of Ayush (Government of India) Header Component
/// Replicates the authentic government portal header (ayush.gov.in) with:
/// 1. Indian National Tricolour micro-ribbon
/// 2. State Emblem of India + "भारत सरकार / आयुष मंत्रालय"
/// 3. Hindi/English dual-language branding & quick formulation search
/// 4. Iconic Ministry Royal Blue (`#0B4F9C`) sub-navigation bar
class AyushHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final IKwathController ctrl;
  final VoidCallback onToggleTheme;
  final bool isDark;
  final VoidCallback onAlerts;
  final VoidCallback onSettings;

  const AyushHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.ctrl,
    required this.onToggleTheme,
    required this.isDark,
    required this.onAlerts,
    required this.onSettings,
  });

  static const List<({String hindi, String english, IconData icon})> navTabs = [
    (hindi: 'टेलीमेट्री', english: 'Telemetry', icon: Icons.sensors_rounded),
    (hindi: 'निर्माण प्रक्रिया', english: 'Kwatha Process', icon: Icons.local_fire_department_rounded),
    (hindi: 'निष्कर्षण चार्ट', english: 'Extraction Charts', icon: Icons.show_chart_rounded),
    (hindi: 'आयुष पॉड संग्रह', english: 'AFI Pod Library', icon: Icons.science_rounded),
    (hindi: 'गुणवत्ता ऑडिट', english: 'Audit & Compliance', icon: Icons.verified_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(bottom: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 1. National Tricolour Micro Ribbon ──────────────────────────
          SizedBox(
            height: 3.5,
            child: Row(
              children: [
                Expanded(child: Container(color: AppTheme.tricolorSaffron)),
                Expanded(child: Container(color: isDark ? const Color(0xFFE2E8F0) : AppTheme.tricolorWhite)),
                Expanded(child: Container(color: AppTheme.tricolorGreen)),
              ],
            ),
          ),

          // ── 2. Official Portal Header Bar ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 920;
                final isMedium = constraints.maxWidth > 680;

                return Row(
                  children: [
                    // State Emblem & Ministry Identity
                    const _AyushEmblemBrand(),

                    const SizedBox(width: 14),

                    // Center Search Bar (like ayush.gov.in)
                    if (isWide) ...[
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: _AyushSearchBar(ctrl: ctrl),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Spacer(),
                    ],

                    // Right Actions (Pills, Emergency, Alerts, Theme)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hindi/English Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.borderDark : AppTheme.ayushBlueLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? AppTheme.borderDark : AppTheme.ayushBlueBorder,
                            ),
                          ),
                          child: Text(
                            'अA',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppTheme.ayushBlue,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // BLE Connection Status Pill
                        BlePill(
                          connected: ctrl.bleConnected,
                          onTap: ctrl.toggleBle,
                        ),

                        if (isMedium) ...[
                          const SizedBox(width: 8),
                          // Machine State Badge
                          StateBadge(stage: ctrl.stage),
                        ],

                        const SizedBox(width: 8),

                        // Emergency Cutoff Button
                        _ActionIconBtn(
                          icon: Icons.power_off_rounded,
                          color: AppTheme.red,
                          tooltip: 'Emergency Hardware Cutoff (230V SSR)',
                          onTap: () => _confirmCutoff(context),
                        ),

                        const SizedBox(width: 6),

                        // Alerts Button with badge
                        _ActionIconBtn(
                          icon: Icons.notifications_rounded,
                          color: ctrl.alertCount > 0 ? AppTheme.red : null,
                          badge: ctrl.alertCount > 0 ? ctrl.alertCount : null,
                          tooltip: 'System Alerts & Safety Monitor',
                          onTap: onAlerts,
                        ),

                        const SizedBox(width: 6),

                        // Settings Button
                        _ActionIconBtn(
                          icon: Icons.tune_rounded,
                          tooltip: 'Calibration & Settings',
                          onTap: onSettings,
                        ),

                        const SizedBox(width: 6),

                        // Theme Mode Toggle
                        _ActionIconBtn(
                          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          tooltip: isDark ? 'Switch to Ayush Light Mode' : 'Switch to Ayush Dark Mode',
                          onTap: onToggleTheme,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // ── 3. Iconic Ministry Royal Blue Sub-Nav Bar (ayush.gov.in) ────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF071B3E), const Color(0xFF0B2E6B)]
                    : [AppTheme.ayushNavy, AppTheme.ayushBlue],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ayushNavy.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(navTabs.length, (idx) {
                  final isSelected = selectedIndex == idx;
                  final item = navTabs[idx];

                  return InkWell(
                    onTap: () => onTabSelected(idx),
                    hoverColor: Colors.white.withValues(alpha: 0.08),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.14)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? AppTheme.tricolorSaffron : Colors.transparent,
                            width: 3.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 8),
                          // Dual Language Label (Hindi + English)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.hindi,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                item.english.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFFFFD180)
                                      : Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.5,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCutoff(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.red, size: 28),
            const SizedBox(width: 10),
            Text(
              'Emergency Hardware Cutoff',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'This initiates an immediate emergency hardware cut: 230V SSR heater disconnects, magnetic stirrer stops, and ESP32 transitions to SAFE state. Proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.red),
            onPressed: () {
              Navigator.pop(context);
              ctrl.triggerEmergencyCutoff();
            },
            child: const Text('Cutoff Now'),
          ),
        ],
      ),
    );
  }
}

// ── Ministry of Ayush National Emblem & Brand Logo ───────────────────────────
class _AyushEmblemBrand extends StatelessWidget {
  const _AyushEmblemBrand();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Official Ministry of Ayush Logo Image
        Container(
          height: 48,
          constraints: const BoxConstraints(maxWidth: 160),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2F5E) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF2A4387) : const Color(0xFFE2E8F0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Image.asset(
            'assets/images/ayush_logo.jpg',
            fit: BoxFit.contain,
            color: isDark ? Colors.white : null,
            colorBlendMode: isDark ? BlendMode.modulate : null,
          ),
        ),

        const SizedBox(width: 10),

        // Official Dual-Language Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'भारत सरकार',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  ' • ',
                  style: TextStyle(
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  ),
                ),
                Text(
                  'आयुष मंत्रालय',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'iKwath',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF60A5FA) : AppTheme.ayushBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFFFCC80), width: 0.8),
                  ),
                  child: Text(
                    'AFI/API',
                    style: GoogleFonts.inter(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryDark,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'SIH 2026',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Ayush Search Bar Component (Inspired by ayush.gov.in) ─────────────────────
class _AyushSearchBar extends StatelessWidget {
  final IKwathController ctrl;
  const _AyushSearchBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1A38) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF233876) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            Icons.eco_rounded,
            size: 16,
            color: AppTheme.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AFI क्वाथ खोजें: ${ctrl.formulation.name} (${ctrl.formulation.sanskritName})',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppTheme.textMutedDark : const Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Mic icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.mic_none_rounded,
              size: 17,
              color: isDark ? AppTheme.textMutedDark : const Color(0xFF64748B),
            ),
          ),
          // Search Blue Button
          Container(
            height: 38,
            width: 42,
            decoration: const BoxDecoration(
              color: AppTheme.ayushBlue,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(7)),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Icon Button Helper ────────────────────────────────────────────────
class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final int? badge;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionIconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(
                  color: color != null
                      ? color!.withValues(alpha: 0.4)
                      : borderColor,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isDark ? const Color(0xFF142042) : const Color(0xFFF8FAFC),
              ),
              child: Icon(
                icon,
                size: 18,
                color: color ?? (isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 17,
                height: 17,
                decoration: const BoxDecoration(
                  color: AppTheme.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Custom Painter for National Ashoka Emblem / Satyameva Jayate Silhouette ──
class _AshokaEmblemPainter extends CustomPainter {
  final Color color;
  const _AshokaEmblemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final w = size.width;
    final h = size.height;

    // Base pedestal
    final pedestal = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.78, w * 0.7, h * 0.12),
      const Radius.circular(2),
    );
    canvas.drawRRect(pedestal, paint);

    // Abacus / Chakra circle in center of pedestal
    canvas.drawCircle(Offset(w * 0.5, h * 0.84), w * 0.1, strokePaint);

    // Central Lion Torso & Head
    final centerLion = Path()
      ..moveTo(w * 0.40, h * 0.76)
      ..lineTo(w * 0.40, h * 0.38)
      ..cubicTo(w * 0.35, h * 0.28, w * 0.45, h * 0.16, w * 0.50, h * 0.14)
      ..cubicTo(w * 0.55, h * 0.16, w * 0.65, h * 0.28, w * 0.60, h * 0.38)
      ..lineTo(w * 0.60, h * 0.76)
      ..close();
    canvas.drawPath(centerLion, paint);

    // Left Lion Profile
    final leftLion = Path()
      ..moveTo(w * 0.38, h * 0.76)
      ..lineTo(w * 0.26, h * 0.74)
      ..cubicTo(w * 0.20, h * 0.55, w * 0.20, h * 0.35, w * 0.28, h * 0.24)
      ..cubicTo(w * 0.35, h * 0.25, w * 0.38, h * 0.35, w * 0.38, h * 0.50)
      ..close();
    canvas.drawPath(leftLion, paint);

    // Right Lion Profile
    final rightLion = Path()
      ..moveTo(w * 0.62, h * 0.76)
      ..lineTo(w * 0.74, h * 0.74)
      ..cubicTo(w * 0.80, h * 0.55, w * 0.80, h * 0.35, w * 0.72, h * 0.24)
      ..cubicTo(w * 0.65, h * 0.25, w * 0.62, h * 0.35, w * 0.62, h * 0.50)
      ..close();
    canvas.drawPath(rightLion, paint);

    // 4 Mane details (lines)
    canvas.drawLine(Offset(w * 0.5, h * 0.36), Offset(w * 0.5, h * 0.62), strokePaint);
    canvas.drawLine(Offset(w * 0.44, h * 0.42), Offset(w * 0.44, h * 0.65), strokePaint);
    canvas.drawLine(Offset(w * 0.56, h * 0.42), Offset(w * 0.56, h * 0.65), strokePaint);
  }

  @override
  bool shouldRepaint(covariant _AshokaEmblemPainter oldDelegate) =>
      oldDelegate.color != color;
}
