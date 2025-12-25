import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/app_color.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.close,
          color: AppColor.redLight,
          iconColor: Colors.white,
          size: 56,
          semanticLabel: 'Bỏ qua',
          onTap: isDisabled ? null : onPass,
        ),
        _ActionButton(
          icon: Icons.favorite,
          color: Colors.green.shade400,
          iconColor: Colors.white,
          size: 56,
          semanticLabel: 'Thích',
          onTap: isDisabled ? null : onLike,
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final Gradient? gradient;
  final Color iconColor;
  final double size;
  final Color? shadowColor;
  final String semanticLabel;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.color,
    this.gradient,
    required this.iconColor,
    required this.size,
    this.shadowColor,
    required this.semanticLabel,
    this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  static const double _iconSizeRatio = 0.45;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.onTap != null,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.gradient == null ? widget.color : null,
              gradient: widget.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.shadowColor ?? Colors.black).withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: widget.onTap != null
                  ? widget.iconColor
                  : widget.iconColor.withOpacity(0.5),
              size: widget.size * _iconSizeRatio,
            ),
          ),
        ),
      ),
    );
  }
}
