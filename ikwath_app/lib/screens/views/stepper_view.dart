import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';

class StepperView extends StatelessWidget {
  const StepperView({super.key});

  static const _steps = [
    _StepInfo(
      icon: Icons.grass_rounded,
      title: 'Scan Botanical Profile',
      subtitle: 'Herbal Formulation (यवाकूट चूर्ण Yavakūṭa Cūrṇa)',
      detail:
          'Optical scanner reads the standardized herbal pod and auto-loads Ayurvedic extraction parameters: water proportion, temp 85–90°C, and target 1/4th mass reduction endpoint.',
      param1: 'Pod: AFI Compliant',
      param2: 'Mesh: #10/40 Coarse',
    ),
    _StepInfo(
      icon: Icons.water_drop_rounded,
      title: 'Add Water & Initialize',
      subtitle: 'Sensors & Fluid Dynamics (द्रव्यमान शून्यीकरण)',
      detail:
          'ESP32 tares the load cell to zero, validates temperature probe, arms boilover sensor, activates food-grade magnetic stirrer, and starts adding water.',
      param1: 'Liquid: Tared Zero',
      param2: 'Stirrer: Armed & Calibrated',
    ),
    _StepInfo(
      icon: Icons.local_fire_department_rounded,
      title: 'Heat & Decoction',
      subtitle: 'PID Thermal Control (85–90°C क्वथन)',
      detail:
          'Induction heater dynamically adjusts power to maintain decoction temperature strictly within the 85–90°C AFI band for optimal active principle extraction.',
      param1: 'Setpoint: 88.0°C',
      param2: 'Tolerance: ±1.5°C Locked',
    ),
    _StepInfo(
      icon: Icons.bubble_chart_rounded,
      title: 'Mass Reduction',
      subtitle: 'Continuous 1/4th Evaporation (चतुर्थांश अपचयन)',
      detail:
          'Load cell continuously streams decoction mass. Process stops automatically the moment mass reaches exactly 25% of initial weight (Chaturthamsha Avashesha).',
      param1: 'Endpoint: 1/4th Target',
      param2: 'Rate: ~18 g/min',
    ),
    _StepInfo(
      icon: Icons.verified_rounded,
      title: 'Kwath Ready!',
      subtitle: 'Auto-Stop & Quality Verification (सिद्ध क्वाथ)',
      detail:
          'Machine auto-stops at the 1/4th endpoint. Optical sensor confirms extractive concentration yield. Ready for serving or dispensing.',
      param1: 'Turbidity: Optimal Yield',
      param2: 'AFI: Gold Standard',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final activeStep = (ctrl.stageIndex - 1).clamp(0, 4);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      'स्वायत्त क्वाथ निर्माण चक्र • Autonomous Extraction State Machine',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '5-Stage Closed-Loop Sequence • AFI/API Pharmacopoeia Standard Compliance',
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
                  'चरण ${(activeStep + 1)} of 5 • ${_steps[activeStep].title}',
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
            step: _steps[activeStep],
            ctrl: ctrl,
            activeStep: activeStep,
          ),

          const SizedBox(height: 22),

          // ── Step Cards (Vertical Detail) ──────────────────────────────
          ...List.generate(_steps.length, (i) {
            final isActive = i == activeStep;
            final isDone = i < activeStep;
            return _StepCard(
              step: _steps[i],
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
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isActive
                                    ? Colors.white
                                    : (isDark
                                        ? AppTheme.textMutedDark
                                        : AppTheme.textMutedLight),
                              ),
                            ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      StepperView._steps[i].title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? AppTheme.primary
                            : isDone
                                ? AppTheme.green
                                : (isDark
                                    ? AppTheme.textMutedDark
                                    : AppTheme.textMutedLight),
                      ),
                    ),
                  ],
                ),
              ),
              // Connector line
              if (i < 4)
                Expanded(
                  child: Container(
                    height: 2.5,
                    margin: const EdgeInsets.only(bottom: 24),
                    color: i < activeStep ? AppTheme.primary : borderColor,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF142042) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppTheme.primary, width: 4.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step.detail,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ParamChip(step.param1),
                    const SizedBox(width: 8),
                    _ParamChip(step.param2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              if (activeStep == 2 || activeStep == 3)
                FilledButton(
                  onPressed: ctrl.togglePause,
                  style: FilledButton.styleFrom(
                    backgroundColor: ctrl.isPaused ? AppTheme.green : AppTheme.primary,
                  ),
                  child: Text(
                    ctrl.isPaused ? 'Resume' : 'Pause',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              if (activeStep < 2)
                FilledButton(
                  onPressed: ctrl.startCycle,
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: const Text('Start Extraction'),
                ),
              if (activeStep == 4)
                FilledButton(
                  onPressed: ctrl.resetNewBatch,
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.green),
                  child: const Text('New Batch (नया बैच)'),
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Abort Kwatha Cycle?'),
                      content: const Text(
                        'This will stop the extraction cycle and return the ESP32 to IDLE state.',
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
                          child: const Text('Abort Cycle'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.red,
                  side: const BorderSide(color: AppTheme.red),
                ),
                child: const Text('Abort'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParamChip extends StatelessWidget {
  final String label;
  const _ParamChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryDark,
        ),
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDone
        ? AppTheme.green
        : isActive
            ? AppTheme.primary
            : (isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? const Color(0xFF1B192A) : const Color(0xFFFFF9F5))
            : cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? AppTheme.primary.withValues(alpha: 0.5)
              : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  step.subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: accent),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle_rounded,
                color: AppTheme.green, size: 20),
          if (isActive)
            const Icon(Icons.play_circle_filled_rounded,
                color: AppTheme.primary, size: 20),
        ],
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
