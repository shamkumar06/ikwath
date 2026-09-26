import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../services/locale_provider.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_theme.dart';

class StepperView extends StatelessWidget {
  const StepperView({super.key});

  List<_StepInfo> _buildSteps(LocaleProvider lp) {
    return [
      _StepInfo(
        icon: Icons.grass_rounded,
        title: lp.t(S.scanBotanical),
        subtitle: 'Herbal Formulation (यवाकूट चूर्ण)',
        detail: 'Optical scanner reads the standardized herbal pod and auto-loads Ayurvedic extraction parameters: water proportion, temp 85–90°C, and target 1/4th mass reduction endpoint.',
        param1: 'Pod: AFI Compliant',
        param2: 'Mesh: #10/40 Coarse',
      ),
      _StepInfo(
        icon: Icons.water_drop_rounded,
        title: lp.t(S.addWater),
        subtitle: 'Sensors & Fluid Dynamics',
        detail: 'ESP32 tares the load cell to zero, validates temperature probe, arms boilover sensor, activates food-grade magnetic stirrer, and starts adding water.',
        param1: 'Liquid: Tared Zero',
        param2: 'Stirrer: Armed & Calibrated',
      ),
      _StepInfo(
        icon: Icons.local_fire_department_rounded,
        title: lp.t(S.heatDecoction),
        subtitle: 'PID Thermal Control (85–90°C)',
        detail: 'Induction heater dynamically adjusts power to maintain decoction temperature strictly within the 85–90°C AFI band for optimal active principle extraction.',
        param1: 'Setpoint: 88.0°C',
        param2: 'Tolerance: ±1.5°C Locked',
      ),
      _StepInfo(
        icon: Icons.bubble_chart_rounded,
        title: lp.t(S.massReductionStep),
        subtitle: 'Continuous 1/4th Evaporation',
        detail: 'Load cell continuously streams decoction mass. Process stops automatically the moment mass reaches exactly 25% of initial weight (Chaturthamsha Avashesha).',
        param1: 'Endpoint: 1/4th Target',
        param2: 'Rate: ~18 g/min',
      ),
      _StepInfo(
        icon: Icons.verified_rounded,
        title: lp.t(S.kwathReady),
        subtitle: 'Auto-Stop & Quality Verification',
        detail: 'Machine auto-stops at the 1/4th endpoint. Optical sensor confirms extractive concentration yield. Ready for serving or dispensing.',
        param1: 'Turbidity: Optimal Yield',
        param2: 'AFI: Gold Standard',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final lp = context.watch<LocaleProvider>();
    final activeStep = (ctrl.stageIndex - 1).clamp(0, 4);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final steps = _buildSteps(lp);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lp.t(S.stepperTitle),
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lp.t(S.stepperSubtitle),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Status pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Text(
                  'चरण ${(activeStep + 1)} of 5 • ${steps[activeStep].title}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Horizontal Step Indicator ─────────────────────────────────
          _HorizStepper(activeStep: activeStep),

          const SizedBox(height: 22),

          // ── Context Banner ────────────────────────────────────────────
          _ContextBanner(
            step: steps[activeStep],
            ctrl: ctrl,
            activeStep: activeStep,
          ),

          const SizedBox(height: 22),

          // ── Step Cards (Vertical Detail) ──────────────────────────────
          ...List.generate(steps.length, (i) {
            final isActive = i == activeStep;
            final isDone = i < activeStep;
            return _StepCard(
              step: steps[i],
              index: i,
              isActive: isActive,
              isDone: isDone,
            );
          }),
        ],
      ),
    );
  }
}

class _HorizStepper extends StatelessWidget {
  final int activeStep;
  const _HorizStepper({required this.activeStep});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Row(
      children: List.generate(5, (i) {
        final isActive = i == activeStep;
        final isDone = i < activeStep;

        return Expanded(
          child: Row(
            children: [
              // Step bubble
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.green
                            : isActive
                                ? AppTheme.primary
                                : (isDark ? AppTheme.cardDark : Colors.white),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone
                              ? AppTheme.green
                              : isActive
                                  ? AppTheme.primary
                                  : borderColor,
                          width: 2,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 22)
                          : Text(
                              '${i + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isActive
                                    ? Colors.white
                                    : (isDark ? Colors.white54 : const Color(0xFF64748B)),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Connector Line
              if (i < 4)
                Expanded(
                  child: Container(
                    height: 3,
                    color: i < activeStep
                        ? AppTheme.green
                        : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _ContextBanner extends StatelessWidget {
  final _StepInfo step;
  final IKwathController ctrl;
  final int activeStep;

  const _ContextBanner({
    required this.step,
    required this.ctrl,
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF142042) : AppTheme.ayushBlueLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.ayushBlueBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.ayushBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.ayushBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'चरण ${(activeStep + 1)} प्रचालन (Stage ${activeStep + 1} Operation)',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ayushBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.detail,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final _StepInfo step;
  final int index;
  final bool isActive;
  final bool isDone;

  const _StepCard({
    required this.step,
    required this.index,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive || isDone ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppTheme.primary : borderColor,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.green.withValues(alpha: 0.15)
                      : isActive
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  step.icon,
                  color: isDone
                      ? AppTheme.green
                      : isActive
                          ? AppTheme.primary
                          : mutedColor,
                ),
              ),
              const SizedBox(width: 16),
              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Right Parameters
              if (isActive || isDone)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _MiniParam(text: step.param1, color: AppTheme.ayushBlue),
                    const SizedBox(height: 4),
                    _MiniParam(text: step.param2, color: AppTheme.amber),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniParam extends StatelessWidget {
  final String text;
  final Color color;

  const _MiniParam({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StepInfo {
  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final String param1;
  final String param2;

  const _StepInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.param1,
    required this.param2,
  });
}
