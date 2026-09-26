import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/cycle_log.dart';

class LogsView extends StatelessWidget {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final logs = ctrl.cycleLogs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Stats Header ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'गुणवत्ता एवं ऑडिट लॉग • AFI Pharmacopoeia Audit Logs',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${logs.length} निष्पादित बैच • ${logs.where((l) => l.afiCompliant).length} AFI मानक प्रमाणित (Compliant)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AFI Compliance Certificate exported (BLE/CSV Download)'),
                      ),
                    ),
                    icon: const Icon(Icons.file_download_outlined, size: 16),
                    label: Text(
                      'Export CSV / Certificate',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Summary Row
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'कुल बैच (Total)',
                      value: '${logs.length}',
                      color: AppTheme.ayushBlue,
                      icon: Icons.list_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      label: 'AFI प्रमाणित (Passed)',
                      value: '${logs.where((l) => l.afiCompliant).length}',
                      color: AppTheme.green,
                      icon: Icons.verified_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      label: 'औसत गुणवत्ता (Avg Quality)',
                      value: logs.isEmpty
                          ? '—'
                          : '${(logs.map((l) => l.qualityScore).reduce((a, b) => a + b) / logs.length).toStringAsFixed(1)}%',
                      color: AppTheme.primary,
                      icon: Icons.star_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // ── Log List ──────────────────────────────────────────────────
        Expanded(
          child: logs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_rounded,
                          size: 56, color: AppTheme.textMutedLight),
                      const SizedBox(height: 12),
                      Text(
                        'No batches completed yet',
                        style: GoogleFonts.inter(color: AppTheme.textMutedLight),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _LogCard(log: logs[i]),
                ),
        ),
      ],
    );
  }
}

class _LogCard extends StatelessWidget {
  final CycleLog log;
  const _LogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final scoreColor = log.qualityScore >= 98
        ? AppTheme.green
        : log.qualityScore >= 92
            ? AppTheme.primary
            : AppTheme.red;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: log.afiCompliant ? AppTheme.green : AppTheme.red,
            width: 4.5,
          ),
          top: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.formulationName,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'बैच आईडी: ${log.batchId} • AFI API Spec',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? AppTheme.textMutedDark
                              : AppTheme.textMutedLight,
                        ).copyWith(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                // Quality Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    log.qualityScore >= 98
                        ? '★ AFI Gold ${log.qualityScore.toStringAsFixed(1)}%'
                        : log.qualityScore >= 92
                            ? '✓ AFI Pass ${log.qualityScore.toStringAsFixed(1)}%'
                            : '⚠ Review ${log.qualityScore.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 12),

            // Metrics row
            Row(
              children: [
                Expanded(
                  child: _LogMetric(
                    label: 'Init → Final',
                    value:
                        '${log.initMassG.toStringAsFixed(0)}g → ${log.finalMassG.toStringAsFixed(1)}g',
                    icon: Icons.scale_rounded,
                  ),
                ),
                Expanded(
                  child: _LogMetric(
                    label: 'Avg Temp',
                    value: '${log.avgTempC.toStringAsFixed(1)}°C',
                    icon: Icons.thermostat_rounded,
                  ),
                ),
                Expanded(
                  child: _LogMetric(
                    label: 'Yield NTU',
                    value: log.yieldNtu.toStringAsFixed(1),
                    icon: Icons.wb_sunny_rounded,
                  ),
                ),
                Expanded(
                  child: _LogMetric(
                    label: 'Duration',
                    value: log.durationLabel,
                    icon: Icons.timer_rounded,
                  ),
                ),
                Expanded(
                  child: _LogMetric(
                    label: 'Completed',
                    value: DateFormat('dd MMM, HH:mm').format(log.completedAt),
                    icon: Icons.calendar_today_rounded,
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

class _LogMetric extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _LogMetric({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
