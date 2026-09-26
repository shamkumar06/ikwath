import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry.dart';
import '../widgets/vessel_diagram.dart';

class TelemetryView extends StatelessWidget {
  const TelemetryView({super.key});

  Color _tempColor(Telemetry t) {
    if (t.isPidLocked) return AppTheme.green;
    if (t.tempC > 95) return AppTheme.red;
    return AppTheme.amber;
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final t = ctrl.telemetry;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Ayush Decoction Hero Card (AFI 1/4th Reduction Target) ──
          _AyushVesselHeroCard(ctrl: ctrl, isDark: isDark),

          const SizedBox(height: 22),

          // ── 2. Physical Prototype Architecture Cutaway Diagram ─────────
          VesselDiagram(telemetry: t, isDark: isDark),

          const SizedBox(height: 22),

          // ── 3. Sensor Card Grid Section Header ────────────────────────
          const _SectionHeader(
            title: 'संवेदक ग्रिड • Real-Time Sensor Telemetry',
            subtitle: '6 calibrated sensors • ESP32 BLE Hardware Stream • 1 Hz sampling',
          ),
          const SizedBox(height: 16),

          // ── 3. Sensor Cards Grid (2x3 or 3x2) ──────────────────────────
          LayoutBuilder(
            builder: (_, constraints) {
              final crossCount = constraints.maxWidth > 950
                  ? 3
                  : constraints.maxWidth > 620
                      ? 2
                      : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.62,
                children: [
                  // 1. Decoction Temperature (PT100 RTD)
                  SensorCard(
                    title: 'तापमान • Decoction Temp',
                    subtitle: 'PT100 RTD + MAX31865 (Class A)',
                    value: t.tempC.toStringAsFixed(1),
                    unit: '°C',
                    rangeLabel: 'लक्ष्य PID: ${t.tempSetpointC.toStringAsFixed(1)}°C (Band: 85–90°C)',
                    tag: t.isPidLocked ? 'PID LOCKED' : 'PID REGULATING',
                    progress: (t.tempC / 100).clamp(0, 1),
                    statusColor: _tempColor(t),
                    icon: Icons.thermostat_rounded,
                    actionLabel: 'PID Autotune',
                    onAction: () {},
                    illustrationAsset: 'assets/images/sensor_temp.jpg',
                  ),

                  // 2. Mass / Reduction (HX711 Load Cell)
                  SensorCard(
                    title: 'द्रव्यमान • Mass Reduction',
                    subtitle: 'HX711 Load Cell (AFI 1/4th Endpoint)',
                    value: t.massG.toStringAsFixed(1),
                    unit: 'g',
                    rangeLabel:
                        'आरंभ: ${t.initMassG.toStringAsFixed(0)}g → लक्ष्य: ${t.targetMassG.toStringAsFixed(0)}g',
                    tag: '${t.percentToGo}% TO GO',
                    progress: t.reductionProgress,
                    statusColor: AppTheme.primary,
                    icon: Icons.scale_rounded,
                    actionLabel: 'Tare Zero (शून्य)',
                    onAction: () {},
                    extraLabel: 'वाष्पीकरण: ${t.evapRateGpm.toStringAsFixed(1)} g/m',
                    illustrationAsset: 'assets/images/sensor_mass.jpg',
                  ),

                  // 3. Magnetic Stirrer (Hall Effect)
                  SensorCard(
                    title: 'मंथक • Magnetic Stirrer',
                    subtitle: 'Hall Effect Driver (यवाकूट Agitation)',
                    value: '${t.stirrerRpm}',
                    unit: 'RPM',
                    rangeLabel: 'Uniform Active Decoction',
                    tag: 'सक्रिय • ACTIVE',
                    progress: (t.stirrerRpm / 600).clamp(0, 1),
                    statusColor: AppTheme.green,
                    icon: Icons.rotate_right_rounded,
                    actionLabel: 'Adjust Speed',
                    onAction: () {},
                    illustrationAsset: 'assets/images/sensor_stirrer.jpg',
                  ),

                  // 4. Optical Yield / Turbidity (IR Nephelometric)
                  SensorCard(
                    title: 'निष्कर्षण • Optical Turbidity',
                    subtitle: 'IR Nephelometric (Yield Index)',
                    value: t.turbidityNtu.toStringAsFixed(1),
                    unit: 'NTU',
                    rangeLabel: 'AFI मानक निष्कर्षण: > 60 NTU',
                    tag: t.turbidityNtu >= 60 ? 'इष्टतम • OPTIMAL' : 'EXTRACTING',
                    progress: (t.turbidityNtu / 100).clamp(0, 1),
                    statusColor: AppTheme.ayushBlue,
                    icon: Icons.opacity_rounded,
                    actionLabel: 'Yield Curve',
                    onAction: () {},
                    illustrationAsset: 'assets/images/sensor_turbidity.jpg',
                  ),

                  // 5. Anti-Boilover Meniscus Clearance
                  SensorCard(
                    title: 'क्वथन रक्षक • Boilover Meniscus',
                    subtitle: 'IR / Ultrasonic Headspace Sensor',
                    value: t.boiloverMm.toStringAsFixed(1),
                    unit: 'mm',
                    rangeLabel: 'न्यूनतम सुरक्षा अंतर: > 25 mm',
                    tag: t.isBoiloverSafe ? 'सुरक्षित • SAFE' : 'सचेत • ALERT',
                    progress: (t.boiloverMm / 60).clamp(0, 1),
                    statusColor: t.isBoiloverSafe ? AppTheme.green : AppTheme.red,
                    icon: Icons.waves_rounded,
                    actionLabel: 'Foam Damping',
                    onAction: () {},
                    illustrationAsset: 'assets/images/sensor_boilover.jpg',
                  ),

                  // 6. SSR Heater Power (Zero-Crossing PWM)
                  SensorCard(
                    title: 'ऊष्मक निर्गम • SSR Heater Output',
                    subtitle: 'Zero-Crossing PWM Power Control',
                    value: '${t.ssrDutyCycle}',
                    unit: '%',
                    rangeLabel: '${t.powerWatts}W of 750W Max Firing',
                    tag: t.ssrDutyCycle > 0 ? 'सक्रिय • FIRING' : 'IDLE',
                    progress: (t.ssrDutyCycle / 100).clamp(0, 1),
                    statusColor: AppTheme.primaryDark,
                    icon: Icons.bolt_rounded,
                    actionLabel: 'SSR Diagnostics',
                    onAction: () {},
                    extraLabel: '${t.powerWatts}W Firing',
                    illustrationAsset: 'assets/images/sensor_temp.jpg',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Ministry of Ayush Decoction Hero Card ────────────────────────────────────
class _AyushVesselHeroCard extends StatelessWidget {
  final IKwathController ctrl;
  final bool isDark;

  const _AyushVesselHeroCard({
    required this.ctrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = ctrl.telemetry;
    final f = ctrl.formulation;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top accent strip (Ayush Saffron to Ayush Blue gradient)
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Formulation Info & Stage Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.soup_kitchen_rounded,
                        color: AppTheme.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                f.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                f.sanskritName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'AFI Part I, Vol I • Pod Ratio: ${f.waterRatio}:1 • यवाकूट चूर्ण: ${f.powderG}g • प्रारम्भिक जल: ${f.initWaterMl}mL',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons: Pause/Resume
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: ctrl.isPaused ? AppTheme.green : AppTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: ctrl.togglePause,
                      icon: Icon(ctrl.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 18),
                      label: Text(ctrl.isPaused ? 'Resume' : 'Pause'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Middle: 1/4th Reduction Progress Bar & ETA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AFI 1/4th Mass Reduction (अपचयन प्रगति)',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                        Text(
                          '${(t.reductionProgress * 100).toStringAsFixed(1)}% पूर्ण • शेष: ${t.massG.toStringAsFixed(1)}g / लक्ष्य: ${t.targetMassG.toStringAsFixed(0)}g',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 12,
                        child: LinearProgressIndicator(
                          value: t.reductionProgress,
                          backgroundColor: isDark
                              ? const Color(0xFF1E2F5E)
                              : const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Bottom 4 Quick Stats Badges
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B142A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      _StatTile(
                        label: 'PID अवस्था',
                        val: t.isPidLocked ? 'PID Locked' : 'Regulating',
                        color: t.isPidLocked ? AppTheme.green : AppTheme.amber,
                        icon: Icons.lock_clock_rounded,
                      ),
                      _Divider(isDark: isDark),
                      _StatTile(
                        label: 'वाष्पीकरण दर',
                        val: '${t.evapRateGpm.toStringAsFixed(1)} g/min',
                        color: AppTheme.ayushBlue,
                        icon: Icons.speed_rounded,
                      ),
                      _Divider(isDark: isDark),
                      _StatTile(
                        label: 'अनुमानित समय (ETA)',
                        val: '${(t.etaSec / 60).floor()}m ${t.etaSec % 60}s',
                        color: AppTheme.primary,
                        icon: Icons.timer_outlined,
                      ),
                      _Divider(isDark: isDark),
                      _StatTile(
                        label: 'क्वथन सुरक्षा',
                        val: t.isBoiloverSafe ? 'Safe Meniscus' : 'Warning',
                        color: t.isBoiloverSafe ? AppTheme.green : AppTheme.red,
                        icon: Icons.shield_rounded,
                      ),
                    ],
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

class _StatTile extends StatelessWidget {
  final String label;
  final String val;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.val,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  val,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
    );
  }
}

// ── Reusable Sensor Card (Ayush Styled) ───────────────────────────────────────
class SensorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final String rangeLabel;
  final String tag;
  final double progress;
  final Color statusColor;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;
  final String? extraLabel;
  final String? illustrationAsset;

  const SensorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.rangeLabel,
    required this.tag,
    required this.progress,
    required this.statusColor,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    this.extraLabel,
    this.illustrationAsset,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final mutedColor = isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          children: [
            // ── Background illustration image (right-side fade) ──
            if (illustrationAsset != null)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 120,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      cs.surface,
                      cs.surface.withValues(alpha: 0.0),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstOut,
                  child: Image.asset(
                    illustrationAsset!,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.35),
                  ),
                ),
              ),

            // ── Foreground card content ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored left accent strip
                Container(width: 4.5, color: statusColor),
                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(icon, size: 17, color: statusColor),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    subtitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: mutedColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Tag pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.28),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: statusColor,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Value Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value,
                              style: GoogleFonts.inter(
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: mutedColor,
                              ),
                            ),
                            const Spacer(),
                            if (extraLabel != null)
                              Text(
                                extraLabel!,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                          ],
                        ),

                        // Range label
                        Text(
                          rangeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: mutedColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 4,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: statusColor.withValues(alpha: 0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: onAction,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              side: BorderSide(color: statusColor.withValues(alpha: 0.35)),
                              textStyle: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(actionLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
          ),
        ),
      ],
    );
  }
}
