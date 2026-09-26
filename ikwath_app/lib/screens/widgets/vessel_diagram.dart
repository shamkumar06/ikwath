import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/telemetry.dart';
import '../../theme/app_theme.dart';

/// Physical Prototype Architecture - Real-Time Cutaway Diagram
/// Replicates the angular.js prototype vessel visualization in Flutter
class VesselDiagram extends StatefulWidget {
  final Telemetry telemetry;
  final bool isDark;

  const VesselDiagram({
    super.key,
    required this.telemetry,
    required this.isDark,
  });

  @override
  State<VesselDiagram> createState() => _VesselDiagramState();
}

class _VesselDiagramState extends State<VesselDiagram>
    with TickerProviderStateMixin {
  late AnimationController _waveCtrl;
  late AnimationController _stirrerCtrl;
  late AnimationController _bubbleCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _stirrerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _stirrerCtrl.dispose();
    _bubbleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.telemetry;
    final isDark = widget.isDark;
    final isHeating = t.ssrDutyCycle > 0;
    final fillRatio = (t.massG / t.initMassG).clamp(0.2, 0.85);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top accent strip ──────────────────────────────────────────────
          Container(
            height: 4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.amber, AppTheme.ayushBlue],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Physical Prototype Architecture',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Real-Time Cutaway • Actuators & Sensor Feedback',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: isDark
                                ? AppTheme.textMutedDark
                                : AppTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Active stage badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isHeating
                            ? AppTheme.green.withValues(alpha: 0.12)
                            : AppTheme.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isHeating
                              ? AppTheme.green.withValues(alpha: 0.35)
                              : AppTheme.amber.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        isHeating ? 'Active Reflux & Agitation' : 'Standby',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isHeating ? AppTheme.green : AppTheme.amber,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Main Diagram Area ─────────────────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return SizedBox(
                      height: 320,
                      child: AnimatedBuilder(
                        animation: Listenable.merge(
                            [_waveCtrl, _stirrerCtrl, _bubbleCtrl]),
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _VesselPainter(
                              fillRatio: fillRatio,
                              wavePhase: _waveCtrl.value,
                              stirrerAngle: _stirrerCtrl.value * 2 * math.pi,
                              bubblePhase: _bubbleCtrl.value,
                              isHeating: isHeating,
                              isDark: isDark,
                              tempC: t.tempC,
                              ssrDuty: t.ssrDutyCycle,
                              targetFillRatio:
                                  (t.targetMassG / t.initMassG).clamp(0.1, 0.5),
                            ),
                            size: Size(width, 320),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // ── Bottom Legend Row ──────────────────────────────────────
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _LegendDot(
                        color: const Color(0xFFBDBDBD), label: 'Demister Mesh'),
                    _LegendDot(color: AppTheme.red, label: 'PT100 RTD'),
                    _LegendDot(color: AppTheme.amber, label: 'SSR Heater (230V)'),
                    _LegendDot(
                        color: AppTheme.ayushBlue, label: 'HX711 Load Cell'),
                    _LegendDot(color: AppTheme.green, label: 'Magnetic Stirrer'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
          ),
        ),
      ],
    );
  }
}

class _VesselPainter extends CustomPainter {
  final double fillRatio;
  final double wavePhase;
  final double stirrerAngle;
  final double bubblePhase;
  final bool isHeating;
  final bool isDark;
  final double tempC;
  final int ssrDuty;
  final double targetFillRatio;

