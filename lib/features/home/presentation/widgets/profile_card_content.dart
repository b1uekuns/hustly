import 'package:flutter/material.dart';
import '../../../../core/resources/app_color.dart';
import '../../data/models/discover_user_model.dart';

class ProfileCardContent extends StatelessWidget {
  final DiscoverUserModel user;
  final ScrollController scrollController;

  const ProfileCardContent({
    super.key,
    required this.user,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final photos = user.photos;
    final mainPhoto = photos.isNotEmpty ? photos.first.url : user.displayPhoto;

    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Main photo
        SliverToBoxAdapter(
          child: _MainPhotoSection(user: user, mainPhoto: mainPhoto),
        ),

        // Bio
        if (user.bio != null && user.bio!.isNotEmpty)
          SliverToBoxAdapter(child: _BioSection(bio: user.bio!)),

        // Interests
        if (user.interests.isNotEmpty)
          SliverToBoxAdapter(child: _InterestsSection(interests: user.interests)),

        // Additional photos
        if (photos.length > 1)
          SliverToBoxAdapter(
            child: _AdditionalPhotosSection(photos: photos.skip(1).toList()),
          ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

class _MainPhotoSection extends StatelessWidget {
  final DiscoverUserModel user;
  final String mainPhoto;

  const _MainPhotoSection({required this.user, required this.mainPhoto});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            mainPhoto,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: Icon(Icons.person, size: 100, color: Colors.grey[400]),
            ),
          ),
          // Gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),
          // User info
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${user.name}, ${user.age ?? '?'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ],
                ),
                if (user.major != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.major!,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (user.datingPurpose != null) ...[
                  const SizedBox(height: 6),
                  _DatingPurposeBadge(purpose: user.datingPurpose!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DatingPurposeBadge extends StatelessWidget {
  final String purpose;

  const _DatingPurposeBadge({required this.purpose});

  @override
  Widget build(BuildContext context) {
    final config = _getPurposeConfig(purpose);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 14),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _PurposeConfig _getPurposeConfig(String purpose) {
    switch (purpose) {
      case 'relationship':
        return _PurposeConfig(
          icon: Icons.favorite,
          label: 'Tìm người yêu',
          color: Colors.pink,
        );
      case 'friends':
        return _PurposeConfig(
          icon: Icons.people,
          label: 'Tìm bạn mới',
          color: Colors.blue,
        );
      case 'casual':
        return _PurposeConfig(
          icon: Icons.local_fire_department,
          label: 'Không ràng buộc',
          color: Colors.orange,
        );
      case 'unsure':
      default:
        return _PurposeConfig(
          icon: Icons.help_outline,
          label: 'Chưa rõ lắm',
          color: Colors.grey,
        );
    }
  }
}

class _PurposeConfig {
  final IconData icon;
  final String label;
  final Color color;

  _PurposeConfig({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _BioSection extends StatelessWidget {
  final String bio;

  const _BioSection({required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: AppColor.redPrimary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Giới thiệu',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bio,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _InterestsSection extends StatelessWidget {
  final List<String> interests;

  const _InterestsSection({required this.interests});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.interests_outlined, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Sở thích',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) => _InterestChip(interest: interest)).toList(),
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String interest;

  const _InterestChip({required this.interest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.redPrimary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.redPrimary.withOpacity(0.2)),
      ),
      child: Text(
        interest,
        style: TextStyle(fontSize: 13, color: AppColor.redPrimary),
      ),
    );
  }
}

class _AdditionalPhotosSection extends StatelessWidget {
  final List<PhotoData> photos;

  const _AdditionalPhotosSection({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.photo_library_outlined, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Ảnh khác',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ...photos.map((photo) => _PhotoItem(url: photo.url)),
        ],
      ),
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final String url;

  const _PhotoItem({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}

