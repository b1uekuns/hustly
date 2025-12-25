import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';

/// Widget hiển thị khi đang tải dữ liệu
class LoadingState extends StatefulWidget {
  // Animation constants
  static const Duration _animationDuration = Duration(milliseconds: 1500);
  static const double _pulseMin = 0.9;
  static const double _pulseMax = 1.1;
  static const double _fadeMin = 0.6;
  static const double _fadeMax = 1.0;
  static const double _containerPadding = 20.0;
  static const double _iconSize = 28.0;
  static const double _progressStrokeWidth = 3.0;
  static const double _shadowBlur = 20.0;
  static const double _shadowSpread = 5.0;
  static const double _shadowOpacity = 0.3;
  static const double _spacing = 20.0;
  static const double _fontSize = 15.0;
  static const String _loadingText = 'Đang tìm người phù hợp...';
  static const String _semanticLabel = 'Đang tải danh sách người dùng';

  const LoadingState({super.key});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: LoadingState._animationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: LoadingState._pulseMin,
      end: LoadingState._pulseMax,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: LoadingState._fadeMin,
      end: LoadingState._fadeMax,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LoadingState._semanticLabel,
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(
                      LoadingState._containerPadding,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.redPrimary.withOpacity(
                            LoadingState._shadowOpacity * _fadeAnimation.value,
                          ),
                          blurRadius: LoadingState._shadowBlur,
                          spreadRadius: LoadingState._shadowSpread,
                        ),
                      ],
                    ),
                    child: const SizedBox(
                      width: LoadingState._iconSize,
                      height: LoadingState._iconSize,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: LoadingState._progressStrokeWidth,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: LoadingState._spacing),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                LoadingState._loadingText,
                style: TextStyle(
                  fontSize: LoadingState._fontSize,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị khi có lỗi
class ErrorState extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  // Animation constants
  static const Duration _animationDuration = Duration(milliseconds: 800);
  static const double _scaleBegin = 0.5;
  static const double _scaleEnd = 1.0;
  static const double _fadeBegin = 0.0;
  static const double _fadeEnd = 1.0;
  static const double _iconSize = 56.0;
  static const double _iconPadding = 16.0;
  static const double _spacing = 24.0;
  static const double _fontSize = 15.0;
  static const double _buttonHorizontalPadding = 32.0;
  static const double _buttonVerticalPadding = 14.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _buttonElevation = 2.0;
  static const double _contentPadding = 24.0;
  static const String _retryButtonText = 'Thử lại';
  static const String _semanticLabel = 'Đã xảy ra lỗi';
  static const String _retryButtonSemanticLabel = 'Thử tải lại';
  static const String _retryButtonTooltip = 'Nhấn để thử lại';

  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  State<ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<ErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ErrorState._animationDuration,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: ErrorState._scaleBegin,
          end: ErrorState._scaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
          ),
        );

    _fadeAnimation =
        Tween<double>(
          begin: ErrorState._fadeBegin,
          end: ErrorState._fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
          ),
        );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: ErrorState._semanticLabel,
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(ErrorState._contentPadding),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(ErrorState._iconPadding),
                    decoration: BoxDecoration(
                      color: AppColor.redLight.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: ErrorState._iconSize,
                      color: AppColor.redLight,
                    ),
                  ),
                ),
                const SizedBox(height: ErrorState._spacing),
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ErrorState._fontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: ErrorState._spacing),
                      Tooltip(
                        message: ErrorState._retryButtonTooltip,
                        child: Semantics(
                          label: ErrorState._retryButtonSemanticLabel,
                          button: true,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              widget.onRetry();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            label: const Text(
                              ErrorState._retryButtonText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.redPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: ErrorState._buttonHorizontalPadding,
                                vertical: ErrorState._buttonVerticalPadding,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ErrorState._buttonBorderRadius,
                                ),
                              ),
                              elevation: ErrorState._buttonElevation,
                            ),
                          ),
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
    );
  }
}

/// Widget hiển thị khi hết người dùng
class NoMoreUsersState extends StatefulWidget {
  final VoidCallback onRefresh;

