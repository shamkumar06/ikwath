import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';

class BlePill extends StatelessWidget {
  final bool connected;
  final VoidCallback onTap;

  const BlePill({super.key, required this.connected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppTheme.green : AppTheme.red;
    final bg = connected ? AppTheme.greenBg : AppTheme.redBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulseDot(color: color),
            const SizedBox(width: 6),
            Text(
              connected ? 'ESP32 BLE' : 'Offline',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _a = Tween<double>(begin: 0.3, end: 1).animate(_c);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

class StateBadge extends StatelessWidget {
  final MachineStage stage;
  const StateBadge({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (stage) {
      case MachineStage.idle:
        bg = const Color(0xFFF1F5F9);
        fg = AppTheme.textMutedLight;
        label = 'निष्क्रिय • IDLE';
      case MachineStage.qrScan:
        bg = AppTheme.ayushBlueLight;
        fg = AppTheme.ayushBlue;
        label = 'क्यूआर स्कैन • QR SCAN';
      case MachineStage.initialize:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        label = 'प्रारंभन • INITIALIZING';
      case MachineStage.pidHeat:
        bg = AppTheme.primaryLight;
        fg = AppTheme.primaryDark;
        label = 'क्वथन • PID HEATING';
      case MachineStage.massMonitor:
        bg = const Color(0xFFEFF6FF);
        fg = AppTheme.ayushBlue;
        label = '1/4 अपचयन • REDUCING';
      case MachineStage.complete:
        bg = AppTheme.greenBg;
        fg = AppTheme.green;
        label = 'सिद्ध क्वाथ • READY ✓';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
