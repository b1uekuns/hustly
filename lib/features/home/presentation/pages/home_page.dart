import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/widgets/navBar/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _currentCardIndex = 0;

  final List<ProfileCard> profiles = [
    ProfileCard(
      name: 'Maria',
      year: 'K67',
      profession: 'Model',
      distance: '2 miles',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    ProfileCard(
      name: 'Sophie',
      year: 'K70',
      profession: 'Trường Điện',
      distance: '5 miles',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    ProfileCard(
      name: 'Emma',
      year: 'K69',
      profession: 'Trường Hóa và Khoa học sự sống',
      distance: '3 miles',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    ProfileCard(
      name: 'Lily',
      year: 'K68',
      profession: 'Khoa Khoa học và Công nghệ',
      distance: '4 miles',
      imageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    ProfileCard(
      name: 'Anna',
      year: 'K68',
      profession: 'Trường Công nghệ thông tin và Truyền thông',
      distance: '1 mile',
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink.shade100,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColor.redPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Hustly',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColor.redPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.redExtraLight.withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: AppColor.redPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Card Stack
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  children: [
                    for (int i = profiles.length - 1; i >= 0; i--)
                      if (i >= _currentCardIndex)
                        Positioned(
                          top: (i - _currentCardIndex) * 4.0,
                          left: (i - _currentCardIndex) * 2.0,
                          right: (i - _currentCardIndex) * 2.0,
                          bottom: 0,
                          child: GestureDetector(
                            onPanUpdate: i == _currentCardIndex
                                ? _onPanUpdate
                                : null,
                            onPanEnd: i == _currentCardIndex ? _onPanEnd : null,
                            child: Transform.scale(
                              scale: 1.0 - (i - _currentCardIndex) * 0.02,
                              child: _buildProfileCard(profiles[i]),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.grey.shade300,
                    iconColor: Colors.grey.shade600,
                    onTap: () => _handleSwipe(false),
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: Colors.pink.shade100,
                    iconColor: Colors.pink,
                    size: 60,
                    onTap: () => _handleSwipe(true),
                  ),
                  _buildActionButton(
                    icon: Icons.star,
                    color: Colors.blue.shade100,
                    iconColor: Colors.blue,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Xử lý chuyển tab nếu cần
        },
      ),
    );
  }

  Widget _buildProfileCard(ProfileCard profile) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: NetworkImage(profile.imageUrl),
            fit: BoxFit.cover,
            //alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            // Overlay màu hồng nhạt phía dưới
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 160,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pinkAccent.withOpacity(0.0),
                      Colors.pinkAccent.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Icon location góc trên trái
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.pinkAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      profile.distance,
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info dưới cùng
            Positioned(
              left: 32,
              right: 32,
              bottom: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.name}, ${profile.year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    profile.profession,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      shadows: [Shadow(color: Colors.black12, blurRadius: 6)],
                    ),
                  ),
                ],
              ),
            ),
            // Nút more góc phải
            Positioned(
              right: 32,
              bottom: 48,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(Icons.more_vert, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    double size = 50,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Handle card dragging animation here if needed
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 100.0;
    if (details.velocity.pixelsPerSecond.dx > threshold) {
      _handleSwipe(true); // Swipe right (like)
    } else if (details.velocity.pixelsPerSecond.dx < -threshold) {
      _handleSwipe(false); // Swipe left (dislike)
    }
  }

  void _handleSwipe(bool isLike) {
    if (_currentCardIndex < profiles.length - 1) {
      setState(() {
        _currentCardIndex++;
      });
    } else {
      // No more cards
      setState(() {
        _currentCardIndex = 0; // Reset for demo purposes
      });
    }
  }
}

class ProfileCard {
  final String name;
  final String year;
  final String profession;
  final String distance;
  final String imageUrl;

  ProfileCard({
    required this.name,
    required this.year,
    required this.profession,
    required this.distance,
    required this.imageUrl,
  });
}
