import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HeatingElement extends StatelessWidget {
  final double ssrDutyCycle; // 0 to 100

  const HeatingElement({super.key, required this.ssrDutyCycle});

  @override
  Widget build(BuildContext context) {
    // 0% = cold (grey), 100% = hot (bright orange/red)
    final double intensity = (ssrDutyCycle / 100.0).clamp(0.0, 1.0);
    final Color coldColor = Theme.of(context).brightness == Brightness.dark 
        ? AppTheme.borderDark 
        : AppTheme.borderLight;
    
    final Color activeColor = Color.lerp(
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      intensity,
    ) ?? AppTheme.amber;

    final Color glowColor = activeColor.withValues(alpha: 0.5 * intensity);
    final Color coilColor = Color.lerp(coldColor, activeColor, intensity) ?? coldColor;

    return Container(
      width: double.infinity,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: intensity > 0 
          ? [BoxShadow(color: glowColor, blurRadius: 15 * intensity, spreadRadius: 2 * intensity)]
          : [],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          Container(
            height: 8,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: coldColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Heating coil overlay
          Container(
            height: 8,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: coilColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: intensity > 0 
                ? [BoxShadow(color: activeColor, blurRadius: 4 * intensity)]
                : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                12, 
                (index) => Container(
                  width: 2,
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
