import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/core/config/routes/app_page.dart';
import 'package:hust_chill_app/core/resources/app_assets.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColor.redLight.withOpacity(0.2),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: FlashyTabBar(
        selectedIndex: selectedIndex,
        showElevation: false,
        onItemSelected: (index) {
          onItemSelected(index);
          _handleNavigation(context, index);
        },
        animationCurve: Curves.easeInOutCirc,
        animationDuration: Duration(milliseconds: 400),
        iconSize: 24,

        items: [
          FlashyTabBarItem(
            icon: SvgPicture.asset(AppAssets.iconHome, width: 24, height: 24),
            title: SvgPicture.asset(
              AppAssets.iconHomeActive,
              width: 24,
              height: 24,
            ),
            activeColor: AppColor.redIcon,
            inactiveColor: AppColor.greyLight,
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.meeting_room),
            title: Icon(Icons.meeting_room, color: AppColor.redIcon),
            activeColor: AppColor.redIcon,
            inactiveColor: AppColor.greyLight,
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(AppAssets.iconHeart, width: 24, height: 24),
            title: SvgPicture.asset(
              AppAssets.iconHeart,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColor.redIcon, BlendMode.srcIn),
            ),
            activeColor: AppColor.redIcon,
            inactiveColor: AppColor.greyLight,
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              AppAssets.iconMessage,
              width: 24,
              height: 24,
            ),
            title: SvgPicture.asset(
              AppAssets.iconMessageActive,
              width: 24,
              height: 24,
            ),
            activeColor: AppColor.redIcon,
            inactiveColor: AppColor.greyLight,
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              AppAssets.iconProfile,
              width: 24,
              height: 24,
            ),
            title: SvgPicture.asset(
              AppAssets.iconProfile,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColor.redIcon, BlendMode.srcIn),
            ),
            activeColor: AppColor.redIcon,
            inactiveColor: AppColor.greyLight,
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Home - Discover
        context.go(AppPage.home.toPath());
        break;
      case 1:
        // Meeting room (placeholder)
        break;
      case 2:
        // Likes (placeholder)
        break;
      case 3:
        // Messages
        context.go(AppPage.chatList.toPath());
        break;
      case 4:
        // Profile (placeholder)
        break;
    }
  }
}
