import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const EmailInputField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Nhập Email HUST',
        // Bỏ errorText khỏi đây để hiển thị bên ngoài
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      onChanged: onChanged,
    );
  }
}
