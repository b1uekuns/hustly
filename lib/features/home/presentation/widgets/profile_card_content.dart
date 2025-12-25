import 'package:flutter/material.dart';
import '../../data/models/discover_user_model.dart';
import 'swipe_indicator.dart';

class ProfileCardContent extends StatefulWidget {
  final DiscoverUserModel user;
  final VoidCallback? onViewMore;
  final double swipeOpacity;
  final SwipeType? swipeType;

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
      setState(() => _currentPhotoIndex++);
    }
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
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
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: Icon(Icons.person, size: 100, color: Colors.grey[400]),
          ),
        ),

        // Story indicators at top
        if (_photoUrls.length > 1)
          Positioned(top: 8, left: 8, right: 8, child: _buildStoryIndicators()),

        // Tap zones for navigation
        if (_photoUrls.length > 1) ...[
          // Left tap zone
          Positioned(
            left: 0,
            top: 0,
            bottom: 100,
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: _previousPhoto,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          // Right tap zone
          Positioned(
            right: 0,
            top: 0,
            bottom: 100,
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: _nextPhoto,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        ],

        // Dark overlay at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
              ),
            ),
          ),
        ),

        // User info overlay
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name and age
              Text(
                '${widget.user.name}, ${widget.user.age ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 12),

              // Status row
              Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'Đang tìm kiếm',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dating purpose
              Row(
                children: [
                  const Text('😍', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    _getDatingPurposeText(widget.user.datingPurpose),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Trong Stack
        if (widget.swipeOpacity > 0 && widget.swipeType != null)
          SwipeIndicator(type: widget.swipeType!, opacity: widget.swipeOpacity),

        // View more button (arrow up)
        if (widget.onViewMore != null)
          Positioned(
            right: 20,
            bottom: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onViewMore,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStoryIndicators() {
    return Row(
      children: List.generate(_photoUrls.length, (index) {
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 2,
              right: index == _photoUrls.length - 1 ? 0 : 2,
            ),
            decoration: BoxDecoration(
              color: index == _currentPhotoIndex
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  String _getDatingPurposeText(String? purpose) {
    switch (purpose) {
      case 'relationship':
        return 'Bạn hẹn hò lâu dài';
      case 'friends':
        return 'Tìm bạn mới';
      case 'casual':
        return 'Không ràng buộc';
      case 'unsure':
        return 'Chưa rõ lắm';
      default:
        return 'Bạn hẹn hò lâu dài';
    }
  }
}
