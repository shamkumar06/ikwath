import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/telemetry.dart';
import '../models/formulation.dart';
import '../models/cycle_log.dart';

enum MachineStage { idle, qrScan, initialize, pidHeat, massMonitor, complete }

class IKwathController extends ChangeNotifier {
  // ── Active Formulation ───────────────────────────────────────────────────
  Formulation _formulation = FormulationLibrary.all.first;
  Formulation get formulation => _formulation;

  // ── Machine State ────────────────────────────────────────────────────────
  MachineStage _stage = MachineStage.idle;
  MachineStage get stage => _stage;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  bool _isEmergency = false;
  bool get isEmergency => _isEmergency;

  bool _bleConnected = true; // Simulated BLE connected
  bool get bleConnected => _bleConnected;

  // ── PID State ────────────────────────────────────────────────────────────
  double _pidKp = 4.2;
  double _pidKi = 0.08;
  double _pidKd = 1.2;
  double _pidIntegral = 0;
  double _pidLastError = 0;

  double get pidKp => _pidKp;
  double get pidKi => _pidKi;
  double get pidKd => _pidKd;

  // ── Live Telemetry ───────────────────────────────────────────────────────
  Telemetry _telemetry = const Telemetry(
    tempC: 87.6,
    tempSetpointC: 88.0,
    massG: 218.4,
    initMassG: 400.0,
    targetMassG: 100.0,
    stirrerRpm: 450,
    turbidityNtu: 74.2,
    boiloverMm: 38.0,
    ssrDutyCycle: 62,
    evapRateGpm: -18.2,
    elapsedSec: 870,
    machineState: 'PID_HEAT',
  );
  Telemetry get telemetry => _telemetry;

  // ── Chart History ────────────────────────────────────────────────────────
  final List<TelemetryPoint> _history = [];
  List<TelemetryPoint> get history => List.unmodifiable(_history);

  // ── Cycle Logs ───────────────────────────────────────────────────────────
  final List<CycleLog> _cycleLogs = CycleLog.demoLogs();
  List<CycleLog> get cycleLogs => List.unmodifiable(_cycleLogs);

  // ── Alerts ───────────────────────────────────────────────────────────────
  final List<Map<String, String>> _alerts = [
    {
      'id': 'a1',
      'type': 'critical',
      'title': 'Thermal PID Drift Warning',
      'desc': 'PT100 reached 91.2°C (>90°C AFI limit). SSR reduced to 25%.',
    },
    {
      'id': 'a2',
      'type': 'warning',
      'title': 'Demister Pad Inspection',
      'desc': 'SS mesh condensation elevated. Check lid vents.',
    },
  ];
  List<Map<String, String>> get alerts => List.unmodifiable(_alerts);
  int get alertCount => _alerts.length;

  // ── Simulation Timer ─────────────────────────────────────────────────────
  Timer? _simTimer;
  final Random _rng = Random();

  // ── Stage Labels ─────────────────────────────────────────────────────────
  static const Map<MachineStage, String> stageLabels = {
    MachineStage.idle: 'IDLE',
    MachineStage.qrScan: 'SCAN QR',
    MachineStage.initialize: 'INITIALIZING',
    MachineStage.pidHeat: 'PID HEATING',
    MachineStage.massMonitor: 'MASS REDUCING',
    MachineStage.complete: 'READY ✓',
  };

  String get stageLabel => stageLabels[_stage] ?? 'IDLE';

  int get stageIndex {
    switch (_stage) {
      case MachineStage.idle:
        return 0;
      case MachineStage.qrScan:
        return 1;
      case MachineStage.initialize:
        return 2;
      case MachineStage.pidHeat:
        return 3;
      case MachineStage.massMonitor:
        return 4;
      case MachineStage.complete:
        return 5;
    }
  }

  // ── Initialization ───────────────────────────────────────────────────────
  IKwathController() {
    _stage = MachineStage.pidHeat; // start mid-cycle for demo
    _seedHistory();
    _startSimulation();
  }

  void _seedHistory() {
    final now = DateTime.now();
    final initM = _formulation.initMassG;
    final sp = _formulation.tempSetpointC;
    for (int i = 20; i >= 0; i--) {
      final progress = (20 - i) / 20;
      _history.add(TelemetryPoint(
        timestamp: now.subtract(Duration(seconds: i * 3)),
        tempC: (78 + progress * (sp - 78) + (_rng.nextDouble() * 0.4 - 0.2))
            .clamp(60, 100),
        massG: initM - progress * (initM - 218.4),
        turbidityNtu: 55 + progress * 20,
        evapRateGpm: -16 - _rng.nextDouble() * 3,
        ssrDutyCycle: (55 + _rng.nextInt(15)),
      ));
    }
  }

  // ── Physics Simulation Loop ──────────────────────────────────────────────
  void _startSimulation() {
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_isPaused || _isEmergency) return;
    if (_stage != MachineStage.pidHeat && _stage != MachineStage.massMonitor) {
      return;
    }

    final sp = _formulation.tempSetpointC;
    double temp = _telemetry.tempC;
    double mass = _telemetry.massG;
    double turbidity = _telemetry.turbidityNtu;
    int ssr = _telemetry.ssrDutyCycle;

    // ── PID closed-loop ──────────────────────────────────────────────────
    final error = sp - temp;
    _pidIntegral = (_pidIntegral + error * 0.1).clamp(-50, 50);
    final derivative = error - _pidLastError;
    _pidLastError = error;
    final pidOut = _pidKp * error + _pidKi * _pidIntegral + _pidKd * derivative;
    ssr = (pidOut + 50).round().clamp(0, 100);

