import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin để quản lý logic swipe card
/// Tách riêng để home_page.dart gọn hơn và dễ test
///
/// Requirements:
/// - State phải implement TickerProviderStateMixin
/// - Gọi initSwipeController() trong initState()
/// - Gọi disposeSwipeController() trong dispose()
mixin SwipeController<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
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
  late ScrollController scrollController = ScrollController();
  double scrollOffset = 0;

  // Animation constants
  static const Duration _flyDuration = Duration(milliseconds: 350);
  static const Duration _returnDuration = Duration(milliseconds: 200);
  static const Duration _scrollResetDuration = Duration(milliseconds: 150);
  static const Duration _actionDelay = Duration(milliseconds: 50);

  // Swipe thresholds
  static const double _swipeLockThreshold = 50.0;
  static const double _swipeThresholdRatio = 0.3;
  static const double _velocityThreshold = 1000.0;
  static const double _horizontalDominanceRatio = 0.8;

  // Animation values
  static const double _angleMultiplier = 0.0006;
  static const double _flyMultiplier = 1.5;
  static const double _flyVerticalOffset = 50.0;
  static const double _indicatorStartThreshold = 0.5;
  static const double _indicatorMinOpacity = 0.0;
  static const double _indicatorMaxOpacity = 1.0;

  /// Threshold để bắt đầu swipe (dựa trên screen width)
  double get swipeThreshold =>
      MediaQuery.of(context).size.width * _swipeThresholdRatio;

  /// Kiểm tra có thể swipe không (dựa trên scroll offset)
  bool get canSwipe => scrollOffset < _swipeLockThreshold;

  /// Khởi tạo controllers
  /// Gọi trong initState() của widget
  void initSwipeController() {
    scrollController = ScrollController();
    flyController = AnimationController(vsync: this, duration: _flyDuration);
    scrollController.addListener(_onScrollChanged);
  }

  /// Dispose controllers
  /// Gọi trong dispose() của widget
  void disposeSwipeController() {
    flyController.dispose();
    scrollController.dispose();
  }

  /// Listener cho scroll changes
  void _onScrollChanged() {
    if (mounted && scrollController.hasClients) {
      setState(() => scrollOffset = scrollController.offset);
    }
  }

  /// Reset card về vị trí ban đầu
  void resetCard() {
    if (!mounted) return;

    setState(() {
      cardOffset = Offset.zero;
      cardAngle = 0;
      isDragging = false;
      isFlying = false;
      flyDirection = null;
    });
  }

  /// Animate card trở về center
  /// Sử dụng khi user thả card mà chưa đủ threshold
  void animateCardBack() {
    if (!mounted) return;

    final start = cardOffset;
    final controller = AnimationController(
      vsync: this,
      duration: _returnDuration,
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {
          cardOffset = Offset.lerp(start, Offset.zero, controller.value)!;
          cardAngle = cardOffset.dx * _angleMultiplier;
        });
      }
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        resetCard();
      }
    });

    controller.forward();
  }

  /// Fly card ra khỏi màn hình
  /// [direction] - 'right' cho like, 'left' cho pass
  /// [onComplete] - Callback khi animation hoàn thành
  void flyCardAway(String direction, VoidCallback onComplete) {
    if (!mounted) return;

    // Haptic feedback khi card bay đi
    HapticFeedback.mediumImpact();

    setState(() {
      isFlying = true;
      flyDirection = direction;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = direction == 'right'
        ? screenWidth * _flyMultiplier
        : -screenWidth * _flyMultiplier;

    flyAnimation = Tween<Offset>(
      begin: cardOffset,
      end: Offset(targetX, cardOffset.dy + _flyVerticalOffset),
    ).animate(CurvedAnimation(parent: flyController, curve: Curves.easeOut));

    flyController.forward(from: 0).then((_) {
      if (mounted) {
        onComplete();
        resetCard();
        flyController.reset();
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      }
    });
  }

  /// Xử lý khi bắt đầu drag
  void onPanStart() {
    if (canSwipe) {
      HapticFeedback.selectionClick();
      setState(() => isDragging = true);
    }
  }

  /// Xử lý khi đang drag
  /// Chỉ nhận horizontal swipe nếu mạnh hơn vertical swipe
  void onPanUpdate(DragUpdateDetails details) {
    if (!canSwipe || !mounted) return;

    // Chỉ nhận swipe ngang mạnh hơn dọc
    if (details.delta.dx.abs() >
        details.delta.dy.abs() * _horizontalDominanceRatio) {
      setState(() {
        cardOffset += Offset(details.delta.dx, 0);
        cardAngle = cardOffset.dx * _angleMultiplier;
      });
    }
  }

  /// Xử lý khi kết thúc drag
  /// Quyết định xem card có bay đi hay quay về
  void onPanEnd(
    DragEndDetails details,
    VoidCallback onLike,
    VoidCallback onPass,
  ) {
    if (!canSwipe || !mounted) return;

    setState(() => isDragging = false);

    final velocity = details.velocity.pixelsPerSecond.dx;

    // Strong swipe detection - dựa trên velocity hoặc distance
    if (velocity.abs() > _velocityThreshold ||
        cardOffset.dx.abs() > swipeThreshold) {
      final isLike = cardOffset.dx > 0 || velocity > _velocityThreshold;
      flyCardAway(isLike ? 'right' : 'left', isLike ? onLike : onPass);
    } else {
      // Card chưa đủ threshold, quay về
      HapticFeedback.lightImpact();
      animateCardBack();
    }
  }

  /// Tính opacity cho indicator (LIKE/NOPE)
  /// Trả về giá trị từ 0.0 đến 1.0 dựa trên khoảng cách swipe
  double get indicatorOpacity {
    final progress = cardOffset.dx.abs() / swipeThreshold;
    return (progress - _indicatorStartThreshold).clamp(
      _indicatorMinOpacity,
      _indicatorMaxOpacity,
    );
  }

  /// Xử lý khi nhấn nút action (like/pass buttons)
  /// [isLike] - true cho like, false cho pass
  /// [onComplete] - Callback khi action hoàn thành
  void handleButtonAction(bool isLike, VoidCallback onComplete) {
    if (!mounted) return;

    // Reset scroll về top nếu đang scroll
    if (scrollController.hasClients && scrollController.offset > 0) {
      scrollController.animateTo(
        0,
        duration: _scrollResetDuration,
        curve: Curves.easeOut,
      );
    }

    // Delay nhỏ để scroll animation hoàn thành
    Future.delayed(_actionDelay, () {
      if (mounted) {
        flyCardAway(isLike ? 'right' : 'left', onComplete);
      }
    });
  }
}
