import 'package:flutter/material.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

/// Header của trang Home với logo và nút settings
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const HomeHeader({
    super.key,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(),
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColor.redPrimary, AppColor.redLight],
          ).createShader(bounds),
          child: const Text(
            'Hustly',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: onSettingsTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.tune, color: Colors.grey[700], size: 18),
      ),
    );
  }
}

