import 'package:flutter/material.dart';
import '../../../../core/resources/app_color.dart';

enum SwipeType { like, nope }

class SwipeIndicator extends StatelessWidget {
  final SwipeType type;
  final double opacity;

  // Constants
  static const double _topPosition = 80.0;
  static const double _horizontalPosition = 30.0;
  static const double _rotationAngle = 0.35;
  static const double _minScale = 0.8;
  static const double _scaleRange = 0.2;
  static const double _borderWidth = 4.0;
  static const double _borderRadius = 8.0;
  static const double _shadowBlur = 10.0;
  static const double _shadowSpread = 2.0;
  static const double _shadowOpacityFactor = 0.5;
  static const double _baseFontSize = 42.0;
  static const double _letterSpacing = 2.0;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  const SwipeIndicator({super.key, required this.type, required this.opacity});

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();

    final isLike = type == SwipeType.like;
    final color = isLike ? Colors.green.shade400 : AppColor.redLight;
    final text = isLike ? 'THÍCH' : 'BỎ QUA';
    final semanticLabel = isLike
        ? 'Đang thích người này'
        : 'Đang bỏ qua người này';
    final angle = isLike ? -_rotationAngle : _rotationAngle;
    final scale = _minScale + (opacity * _scaleRange);

    // Responsive font size
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth < 360) ? _baseFontSize * 0.85 : _baseFontSize;

    return Positioned(
      top: _topPosition,
      left: isLike ? _horizontalPosition : null,
      right: isLike ? null : _horizontalPosition,
      child: Semantics(
        label: semanticLabel,
        liveRegion: true,
        child: Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                padding: _padding,
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: _borderWidth),
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(_shadowOpacityFactor * opacity),
                      blurRadius: _shadowBlur,
                      spreadRadius: _shadowSpread,
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: _letterSpacing,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
