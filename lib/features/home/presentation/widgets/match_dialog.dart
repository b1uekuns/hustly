import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/resources/app_assets.dart';
import '../../../../core/resources/app_color.dart';
import '../../data/models/discover_user_model.dart';

class MatchDialog extends StatefulWidget {
  final MatchedUserData matchedUser;
  final String? currentUserPhoto;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

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
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late ConfettiController _confettiWidgetController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideLeftAnimation;
  late Animation<Offset> _slideRightAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();

    // Controller cho hiệu ứng xuất hiện
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Tăng thời gian
      vsync: this,
    );

    // AVATAR TRÁI: Trượt vào -> Va chạm (overlap nhiều) -> Nảy lại
    _slideLeftAnimation = TweenSequence<Offset>([
      // Giai đoạn 1: Trượt vào nhanh (0% -> 70%)
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-2.0, 0.0),
          end: const Offset(0.05, 0.0), // Chồng LÊN giữa màn hình
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      // Giai đoạn 2: Nảy lại một chút (70% -> 100%)
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.05, 0.0),
          end: const Offset(-0.05, 0.0), // Nảy ra về trái
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_entryController);

    // AVATAR PHẢI: Tương tự nhưng ngược chiều
    _slideRightAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(2.0, 0.0),
          end: const Offset(
            -0.05,
            0.0,
          ), // Chồng LÊN giữa màn hình (ngược chiều)
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-0.05, 0.0),
          end: const Offset(0.05, 0.0), // Nảy ra về phải
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_entryController);

    // Scale animation cho title và heart
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Controller cho pháo giấy
    _confettiWidgetController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Chạy animation
    _entryController.forward().then((_) {
      _confettiWidgetController.play();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _confettiWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dialog chính
        Dialog(
          backgroundColor: const Color.fromARGB(150, 0, 0, 0),
          insetPadding: const EdgeInsets.all(20),
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Lớp nền mờ (Glassmorphism)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
              ),

              // Nội dung chính
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Title "It's a Match"
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildGradientTitle(),
                    ),

                    // 2. Hai Avatar va vào nhau - CHỒNG LÊN NHAU NHIỀU
                    SizedBox(
                      height: 160,
                      width: 250, // Thu nhỏ width để avatar chồng lên nhiều hơn
                      child: Stack(
                        alignment: Alignment.center,
                        // clipBehavior:
                        //     Clip.none, // Cho phép avatar tràn ra ngoài
                        children: [
                          // Avatar User (Trái)
                          Positioned(
                            left: 0,
                            child: SlideTransition(
                              position: _slideLeftAnimation,
                              child: _buildAvatarCircle(
                                widget.currentUserPhoto,
                                true,
                              ),
                            ),
                          ),
                          // Avatar Match (Phải)
                          Positioned(
                            right: 0,
                            child: SlideTransition(
                              position: _slideRightAnimation,
                              child: _buildAvatarCircle(
                                widget.matchedUser.mainPhoto,
                                false,
                              ),
                            ),
                          ),
                          // Trái tim ở giữa với viền gradient
                          Center(
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF3A5E),
                                      Color(0xFFFF9068),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF3A5E,
                                      ).withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFFF3A5E),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 3. Text thông báo
                    Text(
                      'Bạn và ${widget.matchedUser.name} đã thích nhau!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 4. Button Nhắn tin
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF3A5E), Color(0xFFFF6945)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3A5E).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: widget.onSendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Nhắn tin',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 5. Button Tiếp tục
                    TextButton(
                      onPressed: widget.onKeepSwiping,
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Pháo giấy
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiWidgetController,
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }

  // Widget vẽ Avatar với viền Gradient Glow - GIỐNG ẢNH 1
  Widget _buildAvatarCircle(String? url, bool isLeft) {
    // Tăng góc xoay để giống ảnh mẫu hơn
    final double rotateAngle = isLeft ? -0.15 : 0.15;

    return Transform.rotate(
      angle: rotateAngle,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Gradient viền ngoài - NHIỀU LỚP để tạo hiệu ứng glow
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3A5E), Color(0xFFFF6945), Color(0xFFFF9068)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            // Lớp shadow 1 - Gần
            BoxShadow(
              color: const Color(0xFFFF3A5E).withOpacity(0.8),
              blurRadius: 15,
              spreadRadius: 0,
            ),
            // Lớp shadow 2 - Xa hơn
            BoxShadow(
              color: const Color(0xFFFF6945).withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            // Lớp shadow 3 - Rất xa (outer glow)
            BoxShadow(
              color: const Color(0xFFFF9068).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.all(4), // Độ dày viền gradient
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Viền trắng trong
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: url != null && url.isNotEmpty
                ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 60),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60),
                  ),
          ),
        ),
      ),
    );
  }

  // Title Gradient
  Widget _buildGradientTitle() {
    return Text(
      "It's a Match!",
      style: TextStyle(
        fontFamily: 'Cursive',
        fontSize: 48,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFE5394F), Color(0xFFFF9A9E)],
          ).createShader(const Rect.fromLTWH(0, 0, 320, 100)),
        shadows: [
          Shadow(
            blurRadius: 12,
            color: Color(0xFFCE1628).withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }
}
