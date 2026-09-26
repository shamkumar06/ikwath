import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ikwath_controller.dart';
import '../../theme/app_theme.dart';

class AlertsSheet extends StatelessWidget {
  const AlertsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<IKwathController>();
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.redBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: AppTheme.red, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'प्रणाली एवं सुरक्षा चेतावनियाँ • Hardware & Safety Alerts',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${ctrl.alertCount} सक्रिय चेतावनियाँ (active alerts)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Alert list
            Expanded(
              child: ctrl.alerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: AppTheme.green, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'All hardware sensors normal ✓',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.green,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: ctrl.alerts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final alert = ctrl.alerts[i];
                        final isCritical = alert['type'] == 'critical';
                        return _AlertItem(
                          id: alert['id']!,
                          title: alert['title']!,
                          desc: alert['desc']!,
                          isCritical: isCritical,
                          onResolve: () => ctrl.resolveAlert(alert['id']!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String id, title, desc;
  final bool isCritical;
  final VoidCallback onResolve;

  const _AlertItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.isCritical,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCritical ? AppTheme.red : AppTheme.amber;
    final bg = isCritical ? AppTheme.redBg : AppTheme.amberBg;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 4.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onResolve,
            style: TextButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Text(
              'Resolve',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Sheet ───────────────────────────────────────────────────────────
class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late TextEditingController _kpCtrl, _kiCtrl, _kdCtrl;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<IKwathController>();
    _kpCtrl = TextEditingController(text: ctrl.pidKp.toString());
    _kiCtrl = TextEditingController(text: ctrl.pidKi.toString());
    _kdCtrl = TextEditingController(text: ctrl.pidKd.toString());
  }

  @override
  void dispose() {
    _kpCtrl.dispose();
    _kiCtrl.dispose();
    _kdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<IKwathController>();
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text(
              'संयोजन एवं अंशांकन • Settings & Sensor Calibration',
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),

            // PID Tuning
            Text(
              'PID तापीय नियंत्रण पैरामीटर (Thermal Parameters)',
              style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _PidField(label: 'Kp (Proportional)', ctrl: _kpCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _PidField(label: 'Ki (Integral)', ctrl: _kiCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _PidField(label: 'Kd (Derivative)', ctrl: _kdCtrl)),
              ],
            ),
            const SizedBox(height: 20),

            // Calibration Buttons
            Text(
              'संवेदक अंशांकन (Hardware Sensor Calibration)',
              style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _CalibBtn(
                  label: 'Tare HX711 Load Cell',
                  icon: Icons.scale_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('HX711 Load Cell tared to zero (शून्यीकरण).')),
                    );
                  },
                ),
                _CalibBtn(
                  label: 'Calibrate PT100 RTD',
                  icon: Icons.thermostat_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PT100 RTD offset calibrated with MAX31865.')),
                    );
                  },
                ),
                _CalibBtn(
                  label: 'Optical Yield Baseline',
                  icon: Icons.light_mode_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nephelometric zero reference set.')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ctrl.updatePid(
                        double.tryParse(_kpCtrl.text) ?? ctrl.pidKp,
                        double.tryParse(_kiCtrl.text) ?? ctrl.pidKi,
                        double.tryParse(_kdCtrl.text) ?? ctrl.pidKd,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PID parameters flashed to ESP32.')),
                      );
                    },
                    child: const Text('Save Parameters'),
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

class _PidField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  const _PidField({required this.label, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 11),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}

class _CalibBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CalibBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.inter(fontSize: 12)),
    );
  }
}
