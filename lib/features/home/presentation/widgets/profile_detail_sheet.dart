import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/app_color.dart';
import '../../data/models/discover_user_model.dart';
import '../bloc/discover_bloc.dart';
import 'swipe_action_buttons.dart';
import '../../../profile_setup/presentation/pages/step5_dating_purpose_page.dart';

/// Bottom sheet hiển thị thông tin chi tiết profile user
/// Sử dụng DraggableScrollableSheet để có thể scroll và drag
class ProfileDetailSheet extends StatelessWidget {
  final DiscoverUserModel user;

  const ProfileDetailSheet({super.key, required this.user});

  // ==================== SHEET CONSTANTS ====================
  /// Kích thước khởi tạo của sheet (90% screen)
  static const double _initialChildSize = 0.9;

  /// Kích thước tối thiểu (50% screen)
  static const double _minChildSize = 0.5;

  /// Kích thước tối đa (95% screen)
  static const double _maxChildSize = 0.95;

  // ==================== SPACING CONSTANTS ====================
  /// Padding ngang cho các section
  static const double _horizontalPadding = 20.0;

  /// Padding dọc cho header
  static const double _headerVerticalPadding = 8.0;

  /// Padding dọc cho các section
  static const double _sectionVerticalPadding = 8.0;

  /// Padding cho section content
  static const double _sectionContentPadding = 16.0;

  /// Spacing nhỏ giữa các elements
  static const double _smallSpacing = 4.0;

  /// Spacing trung bình
  static const double _mediumSpacing = 8.0;

  /// Spacing lớn
  static const double _largeSpacing = 12.0;

  /// Spacing cho profile header
  static const double _profileHeaderSpacing = 20.0;

  /// Spacing cho bottom padding
  static const double _bottomSpacing = 100.0;

  // ==================== SIZE CONSTANTS ====================
  /// Chiều rộng drag handle
  static const double _dragHandleWidth = 40.0;

  /// Chiều cao drag handle
  static const double _dragHandleHeight = 4.0;

  /// Chiều cao profile image
  static const double _profileImageHeight = 300.0;

  /// Icon size nhỏ
  static const double _smallIconSize = 18.0;

  /// Icon size trung bình
  static const double _mediumIconSize = 20.0;

  /// Icon size lớn (emoji)
  static const double _emojiSize = 24.0;

  // ==================== BORDER RADIUS CONSTANTS ====================
  /// Border radius cho sheet top
  static const double _sheetBorderRadius = 20.0;

  /// Border radius cho drag handle
  static const double _dragHandleBorderRadius = 2.0;

  /// Border radius cho sections
  static const double _sectionBorderRadius = 12.0;

  /// Border radius cho interest chips
  static const double _chipBorderRadius = 20.0;

  /// Border radius cho action buttons
  static const double _buttonBorderRadius = 30.0;

  // ==================== TEXT SIZE CONSTANTS ====================
  /// Font size cho tên user (header)
  static const double _nameTextSize = 28.0;

  /// Font size cho title
  static const double _titleTextSize = 18.0;

  /// Font size cho body text
  static const double _bodyTextSize = 16.0;

  /// Font size cho label text
  static const double _labelTextSize = 14.0;

  // ==================== SHADOW CONSTANTS ====================
  /// Shadow blur radius
  static const double _shadowBlurRadius = 10.0;

  /// Shadow opacity
  static const double _shadowOpacity = 0.05;

  /// Shadow Y offset
  static const double _shadowOffsetY = -5.0;

  // ==================== INTEREST CHIP CONSTANTS ====================
  /// Padding ngang cho interest chips
  static const double _chipHorizontalPadding = 16.0;

  /// Padding dọc cho interest chips
  static const double _chipVerticalPadding = 10.0;

  // ==================== MAX LINES CONSTANTS ====================
  /// Số dòng tối đa cho text
  static const int _maxLines = 2;

