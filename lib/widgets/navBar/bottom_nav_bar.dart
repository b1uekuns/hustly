import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
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
        onItemSelected: onItemSelected,
        animationCurve: Curves.easeInOutCirc,
        animationDuration: Duration(milliseconds: 400),
        iconSize: 24,

        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home, color: AppColor.redLight),
            title: Text('Home', style: TextStyle(color: AppColor.redLight)),
            activeColor: AppColor.redLight,
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.meeting_room, color: AppColor.redLight),
            title: Text('Meeting', style: TextStyle(color: AppColor.redLight)),
            activeColor: AppColor.redLight,
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.favorite_outlined, color: AppColor.redLight),
            title: Text('Favorite', style: TextStyle(color: AppColor.redLight)),
            activeColor: AppColor.redLight,
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.chat_rounded, color: AppColor.redLight),
            title: Text('Chat', style: TextStyle(color: AppColor.redLight)),
            activeColor: AppColor.redLight,
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person, color: AppColor.redLight),
            title: Text('Profile', style: TextStyle(color: AppColor.redLight)),
            activeColor: AppColor.redLight,
          ),
        ],
      ),
    );
  }
}
