/// iKwath Multilingual Localization System
/// Supports 12+ Indian languages for the Ayurvedic Decoction Platform
/// Uses a simple Map-based approach (no external packages needed).
///
/// Languages: English, Hindi, Tamil, Telugu, Kannada, Malayalam,
///            Bengali, Marathi, Gujarati, Punjabi, Odia, Sanskrit

import 'package:flutter/material.dart';

/// Supported locale metadata
class AppLocale {
  final String code;
  final String name;         // Native script name
  final String englishName;  // English name
  final Locale locale;

  const AppLocale({
    required this.code,
    required this.name,
    required this.englishName,
    required this.locale,
  });
}

/// All supported locales
const List<AppLocale> supportedLocales = [
  AppLocale(code: 'en', name: 'English',    englishName: 'English',    locale: Locale('en')),
  AppLocale(code: 'hi', name: 'हिन्दी',      englishName: 'Hindi',      locale: Locale('hi')),
  AppLocale(code: 'ta', name: 'தமிழ்',       englishName: 'Tamil',      locale: Locale('ta')),
  AppLocale(code: 'te', name: 'తెలుగు',      englishName: 'Telugu',     locale: Locale('te')),
  AppLocale(code: 'kn', name: 'ಕನ್ನಡ',       englishName: 'Kannada',    locale: Locale('kn')),
  AppLocale(code: 'ml', name: 'മലയാളം',     englishName: 'Malayalam',  locale: Locale('ml')),
  AppLocale(code: 'bn', name: 'বাংলা',       englishName: 'Bengali',    locale: Locale('bn')),
  AppLocale(code: 'mr', name: 'मराठी',       englishName: 'Marathi',    locale: Locale('mr')),
  AppLocale(code: 'gu', name: 'ગુજરાતી',    englishName: 'Gujarati',   locale: Locale('gu')),
  AppLocale(code: 'pa', name: 'ਪੰਜਾਬੀ',     englishName: 'Punjabi',    locale: Locale('pa')),
  AppLocale(code: 'or', name: 'ଓଡ଼ିଆ',       englishName: 'Odia',       locale: Locale('or')),
  AppLocale(code: 'sa', name: 'संस्कृतम्',    englishName: 'Sanskrit',   locale: Locale('sa')),
];

/// Translation keys used across the app
class S {
  // ── Header / Branding ──────────────────────────────────────────────
  static const govOfIndia       = 'gov_of_india';
  static const ministryOfAyush  = 'ministry_of_ayush';
  static const searchPlaceholder = 'search_placeholder';

  // ── Nav Tabs ───────────────────────────────────────────────────────
  static const tabTelemetry     = 'tab_telemetry';
  static const tabKwathaProcess = 'tab_kwatha_process';
  static const tabExtraction    = 'tab_extraction';
  static const tabPodLibrary    = 'tab_pod_library';
  static const tabAudit         = 'tab_audit';

  // ── Telemetry View ─────────────────────────────────────────────────
  static const sensorGrid       = 'sensor_grid';
  static const sensorGridSub    = 'sensor_grid_sub';
  static const decocTemp        = 'decoction_temp';
  static const massReduction    = 'mass_reduction';
  static const magneticStirrer  = 'magnetic_stirrer';
  static const opticalTurbidity = 'optical_turbidity';
  static const boiloverMeniscus = 'boilover_meniscus';
  static const ssrHeaterOutput  = 'ssr_heater_output';

  // ── Hero Card ──────────────────────────────────────────────────────
  static const massReductionProgress = 'mass_reduction_progress';
  static const pidState         = 'pid_state';
  static const pidLocked        = 'pid_locked';
  static const pidRegulating    = 'pid_regulating';
  static const evapRate         = 'evap_rate';
  static const eta              = 'eta';
  static const boilSafety       = 'boil_safety';
  static const safeMeniscus     = 'safe_meniscus';
  static const warning          = 'warning';
  static const target           = 'target';
  static const complete         = 'complete';
  static const toGo             = 'to_go';
  static const resume           = 'resume';
  static const pause            = 'pause';

  // ── Stepper View ───────────────────────────────────────────────────
  static const stepperTitle     = 'stepper_title';
  static const stepperSubtitle  = 'stepper_subtitle';
  static const scanBotanical    = 'scan_botanical';
  static const addWater         = 'add_water';
  static const heatDecoction    = 'heat_decoction';
  static const massReductionStep = 'mass_reduction_step';
  static const kwathReady       = 'kwath_ready';

  // ── Status Banner ──────────────────────────────────────────────────
  static const ayushPharma      = 'ayush_pharmacopoeia';
  static const activeFormulation = 'active_formulation';

  // ── Common ─────────────────────────────────────────────────────────
  static const emergencyCutoff  = 'emergency_cutoff';
  static const emergencyBody    = 'emergency_body';
  static const cancel           = 'cancel';
  static const cutoffNow        = 'cutoff_now';
  static const settings         = 'settings';
  static const alerts           = 'alerts';
  static const selectLanguage   = 'select_language';
  static const active           = 'active';
  static const safe             = 'safe';
  static const alertStatus      = 'alert';
  static const optimal          = 'optimal';
  static const extracting       = 'extracting';
  static const firing           = 'firing';
  static const idle             = 'idle';
}