  /// Show profile detail sheet với haptic feedback
  static void show(BuildContext context, DiscoverUserModel user) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileDetailSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _initialChildSize,
      minChildSize: _minChildSize,
      maxChildSize: _maxChildSize,
      builder: (context, scrollController) {
        return Semantics(
          label: 'Chi tiết hồ sơ của ${user.name}',
          container: true,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_sheetBorderRadius),
              ),
            ),
            child: Column(
              children: [
                // Header with close button
                _buildHeader(context),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image
                        _buildProfileImage(),

                        // Profile header with name and verified badge
                        _buildProfileHeader(),

                        // Dating info section (combined searching + purpose)
                        _buildDatingInfoSection(),

                        // Main information section
                        _buildMainInfoSection(),

                        // Additional info sections
                        if (user.major != null)
                          _buildInfoItem(
                            'Trường/Khoa/Viện',
                            user.major!,
                            Icons.school,
                          ),
                        if (user.education != null)
                          _buildInfoItem(
                            'Giáo dục',
                            user.education!,
                            Icons.school_outlined,
                          ),

                        // Interests section
                        if (user.interests.isNotEmpty) _buildInterestsSection(),

                        // Action buttons
                        _buildActionButtons(context),

                        const SizedBox(height: _bottomSpacing),
                      ],
                    ),
                  ),
                ),

                // Bottom action buttons
                _buildBottomActions(context),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Drag handle ở top của sheet
  Widget _buildHeader(BuildContext context) {
    return Semantics(
      label: 'Kéo để đóng',
      hint: 'Vuốt xuống để đóng chi tiết hồ sơ',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: _headerVerticalPadding),
        child: Center(
          child: Container(
            width: _dragHandleWidth,
            height: _dragHandleHeight,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(_dragHandleBorderRadius),
            ),
          ),
        ),
      ),
    );
  }

  /// Profile image với error handling và loading state
  Widget _buildProfileImage() {
    final photos = user.photos;
    final mainPhoto = photos.isNotEmpty ? photos.first.url : user.displayPhoto;

    return Semantics(
      label: 'Ảnh hồ sơ của ${user.name}',
      image: true,
      child: Container(
        height: _profileImageHeight,
        width: double.infinity,
        color: Colors.grey[200],
        child: Image.network(
          mainPhoto,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  SizedBox(height: _mediumSpacing),
                  Text(
                    'Không thể tải ảnh',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Header với tên và tuổi
  Widget _buildProfileHeader() {
    return Semantics(
      header: true,
      label: '${user.name}, ${user.age ?? ''} tuổi',
      child: Padding(
        padding: const EdgeInsets.all(_profileHeaderSpacing),
        child: Row(
          children: [
            Flexible(
              child: Text(
                '${user.name}, ${user.age ?? ''}',
                style: const TextStyle(
                  fontSize: _nameTextSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section hiển thị mục đích hẹn hò
  Widget _buildDatingInfoSection() {
    final datingTitle = DatingPurposeConstants.getTitle(user.datingPurpose);
    final datingSubtitle = DatingPurposeConstants.getSubtitle(
      user.datingPurpose,
    );

    return Semantics(
      label: 'Đang tìm kiếm $datingTitle, $datingSubtitle',
      container: true,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _sectionVerticalPadding,
        ),
        padding: const EdgeInsets.all(_sectionContentPadding),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(_sectionBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: _smallIconSize,
                ),
                const SizedBox(width: _mediumSpacing),
                const Text(
                  'Đang tìm kiếm',
                  style: TextStyle(
                    fontSize: _labelTextSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: _largeSpacing),
            Row(
              children: [
                Text(
                  DatingPurposeConstants.getEmoji(user.datingPurpose),
                  style: const TextStyle(fontSize: _emojiSize),
                ),
                const SizedBox(width: _largeSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        datingTitle,
                        style: const TextStyle(
                          fontSize: _titleTextSize,
                          color: AppColor.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: _smallSpacing),
                      Text(
                        datingSubtitle,
                        style: const TextStyle(
                          fontSize: _labelTextSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Section hiển thị thông tin chính (khoảng cách, giới tính)
  Widget _buildMainInfoSection() {
    final genderText = user.gender == 'male'
        ? 'Nam'
        : user.gender == 'female'
        ? 'Nữ'
        : user.gender ?? '';

    return Semantics(
      label:
          'Thông tin chính: '
          '${user.distance != null ? 'Cách xa ${user.distance} km, ' : ''}'
          '${user.gender != null ? 'Giới tính $genderText' : ''}',
      container: true,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _sectionVerticalPadding,
        ),
        padding: const EdgeInsets.all(_sectionContentPadding),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(_sectionBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: _smallIconSize,
                  color: Colors.grey,
                ),
                const SizedBox(width: _mediumSpacing),
                const Text(
                  'Thông tin chính',
                  style: TextStyle(
                    fontSize: _bodyTextSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: _mediumSpacing),
            if (user.distance != null)
              _buildInfoRow(Icons.location_on, 'Cách xa ${user.distance} km'),
            if (user.gender != null) ...[
              const SizedBox(height: _mediumSpacing),
              _buildInfoRow(Icons.wc, genderText),
            ],
          ],
        ),
      ),
    );
  }

  /// Generic info item widget (education, major, etc.)
  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Semantics(
      label: '$title: $value',
      container: true,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _smallSpacing,
        ),
        padding: const EdgeInsets.all(_sectionContentPadding),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(_sectionBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: _smallIconSize, color: Colors.grey),
                const SizedBox(width: _mediumSpacing),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: _bodyTextSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: _mediumSpacing),
            Text(
              value,
              style: const TextStyle(
                fontSize: _bodyTextSize,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: _maxLines,
            ),
          ],
        ),
      ),
    );
  }

  /// Section hiển thị các sở thích
  Widget _buildInterestsSection() {
    return Semantics(
      label: 'Sở thích: ${user.interests.join(', ')}',
      container: true,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _sectionVerticalPadding,
        ),
        padding: const EdgeInsets.all(_sectionContentPadding),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(_sectionBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.grid_view,
                  size: _smallIconSize,
                  color: Colors.grey,
                ),
                const SizedBox(width: _mediumSpacing),
                const Text(
                  'Sở Thích',
                  style: TextStyle(
                    fontSize: _bodyTextSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: _largeSpacing),
            Wrap(
              spacing: _mediumSpacing,
              runSpacing: _mediumSpacing,
              children: user.interests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _chipHorizontalPadding,
                    vertical: _chipVerticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_chipBorderRadius),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    interest,
                    style: const TextStyle(
                      fontSize: _labelTextSize,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Các nút action (share, block, report)
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          'Chia sẻ hồ sơ của ${user.name}',
          Colors.white,
          Colors.black,
          Icons.share,
          'Chia sẻ hồ sơ',
          () {
            HapticFeedback.lightImpact();
            // TODO: Handle share
          },
        ),
        _buildActionButton(
          'Chặn ${user.name}',
          Colors.white,
          Colors.black,
          Icons.block,
          'Chặn người dùng',
          () {
            HapticFeedback.mediumImpact();
            // TODO: Handle block
          },
        ),
        _buildActionButton(
          'Báo Cáo ${user.name}',
          Colors.white,
          Colors.red,
          Icons.flag,
          'Báo cáo vi phạm',
          () {
            HapticFeedback.mediumImpact();
            // TODO: Handle report
          },
        ),
      ],
    );
  }

  /// Generic action button với haptic feedback và tooltip
  Widget _buildActionButton(
    String text,
    Color bgColor,
    Color textColor,
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Semantics(
      button: true,
      label: text,
      hint: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _smallSpacing,
        ),
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: _sectionContentPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: textColor, size: _mediumIconSize),
                    const SizedBox(width: _mediumSpacing),
                    Flexible(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: _bodyTextSize,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom action buttons (Like/Pass)
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _sectionContentPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_shadowOpacity),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffsetY),
          ),
        ],
      ),
      child: SafeArea(
        child: SwipeActionButtons(
          isDisabled: false,
          onPass: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            context.read<DiscoverBloc>().add(DiscoverEvent.passUser(user.id));
          },
          onLike: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
            context.read<DiscoverBloc>().add(DiscoverEvent.likeUser(user.id));
          },
        ),
      ),
    );
  }

  /// Row hiển thị icon + text
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: _smallIconSize, color: Colors.grey[700]),
        const SizedBox(width: _mediumSpacing),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: _bodyTextSize,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
