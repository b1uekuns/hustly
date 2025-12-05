import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

class PendingApprovalPage extends StatefulWidget {
  const PendingApprovalPage({super.key});

  @override
  State<PendingApprovalPage> createState() => _PendingApprovalPageState();
}

class _PendingApprovalPageState extends State<PendingApprovalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  Timer? _autoCheckTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Auto-check approval status every 30 seconds
    _startAutoCheck();
  }

  void _startAutoCheck() {
    _autoCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthEvent.authCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          if (state.isApproved) {
            // Navigate to home when approved
            context.go(AppPage.home.toPath());
          } else if (state.isRejected) {
            // Show rejection message
            _showRejectionDialog(
              state.rejectionReason ?? 'Không có lý do cụ thể',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Icon with Glow Effect
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.redPrimary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: AppColor.redLight.withOpacity(0.2),
                            blurRadius: 50,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.hourglass_top_rounded,
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColor.redPrimary, AppColor.redLight],
                    ).createShader(bounds),
                    child: const Text(
                      'Đang chờ phê duyệt',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Hồ sơ của bạn đang được xem xét.\nBạn sẽ tự động vào ứng dụng khi được duyệt!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildStepItem(
                          icon: Icons.check_circle,
                          title: 'Đăng ký thành công',
                          isCompleted: true,
                        ),
                        _buildConnector(),
                        _buildStepItem(
                          icon: Icons.pending,
                          title: 'Đang chờ admin duyệt',
                          isCompleted: false,
                          isActive: true,
                        ),
                        _buildConnector(),
                        _buildStepItem(
                          icon: Icons.home,
                          title: 'Vào ứng dụng',
                          isCompleted: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Auto-refresh indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.redPrimary.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tự động kiểm tra trạng thái...',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.blackLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Time estimate
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.redPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColor.redPrimary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColor.redPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Thường mất 1-24 giờ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColor.redPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String title,
    required bool isCompleted,
    bool isActive = false,
  }) {
    final color = isCompleted
        ? Colors.green
        : isActive
            ? AppColor.redPrimary
            : Colors.grey.shade400;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: isCompleted
                ? const LinearGradient(colors: [Colors.green, Colors.lightGreen])
                : isActive
                    ? AppTheme.primaryGradient
                    : null,
            color: !isCompleted && !isActive ? Colors.grey.shade200 : null,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColor.redPrimary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isCompleted || isActive ? Colors.white : color,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isCompleted || isActive
                  ? AppColor.blackPrimary
                  : Colors.grey.shade500,
            ),
          ),
        ),
        if (isActive)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColor.redPrimary,
            ),
          ),
      ],
    );
  }

  Widget _buildConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 19),
      width: 2,
      height: 24,
      color: Colors.grey.shade300,
    );
  }

  void _showRejectionDialog(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Hồ sơ bị từ chối'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lý do:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(reason),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
              context.go(AppPage.login.toPath());
            },
            child: const Text('Đăng nhập lại'),
          ),
        ],
      ),
    );
  }
}
