import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'services/ikwath_controller.dart';
import 'services/locale_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IKwathController()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const IKwathApp(),
    ),
  );
}

class IKwathApp extends StatefulWidget {
  const IKwathApp({super.key});

  @override
  State<IKwathApp> createState() => _IKwathAppState();
}

class _IKwathAppState extends State<IKwathApp> {
  bool _isDark = false;

  void toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKwath — Smart Decoction Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(onToggleTheme: toggleTheme, isDark: _isDark),
    );
  }
}
