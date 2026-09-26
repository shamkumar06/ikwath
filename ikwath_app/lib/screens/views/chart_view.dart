import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  int _selectedMetric = 0;

  static const _metrics = [
    _Metric('Decoction Temperature (तापमान)', '°C', AppTheme.primary),
    _Metric('Mass Reduction (द्रव्यमान)', 'g', AppTheme.ayushBlue),
    _Metric('Optical Turbidity (निष्कर्षण)', 'NTU', AppTheme.amber),
    _Metric('Evaporation Rate (वाष्पीकरण)', 'g/min', AppTheme.green),
    _Metric('SSR Heater Duty (ऊष्मक शक्ति)', '%', Color(0xFFC2410C)),
  ];

  double _getValue(TelemetryPoint p, int metric) {
    switch (metric) {
      case 0:
        return p.tempC;
      case 1:
        return p.massG;
      case 2:
        return p.turbidityNtu;
      case 3:
        return p.evapRateGpm.abs();
      case 4:
        return p.ssrDutyCycle.toDouble();
      default:
        return p.tempC;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final history = ctrl.history;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final metric = _metrics[_selectedMetric];

    // Build spots
    final spots = history.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), _getValue(e.value, _selectedMetric));
    }).toList();

    final minY = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 5;
    final maxY = spots.isEmpty
        ? 100.0
        : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 5;

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
                      'सक्रिय निष्कर्षण चार्ट • Live Extraction Telemetry',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${metric.name} (${metric.unit}) • ${history.length} बिंदु • 1 Hz sampling',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Metric Selector
              DropdownButton<int>(
                value: _selectedMetric,
                onChanged: (v) => setState(() => _selectedMetric = v!),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(10),
                items: List.generate(
                  _metrics.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _metrics[i].color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _metrics[i].name,
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Current Value Banner ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: metric.color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up_rounded, color: metric.color),
                const SizedBox(width: 12),
                Text(
                  history.isEmpty
                      ? '—'
                      : _getValue(history.last, _selectedMetric)
                          .toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: metric.color,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  metric.unit,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  ),
                ),
                const Spacer(),
                Text(
                  'लाइव ESP32 डेटा',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: metric.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Chart Area ────────────────────────────────────────────────
          Container(
            height: 280,
            padding: const EdgeInsets.only(top: 24, right: 24, left: 10, bottom: 10),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              ),
            ),
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      'Collecting data...',
                      style: GoogleFonts.inter(
                        color: isDark
                            ? AppTheme.textMutedDark
                            : AppTheme.textMutedLight,
                      ),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: (isDark
                                  ? AppTheme.borderDark
                                  : AppTheme.borderLight)
                              .withValues(alpha: 0.6),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (v, _) => Text(
                              v.toStringAsFixed(0),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isDark
                                    ? AppTheme.textMutedDark
                                    : AppTheme.textMutedLight,
                              ),
                            ),
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: 5,
                            getTitlesWidget: (v, _) => Text(
                              '${v.toInt()}s',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isDark
                                    ? AppTheme.textMutedDark
                                    : AppTheme.textMutedLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: metric.color,
                          barWidth: 2.8,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: metric.color.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  final String name;
  final String unit;
  final Color color;

  const _Metric(this.name, this.unit, this.color);
}
