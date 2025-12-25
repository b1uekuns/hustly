import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/discover_user_model.dart';
import 'swipe_indicator.dart';
import '../../../profile_setup/presentation/pages/step5_dating_purpose_page.dart';

class ProfileCardContent extends StatefulWidget {
  final DiscoverUserModel user;
  final VoidCallback? onViewMore;
  final double swipeOpacity;
  final SwipeType? swipeType;

  // Layout constants
  static const double _indicatorTop = 8.0;
  static const double _indicatorHorizontal = 8.0;
  static const double _indicatorHeight = 3.0;
  static const double _indicatorMargin = 2.0;
  static const double _indicatorBorderRadius = 2.0;
  static const double _indicatorActiveOpacity = 1.0;
  static const double _indicatorInactiveOpacity = 0.4;

  static const double _tapZoneWidthRatio = 0.35;
  static const double _tapZoneBottom = 100.0;

  static const double _overlayHeight = 200.0;
  static const double _overlayOpacity = 0.9;

  static const double _contentHorizontal = 20.0;
  static const double _contentBottom = 20.0;

  static const double _nameFontSize = 26.0;
  static const double _nameSpacing = 12.0;

  static const double _statusIconSize = 18.0;
  static const double _statusSpacing = 6.0;
  static const double _statusFontSize = 14.0;
  static const double _statusRowSpacing = 8.0;

  static const double _emojiSize = 18.0;

  static const double _viewMoreButtonSize = 40.0;
  static const double _viewMorePadding = 8.0;
  static const double _viewMoreIconSize = 24.0;
  static const double _viewMoreBorderRadius = 24.0;
  static const double _viewMoreOpacity = 0.2;

  static const double _errorIconSize = 100.0;

  // Text constants
  static const String _searchingText = 'Đang tìm kiếm';
  static const String _viewMoreTooltip = 'Xem chi tiết';
  static const String _previousPhotoLabel = 'Ảnh trước';
  static const String _nextPhotoLabel = 'Ảnh tiếp theo';

  const ProfileCardContent({
    super.key,
    required this.user,
    this.onViewMore,
    this.swipeOpacity = 0.0,
    this.swipeType,
  });

  @override
  State<ProfileCardContent> createState() => _ProfileCardContentState();
}

class _ProfileCardContentState extends State<ProfileCardContent> {
  int _currentPhotoIndex = 0;

  List<String> get _photoUrls {
    final photos = widget.user.photos;
    if (photos.isEmpty) {
      return [widget.user.displayPhoto];
    }
    return photos.map((p) => p.url).toList();
  }

  void _nextPhoto() {
    if (_currentPhotoIndex < _photoUrls.length - 1) {
      HapticFeedback.selectionClick();
      setState(() => _currentPhotoIndex++);
    }
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      HapticFeedback.selectionClick();
      setState(() => _currentPhotoIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main photo - full screen
        Image.network(
          _photoUrls[_currentPhotoIndex],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: ProfileCardContent._errorIconSize,
              color: Colors.grey[400],
            ),
          ),
        ),

        // Story indicators at top
        if (_photoUrls.length > 1)
          Positioned(
            top: ProfileCardContent._indicatorTop,
            left: ProfileCardContent._indicatorHorizontal,
            right: ProfileCardContent._indicatorHorizontal,
            child: _buildStoryIndicators(),
          ),

        // Tap zones for navigation
        if (_photoUrls.length > 1) ...[
          // Left tap zone
          Positioned(
            left: 0,
            top: 0,
            bottom: ProfileCardContent._tapZoneBottom,
            width:
                MediaQuery.of(context).size.width *
                ProfileCardContent._tapZoneWidthRatio,
            child: Semantics(
              label: ProfileCardContent._previousPhotoLabel,
              button: true,
              child: GestureDetector(
                onTap: _previousPhoto,
                behavior: HitTestBehavior.translucent,
              ),
            ),
          ),
          // Right tap zone
          Positioned(
            right: 0,
            top: 0,
            bottom: ProfileCardContent._tapZoneBottom,
            width:
                MediaQuery.of(context).size.width *
                ProfileCardContent._tapZoneWidthRatio,
            child: Semantics(
              label: ProfileCardContent._nextPhotoLabel,
              button: true,
              child: GestureDetector(
                onTap: _nextPhoto,
                behavior: HitTestBehavior.translucent,
              ),
            ),
          ),
        ],

