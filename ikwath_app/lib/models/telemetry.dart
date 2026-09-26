/// Real-time sensor telemetry snapshot from ESP32
class Telemetry {
  final double tempC;           // PT100 RTD + MAX31865
  final double tempSetpointC;   // PID target
  final double massG;           // HX711 Load Cell
  final double initMassG;       // Tared starting mass
  final double targetMassG;     // 1/4th endpoint
  final int stirrerRpm;         // Magnetic Stirrer (Hall effect)
  final double turbidityNtu;    // Optical sensor yield index
  final double boiloverMm;      // IR meniscus clearance (safe > 25 mm)
  final int ssrDutyCycle;       // PID PWM output %
  final double evapRateGpm;     // Evaporation rate g/min
  final int elapsedSec;         // Cycle elapsed seconds
  final String machineState;    // ESP32 state-machine label

  const Telemetry({
    required this.tempC,
    required this.tempSetpointC,
    required this.massG,
    required this.initMassG,
    required this.targetMassG,
    required this.stirrerRpm,
    required this.turbidityNtu,
    required this.boiloverMm,
    required this.ssrDutyCycle,
    required this.evapRateGpm,
    required this.elapsedSec,
    required this.machineState,
  });

  /// Reduction progress 0.0 → 1.0
  double get reductionProgress {
    final total = initMassG - targetMassG;
    if (total <= 0) return 1.0;
    final done = initMassG - massG;
    return (done / total).clamp(0.0, 1.0);
  }

  /// Percentage remaining to 1/4th endpoint
  int get percentToGo => ((1.0 - reductionProgress) * 100).round();

  /// Estimated time remaining in seconds
  int get etaSec {
    if (evapRateGpm >= 0) return 0;
    final remaining = massG - targetMassG;
    return ((remaining / evapRateGpm.abs()) * 60).round();
  }

  /// Heater power in Watts (750W heater max)
  int get powerWatts => ((ssrDutyCycle / 100.0) * 750).round();

  bool get isBoiloverSafe => boiloverMm > 25.0;
  bool get isPidLocked =>
      (tempC - tempSetpointC).abs() <= 1.5 && machineState == 'PID_HEAT';

  Telemetry copyWith({
    double? tempC,
    double? tempSetpointC,
    double? massG,
    double? initMassG,
    double? targetMassG,
    int? stirrerRpm,
    double? turbidityNtu,
    double? boiloverMm,
    int? ssrDutyCycle,
    double? evapRateGpm,
    int? elapsedSec,
    String? machineState,
  }) {
    return Telemetry(
      tempC: tempC ?? this.tempC,
      tempSetpointC: tempSetpointC ?? this.tempSetpointC,
      massG: massG ?? this.massG,
      initMassG: initMassG ?? this.initMassG,
      targetMassG: targetMassG ?? this.targetMassG,
      stirrerRpm: stirrerRpm ?? this.stirrerRpm,
      turbidityNtu: turbidityNtu ?? this.turbidityNtu,
      boiloverMm: boiloverMm ?? this.boiloverMm,
      ssrDutyCycle: ssrDutyCycle ?? this.ssrDutyCycle,
      evapRateGpm: evapRateGpm ?? this.evapRateGpm,
      elapsedSec: elapsedSec ?? this.elapsedSec,
      machineState: machineState ?? this.machineState,
    );
  }
}

/// Historical data point for charting
class TelemetryPoint {
  final DateTime timestamp;
  final double tempC;
  final double massG;
  final double turbidityNtu;
  final double evapRateGpm;
  final int ssrDutyCycle;

  const TelemetryPoint({
    required this.timestamp,
    required this.tempC,
    required this.massG,
    required this.turbidityNtu,
    required this.evapRateGpm,
    required this.ssrDutyCycle,
  });
}