  // Animation constants
  static const Duration _entranceDuration = Duration(milliseconds: 800);
  static const Duration _bounceDuration = Duration(milliseconds: 2000);
  static const double _scaleBegin = 0.5;
  static const double _scaleEnd = 1.0;
  static const double _fadeBegin = 0.0;
  static const double _fadeEnd = 1.0;
  static const double _bounceMin = 0.95;
  static const double _bounceMax = 1.05;
  static const double _iconSize = 64.0;
  static const double _iconPadding = 20.0;
  static const double _iconOpacity = 0.7;
  static const double _containerOpacity = 0.1;
  static const double _shadowOpacity = 0.3;
  static const double _shadowBlur = 8.0;
  static const double _spacing = 24.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingLarge = 32.0;
  static const double _titleFontSize = 24.0;
  static const double _subtitleFontSize = 15.0;
  static const double _buttonFontSize = 16.0;
  static const double _textHeight = 1.5;
  static const double _buttonHorizontalPadding = 32.0;
  static const double _buttonVerticalPadding = 14.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _contentPadding = 24.0;
  static const String _title = 'Hết người rồi! 😅';
  static const String _subtitle = 'Quay lại sau để khám phá thêm nhé!';
  static const String _refreshButtonText = 'Tải lại';
  static const String _semanticLabel = 'Đã hết người dùng để khám phá';
  static const String _refreshButtonSemanticLabel =
      'Tải lại danh sách người dùng';
  static const String _refreshButtonTooltip = 'Nhấn để tải lại';

  const NoMoreUsersState({super.key, required this.onRefresh});

  @override
  State<NoMoreUsersState> createState() => _NoMoreUsersStateState();
}

class _NoMoreUsersStateState extends State<NoMoreUsersState>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _scaleController = AnimationController(
      duration: NoMoreUsersState._entranceDuration,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: NoMoreUsersState._scaleBegin,
          end: NoMoreUsersState._scaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
          ),
        );

    _fadeAnimation =
        Tween<double>(
          begin: NoMoreUsersState._fadeBegin,
          end: NoMoreUsersState._fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
          ),
        );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    // Continuous bounce animation for heart icon
    _bounceController = AnimationController(
      duration: NoMoreUsersState._bounceDuration,
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation =
        Tween<double>(
          begin: NoMoreUsersState._bounceMin,
          end: NoMoreUsersState._bounceMax,
        ).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
        );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: NoMoreUsersState._semanticLabel,
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(NoMoreUsersState._contentPadding),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated heart icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _bounceAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(
                            NoMoreUsersState._iconPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.redPrimary.withOpacity(
                              NoMoreUsersState._containerOpacity,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: NoMoreUsersState._iconSize,
                            color: AppColor.redPrimary.withOpacity(
                              NoMoreUsersState._iconOpacity,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: NoMoreUsersState._spacing),

                // Text content with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const Text(
                        NoMoreUsersState._title,
                        style: TextStyle(
                          fontSize: NoMoreUsersState._titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: NoMoreUsersState._spacingSmall),
                      Text(
                        NoMoreUsersState._subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: NoMoreUsersState._subtitleFontSize,
                          color: Colors.grey[600],
                          height: NoMoreUsersState._textHeight,
                        ),
                      ),
                      const SizedBox(height: NoMoreUsersState._spacingLarge),

                      // Refresh button
                      Tooltip(
                        message: NoMoreUsersState._refreshButtonTooltip,
                        child: Semantics(
                          label: NoMoreUsersState._refreshButtonSemanticLabel,
                          button: true,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                NoMoreUsersState._buttonBorderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.redPrimary.withOpacity(
                                    NoMoreUsersState._shadowOpacity,
                                  ),
                                  blurRadius: NoMoreUsersState._shadowBlur,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                widget.onRefresh();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              label: const Text(
                                NoMoreUsersState._refreshButtonText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: NoMoreUsersState._buttonFontSize,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      NoMoreUsersState._buttonHorizontalPadding,
                                  vertical:
                                      NoMoreUsersState._buttonVerticalPadding,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    NoMoreUsersState._buttonBorderRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
