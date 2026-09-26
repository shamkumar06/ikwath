import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ikwath_controller.dart';
import '../theme/app_theme.dart';
import 'views/telemetry_view.dart';
import 'views/stepper_view.dart';
import 'views/chart_view.dart';
import 'views/logs_view.dart';
import 'views/formulation_view.dart';
import 'widgets/ayush_header.dart';
import 'widgets/alerts_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const DashboardScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final isDark = widget.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: Column(
        children: [
          // ── 1. Official Ministry of Ayush Portal Header & Sub-Nav ─────
          AyushHeader(
            selectedIndex: _selectedIndex,
            onTabSelected: (i) => setState(() => _selectedIndex = i),
            ctrl: ctrl,
            onToggleTheme: widget.onToggleTheme,
            isDark: isDark,
            onAlerts: () => _openAlerts(context),
            onSettings: () => _openSettings(context),
          ),

          // ── 2. Ministry of Ayush Status & Compliance Banner Strip ──────
          _AyushHeroStatusStrip(ctrl: ctrl, isDark: isDark),

          // ── 3. Main Dynamic View Canvas ───────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildView(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildView(int idx) {
    switch (idx) {
      case 0:
        return const TelemetryView(key: ValueKey('telemetry'));
      case 1:
        return const StepperView(key: ValueKey('stepper'));
      case 2:
        return const ChartView(key: ValueKey('chart'));
      case 3:
        return const FormulationView(key: ValueKey('formulation'));
      case 4:
        return const LogsView(key: ValueKey('logs'));
      default:
        return const TelemetryView(key: ValueKey('telemetry'));
    }
  }

  void _openAlerts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<IKwathController>(),
        child: const AlertsSheet(),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<IKwathController>(),
        child: const SettingsSheet(),
      ),
    );
  }
}

// ── Ministry of Ayush Status Banner (Inspired by ayush.gov.in Hero) ───────────
class _AyushHeroStatusStrip extends StatelessWidget {
  final IKwathController ctrl;
  final bool isDark;

  const _AyushHeroStatusStrip({
    required this.ctrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = ctrl.telemetry;
    final f = ctrl.formulation;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1733) : const Color(0xFFFFF7ED),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E3163) : const Color(0xFFFFEDD5),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 750;

          if (isCompact) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.verified_rounded, size: 16, color: AppTheme.primary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${f.name} (${f.sanskritName}) • ${t.tempC.toStringAsFixed(1)}°C • ${t.percentToGo}% to endpoint',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF9A3412),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              // Ministry Mandate Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_florist_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'AFI मानक क्वाथ • AYUSH PHARMACOPOEIA',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Active Formulation & Sanskrit Name
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'सक्रिय योग (Active Formulation): ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppTheme.textMutedDark : const Color(0xFF78350F),
                      ),
                    ),
                    Text(
                      '${f.name} ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF431407),
                      ),
                    ),
                    Text(
                      '(${f.sanskritName})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Telemetry Quick Stats in Header
              _MiniBadge(
                label: 'PID तापमान',
                val: '${t.tempC.toStringAsFixed(1)}°C',
                color: t.isPidLocked ? AppTheme.green : AppTheme.amber,
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: 'अवशेष द्रव्यमान',
                val: '${t.massG.toStringAsFixed(0)}g / ${t.targetMassG.toStringAsFixed(0)}g',
                color: AppTheme.ayushBlue,
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: '1/4th अपचयन',
                val: '${(t.reductionProgress * 100).toStringAsFixed(0)}%',
                color: AppTheme.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final String val;
  final Color color;

  const _MiniBadge({required this.label, required this.val, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            val,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