  _VesselPainter({
    required this.fillRatio,
    required this.wavePhase,
    required this.stirrerAngle,
    required this.bubblePhase,
    required this.isHeating,
    required this.isDark,
    required this.tempC,
    required this.ssrDuty,
    required this.targetFillRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Vessel geometry
    final vesselLeft = w * 0.22;
    final vesselRight = w * 0.78;
    final vesselTop = h * 0.06;
    final vesselBottom = h * 0.78;
    final vesselWidth = vesselRight - vesselLeft;
    final vesselHeight = vesselBottom - vesselTop;
    final innerLeft = vesselLeft + 14;
    final innerRight = vesselRight - 14;
    final innerTop = vesselTop + 10;
    final innerBottom = vesselBottom - 14;

    // ── 1. Draw SSR Heater glow below vessel ──────────────────────────────
    _drawHeaterGlow(canvas, size, vesselLeft, vesselRight, vesselBottom);

    // ── 2. Draw vessel outer shell ────────────────────────────────────────
    _drawVesselShell(canvas, size, vesselLeft, vesselRight, vesselTop,
        vesselBottom, vesselWidth, vesselHeight);

    // ── 3. Draw liquid fill with animated waves ───────────────────────────
    final liquidTop = innerBottom - (innerBottom - innerTop) * fillRatio;
    _drawLiquid(canvas, innerLeft, innerRight, innerTop, innerBottom,
        liquidTop, vesselWidth);

    // ── 4. Draw 1/4th target line ─────────────────────────────────────────
    final targetY = innerBottom - (innerBottom - innerTop) * targetFillRatio;
    _drawTargetLine(canvas, innerLeft, innerRight, targetY);

    // ── 5. Draw bubbles ───────────────────────────────────────────────────
    if (isHeating) {
      _drawBubbles(canvas, innerLeft, innerRight, liquidTop, innerBottom);
    }

    // ── 6. Draw PT100 RTD sensor ──────────────────────────────────────────
    _drawRTDSensor(canvas, vesselLeft, innerLeft, vesselTop, innerBottom,
        liquidTop);

    // ── 7. Draw magnetic stirrer ──────────────────────────────────────────
    final stirrerY = innerBottom - 20;
    final stirrerCX = (innerLeft + innerRight) / 2;
    _drawStirrer(canvas, stirrerCX, stirrerY);

    // ── 8. Draw demister mesh (lid) ───────────────────────────────────────
    _drawDemister(canvas, vesselLeft, vesselRight, vesselTop);

    // ── 9. Draw heater bar below vessel ───────────────────────────────────
    _drawHeaterBar(canvas, vesselLeft, vesselRight, vesselBottom, w, h);

    // ── 10. Draw load cell bar below heater ───────────────────────────────
    _drawLoadCellBar(canvas, vesselLeft, vesselRight, vesselBottom, h);

    // ── 11. Draw ESP32/PCB board ───────────────────────────────────────────
    _drawPCBBoard(canvas, w, h, vesselBottom);

    // ── 12. Draw annotation labels ────────────────────────────────────────
    _drawAnnotations(canvas, size, vesselLeft, vesselRight, vesselTop,
        vesselBottom, liquidTop, targetY, stirrerY, stirrerCX);
  }

  void _drawHeaterGlow(Canvas canvas, Size size, double left, double right,
      double vesselBottom) {
    if (ssrDuty == 0) return;
    final intensity = ssrDuty / 100.0;
    final glowPaint = Paint()
      ..color = AppTheme.amber.withValues(alpha: 0.15 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30 * intensity);
    canvas.drawRect(
      Rect.fromLTRB(left - 20, vesselBottom - 10, right + 20,
          vesselBottom + 60),
      glowPaint,
    );
  }

  void _drawVesselShell(Canvas canvas, Size size, double left, double right,
      double top, double bottom, double vw, double vh) {
    final wallPaint = Paint()
      ..color = isDark ? const Color(0xFF2D3A5E) : const Color(0xFFCFD8DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Main vessel body (rounded rect)
    final vesselPath = Path()
      ..moveTo(left, top + 12)
      ..lineTo(left, bottom - 6)
      ..quadraticBezierTo(left, bottom, left + 6, bottom)
      ..lineTo(right - 6, bottom)
      ..quadraticBezierTo(right, bottom, right, bottom - 6)
      ..lineTo(right, top + 12);

    canvas.drawPath(vesselPath, wallPaint);

    // Lid (flat top plate)
    final lidPaint = Paint()
      ..color = isDark ? const Color(0xFF3D4F7E) : const Color(0xFFB0BEC5)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left - 18, top - 4, right + 18, top + 14),
        const Radius.circular(6),
      ),
      lidPaint,
    );

