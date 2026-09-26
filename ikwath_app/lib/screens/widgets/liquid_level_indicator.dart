import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LiquidLevelIndicator extends StatefulWidget {
  final double fillPercentage; // 0.0 to 1.0
  final bool isHeating;
  final double targetPercentage;

  const LiquidLevelIndicator({
    super.key,
    required this.fillPercentage,
    required this.isHeating,
    required this.targetPercentage,
  });

  @override
  State<LiquidLevelIndicator> createState() => _LiquidLevelIndicatorState();
}

class _LiquidLevelIndicatorState extends State<LiquidLevelIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.isHeating) {
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(LiquidLevelIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHeating && !oldWidget.isHeating) {
      _waveController.repeat();
    } else if (!widget.isHeating && oldWidget.isHeating) {
      _waveController.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Target Line
          Positioned(
            bottom: 180 * widget.targetPercentage,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: AppTheme.amber.withValues(alpha: 0.5),
            ),
          ),
          
          // Liquid Fill
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LiquidPainter(
                    fillPercentage: widget.fillPercentage,
                    waveValue: _waveController.value,
                    isHeating: widget.isHeating,
                    liquidColor: AppTheme.primaryDeep,
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
          ),

          // Overlay glass glare
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.4),
                  Colors.white.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double fillPercentage;
  final double waveValue;
  final bool isHeating;
  final Color liquidColor;

  _LiquidPainter({
    required this.fillPercentage,
    required this.waveValue,
    required this.isHeating,
    required this.liquidColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fillPercentage <= 0) return;

    final double fillHeight = size.height * fillPercentage;
    final double yOffset = size.height - fillHeight;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, yOffset);

    if (isHeating) {
      // Draw wavy top
      for (double x = 0; x <= size.width; x++) {
        final double waveHeight = 8.0 * math.sin((x / size.width * 2 * math.pi) + (waveValue * 2 * math.pi));
        final double waveHeight2 = 4.0 * math.cos((x / size.width * 3 * math.pi) - (waveValue * 4 * math.pi));
        path.lineTo(x, yOffset + waveHeight + waveHeight2);
      }
    } else {
      path.lineTo(size.width, yOffset);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..color = liquidColor
      ..style = PaintingStyle.fill;
    
    // Add gradient for depth
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        liquidColor.withValues(alpha: 0.8),
        liquidColor,
      ],
    ).createShader(Rect.fromLTWH(0, yOffset, size.width, fillHeight));

    canvas.drawPath(path, paint);

    // Draw bubbles if heating
    if (isHeating) {
      final bubblePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      
      final random = math.Random(waveValue.hashCode); // Pseudo-random based on animation
      
      for (int i = 0; i < 10; i++) {
        final double bx = size.width * random.nextDouble();
        // Bubbles move up
        final double moveUp = (waveValue + (i * 0.1)) % 1.0;
        final double by = size.height - (fillHeight * moveUp);
        
        if (by > yOffset) {
           final double radius = 2.0 + random.nextDouble() * 4.0;
           canvas.drawCircle(Offset(bx, by), radius, bubblePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    return oldDelegate.fillPercentage != fillPercentage ||
           oldDelegate.waveValue != waveValue ||
           oldDelegate.isHeating != isHeating;
  }
}