        // Dark overlay at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: ProfileCardContent._overlayHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(ProfileCardContent._overlayOpacity),
                ],
              ),
            ),
          ),
        ),

        // User info overlay
        Positioned(
          left: ProfileCardContent._contentHorizontal,
          right: ProfileCardContent._contentHorizontal,
          bottom: ProfileCardContent._contentBottom,
          child: Semantics(
            label: 'Thông tin ${widget.user.name}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name and age
                Text(
                  widget.user.age != null
                      ? '${widget.user.name}, ${widget.user.age}'
                      : widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ProfileCardContent._nameFontSize,
                  ),
                ),
                const SizedBox(height: ProfileCardContent._nameSpacing),

                // Status row
                Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white70,
                      size: ProfileCardContent._statusIconSize,
                    ),
                    const SizedBox(width: ProfileCardContent._statusSpacing),
                    const Text(
                      ProfileCardContent._searchingText,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: ProfileCardContent._statusFontSize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ProfileCardContent._statusRowSpacing),

                // Dating purpose
                Row(
                  children: [
                    Text(
                      DatingPurposeConstants.getEmoji(
                        widget.user.datingPurpose,
                      ),
                      style: const TextStyle(
                        fontSize: ProfileCardContent._emojiSize,
                      ),
                    ),
                    const SizedBox(width: ProfileCardContent._statusSpacing),
                    Text(
                      DatingPurposeConstants.getTitle(
                        widget.user.datingPurpose,
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: ProfileCardContent._statusFontSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Trong Stack
        if (widget.swipeOpacity > 0 && widget.swipeType != null)
          SwipeIndicator(type: widget.swipeType!, opacity: widget.swipeOpacity),

        // View more button (arrow up)
        if (widget.onViewMore != null)
          Positioned(
            right: ProfileCardContent._contentHorizontal,
            bottom: ProfileCardContent._contentBottom,
            child: Tooltip(
              message: ProfileCardContent._viewMoreTooltip,
              child: Semantics(
                label: ProfileCardContent._viewMoreTooltip,
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onViewMore?.call();
                    },
                    borderRadius: BorderRadius.circular(
                      ProfileCardContent._viewMoreBorderRadius,
                    ),
                    child: Container(
                      width: ProfileCardContent._viewMoreButtonSize,
                      height: ProfileCardContent._viewMoreButtonSize,
                      padding: const EdgeInsets.all(
                        ProfileCardContent._viewMorePadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          ProfileCardContent._viewMoreOpacity,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                        size: ProfileCardContent._viewMoreIconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStoryIndicators() {
    return Semantics(
      label: 'Ảnh ${_currentPhotoIndex + 1} / ${_photoUrls.length}',
      child: Row(
        children: List.generate(_photoUrls.length, (index) {
          final isActive = index == _currentPhotoIndex;
          return Expanded(
            child: Container(
              height: ProfileCardContent._indicatorHeight,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : ProfileCardContent._indicatorMargin,
                right: index == _photoUrls.length - 1
                    ? 0
                    : ProfileCardContent._indicatorMargin,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(
                        ProfileCardContent._indicatorActiveOpacity,
                      )
                    : Colors.white.withOpacity(
                        ProfileCardContent._indicatorInactiveOpacity,
                      ),
                borderRadius: BorderRadius.circular(
                  ProfileCardContent._indicatorBorderRadius,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
