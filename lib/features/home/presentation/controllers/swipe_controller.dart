import 'package:flutter/material.dart';

/// Mixin để quản lý logic swipe card
/// Tách riêng để home_page.dart gọn hơn
mixin SwipeController<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  // Animation controllers
  late AnimationController flyController;
  late Animation<Offset> flyAnimation;

  // Swipe state
  Offset cardOffset = Offset.zero;
  double cardAngle = 0;
  bool isDragging = false;
  bool isFlying = false;
  String? flyDirection;

  // Scroll controller cho profile
  final ScrollController scrollController = ScrollController();
  double scrollOffset = 0;

  // Constants
  static const double swipeLockThreshold = 50.0;
  static const double angleMultiplier = 0.0006;
  static const double velocityThreshold = 1000.0;

  double get swipeThreshold => MediaQuery.of(context).size.width * 0.3;
  bool get canSwipe => scrollOffset < swipeLockThreshold;

  /// Khởi tạo controllers
  void initSwipeController() {
    flyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    scrollController.addListener(_onScrollChanged);
  }

  /// Dispose controllers
  void disposeSwipeController() {
    flyController.dispose();
    scrollController.dispose();
  }

  void _onScrollChanged() {
    setState(() => scrollOffset = scrollController.offset);
  }

  /// Reset card về vị trí ban đầu
  void resetCard() {
    setState(() {
      cardOffset = Offset.zero;
      cardAngle = 0;
      isDragging = false;
      isFlying = false;
      flyDirection = null;
    });
  }

  /// Animate card trở về center
  void animateCardBack() {
    final start = cardOffset;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    controller.addListener(() {
      setState(() {
        cardOffset = Offset.lerp(start, Offset.zero, controller.value)!;
        cardAngle = cardOffset.dx * angleMultiplier;
      });
    });

    controller.forward().then((_) {
      controller.dispose();
      resetCard();
    });
  }

  /// Fly card ra khỏi màn hình
  void flyCardAway(String direction, VoidCallback onComplete) {
    setState(() {
      isFlying = true;
      flyDirection = direction;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = direction == 'right' ? screenWidth * 1.5 : -screenWidth * 1.5;

    flyAnimation = Tween<Offset>(
      begin: cardOffset,
      end: Offset(targetX, cardOffset.dy + 50),
    ).animate(CurvedAnimation(
      parent: flyController,
      curve: Curves.easeOut,
    ));

    flyController.forward(from: 0).then((_) {
      onComplete();
      resetCard();
      flyController.reset();
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
  }

  /// Xử lý khi bắt đầu drag
  void onPanStart() {
    if (canSwipe) {
      setState(() => isDragging = true);
    }
  }

  /// Xử lý khi đang drag
  void onPanUpdate(DragUpdateDetails details) {
    if (!canSwipe) return;

    // Chỉ nhận swipe ngang mạnh hơn dọc
    if (details.delta.dx.abs() > details.delta.dy.abs() * 0.8) {
      setState(() {
        cardOffset += Offset(details.delta.dx, 0);
        cardAngle = cardOffset.dx * angleMultiplier;
      });
    }
  }

  /// Xử lý khi kết thúc drag
  void onPanEnd(DragEndDetails details, VoidCallback onLike, VoidCallback onPass) {
    if (!canSwipe) return;

    setState(() => isDragging = false);

    final velocity = details.velocity.pixelsPerSecond.dx;

    // Strong swipe detection
    if (velocity.abs() > velocityThreshold || cardOffset.dx.abs() > swipeThreshold) {
      final isLike = cardOffset.dx > 0 || velocity > velocityThreshold;
      flyCardAway(
        isLike ? 'right' : 'left',
        isLike ? onLike : onPass,
      );
    } else {
      animateCardBack();
    }
  }

  /// Tính opacity cho indicator (LIKE/NOPE)
  double get indicatorOpacity {
    final progress = cardOffset.dx.abs() / swipeThreshold;
    return (progress - 0.5).clamp(0.0, 1.0);
  }

  /// Xử lý khi nhấn nút action
  void handleButtonAction(bool isLike, VoidCallback onComplete) {
    if (scrollController.hasClients && scrollController.offset > 0) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }

    Future.delayed(const Duration(milliseconds: 50), () {
      flyCardAway(isLike ? 'right' : 'left', onComplete);
    });
  }
}

