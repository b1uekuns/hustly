import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/utils/app_style.dart';

import '../../core/utils/app_color.dart';

enum SnackType { success, error, warning, info }

class AppSnackbar {
  static OverlayEntry? _currentOverlay;

  static void showSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    SnackType type = SnackType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    final overlay = Overlay.of(context);
    _currentOverlay?.remove(); // remove cái cũ nếu đang hiện

    Color bgColor;
    IconData icon;
    switch (type) {
      case SnackType.error:
        bgColor = Colors.redAccent.withOpacity(0.8);
        icon = Icons.error;
        break;
      case SnackType.warning:
        bgColor = Colors.orangeAccent.withOpacity(0.8);
        icon = Icons.warning;
        break;
      case SnackType.info:
        bgColor = Colors.blueAccent.withOpacity(0.8);
        icon = Icons.info_outline;
        break;
      default:
        bgColor = Colors.green.withOpacity(0.8);
        icon = Icons.check_circle;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 16,
        right: 16,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, -20 * (1 - value)),
              child: child,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: AppColor.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "$title\n$message",
                          style: AppStyle.def.bold
                              .size(16)
                              .colors(AppColor.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _currentOverlay = overlayEntry;

    Future.delayed(duration, () {
      if (overlayEntry.mounted) overlayEntry.remove();
      if (_currentOverlay == overlayEntry) _currentOverlay = null;
    });
  }
}