    // Camera/sensor port on lid
    final portPaint = Paint()
      ..color = isDark ? const Color(0xFF1A2540) : const Color(0xFF78909C);
    canvas.drawCircle(Offset((left + right) / 2, top + 5), 6, portPaint);
    canvas.drawCircle(Offset((left + right) / 2, top + 5), 3,
        Paint()..color = const Color(0xFF263238));
  }

  void _drawLiquid(Canvas canvas, double left, double right, double top,
      double bottom, double liquidTop, double vesselWidth) {
    final path = Path();
    path.moveTo(left, bottom);
    path.lineTo(left, liquidTop);

    // Animated wave surface
    final waveAmplitude = isHeating ? 6.0 : 3.0; // Smaller wave if not heating but stirrer active
    for (double x = left; x <= right; x++) {
      final progress = (x - left) / (right - left);
      final wave1 = waveAmplitude * math.sin(progress * 2 * math.pi + wavePhase * 2 * math.pi);
      final wave2 = (waveAmplitude / 2) * math.cos(progress * 3 * math.pi - wavePhase * 4 * math.pi);
      path.lineTo(x, liquidTop + wave1 + wave2);
    }

    path.lineTo(right, bottom);
    path.close();

    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD4850A).withValues(alpha: 0.9),
          const Color(0xFF8B5E0A),
        ],
      ).createShader(Rect.fromLTRB(left, liquidTop, right, bottom));
    canvas.drawPath(path, liquidPaint);
  }

  void _drawTargetLine(
      Canvas canvas, double left, double right, double targetY) {
    final paint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dashWidth = 8.0;
    final dashSpace = 5.0;
    double x = left;
    while (x < right) {
      canvas.drawLine(
          Offset(x, targetY), Offset(x + dashWidth, targetY), paint);
      x += dashWidth + dashSpace;
    }

    // Label
    final tp = TextPainter(
      text: TextSpan(
        text: '1/4 Target (100g)',
        style: GoogleFonts.inter(
          fontSize: 9,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(right + 6, targetY - 6));
  }

  void _drawBubbles(Canvas canvas, double left, double right, double liquidTop,
      double bottom) {
    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    final rng = math.Random(42);
    for (int i = 0; i < 8; i++) {
      final bx = left + rng.nextDouble() * (right - left);
      final moveUp = (bubblePhase + i * 0.125) % 1.0;
      final by = bottom - moveUp * (bottom - liquidTop);
      if (by > liquidTop) {
        final r = 2.0 + rng.nextDouble() * 4.0;
        canvas.drawCircle(Offset(bx, by), r, bubblePaint);
      }
    }
  }

  void _drawRTDSensor(Canvas canvas, double vesselLeft, double innerLeft,
      double vesselTop, double innerBottom, double liquidTop) {
    final sensorX = innerLeft + 28;
    final probePaint = Paint()
      ..color = AppTheme.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(sensorX, vesselTop + 14),
      Offset(sensorX, innerBottom - 30),
      probePaint,
    );

    // Tip dot
    canvas.drawCircle(
      Offset(sensorX, innerBottom - 30),
      4,
      Paint()..color = AppTheme.red,
    );

    // Wire to left wall
    final wirePaint = Paint()
      ..color = AppTheme.red.withValues(alpha: 0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(sensorX, vesselTop + 14),
      Offset(vesselLeft - 20, vesselTop + 14),
      wirePaint,
    );

    // Label
    final tp = TextPainter(
      text: TextSpan(
        text: 'RTD PT100\nSensor',
        style: GoogleFonts.inter(
          fontSize: 8.5,
          color: AppTheme.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(vesselLeft - 80, vesselTop + 8));
  }

  void _drawStirrer(Canvas canvas, double cx, double cy) {
    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(stirrerAngle);

    // Draw stirrer bar
    final barPaint = Paint()
      ..color = AppTheme.green
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-28, -5, 56, 10),
        const Radius.circular(5),
      ),
      barPaint,
    );
    // Center dot
    canvas.drawCircle(Offset.zero, 5, basePaint);
    canvas.restore();

    // Swirl lines to show rotation
    if (isHeating) {
      final swirlPaint = Paint()
        ..color = AppTheme.green.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      for (int i = 0; i < 3; i++) {
        final r = 20.0 + i * 12;
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: r),
          stirrerAngle + i * 0.8,
          1.2,
          false,
          swirlPaint,
        );
      }
    }
  }

  void _drawDemister(
      Canvas canvas, double left, double right, double top) {
    final meshPaint = Paint()
      ..color = const Color(0xFFBDBDBD).withValues(alpha: 0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Grid lines
    for (double x = left; x <= right; x += 10) {
      canvas.drawLine(Offset(x, top + 2), Offset(x, top + 12), meshPaint);
    }
    canvas.drawLine(Offset(left, top + 7), Offset(right, top + 7), meshPaint);
  }

  void _drawHeaterBar(Canvas canvas, double left, double right,
      double vesselBottom, double w, double h) {
    final heaterTop = vesselBottom + 14;
    final heaterBottom = heaterTop + 12;
    final intensity = ssrDuty / 100.0;

    // Background track
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2D3A5E) : const Color(0xFFECEFF1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, heaterTop, right, heaterBottom),
        const Radius.circular(6),
      ),
      bgPaint,
    );

    // Heating fill
    if (intensity > 0) {
      final heatColor = Color.lerp(
        const Color(0xFFF59E0B),
        const Color(0xFFEF4444),
        intensity,
      )!;
      final heatPaint = Paint()
        ..color = heatColor
        ..maskFilter = intensity > 0.5
            ? MaskFilter.blur(BlurStyle.normal, 6 * intensity)
            : null;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, heaterTop, right, heaterBottom),
          const Radius.circular(6),
        ),
        heatPaint,
      );
    }

    // Label
    final tp = TextPainter(
      text: TextSpan(
        text: '230V Heater (SSR)',
        style: GoogleFonts.inter(
          fontSize: 8.5,
          color: AppTheme.amber,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(left, heaterTop - 12));
  }

  void _drawLoadCellBar(
      Canvas canvas, double left, double right, double vesselBottom, double h) {
    final lcTop = vesselBottom + 30;
    final lcBottom = lcTop + 8;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E2F5E) : const Color(0xFFBBDEFB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, lcTop, right, lcBottom),
        const Radius.circular(4),
      ),
      bgPaint,
    );

    // Sensor dot
    canvas.drawCircle(
      Offset((left + right) / 2, (lcTop + lcBottom) / 2),
      4,
      Paint()..color = AppTheme.ayushBlue,
    );

    // Label
    final tp = TextPainter(
      text: TextSpan(
        text: 'HX711 Load Cell',
        style: GoogleFonts.inter(
          fontSize: 8.5,
          color: AppTheme.ayushBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(left, lcTop - 12));
  }

  void _drawPCBBoard(Canvas canvas, double w, double h, double vesselBottom) {
    final boardTop = vesselBottom + 46;
    final boardBottom = boardTop + 36;
    final boardLeft = w * 0.10;
    final boardRight = w * 0.90;

    // PCB background
    final pcbPaint = Paint()
      ..color = isDark ? const Color(0xFF0D1B36) : const Color(0xFF1B2A4A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(boardLeft, boardTop, boardRight, boardBottom),
        const Radius.circular(6),
      ),
      pcbPaint,
    );

    // PCB components
    _drawPCBComponent(canvas, boardLeft + 20, boardTop + 8, 52, 20,
        isDark ? AppTheme.primary : const Color(0xFF1565C0), 'iKwath\nESP32');
    _drawPCBComponent(canvas, boardLeft + 84, boardTop + 8, 36, 20,
        const Color(0xFF37474F), 'ESP32');
    _drawPCBComponent(canvas, boardLeft + 132, boardTop + 8, 36, 20,
        const Color(0xFF33691E), '5V/12V');
    _drawPCBComponent(canvas, boardLeft + 180, boardTop + 8, 36, 20,
        const Color(0xFFB71C1C), 'SSR');
  }

  void _drawPCBComponent(Canvas canvas, double x, double y, double w, double h,
      Color color, String label) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(3),
      ),
      Paint()..color = color,
    );

    final lines = label.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: lines[i],
          style: GoogleFonts.inter(
            fontSize: 7,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: w);
      tp.paint(canvas, Offset(x + 2, y + 2 + i * 9.0));
    }
  }

  void _drawAnnotations(
    Canvas canvas,
    Size size,
    double left,
    double right,
    double top,
    double bottom,
    double liquidTop,
    double targetY,
    double stirrerY,
    double stirrerCX,
  ) {
    // Mag Stirrer label (right side)
    final stirrerTp = TextPainter(
      text: TextSpan(
        text: 'Mag Stirrer (450 RPM)',
        style: GoogleFonts.inter(
          fontSize: 8.5,
          color: AppTheme.green,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    stirrerTp.paint(canvas, Offset(right + 6, stirrerY - 6));

    // Annotation line from stirrer to label
    canvas.drawLine(
      Offset(stirrerCX + 28, stirrerY),
      Offset(right + 4, stirrerY),
      Paint()
        ..color = AppTheme.green.withValues(alpha: 0.4)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _VesselPainter old) {
    return old.fillRatio != fillRatio ||
        old.wavePhase != wavePhase ||
        old.stirrerAngle != stirrerAngle ||
        old.bubblePhase != bubblePhase ||
        old.isHeating != isHeating ||
        old.ssrDuty != ssrDuty;
  }
}