    // ── Thermal dynamics ─────────────────────────────────────────────────
    final heating = (ssr / 100.0) * 0.45;
    final thermalLoss = (temp - 25.0) * 0.0035;
    temp += heating - thermalLoss + (_rng.nextDouble() * 0.08 - 0.04);
    temp = double.parse(temp.toStringAsFixed(1)).clamp(20, 105);

    // ── Mass evaporation ─────────────────────────────────────────────────
    double evapRate = 0;
    if (temp > 80.0 && mass > _formulation.targetMassG) {
      final evapPerSec =
          0.12 + ((temp - 80.0) / 10.0) * 0.18 + (_rng.nextDouble() * 0.02);
      mass = (mass - evapPerSec).clamp(_formulation.targetMassG, 9999);
      evapRate = -(evapPerSec * 60);
      mass = double.parse(mass.toStringAsFixed(1));
    } else {
      evapRate = -0.5;
    }

    // ── Optical turbidity builds as liquid thickens ───────────────────────
    if (turbidity < _formulation.targetNtu) {
      turbidity = double.parse((turbidity + 0.08).toStringAsFixed(1));
    }

    final newT = _telemetry.copyWith(
      tempC: temp,
      tempSetpointC: sp,
      massG: mass,
      stirrerRpm: _formulation.stirrerRpm,
      turbidityNtu: turbidity,
      ssrDutyCycle: ssr,
      evapRateGpm: double.parse(evapRate.toStringAsFixed(1)),
      elapsedSec: _telemetry.elapsedSec + 1,
      machineState: _stage == MachineStage.pidHeat ? 'PID_HEAT' : 'MASS_REDUCE',
    );

    _telemetry = newT;

    // Push to chart history (keep 25 points)
    _history.add(TelemetryPoint(
      timestamp: DateTime.now(),
      tempC: temp,
      massG: mass,
      turbidityNtu: turbidity,
      evapRateGpm: evapRate,
      ssrDutyCycle: ssr,
    ));
    if (_history.length > 25) _history.removeAt(0);

    // Auto-advance to mass monitor stage
    if (_stage == MachineStage.pidHeat && temp >= sp - 1.5) {
      _stage = MachineStage.massMonitor;
    }

    // Detect 1/4th reduction endpoint
    if (mass <= _formulation.targetMassG + 0.5 &&
        _stage == MachineStage.massMonitor) {
      _completeCycle();
    }

    notifyListeners();
  }

  // ── Public API ───────────────────────────────────────────────────────────

  void loadFormulation(Formulation f) {
    _formulation = f;
    _telemetry = Telemetry(
      tempC: 32.0,
      tempSetpointC: f.tempSetpointC,
      massG: f.initMassG,
      initMassG: f.initMassG,
      targetMassG: f.targetMassG,
      stirrerRpm: f.stirrerRpm,
      turbidityNtu: 22.0,
      boiloverMm: 38.0,
      ssrDutyCycle: 0,
      evapRateGpm: 0,
      elapsedSec: 0,
      machineState: 'IDLE',
    );
    _stage = MachineStage.initialize;
    _pidIntegral = 0;
    _pidLastError = 0;
    _history.clear();
    notifyListeners();
  }

  void startCycle() {
    if (_stage == MachineStage.initialize ||
        _stage == MachineStage.idle) {
      _stage = MachineStage.pidHeat;
      _isPaused = false;
      notifyListeners();
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void triggerEmergencyCutoff() {
    _isEmergency = true;
    _stage = MachineStage.idle;
    _telemetry = _telemetry.copyWith(
      ssrDutyCycle: 0,
      stirrerRpm: 0,
      machineState: 'EMERGENCY_STOP',
    );
    addAlert('critical', 'Emergency Cutoff Activated',
        '230V SSR heater and stirrer disconnected immediately.');
    notifyListeners();
  }

  void resetEmergency() {
    _isEmergency = false;
    _stage = MachineStage.idle;
    notifyListeners();
  }

  void resetNewBatch() {
    _stage = MachineStage.qrScan;
    _isEmergency = false;
    _isPaused = false;
    notifyListeners();
  }

  void toggleBle() {
    _bleConnected = !_bleConnected;
    notifyListeners();
  }

  void updatePid(double kp, double ki, double kd) {
    _pidKp = kp;
    _pidKi = ki;
    _pidKd = kd;
    notifyListeners();
  }

  void resolveAlert(String id) {
    _alerts.removeWhere((a) => a['id'] == id);
    notifyListeners();
  }

  void addAlert(String type, String title, String desc) {
    _alerts.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'title': title,
      'desc': desc,
    });
    notifyListeners();
  }

  void _completeCycle() {
    _stage = MachineStage.complete;
    _telemetry = _telemetry.copyWith(
      massG: _formulation.targetMassG,
      ssrDutyCycle: 0,
      machineState: 'COMPLETE',
    );

    final now = DateTime.now();
    final batchId =
        'BATCH-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${_rng.nextInt(90) + 10}';

    _cycleLogs.insert(
      0,
      CycleLog(
        batchId: batchId,
        formulationName: _formulation.name,
        initMassG: _formulation.initMassG,
        finalMassG: _telemetry.massG,
        avgTempC: _telemetry.tempC,
        yieldNtu: _telemetry.turbidityNtu,
        durationSec: _telemetry.elapsedSec,
        qualityScore: 99.2,
        afiCompliant: true,
        completedAt: now,
      ),
    );
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }
}
