/// Completed Kwatha cycle audit record (stored locally)
class CycleLog {
  final String batchId;
  final String formulationName;
  final double initMassG;
  final double finalMassG;
  final double avgTempC;
  final double yieldNtu;
  final int durationSec;
  final double qualityScore;   // 0–100
  final bool afiCompliant;
  final DateTime completedAt;

  const CycleLog({
    required this.batchId,
    required this.formulationName,
    required this.initMassG,
    required this.finalMassG,
    required this.avgTempC,
    required this.yieldNtu,
    required this.durationSec,
    required this.qualityScore,
    required this.afiCompliant,
    required this.completedAt,
  });

  String get durationLabel {
    final m = durationSec ~/ 60;
    final s = durationSec % 60;
    return '${m}m ${s}s';
  }

  String get qualityLabel {
    if (qualityScore >= 98) return 'AFI Gold ✓';
    if (qualityScore >= 92) return 'AFI Pass ✓';
    return 'Review Required';
  }

  Map<String, dynamic> toJson() => {
        'batchId': batchId,
        'formulationName': formulationName,
        'initMassG': initMassG,
        'finalMassG': finalMassG,
        'avgTempC': avgTempC,
        'yieldNtu': yieldNtu,
        'durationSec': durationSec,
        'qualityScore': qualityScore,
        'afiCompliant': afiCompliant,
        'completedAt': completedAt.toIso8601String(),
      };

  factory CycleLog.fromJson(Map<String, dynamic> json) => CycleLog(
        batchId: json['batchId'] as String,
        formulationName: json['formulationName'] as String,
        initMassG: (json['initMassG'] as num).toDouble(),
        finalMassG: (json['finalMassG'] as num).toDouble(),
        avgTempC: (json['avgTempC'] as num).toDouble(),
        yieldNtu: (json['yieldNtu'] as num).toDouble(),
        durationSec: json['durationSec'] as int,
        qualityScore: (json['qualityScore'] as num).toDouble(),
        afiCompliant: json['afiCompliant'] as bool,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  /// Generate demo seed logs
  static List<CycleLog> demoLogs() {
    final now = DateTime.now();
    return [
      CycleLog(
        batchId: 'BATCH-${now.year}-0914-01',
        formulationName: 'Tulsi Kwath',
        initMassG: 400.0,
        finalMassG: 100.2,
        avgTempC: 88.1,
        yieldNtu: 76.4,
        durationSec: 1540,
        qualityScore: 99.2,
        afiCompliant: true,
        completedAt: now.subtract(const Duration(days: 3)),
      ),
      CycleLog(
        batchId: 'BATCH-${now.year}-0915-02',
        formulationName: 'AYUSH-64',
        initMassG: 450.0,
        finalMassG: 112.8,
        avgTempC: 87.0,
        yieldNtu: 83.9,
        durationSec: 1680,
        qualityScore: 98.7,
        afiCompliant: true,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
      CycleLog(
        batchId: 'BATCH-${now.year}-0916-03',
        formulationName: 'Dashamoola Kwath',
        initMassG: 480.0,
        finalMassG: 120.4,
        avgTempC: 90.2,
        yieldNtu: 88.1,
        durationSec: 1820,
        qualityScore: 99.5,
        afiCompliant: true,
        completedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