/// Master translation map: langCode → { key → translation }
const Map<String, Map<String, String>> translations = {
  // ══════════════════════════════════════════════════════════════════════
  // ENGLISH
  // ══════════════════════════════════════════════════════════════════════
  'en': {
    S.govOfIndia:       'Government of India',
    S.ministryOfAyush:  'Ministry of Ayush',
    S.searchPlaceholder: 'Search AFI Kwath formulation...',

    S.tabTelemetry:     'Telemetry',
    S.tabKwathaProcess: 'Kwatha Process',
    S.tabExtraction:    'Extraction Charts',
    S.tabPodLibrary:    'AFI Pod Library',
    S.tabAudit:         'Audit & Compliance',

    S.sensorGrid:       'Real-Time Sensor Telemetry',
    S.sensorGridSub:    '6 calibrated sensors • ESP32 BLE • 1 Hz sampling',
    S.decocTemp:        'Decoction Temp',
    S.massReduction:    'Mass Reduction',
    S.magneticStirrer:  'Magnetic Stirrer',
    S.opticalTurbidity: 'Optical Turbidity',
    S.boiloverMeniscus: 'Boilover Meniscus',
    S.ssrHeaterOutput:  'SSR Heater Output',

    S.massReductionProgress: 'AFI 1/4th Mass Reduction',
    S.pidState:         'PID State',
    S.pidLocked:        'PID Locked',
    S.pidRegulating:    'Regulating',
    S.evapRate:         'Evaporation Rate',
    S.eta:              'ETA',
    S.boilSafety:       'Boilover Safety',
    S.safeMeniscus:     'Safe Meniscus',
    S.warning:          'Warning',
    S.target:           'Target',
    S.complete:         'Complete',
    S.toGo:             'to go',
    S.resume:           'Resume',
    S.pause:            'Pause',

    S.stepperTitle:     'Autonomous Extraction State Machine',
    S.stepperSubtitle:  '5-Stage Closed-Loop Sequence • AFI Standard',
    S.scanBotanical:    'Scan Botanical Profile',
    S.addWater:         'Add Water & Initialize',
    S.heatDecoction:    'Heat & Decoction',
    S.massReductionStep: 'Mass Reduction',
    S.kwathReady:       'Kwath Ready!',

    S.ayushPharma:      'AYUSH PHARMACOPOEIA',
    S.activeFormulation: 'Active Formulation',

    S.emergencyCutoff:  'Emergency Hardware Cutoff',
    S.emergencyBody:    'This initiates an immediate emergency hardware cut: 230V SSR heater disconnects, magnetic stirrer stops, and ESP32 transitions to SAFE state. Proceed?',
    S.cancel:           'Cancel',
    S.cutoffNow:        'Cutoff Now',
    S.settings:         'Settings',
    S.alerts:           'System Alerts',
    S.selectLanguage:   'Select Language',
    S.active:           'ACTIVE',
    S.safe:             'SAFE',
    S.alertStatus:      'ALERT',
    S.optimal:          'OPTIMAL',
    S.extracting:       'EXTRACTING',
    S.firing:           'FIRING',
    S.idle:             'IDLE',
  },

  // ══════════════════════════════════════════════════════════════════════
  // HINDI
  // ══════════════════════════════════════════════════════════════════════
  'hi': {
    S.govOfIndia:       'भारत सरकार',
    S.ministryOfAyush:  'आयुष मंत्रालय',
    S.searchPlaceholder: 'AFI क्वाथ योग खोजें...',

    S.tabTelemetry:     'टेलीमेट्री',
    S.tabKwathaProcess: 'निर्माण प्रक्रिया',
    S.tabExtraction:    'निष्कर्षण चार्ट',
    S.tabPodLibrary:    'आयुष पॉड संग्रह',
    S.tabAudit:         'गुणवत्ता ऑडिट',

    S.sensorGrid:       'संवेदक ग्रिड • वास्तविक समय',
    S.sensorGridSub:    '6 अंशांकित संवेदक • ESP32 BLE • 1 Hz नमूनाकरण',
    S.decocTemp:        'तापमान • काढ़ा तापमान',
    S.massReduction:    'द्रव्यमान • अपचयन',
    S.magneticStirrer:  'मंथक • चुंबकीय मंथक',
    S.opticalTurbidity: 'निष्कर्षण • प्रकाशीय मैलापन',
    S.boiloverMeniscus: 'क्वथन रक्षक • उफान',
    S.ssrHeaterOutput:  'ऊष्मक निर्गम • SSR',

    S.massReductionProgress: 'AFI चतुर्थांश अपचयन प्रगति',
    S.pidState:         'PID अवस्था',
    S.pidLocked:        'PID स्थिर',
    S.pidRegulating:    'नियमन हो रहा है',
    S.evapRate:         'वाष्पीकरण दर',
    S.eta:              'अनुमानित समय',
    S.boilSafety:       'क्वथन सुरक्षा',
    S.safeMeniscus:     'सुरक्षित तल',
    S.warning:          'चेतावनी',
    S.target:           'लक्ष्य',
    S.complete:         'पूर्ण',
    S.toGo:             'शेष',
    S.resume:           'पुनः प्रारंभ',
    S.pause:            'रुकें',

    S.stepperTitle:     'स्वायत्त क्वाथ निर्माण चक्र',
    S.stepperSubtitle:  '5-चरण बंद-लूप अनुक्रम • AFI मानक',
    S.scanBotanical:    'वानस्पतिक प्रोफ़ाइल स्कैन करें',
    S.addWater:         'जल डालें एवं आरंभ करें',
    S.heatDecoction:    'तापन एवं क्वथन',
    S.massReductionStep: 'द्रव्यमान अपचयन',
    S.kwathReady:       'क्वाथ तैयार!',

    S.ayushPharma:      'आयुष भेषजसंहिता',
    S.activeFormulation: 'सक्रिय योग',

    S.emergencyCutoff:  'आपातकालीन हार्डवेयर कटऑफ',
    S.emergencyBody:    'यह तत्काल आपातकालीन हार्डवेयर कट आरंभ करता है: 230V SSR हीटर विच्छेद, चुंबकीय मंथक रुक जाएगा, और ESP32 सुरक्षित अवस्था में आ जाएगा।',
    S.cancel:           'रद्द करें',
    S.cutoffNow:        'अभी कट करें',
    S.settings:         'सेटिंग्स',
    S.alerts:           'प्रणाली अलर्ट',
    S.selectLanguage:   'भाषा चुनें',
    S.active:           'सक्रिय',
    S.safe:             'सुरक्षित',
    S.alertStatus:      'सचेत',
    S.optimal:          'इष्टतम',
    S.extracting:       'निष्कर्षण',
    S.firing:           'चालू',
    S.idle:             'निष्क्रिय',
  },

  // ══════════════════════════════════════════════════════════════════════
  // TAMIL
  // ══════════════════════════════════════════════════════════════════════
  'ta': {
    S.govOfIndia:       'இந்திய அரசு',
    S.ministryOfAyush:  'ஆயுஷ் அமைச்சகம்',
    S.searchPlaceholder: 'AFI கஷாயம் தேடுங்கள்...',

    S.tabTelemetry:     'தொலைஅளவீடு',
    S.tabKwathaProcess: 'கஷாய செயல்முறை',
    S.tabExtraction:    'பிரித்தெடுத்தல் வரைபடங்கள்',
    S.tabPodLibrary:    'AFI பாட் நூலகம்',
    S.tabAudit:         'தரச் சோதனை',

    S.sensorGrid:       'நிகழ்நேர உணரி தொலைஅளவீடு',
    S.sensorGridSub:    '6 அளவுத்திருத்த உணரிகள் • ESP32 BLE • 1 Hz',
    S.decocTemp:        'கஷாய வெப்பநிலை',
    S.massReduction:    'நிறை குறைப்பு',
    S.magneticStirrer:  'காந்த கலக்கி',
    S.opticalTurbidity: 'ஒளிக் கலங்கல்',
    S.boiloverMeniscus: 'கொதிப்பு பாதுகாப்பு',
    S.ssrHeaterOutput:  'SSR வெப்பமூட்டி',

    S.massReductionProgress: 'AFI 1/4 நிறை குறைப்பு',
    S.pidState:         'PID நிலை',
    S.pidLocked:        'PID பூட்டப்பட்டது',
    S.pidRegulating:    'ஒழுங்குபடுத்துகிறது',
    S.evapRate:         'ஆவியாதல் வீதம்',
    S.eta:              'மதிப்பிட்ட நேரம்',
    S.boilSafety:       'கொதிப்பு பாதுகாப்பு',
    S.safeMeniscus:     'பாதுகாப்பான மட்டம்',
    S.warning:          'எச்சரிக்கை',
    S.target:           'இலக்கு',
    S.complete:         'முடிந்தது',
    S.toGo:             'மீதம்',
    S.resume:           'தொடர்க',
    S.pause:            'நிறுத்து',

    S.stepperTitle:     'தன்னியக்க கஷாய செயல்முறை',
    S.stepperSubtitle:  '5-நிலை மூடிய-வளைய வரிசை • AFI தரநிலை',
    S.scanBotanical:    'தாவர விவரம் ஸ்கேன்',
    S.addWater:         'நீர் சேர்த்து துவக்கு',
    S.heatDecoction:    'வெப்பமூட்டல் & கஷாயம்',
    S.massReductionStep: 'நிறை குறைப்பு',
    S.kwathReady:       'கஷாயம் தயார்!',

    S.ayushPharma:      'ஆயுஷ் மருந்தகம்',
    S.activeFormulation: 'செயலில் உள்ள சூத்திரம்',

    S.emergencyCutoff:  'அவசர வன்பொருள் நிறுத்தம்',
    S.emergencyBody:    'இது உடனடி அவசர வன்பொருள் நிறுத்தத்தைத் தொடங்கும்: 230V SSR வெப்பமூட்டி துண்டிக்கப்படும், காந்த கலக்கி நிற்கும்.',
    S.cancel:           'ரத்து',
    S.cutoffNow:        'இப்போது நிறுத்து',
    S.settings:         'அமைப்புகள்',
    S.alerts:           'அமைப்பு எச்சரிக்கைகள்',
    S.selectLanguage:   'மொழி தேர்வு',
    S.active:           'செயலில்',
    S.safe:             'பாதுகாப்பு',
    S.alertStatus:      'எச்சரிக்கை',
    S.optimal:          'உகந்தது',
    S.extracting:       'பிரித்தெடுத்தல்',
    S.firing:           'இயக்கம்',
    S.idle:             'செயலற்றது',
  },

  // ══════════════════════════════════════════════════════════════════════
  // TELUGU
  // ══════════════════════════════════════════════════════════════════════
  'te': {
    S.govOfIndia:       'భారత ప్రభుత్వం',
    S.ministryOfAyush:  'ఆయుష్ మంత్రిత్వ శాఖ',
    S.searchPlaceholder: 'AFI కషాయం శోధించండి...',

    S.tabTelemetry:     'టెలిమెట్రీ',
    S.tabKwathaProcess: 'కషాయ ప్రక్రియ',
    S.tabExtraction:    'సారం పటాలు',
    S.tabPodLibrary:    'AFI పాడ్ లైబ్రరీ',
    S.tabAudit:         'నాణ్యత తనిఖీ',

    S.sensorGrid:       'నిజ-సమయ సెన్సార్ టెలిమెట్రీ',
    S.sensorGridSub:    '6 సెన్సార్లు • ESP32 BLE • 1 Hz',
    S.decocTemp:        'కషాయ ఉష్ణోగ్రత',
    S.massReduction:    'ద్రవ్యరాశి తగ్గింపు',
    S.magneticStirrer:  'అయస్కాంత కలుపుకి',
    S.opticalTurbidity: 'కాంతి మాలిన్యం',
    S.boiloverMeniscus: 'పొంగు రక్షణ',
    S.ssrHeaterOutput:  'SSR హీటర్ అవుట్‌పుట్',

    S.massReductionProgress: 'AFI 1/4 ద్రవ్యరాశి తగ్గింపు',
    S.pidState:         'PID స్థితి',
    S.pidLocked:        'PID లాక్ అయింది',
    S.pidRegulating:    'నియంత్రిస్తోంది',
    S.evapRate:         'ఆవిరి రేటు',
    S.eta:              'అంచనా సమయం',
    S.boilSafety:       'పొంగు భద్రత',
    S.safeMeniscus:     'సురక్షిత మట్టం',
    S.warning:          'హెచ్చరిక',
    S.target:           'లక్ష్యం',
    S.complete:         'పూర్తి',
    S.toGo:             'మిగిలింది',
    S.resume:           'కొనసాగించు',
    S.pause:            'ఆపు',

    S.stepperTitle:     'స్వయంచాలక కషాయ ప్రక్రియ',
    S.stepperSubtitle:  '5-దశల క్రమం • AFI ప్రమాణం',
    S.scanBotanical:    'వృక్షశాస్త్ర ప్రొఫైల్ స్కాన్',
    S.addWater:         'నీరు జోడించి ప్రారంభించు',
    S.heatDecoction:    'వేడి & కషాయం',
    S.massReductionStep: 'ద్రవ్యరాశి తగ్గింపు',
    S.kwathReady:       'కషాయం సిద్ధం!',

    S.ayushPharma:      'ఆయుష్ ఫార్మకోపియా',
    S.activeFormulation: 'క్రియాశీల సూత్రీకరణ',

    S.emergencyCutoff:  'అత్యవసర హార్డ్‌వేర్ కటాఫ్',
    S.emergencyBody:    'ఇది తక్షణ అత్యవసర హార్డ్‌వేర్ కట్‌ను ప్రారంభిస్తుంది.',
    S.cancel:           'రద్దు',
    S.cutoffNow:        'ఇప్పుడు కటాఫ్',
    S.settings:         'సెట్టింగ్‌లు',
    S.alerts:           'సిస్టమ్ అలర్ట్‌లు',
    S.selectLanguage:   'భాషను ఎంచుకోండి',
    S.active:           'సక్రియం',
    S.safe:             'సురక్షితం',
    S.alertStatus:      'హెచ్చరిక',
    S.optimal:          'ఉత్తమం',
    S.extracting:       'వెలికితీత',
    S.firing:           'నడుస్తోంది',
    S.idle:             'నిష్క్రియ',
  },

  // ══════════════════════════════════════════════════════════════════════
  // KANNADA
  // ══════════════════════════════════════════════════════════════════════
  'kn': {
    S.govOfIndia:       'ಭಾರತ ಸರ್ಕಾರ',
    S.ministryOfAyush:  'ಆಯುಷ್ ಸಚಿವಾಲಯ',
    S.searchPlaceholder: 'AFI ಕಷಾಯ ಹುಡುಕಿ...',

    S.tabTelemetry:     'ಟೆಲಿಮೆಟ್ರಿ',
    S.tabKwathaProcess: 'ಕಷಾಯ ಪ್ರಕ್ರಿಯೆ',
    S.tabExtraction:    'ಸಾರ ನಕ್ಷೆಗಳು',
    S.tabPodLibrary:    'AFI ಪಾಡ್ ಗ್ರಂಥಾಲಯ',
    S.tabAudit:         'ಗುಣಮಟ್ಟ ಲೆಕ್ಕಪರಿಶೋಧನೆ',

    S.sensorGrid:       'ನೈಜ-ಸಮಯ ಸಂವೇದಕ ಟೆಲಿಮೆಟ್ರಿ',
    S.sensorGridSub:    '6 ಸಂವೇದಕಗಳು • ESP32 BLE • 1 Hz',
    S.decocTemp:        'ಕಷಾಯ ತಾಪಮಾನ',
    S.massReduction:    'ದ್ರವ್ಯರಾಶಿ ಕಡಿತ',
    S.magneticStirrer:  'ಕಾಂತೀಯ ಕಲಕುವಿಕೆ',
    S.opticalTurbidity: 'ದೃಗ್ವಿಷಯ ಮಬ್ಬು',
    S.boiloverMeniscus: 'ಕುದಿ ರಕ್ಷಣೆ',
    S.ssrHeaterOutput:  'SSR ಹೀಟರ್ ಔಟ್‌ಪುಟ್',

    S.massReductionProgress: 'AFI 1/4 ದ್ರವ್ಯರಾಶಿ ಕಡಿತ',
    S.pidState:         'PID ಸ್ಥಿತಿ',
    S.pidLocked:        'PID ಲಾಕ್ ಆಗಿದೆ',
    S.pidRegulating:    'ನಿಯಂತ್ರಿಸುತ್ತಿದೆ',
    S.evapRate:         'ಆವಿಯಾಗುವ ದರ',
    S.eta:              'ಅಂದಾಜು ಸಮಯ',
    S.boilSafety:       'ಕುದಿ ಸುರಕ್ಷತೆ',
    S.safeMeniscus:     'ಸುರಕ್ಷಿತ ಮಟ್ಟ',
    S.warning:          'ಎಚ್ಚರಿಕೆ',
    S.target:           'ಗುರಿ',
    S.complete:         'ಸಂಪೂರ್ಣ',
    S.toGo:             'ಉಳಿದಿದೆ',
    S.resume:           'ಮುಂದುವರಿಸಿ',
    S.pause:            'ನಿಲ್ಲಿಸಿ',

    S.stepperTitle:     'ಸ್ವಯಂಚಾಲಿತ ಕಷಾಯ ಪ್ರಕ್ರಿಯೆ',
    S.stepperSubtitle:  '5-ಹಂತ ಮುಚ್ಚಿದ-ಲೂಪ್ ಅನುಕ್ರಮ • AFI ಮಾನಕ',
    S.scanBotanical:    'ಸಸ್ಯಶಾಸ್ತ್ರ ಪ್ರೊಫೈಲ್ ಸ್ಕ್ಯಾನ್',
    S.addWater:         'ನೀರು ಸೇರಿಸಿ ಪ್ರಾರಂಭಿಸಿ',
    S.heatDecoction:    'ಬಿಸಿಮಾಡುವಿಕೆ & ಕಷಾಯ',
    S.massReductionStep: 'ದ್ರವ್ಯರಾಶಿ ಕಡಿತ',
    S.kwathReady:       'ಕಷಾಯ ಸಿದ್ಧ!',

    S.ayushPharma:      'ಆಯುಷ್ ಔಷಧಸಂಹಿತೆ',
    S.activeFormulation: 'ಸಕ್ರಿಯ ಸೂತ್ರೀಕರಣ',

    S.emergencyCutoff:  'ತುರ್ತು ಹಾರ್ಡ್‌ವೇರ್ ಕಟಾಫ್',
    S.emergencyBody:    'ಇದು ತಕ್ಷಣದ ತುರ್ತು ಹಾರ್ಡ್‌ವೇರ್ ಕಟ್ ಅನ್ನು ಪ್ರಾರಂಭಿಸುತ್ತದೆ.',
    S.cancel:           'ರದ್ದು',
    S.cutoffNow:        'ಈಗ ಕಟ್ ಮಾಡಿ',
    S.settings:         'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
    S.alerts:           'ಸಿಸ್ಟಮ್ ಎಚ್ಚರಿಕೆಗಳು',
    S.selectLanguage:   'ಭಾಷೆ ಆಯ್ಕೆ',
    S.active:           'ಸಕ್ರಿಯ',
    S.safe:             'ಸುರಕ್ಷಿತ',
    S.alertStatus:      'ಎಚ್ಚರಿಕೆ',
    S.optimal:          'ಅತ್ಯುತ್ತಮ',
    S.extracting:       'ಹೊರತೆಗೆಯುವಿಕೆ',
    S.firing:           'ಚಾಲನೆ',
    S.idle:             'ನಿಷ್ಕ್ರಿಯ',
  },

  // ══════════════════════════════════════════════════════════════════════
  // MALAYALAM
  // ══════════════════════════════════════════════════════════════════════
  'ml': {
    S.govOfIndia:       'ഇന്ത്യാ ഗവൺമെന്റ്',
    S.ministryOfAyush:  'ആയുഷ് മന്ത്രാലയം',
    S.searchPlaceholder: 'AFI കഷായം തിരയുക...',

    S.tabTelemetry:     'ടെലിമെട്രി',
    S.tabKwathaProcess: 'കഷായ പ്രക്രിയ',
    S.tabExtraction:    'സത്ത് ചാർട്ടുകൾ',
    S.tabPodLibrary:    'AFI പോഡ് ലൈബ്രറി',
    S.tabAudit:         'ഗുണനിലവാര ഓഡിറ്റ്',

    S.sensorGrid:       'തത്സമയ സെൻസർ ടെലിമെട്രി',
    S.sensorGridSub:    '6 സെൻസറുകൾ • ESP32 BLE • 1 Hz',
    S.decocTemp:        'കഷായ താപനില',
    S.massReduction:    'പിണ്ഡം കുറയ്ക്കൽ',
    S.magneticStirrer:  'കാന്തിക ഇളക്കി',
    S.opticalTurbidity: 'പ്രകാശ കലക്കം',
    S.boiloverMeniscus: 'തിളച്ചുകവിയൽ സുരക്ഷ',
    S.ssrHeaterOutput:  'SSR ഹീറ്റർ ഔട്ട്‌പുട്ട്',

    S.massReductionProgress: 'AFI 1/4 പിണ്ഡം കുറയ്ക്കൽ',
    S.pidState:         'PID നില',
    S.pidLocked:        'PID ലോക്ക് ആയി',
    S.pidRegulating:    'നിയന്ത്രിക്കുന്നു',
    S.evapRate:         'ബാഷ്പീകരണ നിരക്ക്',
    S.eta:              'കണക്കാക്കിയ സമയം',
    S.boilSafety:       'തിളച്ചുകവിയൽ സുരക്ഷ',
    S.safeMeniscus:     'സുരക്ഷിത നില',
    S.warning:          'മുന്നറിയിപ്പ്',
    S.target:           'ലക്ഷ്യം',
    S.complete:         'പൂർത്തി',
    S.toGo:             'ബാക്കി',
    S.resume:           'തുടരുക',
    S.pause:            'നിർത്തുക',

    S.stepperTitle:     'സ്വയംചാലിത കഷായ പ്രക്രിയ',
    S.stepperSubtitle:  '5-ഘട്ട ക്ലോസ്ഡ്-ലൂപ്പ് ക്രമം • AFI നിലവാരം',
    S.scanBotanical:    'സസ്യശാസ്ത്ര പ്രൊഫൈൽ സ്കാൻ',
    S.addWater:         'വെള്ളം ചേർത്ത് ആരംഭിക്കുക',
    S.heatDecoction:    'ചൂടാക്കൽ & കഷായം',
    S.massReductionStep: 'പിണ്ഡം കുറയ്ക്കൽ',
    S.kwathReady:       'കഷായം തയ്യാർ!',

    S.ayushPharma:      'ആയുഷ് ഫാർമക്കോപ്പിയ',
    S.activeFormulation: 'സജീവ ഫോർമുലേഷൻ',

    S.emergencyCutoff:  'അടിയന്തര ഹാർഡ്‌വെയർ കട്ടോഫ്',
    S.emergencyBody:    'ഇത് ഉടനടി അടിയന്തര ഹാർഡ്‌വെയർ കട്ട് ആരംഭിക്കും.',
    S.cancel:           'റദ്ദാക്കുക',
    S.cutoffNow:        'ഇപ്പോൾ കട്ട്',
    S.settings:         'ക്രമീകരണങ്ങൾ',
    S.alerts:           'സിസ്റ്റം അലേർട്ടുകൾ',
    S.selectLanguage:   'ഭാഷ തിരഞ്ഞെടുക്കുക',
    S.active:           'സജീവം',
    S.safe:             'സുരക്ഷിതം',
    S.alertStatus:      'മുന്നറിയിപ്പ്',
    S.optimal:          'ഏറ്റവും മികച്ചത്',
    S.extracting:       'വേർതിരിക്കൽ',
    S.firing:           'പ്രവർത്തനം',
    S.idle:             'നിഷ്ക്രിയം',
  },

  // ══════════════════════════════════════════════════════════════════════
  // BENGALI
  // ══════════════════════════════════════════════════════════════════════
  'bn': {
    S.govOfIndia:       'ভারত সরকার',
    S.ministryOfAyush:  'আয়ুষ মন্ত্রণালয়',
    S.searchPlaceholder: 'AFI কাথ অনুসন্ধান করুন...',

    S.tabTelemetry:     'টেলিমেট্রি',
    S.tabKwathaProcess: 'কাথ প্রক্রিয়া',
    S.tabExtraction:    'নিষ্কাশন চার্ট',
    S.tabPodLibrary:    'AFI পড লাইব্রেরি',
    S.tabAudit:         'মান নিরীক্ষা',

    S.sensorGrid:       'রিয়েল-টাইম সেন্সর টেলিমেট্রি',
    S.sensorGridSub:    '৬ সেন্সর • ESP32 BLE • 1 Hz',
    S.decocTemp:        'কাথ তাপমাত্রা',
    S.massReduction:    'ভর হ্রাস',
    S.magneticStirrer:  'চৌম্বকীয় মন্থক',
    S.opticalTurbidity: 'আলোকীয় ঘোলাটে',
    S.boiloverMeniscus: 'ফুটন্ত সুরক্ষা',
    S.ssrHeaterOutput:  'SSR হিটার আউটপুট',

    S.massReductionProgress: 'AFI ১/৪ ভর হ্রাস',
    S.pidState:         'PID অবস্থা',
    S.pidLocked:        'PID লক হয়েছে',
    S.pidRegulating:    'নিয়ন্ত্রণ করছে',
    S.evapRate:         'বাষ্পীভবন হার',
    S.eta:              'আনুমানিক সময়',
    S.boilSafety:       'ফুটন্ত নিরাপত্তা',
    S.safeMeniscus:     'নিরাপদ মাত্রা',
    S.warning:          'সতর্কতা',
    S.target:           'লক্ষ্য',
    S.complete:         'সম্পূর্ণ',
    S.toGo:             'বাকি',
    S.resume:           'পুনরায় শুরু',
    S.pause:            'বিরতি',

    S.stepperTitle:     'স্বয়ংক্রিয় কাথ প্রক্রিয়া',
    S.stepperSubtitle:  '৫-ধাপ ক্রম • AFI মান',
    S.scanBotanical:    'উদ্ভিদ প্রোফাইল স্ক্যান',
    S.addWater:         'জল যোগ করুন ও শুরু করুন',
    S.heatDecoction:    'উত্তাপন ও কাথ',
    S.massReductionStep: 'ভর হ্রাস',
    S.kwathReady:       'কাথ প্রস্তুত!',

    S.ayushPharma:      'আয়ুষ ফার্মাকোপিয়া',
    S.activeFormulation: 'সক্রিয় সূত্র',

    S.emergencyCutoff:  'জরুরি হার্ডওয়্যার কাটঅফ',
    S.emergencyBody:    'এটি তাৎক্ষণিক জরুরি হার্ডওয়্যার কাট শুরু করবে।',
    S.cancel:           'বাতিল',
    S.cutoffNow:        'এখনই কাট',
    S.settings:         'সেটিংস',
    S.alerts:           'সিস্টেম সতর্কতা',
    S.selectLanguage:   'ভাষা নির্বাচন',
    S.active:           'সক্রিয়',
    S.safe:             'নিরাপদ',
    S.alertStatus:      'সতর্কতা',
    S.optimal:          'সর্বোত্তম',
    S.extracting:       'নিষ্কাশন',
    S.firing:           'চালু',
    S.idle:             'নিষ্ক্রিয়',
  },

  // ══════════════════════════════════════════════════════════════════════
  // MARATHI
  // ══════════════════════════════════════════════════════════════════════
  'mr': {
    S.govOfIndia:       'भारत सरकार',
    S.ministryOfAyush:  'आयुष मंत्रालय',
    S.searchPlaceholder: 'AFI क्वाथ शोधा...',

    S.tabTelemetry:     'टेलीमेट्री',
    S.tabKwathaProcess: 'क्वाथ प्रक्रिया',
    S.tabExtraction:    'निष्कर्षण आलेख',
    S.tabPodLibrary:    'AFI पॉड संग्रह',
    S.tabAudit:         'गुणवत्ता लेखापरीक्षण',

    S.sensorGrid:       'रिअल-टाइम सेन्सर टेलीमेट्री',
    S.sensorGridSub:    '६ सेन्सर • ESP32 BLE • 1 Hz',
    S.decocTemp:        'क्वाथ तापमान',
    S.massReduction:    'वस्तुमान कमी',
    S.magneticStirrer:  'चुंबकीय मंथक',
    S.opticalTurbidity: 'प्रकाशीय मलिनता',
    S.boiloverMeniscus: 'उकळणे रक्षक',
    S.ssrHeaterOutput:  'SSR हीटर आउटपुट',

    S.massReductionProgress: 'AFI १/४ वस्तुमान कमी',
    S.pidState:         'PID स्थिती',
    S.pidLocked:        'PID लॉक',
    S.pidRegulating:    'नियमन सुरू',
    S.evapRate:         'बाष्पीभवन दर',
    S.eta:              'अंदाजित वेळ',
    S.boilSafety:       'उकळणे सुरक्षा',
    S.safeMeniscus:     'सुरक्षित पातळी',
    S.warning:          'इशारा',
    S.target:           'लक्ष्य',
    S.complete:         'पूर्ण',
    S.toGo:             'बाकी',
    S.resume:           'पुन्हा सुरू',
    S.pause:            'थांबा',

    S.stepperTitle:     'स्वायत्त क्वाथ निर्माण चक्र',
    S.stepperSubtitle:  '५-चरण बंद-लूप क्रम • AFI मानक',
    S.scanBotanical:    'वनस्पती प्रोफाइल स्कॅन',
    S.addWater:         'पाणी घाला आणि सुरू करा',
    S.heatDecoction:    'तापन आणि क्वथन',
    S.massReductionStep: 'वस्तुमान कमी',
    S.kwathReady:       'क्वाथ तयार!',

    S.ayushPharma:      'आयुष भेषजसंहिता',
    S.activeFormulation: 'सक्रिय योग',

    S.emergencyCutoff:  'आणीबाणी हार्डवेअर कटऑफ',
    S.emergencyBody:    'हे तात्काळ आणीबाणी हार्डवेअर कट सुरू करेल.',
    S.cancel:           'रद्द करा',
    S.cutoffNow:        'आत्ता कट',
    S.settings:         'सेटिंग्ज',
    S.alerts:           'सिस्टम इशारे',
    S.selectLanguage:   'भाषा निवडा',
    S.active:           'सक्रिय',
    S.safe:             'सुरक्षित',
    S.alertStatus:      'इशारा',
    S.optimal:          'इष्टतम',
    S.extracting:       'निष्कर्षण',
    S.firing:           'चालू',
    S.idle:             'निष्क्रिय',
  },

  // ══════════════════════════════════════════════════════════════════════
  // GUJARATI
  // ══════════════════════════════════════════════════════════════════════
  'gu': {
    S.govOfIndia:       'ભારત સરકાર',
    S.ministryOfAyush:  'આયુષ મંત્રાલય',
    S.searchPlaceholder: 'AFI ક્વાથ શોધો...',

    S.tabTelemetry:     'ટેલિમેટ્રી',
    S.tabKwathaProcess: 'ક્વાથ પ્રક્રિયા',
    S.tabExtraction:    'નિષ્કર્ષણ ચાર્ટ',
    S.tabPodLibrary:    'AFI પૉડ સંગ્રહ',
    S.tabAudit:         'ગુણવત્તા ઓડિટ',

    S.sensorGrid:       'રીઅલ-ટાઈમ સેન્સર ટેલિમેટ્રી',
    S.sensorGridSub:    '6 સેન્સર • ESP32 BLE • 1 Hz',
    S.decocTemp:        'ક્વાથ તાપમાન',
    S.massReduction:    'દળ ઘટાડો',
    S.magneticStirrer:  'ચુંબકીય મંથક',
    S.opticalTurbidity: 'પ્રકાશીય ગંદકી',
    S.boiloverMeniscus: 'ઉકળવું રક્ષણ',
    S.ssrHeaterOutput:  'SSR હીટર આઉટપુટ',

    S.massReductionProgress: 'AFI 1/4 દળ ઘટાડો',
    S.pidState:         'PID સ્થિતિ',
    S.pidLocked:        'PID લૉક',
    S.pidRegulating:    'નિયમન ચાલુ',
    S.evapRate:         'બાષ્પીભવન દર',
    S.eta:              'અંદાજીત સમય',
    S.boilSafety:       'ઉકળવું સુરક્ષા',
    S.safeMeniscus:     'સુરક્ષિત સ્તર',
    S.warning:          'ચેતવણી',
    S.target:           'લક્ષ્ય',
    S.complete:         'પૂર્ણ',
    S.toGo:             'બાકી',
    S.resume:           'ફરી શરૂ',
    S.pause:            'થોભો',

    S.stepperTitle:     'સ્વાયત્ત ક્વાથ નિર્માણ ચક્ર',
    S.stepperSubtitle:  '5-તબક્કો ક્રમ • AFI ધોરણ',
    S.scanBotanical:    'વનસ્પતિ પ્રોફાઇલ સ્કેન',
    S.addWater:         'પાણી ઉમેરો અને શરૂ કરો',
    S.heatDecoction:    'ગરમી અને ક્વાથ',
    S.massReductionStep: 'દળ ઘટાડો',
    S.kwathReady:       'ક્વાથ તૈયાર!',

    S.ayushPharma:      'આયુષ ભેષજસંહિતા',
    S.activeFormulation: 'સક્રિય યોગ',

    S.emergencyCutoff:  'કટોકટી હાર્ડવેર કટઓફ',
    S.emergencyBody:    'આ તાત્કાલિક કટોકટી હાર્ડવેર કટ શરૂ કરશે.',
    S.cancel:           'રદ કરો',
    S.cutoffNow:        'હમણાં કટ',
    S.settings:         'સેટિંગ્સ',
    S.alerts:           'સિસ્ટમ ચેતવણીઓ',
    S.selectLanguage:   'ભાષા પસંદ કરો',
    S.active:           'સક્રિય',
    S.safe:             'સુરક્ષિત',
    S.alertStatus:      'ચેતવણી',
    S.optimal:          'શ્રેષ્ઠ',
    S.extracting:       'નિષ્કર્ષણ',
    S.firing:           'ચાલુ',
    S.idle:             'નિષ્ક્રિય',
  },

  // ══════════════════════════════════════════════════════════════════════
  // PUNJABI
  // ══════════════════════════════════════════════════════════════════════
  'pa': {
    S.govOfIndia:       'ਭਾਰਤ ਸਰਕਾਰ',
    S.ministryOfAyush:  'ਆਯੁਸ਼ ਮੰਤਰਾਲਾ',
    S.searchPlaceholder: 'AFI ਕਵਾਥ ਖੋਜੋ...',

    S.tabTelemetry:     'ਟੈਲੀਮੈਟਰੀ',
    S.tabKwathaProcess: 'ਕਵਾਥ ਪ੍ਰਕਿਰਿਆ',
    S.tabExtraction:    'ਨਿਸ਼ਕਰਸ਼ਣ ਚਾਰਟ',
    S.tabPodLibrary:    'AFI ਪੌਡ ਲਾਇਬ੍ਰੇਰੀ',
    S.tabAudit:         'ਗੁਣਵੱਤਾ ਆਡਿਟ',

    S.sensorGrid:       'ਰੀਅਲ-ਟਾਈਮ ਸੈਂਸਰ ਟੈਲੀਮੈਟਰੀ',
    S.sensorGridSub:    '6 ਸੈਂਸਰ • ESP32 BLE • 1 Hz',
    S.decocTemp:        'ਕਵਾਥ ਤਾਪਮਾਨ',
    S.massReduction:    'ਪੁੰਜ ਕਮੀ',
    S.magneticStirrer:  'ਚੁੰਬਕੀ ਮੰਥਕ',
    S.opticalTurbidity: 'ਪ੍ਰਕਾਸ਼ੀ ਗੰਦਲਾਪਣ',
    S.boiloverMeniscus: 'ਉਬਾਲ ਸੁਰੱਖਿਆ',
    S.ssrHeaterOutput:  'SSR ਹੀਟਰ ਆਉਟਪੁੱਟ',

    S.massReductionProgress: 'AFI 1/4 ਪੁੰਜ ਕਮੀ',
    S.pidState:         'PID ਸਥਿਤੀ',
    S.pidLocked:        'PID ਲਾਕ',
    S.pidRegulating:    'ਨਿਯਮਨ ਜਾਰੀ',
    S.evapRate:         'ਵਾਸ਼ਪੀਕਰਨ ਦਰ',
    S.eta:              'ਅੰਦਾਜ਼ਨ ਸਮਾਂ',
    S.boilSafety:       'ਉਬਾਲ ਸੁਰੱਖਿਆ',
    S.safeMeniscus:     'ਸੁਰੱਖਿਅਤ ਪੱਧਰ',
    S.warning:          'ਚੇਤਾਵਨੀ',
    S.target:           'ਟੀਚਾ',
    S.complete:         'ਪੂਰਾ',
    S.toGo:             'ਬਾਕੀ',
    S.resume:           'ਮੁੜ ਸ਼ੁਰੂ',
    S.pause:            'ਰੁਕੋ',

    S.stepperTitle:     'ਸਵੈਚਾਲਤ ਕਵਾਥ ਨਿਰਮਾਣ ਚੱਕਰ',
    S.stepperSubtitle:  '5-ਪੜਾਅ ਕ੍ਰਮ • AFI ਮਿਆਰ',
    S.scanBotanical:    'ਬੋਟੈਨੀਕਲ ਪ੍ਰੋਫਾਈਲ ਸਕੈਨ',
    S.addWater:         'ਪਾਣੀ ਪਾਓ ਅਤੇ ਸ਼ੁਰੂ ਕਰੋ',
    S.heatDecoction:    'ਗਰਮ ਕਰੋ ਅਤੇ ਕਵਾਥ',
    S.massReductionStep: 'ਪੁੰਜ ਕਮੀ',
    S.kwathReady:       'ਕਵਾਥ ਤਿਆਰ!',

    S.ayushPharma:      'ਆਯੁਸ਼ ਫਾਰਮਾਕੋਪੀਆ',
    S.activeFormulation: 'ਸਰਗਰਮ ਫਾਰਮੂਲੇਸ਼ਨ',

    S.emergencyCutoff:  'ਐਮਰਜੈਂਸੀ ਹਾਰਡਵੇਅਰ ਕਟਔਫ',
    S.emergencyBody:    'ਇਹ ਤੁਰੰਤ ਐਮਰਜੈਂਸੀ ਹਾਰਡਵੇਅਰ ਕੱਟ ਸ਼ੁਰੂ ਕਰੇਗਾ।',
    S.cancel:           'ਰੱਦ ਕਰੋ',
    S.cutoffNow:        'ਹੁਣੇ ਕੱਟ',
    S.settings:         'ਸੈਟਿੰਗਜ਼',
    S.alerts:           'ਸਿਸਟਮ ਅਲਰਟ',
    S.selectLanguage:   'ਭਾਸ਼ਾ ਚੁਣੋ',
    S.active:           'ਸਰਗਰਮ',
    S.safe:             'ਸੁਰੱਖਿਅਤ',
    S.alertStatus:      'ਸਾਵਧਾਨ',
    S.optimal:          'ਸਰਵੋਤਮ',
    S.extracting:       'ਨਿਸ਼ਕਰਸ਼ਣ',
    S.firing:           'ਚਾਲੂ',
    S.idle:             'ਨਿਸ਼ਕਿਰਿਆ',
  },

  // ══════════════════════════════════════════════════════════════════════
  // ODIA
  // ══════════════════════════════════════════════════════════════════════
  'or': {
    S.govOfIndia:       'ଭାରତ ସରକାର',
    S.ministryOfAyush:  'ଆୟୁଷ ମନ୍ତ୍ରଣାଳୟ',
    S.searchPlaceholder: 'AFI କଷାୟ ଖୋଜନ୍ତୁ...',

    S.tabTelemetry:     'ଟେଲିମେଟ୍ରି',
    S.tabKwathaProcess: 'କଷାୟ ପ୍ରକ୍ରିୟା',
    S.tabExtraction:    'ନିଷ୍କର୍ଷଣ ଚାର୍ଟ',
    S.tabPodLibrary:    'AFI ପଡ ଲାଇବ୍ରେରୀ',
    S.tabAudit:         'ଗୁଣବତ୍ତା ଅଡିଟ',

    S.sensorGrid:       'ରିଅଲ-ଟାଇମ ସେନସର ଟେଲିମେଟ୍ରି',
    S.sensorGridSub:    '୬ ସେନସର • ESP32 BLE • 1 Hz',
    S.decocTemp:        'କଷାୟ ତାପମାତ୍ରା',
    S.massReduction:    'ଓଜନ ହ୍ରାସ',
    S.magneticStirrer:  'ଚୁମ୍ବକୀୟ ମନ୍ଥକ',
    S.opticalTurbidity: 'ଆଲୋକୀୟ ଘୋଳାଟ',
    S.boiloverMeniscus: 'ଫୁଟିବା ସୁରକ୍ଷା',
    S.ssrHeaterOutput:  'SSR ହିଟର ଆଉଟପୁଟ',

    S.massReductionProgress: 'AFI ୧/୪ ଓଜନ ହ୍ରାସ',
    S.pidState:         'PID ଅବସ୍ଥା',
    S.pidLocked:        'PID ଲକ',
    S.pidRegulating:    'ନିୟନ୍ତ୍ରଣ ଚାଲୁ',
    S.evapRate:         'ବାଷ୍ପୀଭବନ ହାର',
    S.eta:              'ଆକଳିତ ସମୟ',
    S.boilSafety:       'ଫୁଟିବା ସୁରକ୍ଷା',
    S.safeMeniscus:     'ସୁରକ୍ଷିତ ସ୍ତର',
    S.warning:          'ଚେତାବନୀ',
    S.target:           'ଲକ୍ଷ୍ୟ',
    S.complete:         'ସମ୍ପୂର୍ଣ୍ଣ',
    S.toGo:             'ବାକି',
    S.resume:           'ପୁନଃ ଆରମ୍ଭ',
    S.pause:            'ରୁହନ୍ତୁ',

    S.stepperTitle:     'ସ୍ୱୟଂଚାଳିତ କଷାୟ ପ୍ରକ୍ରିୟା',
    S.stepperSubtitle:  '୫-ପର୍ଯ୍ୟାୟ କ୍ରମ • AFI ମାନକ',
    S.scanBotanical:    'ଉଦ୍ଭିଦ ପ୍ରୋଫାଇଲ ସ୍କାନ',
    S.addWater:         'ପାଣି ମିଶାନ୍ତୁ ଓ ଆରମ୍ଭ କରନ୍ତୁ',
    S.heatDecoction:    'ଗରମ କରନ୍ତୁ ଓ କଷାୟ',
    S.massReductionStep: 'ଓଜନ ହ୍ରାସ',
    S.kwathReady:       'କଷାୟ ପ୍ରସ୍ତୁତ!',

    S.ayushPharma:      'ଆୟୁଷ ଫାର୍ମାକୋପିଆ',
    S.activeFormulation: 'ସକ୍ରିୟ ସୂତ୍ର',

    S.emergencyCutoff:  'ଜରୁରୀ ହାର୍ଡୱେୟାର କଟଅଫ',
    S.emergencyBody:    'ଏହା ତୁରନ୍ତ ଜରୁରୀ ହାର୍ଡୱେୟାର କଟ ଆରମ୍ଭ କରିବ।',
    S.cancel:           'ବାତିଲ',
    S.cutoffNow:        'ବର୍ତ୍ତମାନ କଟ',
    S.settings:         'ସେଟିଂସ',
    S.alerts:           'ସିଷ୍ଟମ ସତର୍କତା',
    S.selectLanguage:   'ଭାଷା ଚୟନ କରନ୍ତୁ',
    S.active:           'ସକ୍ରିୟ',
    S.safe:             'ସୁରକ୍ଷିତ',
    S.alertStatus:      'ସତର୍କତା',
    S.optimal:          'ସର୍ବୋତ୍ତମ',
    S.extracting:       'ନିଷ୍କର୍ଷଣ',
    S.firing:           'ଚାଲୁ',
    S.idle:             'ନିଷ୍କ୍ରିୟ',
  },

  // ══════════════════════════════════════════════════════════════════════
  // SANSKRIT
  // ══════════════════════════════════════════════════════════════════════
  'sa': {
    S.govOfIndia:       'भारतसर्वकारः',
    S.ministryOfAyush:  'आयुष मन्त्रालयः',
    S.searchPlaceholder: 'AFI क्वाथं अन्विष्यतु...',

    S.tabTelemetry:     'दूरमापनम्',
    S.tabKwathaProcess: 'क्वाथ प्रक्रिया',
    S.tabExtraction:    'निष्कर्षण आलेखाः',
    S.tabPodLibrary:    'AFI पॉड् संग्रहालयः',
    S.tabAudit:         'गुणपरीक्षणम्',

    S.sensorGrid:       'तात्कालिकं संवेदक दूरमापनम्',
    S.sensorGridSub:    '६ संवेदकाः • ESP32 BLE • 1 Hz',
    S.decocTemp:        'क्वाथ तापमानम्',
    S.massReduction:    'द्रव्यमान ह्रासः',
    S.magneticStirrer:  'चुम्बकीय मन्थकः',
    S.opticalTurbidity: 'प्रकाशीय मलिनता',
    S.boiloverMeniscus: 'क्वथन रक्षणम्',
    S.ssrHeaterOutput:  'SSR तापक निर्गमः',

    S.massReductionProgress: 'AFI चतुर्थांश ह्रास प्रगतिः',
    S.pidState:         'PID अवस्था',
    S.pidLocked:        'PID स्थिरम्',
    S.pidRegulating:    'नियमनं क्रियते',
    S.evapRate:         'वाष्पीकरण वेगः',
    S.eta:              'अनुमानित कालः',
    S.boilSafety:       'क्वथन सुरक्षा',
    S.safeMeniscus:     'सुरक्षित तलम्',
    S.warning:          'चेतावनी',
    S.target:           'लक्ष्यम्',
    S.complete:         'पूर्णम्',
    S.toGo:             'शेषम्',
    S.resume:           'पुनः आरभ्यताम्',
    S.pause:            'विरम्यताम्',

    S.stepperTitle:     'स्वायत्तं क्वाथ निर्माण चक्रम्',
    S.stepperSubtitle:  '५-सोपान अनुक्रमः • AFI मानकम्',
    S.scanBotanical:    'वनस्पति चित्रं स्कैन् कुर्वन्तु',
    S.addWater:         'जलं योजयतु आरभतु च',
    S.heatDecoction:    'तापनं क्वथनं च',
    S.massReductionStep: 'द्रव्यमान ह्रासः',
    S.kwathReady:       'क्वाथः सिद्धः!',

    S.ayushPharma:      'आयुष भेषजसंहिता',
    S.activeFormulation: 'सक्रियः योगः',

    S.emergencyCutoff:  'आपत्कालीनं यन्त्रांश विच्छेदनम्',
    S.emergencyBody:    'एतत् तात्कालिकं आपत्कालीनं यन्त्रांश विच्छेदनं आरभते।',
    S.cancel:           'निरस्यताम्',
    S.cutoffNow:        'अधुना विच्छिद्यताम्',
    S.settings:         'विन्यासाः',
    S.alerts:           'प्रणाली सूचनाः',
    S.selectLanguage:   'भाषां चिनोतु',
    S.active:           'सक्रियम्',
    S.safe:             'सुरक्षितम्',
    S.alertStatus:      'सतर्कम्',
    S.optimal:          'इष्टतमम्',
    S.extracting:       'निष्कर्षणम्',
    S.firing:           'प्रज्वलनम्',
    S.idle:             'निष्क्रियम्',
  },
};

/// Helper to get a translation string with fallback to English
String tr(String key, String langCode) {
  return translations[langCode]?[key]
      ?? translations['en']?[key]
      ?? key;
}
