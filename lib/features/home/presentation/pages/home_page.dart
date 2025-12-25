import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../widgets/navBar/bottom_nav_bar.dart';
import '../../data/models/discover_user_model.dart';
import '../bloc/discover_bloc.dart';
import '../controllers/swipe_controller.dart';
import '../widgets/empty_states.dart';
import '../widgets/home_header.dart';
import '../widgets/match_dialog.dart';
import '../widgets/profile_card_content.dart';
import '../widgets/profile_detail_sheet.dart';
import '../widgets/swipe_action_buttons.dart';
import '../widgets/swipe_indicator.dart';

/// Home page - Main discovery/swipe screen
/// Displays user profiles in a stack that can be swiped left (pass) or right (like)
/// Integrates with SwipeController mixin for gesture handling
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, SwipeController {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    initSwipeController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    disposeSwipeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DiscoverBloc>()..add(const DiscoverEvent.loadDiscover()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _navIndex,
          onItemSelected: (i) => setState(() => _navIndex = i),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<DiscoverBloc, DiscoverState>(
      listener: _handleStateChange,
      builder: (context, state) {
        // Loading state
        if (state is Loading) return const LoadingState();

        // Error state
        if (state is DiscoverError) {
          return ErrorState(
            message: state.message,
            onRetry: () => context.read<DiscoverBloc>().add(
              const DiscoverEvent.loadDiscover(),
            ),
          );
        }

        // No more users
        if (state is NoMoreUsers) {
          return NoMoreUsersState(
            onRefresh: () => context.read<DiscoverBloc>().add(
              const DiscoverEvent.resetCards(),
            ),
          );
        }

        // Get users from state
        final users = _getUsersFromState(state);
        final index = _getIndexFromState(state);

        if (users.isEmpty || index >= users.length) {
          return NoMoreUsersState(
            onRefresh: () => context.read<DiscoverBloc>().add(
              const DiscoverEvent.resetCards(),
            ),
          );
        }

        return _buildCardStack(users, index, context);
      },
    );
  }

  void _handleStateChange(BuildContext context, DiscoverState state) {
    if (state is Matched) {
      _showMatchDialog(context, state.matchedUser);
    }
  }

  List<DiscoverUserModel> _getUsersFromState(DiscoverState state) {
    return state.maybeMap(
      loaded: (s) => s.users,
      interacting: (s) => s.users,
      matched: (s) => s.users,
      orElse: () => [],
    );
  }

  int _getIndexFromState(DiscoverState state) {
    return state.maybeMap(
      loaded: (s) => s.currentIndex,
      interacting: (s) => s.currentIndex,
      matched: (s) => s.currentIndex,
      orElse: () => 0,
    );
  }

  Widget _buildCardStack(
    List<DiscoverUserModel> users,
    int index,
    BuildContext context,
  ) {
    final user = users[index];

    return Stack(
      children: [
        // Background cards
        ..._buildBackgroundCards(users, index),

        // Main card (flying or swipeable)
        isFlying ? _buildFlyingCard(user) : _buildSwipeableCard(user, context),

        // Action buttons
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: SwipeActionButtons(
            isDisabled: isFlying,
            onPass: () => _handleAction(user, context, isLike: false),
            onLike: () => _handleAction(user, context, isLike: true),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBackgroundCards(
    List<DiscoverUserModel> users,
    int currentIndex,
  ) {
    final cards = <Widget>[];
    final maxIndex = (currentIndex + 2).clamp(0, users.length - 1);

    for (int i = maxIndex; i > currentIndex; i--) {
      cards.add(_BackgroundCard(user: users[i], stackIndex: i - currentIndex));
    }

    return cards;
  }

  Widget _buildFlyingCard(DiscoverUserModel user) {
    return AnimatedBuilder(
      animation: flyController,
      builder: (_, __) => Transform.translate(
        offset: flyAnimation.value,
        child: Transform.rotate(
          angle: flyDirection == 'right' ? 0.2 : -0.2,
          child: _ProfileCard(user: user, scrollController: scrollController),
        ),
      ),
    );
  }

  Widget _buildSwipeableCard(DiscoverUserModel user, BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 80,
      child: GestureDetector(
        onPanStart: (_) => onPanStart(),
        onPanUpdate: onPanUpdate,
        onPanEnd: (details) => onPanEnd(
          details,
          () =>
              context.read<DiscoverBloc>().add(DiscoverEvent.likeUser(user.id)),
          () =>
              context.read<DiscoverBloc>().add(DiscoverEvent.passUser(user.id)),
        ),
        child: Transform.translate(
          offset: isDragging ? cardOffset : Offset.zero,
          child: Transform.rotate(
            angle: isDragging ? cardAngle : 0,
            child: _ProfileCard(
              user: user,
              scrollController: scrollController,
              swipeOpacity: isDragging ? indicatorOpacity : 0.0,
              swipeType: isDragging && cardOffset.dx != 0
                  ? (cardOffset.dx > 0 ? SwipeType.like : SwipeType.nope)
                  : null,
              onViewMore: () {
                ProfileDetailSheet.show(context, user);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(
    DiscoverUserModel user,
    BuildContext context, {
    required bool isLike,
  }) {
    handleButtonAction(isLike, () {
      final event = isLike
          ? DiscoverEvent.likeUser(user.id)
          : DiscoverEvent.passUser(user.id);
      context.read<DiscoverBloc>().add(event);
    });
  }

  void _showMatchDialog(BuildContext context, MatchedUserData matchedUser) {
    resetCard();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MatchDialog(
        matchedUser: matchedUser,
        onSendMessage: () => Navigator.pop(context),
        onKeepSwiping: () {
          Navigator.pop(context);
          context.read<DiscoverBloc>().add(const DiscoverEvent.nextCard());
        },
      ),
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  final DiscoverUserModel user;
  final int stackIndex;

  const _BackgroundCard({required this.user, required this.stackIndex});

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - (stackIndex * 0.04);
    final offset = stackIndex * 8.0;

    return Positioned(
      top: offset,
      left: 8 + stackIndex * 4.0,
      right: 8 + stackIndex * 4.0,
      bottom: 80 + stackIndex * 4.0,
      child: Transform.scale(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
            image: user.photos.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(user.photos.first.url),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile card widget
class _ProfileCard extends StatelessWidget {
  final DiscoverUserModel user;
  final ScrollController scrollController;
  final VoidCallback? onViewMore;
  final double swipeOpacity;
  final SwipeType? swipeType;

  const _ProfileCard({
    required this.user,
    required this.scrollController,
    this.onViewMore,
    this.swipeOpacity = 0.0,
    this.swipeType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ProfileCardContent(
          user: user,
          onViewMore: onViewMore,
          swipeOpacity: swipeOpacity,
          swipeType: swipeType,
        ),
      ),
    );
  }
}
