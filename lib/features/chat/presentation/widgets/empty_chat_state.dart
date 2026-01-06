import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';

import '../../../../core/config/routes/app_page.dart';

class EmptyChatState extends StatelessWidget {
  const EmptyChatState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 120,
              color: AppColor.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa có tin nhắn',
              style: AppStyle.def.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Khi bạn match với ai đó,\ncuộc trò chuyện sẽ xuất hiện ở đây',
              style: AppStyle.def.copyWith(fontSize: 16, color: AppColor.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to discover page
                context.go(AppPage.home.toPath());
              },
              icon: const Icon(Icons.explore),
              label: const Text('Khám phá ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.redIcon,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
