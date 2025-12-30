import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final Function(String) onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColor.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    hintStyle: AppStyle.def.copyWith(color: AppColor.grey),
                    border: InputBorder.none,
                  ),
                  style: AppStyle.def,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !isSending) {
                      onSend(value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: AppColor.redIcon,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, color: AppColor.white),
                onPressed: isSending
                    ? null
                    : () {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          onSend(text);
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
