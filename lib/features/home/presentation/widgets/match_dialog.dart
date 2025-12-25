import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../../data/models/discover_user_model.dart';

class MatchDialog extends StatefulWidget {
  final MatchedUserData matchedUser;
  final String? currentUserPhoto;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  // Animation constants
  static const Duration _animationDuration = Duration(milliseconds: 600);
  static const double _scaleBegin = 0.5;
  static const double _scaleEnd = 1.0;
  static const double _fadeBegin = 0.0;
  static const double _fadeEnd = 1.0;

  // Layout constants
  static const double _dialogPadding = 24.0;
  static const double _dialogBorderRadius = 28.0;
  static const double _shadowBlur = 30.0;
  static const double _shadowSpread = 5.0;
  static const double _shadowOpacity = 0.3;

  static const double _heartIconPadding = 16.0;
  static const double _heartIconSize = 48.0;
  static const double _spacing = 24.0;
  static const double _spacingSmall = 12.0;
  static const double _spacingMedium = 16.0;
  static const double _spacingLarge = 32.0;

  static const double _titleFontSize = 32.0;
  static const double _subtitleFontSize = 16.0;

  static const double _profilePhotoSize = 80.0;
  static const double _profileBorderWidth = 3.0;
  static const double _profileShadowBlur = 10.0;
  static const double _profileShadowSpread = 2.0;
  static const double _profileShadowOpacity = 0.2;

  static const double _centerHeartPadding = 8.0;
  static const double _centerHeartSize = 24.0;
  static const double _centerHeartOpacity = 0.1;

  static const double _buttonVerticalPadding = 14.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _buttonSpacing = 12.0;
  static const double _buttonShadowBlur = 8.0;
  static const double _buttonShadowOpacity = 0.3;

  static const double _placeholderIconSize = 40.0;

  // Text constants
  static const String _titleText = "It's a Match! 💕";
  static const String _keepSwipingText = 'Tiếp tục';
  static const String _sendMessageText = 'Nhắn tin';
  static const String _keepSwipingTooltip = 'Tiếp tục tìm kiếm';
  static const String _sendMessageTooltip = 'Gửi tin nhắn cho người này';
  static const String _dialogSemanticLabel = 'Đã ghép đôi thành công';

  const MatchDialog({
    super.key,
    required this.matchedUser,
    this.currentUserPhoto,
    required this.onSendMessage,
    required this.onKeepSwiping,
  });

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact(); // Celebrate the match!
    _controller = AnimationController(
      duration: MatchDialog._animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: MatchDialog._scaleBegin,
      end: MatchDialog._scaleEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(
      begin: MatchDialog._fadeBegin,
      end: MatchDialog._fadeEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
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
      label: MatchDialog._dialogSemanticLabel,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(MatchDialog._dialogPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MatchDialog._dialogBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.redPrimary.withOpacity(
                      MatchDialog._shadowOpacity,
                    ),
                    blurRadius: MatchDialog._shadowBlur,
                    spreadRadius: MatchDialog._shadowSpread,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hearts animation
                  Container(
                    padding: const EdgeInsets.all(
                      MatchDialog._heartIconPadding,
                    ),
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: MatchDialog._heartIconSize,
                    ),
                  ),
                  const SizedBox(height: MatchDialog._spacing),

                  // "It's a Match!" text
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColor.redPrimary, AppColor.redLight],
                    ).createShader(bounds),
                    child: const Text(
                      MatchDialog._titleText,
                      style: TextStyle(
                        fontSize: MatchDialog._titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: MatchDialog._spacingSmall),

                  Semantics(
                    label: 'Bạn và ${widget.matchedUser.name} đã thích nhau',
                    child: Text(
                      'Bạn và ${widget.matchedUser.name} đã thích nhau!',
                      style: TextStyle(
                        fontSize: MatchDialog._subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: MatchDialog._spacing),

                  // Profile photos
                  Semantics(
                    label: 'Ảnh đại diện của bạn và ${widget.matchedUser.name}',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current user
                        _buildProfileCircle(
                          imageUrl: widget.currentUserPhoto,
                          isCurrentUser: true,
                        ),
                        const SizedBox(width: MatchDialog._spacingMedium),
                        // Heart between
                        Container(
                          padding: const EdgeInsets.all(
                            MatchDialog._centerHeartPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.redPrimary.withOpacity(
                              MatchDialog._centerHeartOpacity,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: AppColor.redPrimary,
                            size: MatchDialog._centerHeartSize,
                          ),
                        ),
                        const SizedBox(width: MatchDialog._spacingMedium),
                        // Matched user
                        _buildProfileCircle(
                          imageUrl: widget.matchedUser.mainPhoto,
                          isCurrentUser: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: MatchDialog._spacingLarge),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: MatchDialog._keepSwipingTooltip,
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              widget.onKeepSwiping();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: MatchDialog._buttonVerticalPadding,
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  MatchDialog._buttonBorderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              MatchDialog._keepSwipingText,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: MatchDialog._buttonSpacing),
                      Expanded(
                        child: Tooltip(
                          message: MatchDialog._sendMessageTooltip,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                MatchDialog._buttonBorderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.redPrimary.withOpacity(
                                    MatchDialog._buttonShadowOpacity,
                                  ),
                                  blurRadius: MatchDialog._buttonShadowBlur,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                widget.onSendMessage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: MatchDialog._buttonVerticalPadding,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    MatchDialog._buttonBorderRadius,
                                  ),
                                ),
                              ),
                              child: const Text(
                                MatchDialog._sendMessageText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCircle({String? imageUrl, required bool isCurrentUser}) {
    return Container(
      width: MatchDialog._profilePhotoSize,
      height: MatchDialog._profilePhotoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrentUser ? AppColor.redPrimary : AppColor.redLight,
          width: MatchDialog._profileBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.redPrimary.withOpacity(
              MatchDialog._profileShadowOpacity,
            ),
            blurRadius: MatchDialog._profileShadowBlur,
            spreadRadius: MatchDialog._profileShadowSpread,
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: MatchDialog._placeholderIconSize,
        color: Colors.grey[400],
      ),
    );
  }
}
