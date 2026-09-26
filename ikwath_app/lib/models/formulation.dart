/// AFI/API Standardized Kwatha Formulation model
class Formulation {
  final String id;
  final String name;
  final String sanskritName;    // Sanskrit/Devanagari name
  final String botanical;
  final String description;
  final String afiStandard;
  final double initMassG;       // Starting mass in grams
  final double targetMassG;     // 1/4th reduction endpoint
  final double tempSetpointC;   // PID target temperature
  final int stirrerRpm;
  final double targetNtu;       // Optical turbidity target
  final int waterRatio;         // Water : herb ratio (typically 16)
  final double powderG;         // Herb powder weight in grams
  final double initWaterMl;     // Initial water volume in mL

  const Formulation({
    required this.id,
    required this.name,
    required this.sanskritName,
    required this.botanical,
    required this.description,
    required this.afiStandard,
    required this.initMassG,
    required this.targetMassG,
    required this.tempSetpointC,
    required this.stirrerRpm,
    required this.targetNtu,
    required this.waterRatio,
    required this.powderG,
    required this.initWaterMl,
  });

  double get reductionRatio => initMassG / targetMassG;
}

/// Master AFI/API Formulation Library
class FormulationLibrary {
  static const List<Formulation> all = [
    Formulation(
      id: 'tulsi',
      name: 'Tulsi Kwath',
      sanskritName: 'तुलसी क्वाथ',
      botanical: 'Ocimum sanctum',
      description:
          'Yavakūṭa Cūrṇa (#10/40 mesh). Immunomodulatory & adaptogenic. 1:16 water ratio.',
      afiStandard: 'AFI Part-I • 4:1',
      initMassG: 400.0,
      targetMassG: 100.0,
      tempSetpointC: 88.0,
      stirrerRpm: 450,
      targetNtu: 76.5,
      waterRatio: 16,
      powderG: 25.0,
      initWaterMl: 400.0,
    ),
    Formulation(
      id: 'ayush64',
      name: 'AYUSH-64',
      sanskritName: 'आयुष-64 क्वाथ',
      botanical: 'Saptaparna, Katuki, Chirayata, Kuberaksha',
      description:
          'Anti-malarial & immune decoction. CCRAS validated. 1:16 ratio.',
      afiStandard: 'CCRAS / Ayush Standard',
      initMassG: 450.0,
      targetMassG: 112.5,
      tempSetpointC: 87.0,
      stirrerRpm: 500,
      targetNtu: 84.0,
      waterRatio: 16,
      powderG: 28.0,
      initWaterMl: 450.0,
    ),
    Formulation(
      id: 'dashamoola',
      name: 'Dashamoola Kwath',
      sanskritName: 'दशमूल क्वाथ',
      botanical: 'Aegle marmelos, Premna integrifolia et al.',
      description:
          'Ten Roots Complex. Thick extractive yield. Vata-pacifying.',
      afiStandard: 'AFI Part-I • 4:1',
      initMassG: 480.0,
      targetMassG: 120.0,
      tempSetpointC: 90.0,
      stirrerRpm: 550,
      targetNtu: 88.5,
      waterRatio: 16,
      powderG: 30.0,
      initWaterMl: 480.0,
    ),
    Formulation(
      id: 'giloy',
      name: 'Giloy Kwath',
      sanskritName: 'गिलोय क्वाथ',
      botanical: 'Tinospora cordifolia',
      description:
          'Stem YC powder. Low temp extraction preserves tinocordiside glycosides.',
      afiStandard: 'AFI Part-II • 4:1',
      initMassG: 400.0,
      targetMassG: 100.0,
      tempSetpointC: 86.0,
      stirrerRpm: 420,
      targetNtu: 72.0,
      waterRatio: 16,
      powderG: 25.0,
      initWaterMl: 400.0,
    ),
    Formulation(
      id: 'triphala',
      name: 'Triphala Decoction',
      sanskritName: 'त्रिफला क्वाथ',
      botanical: 'Haritaki, Bibhitaki, Amalaki',
      description:
          'High tannin extraction. Demister traps volatile aroma compounds.',
      afiStandard: 'AFI Part-I • 4:1',
      initMassG: 400.0,
      targetMassG: 100.0,
      tempSetpointC: 89.0,
      stirrerRpm: 450,
      targetNtu: 82.0,
      waterRatio: 16,
      powderG: 25.0,
      initWaterMl: 400.0,
    ),
    Formulation(
      id: 'mahasudarshan',
      name: 'Mahasudarshan Kwath',
      sanskritName: 'महासुदर्शन क्वाथ',
      botanical: '54 Herb Pharmacopeial formulation',
      description:
          'Complex bitter glycosides. Uniform stirring and exact 1/4 reduction.',
      afiStandard: 'AFI Part-I',
      initMassG: 400.0,
      targetMassG: 100.0,
      tempSetpointC: 88.0,
      stirrerRpm: 480,
      targetNtu: 91.0,
      waterRatio: 16,
      powderG: 25.0,
      initWaterMl: 400.0,
    ),
  ];

  static Formulation byId(String id) =>
      all.firstWhere((f) => f.id == id, orElse: () => all.first);
}

