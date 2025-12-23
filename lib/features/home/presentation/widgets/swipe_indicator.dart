import 'package:flutter/material.dart';

enum SwipeType { like, nope }

class SwipeIndicator extends StatelessWidget {
  final SwipeType type;
  final double opacity;

  const SwipeIndicator({
    super.key,
    required this.type,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();

    final isLike = type == SwipeType.like;
    final color = isLike ? Colors.green : Colors.red;
    final text = isLike ? 'LIKE' : 'NOPE';
    final angle = isLike ? -0.35 : 0.35;

    return Positioned(
      top: 80,
      left: isLike ? 30 : null,
      right: isLike ? null : 30,
      child: Transform.rotate(
        angle: angle,
        child: Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

