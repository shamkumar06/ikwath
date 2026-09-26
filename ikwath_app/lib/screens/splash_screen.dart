import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const SplashScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)),
    );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl, curve: const Interval(0, 0.4, curve: Curves.easeOutCubic)),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl, curve: const Interval(0.2, 1, curve: Curves.easeInOut)),
    );

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, a, b) => DashboardScreen(
              onToggleTheme: widget.onToggleTheme,
              isDark: widget.isDark,
            ),
            transitionsBuilder: (context, anim, secondaryAnim, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071F47), // Ministry of Ayush Deep Navy
              Color(0xFF0B3A7A),
              Color(0xFF040F24),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Ministry Identity & State Emblem ─────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    children: [
                      // Ashoka Lion Capital Golden Silhouette Card
                      Container(
                        width: 76,
                        height: 82,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const CustomPaint(
                          painter: _SplashAshokaPainter(),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Government of India & Ministry of Ayush Dual Titles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'भारत सरकार',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Text(
                            '  •  ',
                            style: TextStyle(color: Color(0xFFFFB74D)),
                          ),
                          Text(
                            'आयुष मंत्रालय',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFFB74D),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'MINISTRY OF AYUSH  •  GOVERNMENT OF INDIA',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Platform Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'iKwath',
                            style: GoogleFonts.inter(
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1.5,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'AFI 2026',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'TEAM SAMADHANA  •  SMART INDIA HACKATHON',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF93C5FD),
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Tagline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'स्मार्ट यवाकूट क्वाथ निर्माण प्रणाली\nAFI/API-standardized Decoction Platform • Automated 1/4th Reduction',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Tricolour Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 5,
                            color: Colors.white.withValues(alpha: 0.15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: _progressAnim.value,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.tricolorSaffron,
                                        Color(0xFFFFB74D),
                                        AppTheme.tricolorWhite,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer ───────────────────────────────────────────────
              const SizedBox(height: 50),
              FadeTransition(
                opacity: _fadeAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bluetooth_connected_rounded,
                        size: 15, color: Color(0xFF60A5FA)),
                    const SizedBox(width: 8),
                    Text(
                      'ESP32 Direct BLE Control • Standalone Offline Architecture',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashAshokaPainter extends CustomPainter {
  const _SplashAshokaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB74D)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFFFFB74D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final w = size.width;
    final h = size.height;

    // Pedestal
    final pedestal = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.78, w * 0.7, h * 0.12),
      const Radius.circular(3),
    );
    canvas.drawRRect(pedestal, paint);

    // Chakra in center
    canvas.drawCircle(Offset(w * 0.5, h * 0.84), w * 0.11, strokePaint);

    // Lions
    final centerLion = Path()
      ..moveTo(w * 0.38, h * 0.76)
      ..lineTo(w * 0.38, h * 0.36)
      ..cubicTo(w * 0.34, h * 0.25, w * 0.44, h * 0.14, w * 0.50, h * 0.12)
      ..cubicTo(w * 0.56, h * 0.14, w * 0.66, h * 0.25, w * 0.62, h * 0.36)
      ..lineTo(w * 0.62, h * 0.76)
      ..close();
    canvas.drawPath(centerLion, paint);

    final leftLion = Path()
      ..moveTo(w * 0.36, h * 0.76)
      ..lineTo(w * 0.24, h * 0.74)
      ..cubicTo(w * 0.18, h * 0.54, w * 0.18, h * 0.34, w * 0.26, h * 0.22)
      ..cubicTo(w * 0.33, h * 0.23, w * 0.36, h * 0.33, w * 0.36, h * 0.48)
      ..close();
    canvas.drawPath(leftLion, paint);

    final rightLion = Path()
      ..moveTo(w * 0.64, h * 0.76)
      ..lineTo(w * 0.76, h * 0.74)
      ..cubicTo(w * 0.82, h * 0.54, w * 0.82, h * 0.34, w * 0.74, h * 0.22)
      ..cubicTo(w * 0.67, h * 0.23, w * 0.64, h * 0.33, w * 0.64, h * 0.48)
      ..close();
    canvas.drawPath(rightLion, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
