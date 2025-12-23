import 'package:flutter/material.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

class SwipeActionButtons extends StatelessWidget {
  final VoidCallback? onPass;
  final VoidCallback? onLike;
  final bool isDisabled;

  const SwipeActionButtons({
    super.key,
    this.onPass,
    this.onLike,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pass button
        _ActionButton(
          icon: Icons.close,
          color: Colors.white,
          iconColor: Colors.grey.shade600,
          size: 60,
          onTap: isDisabled ? null : onPass,
        ),
        const SizedBox(width: 24),
        // Like button
        _ActionButton(
          icon: Icons.favorite,
          gradient: AppTheme.primaryGradient,
          iconColor: Colors.white,
          size: 68,
          shadowColor: AppColor.redPrimary,
          onTap: isDisabled ? null : onLike,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Gradient? gradient;
  final Color iconColor;
  final double size;
  final Color? shadowColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.color,
    this.gradient,
    required this.iconColor,
    required this.size,
    this.shadowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (shadowColor ?? Colors.black).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: onTap != null ? iconColor : iconColor.withOpacity(0.5),
          size: size * 0.45,
        ),
      ),
    );
  }
}

