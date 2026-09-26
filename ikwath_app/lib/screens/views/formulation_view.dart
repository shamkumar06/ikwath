import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/formulation.dart';

class FormulationView extends StatelessWidget {
  const FormulationView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Title & AFI Compliance ────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'आयुष क्वाथ संग्रह • AFI Standardized Pod Library',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${FormulationLibrary.all.length} Pharmacopoeia formulations • 1/4th mass reduction • Tap to load onto ESP32',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              // AFI Certification Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.greenBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTheme.greenBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 15, color: AppTheme.green),
                    const SizedBox(width: 6),
                    Text(
                      'AFI / CCRAS COMPLIANT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.green,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── Pod Cards Grid ───────────────────────────────────────────
          LayoutBuilder(
            builder: (_, constraints) {
              final crossCount = constraints.maxWidth > 850 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.7,
                ),
                itemCount: FormulationLibrary.all.length,
                itemBuilder: (_, i) {
                  final f = FormulationLibrary.all[i];
                  final isActive = ctrl.formulation.id == f.id;
                  return _FormulationCard(
                    formulation: f,
                    isActive: isActive,
                    onLoad: () => ctrl.loadFormulation(f),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FormulationCard extends StatelessWidget {
  final Formulation formulation;
  final bool isActive;
  final VoidCallback onLoad;

  const _FormulationCard({
    required this.formulation,
    required this.isActive,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isActive
        ? AppTheme.primary
        : (isDark ? AppTheme.borderDark : AppTheme.borderLight);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? const Color(0xFF1E1710) : const Color(0xFFFFF9F5))
            : cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppTheme.primary.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: isActive ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onLoad,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Icon, Name, AFI badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.spa_rounded,
                          color: AppTheme.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                formulation.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formulation.sanskritName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formulation.botanical,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.herbalBrown,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'सक्रिय • LOADED',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.greenBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.greenBorder),
                        ),
                        child: Text(
                          'AFI ✓',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.green,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  formulation.description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Parameters row
                Row(
                  children: [
                    _ParamTag(
                      icon: Icons.thermostat_rounded,
                      label: '${formulation.tempSetpointC.toStringAsFixed(0)}°C',
                    ),
                    const SizedBox(width: 6),
                    _ParamTag(
                      icon: Icons.scale_rounded,
                      label:
                          '${formulation.initMassG.toStringAsFixed(0)}g → ${formulation.targetMassG.toStringAsFixed(0)}g (1/4th)',
                    ),
                    const SizedBox(width: 6),
                    _ParamTag(
                      icon: Icons.rotate_right_rounded,
                      label: '${formulation.stirrerRpm} RPM',
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: isActive ? null : onLoad,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            isActive ? AppTheme.green : AppTheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        textStyle: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(isActive ? 'सक्रिय ✓' : 'Load Pod'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ParamTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ParamTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.borderDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
