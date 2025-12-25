import 'package:flutter/material.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

/// Header của trang Home với logo và nút settings
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const HomeHeader({super.key, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildLogo(), _buildSettingsButton()],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColor.redPrimary, AppColor.redLight],
          ).createShader(bounds),
          child: const Text(
            'Hustly',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSettingsTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColor.redLight.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.tune, color: AppColor.redLight, size: 20),
        ),
      ),
    );
  }
}
