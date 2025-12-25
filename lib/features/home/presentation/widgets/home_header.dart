import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

/// Header của trang Home với logo và nút settings
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  // Constants
  static const double _horizontalPadding = 8.0;
  static const double _logoIconPadding = 8.0;
  static const double _logoIconSize = 14.0;
  static const double _logoSpacing = 8.0;
  static const double _logoFontSize = 18.0;
  static const double _logoLetterSpacing = 0.5;
  static const double _settingsButtonSize = 36.0;
  static const double _settingsIconSize = 20.0;
  static const double _settingsBackgroundOpacity = 0.1;

  const HomeHeader({super.key, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildLogo(context), _buildSettingsButton()],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Semantics(
      label: 'Hustly',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(_logoIconPadding),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: _logoIconSize,
            ),
          ),
          const SizedBox(width: _logoSpacing),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColor.redPrimary, AppColor.redLight],
            ).createShader(bounds),
            child: const Text(
              'Hustly',
              style: TextStyle(
                fontSize: _logoFontSize,
                fontWeight: FontWeight.bold,
                color: AppColor.white,
                letterSpacing: _logoLetterSpacing,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return _AnimatedSettingsButton(onTap: onSettingsTap);
  }
}

/// Animated settings button with scale effect
class _AnimatedSettingsButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _AnimatedSettingsButton({this.onTap});

  @override
  State<_AnimatedSettingsButton> createState() =>
      _AnimatedSettingsButtonState();
}

class _AnimatedSettingsButtonState extends State<_AnimatedSettingsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Bộ lọc tìm kiếm',
      child: Semantics(
        label: 'Mở bộ lọc tìm kiếm',
        button: true,
        enabled: widget.onTap != null,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: HomeHeader._settingsButtonSize,
                height: HomeHeader._settingsButtonSize,
                decoration: BoxDecoration(
                  color: AppColor.redLight.withOpacity(
                    HomeHeader._settingsBackgroundOpacity,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColor.redLight,
                  size: HomeHeader._settingsIconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
