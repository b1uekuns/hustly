import 'package:flutter/material.dart';
import '../../core/resources/app_color.dart';

class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T? selectedItem;
  final String Function(T) labelBuilder;
  final IconData Function(T)? iconBuilder;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.labelBuilder,
    this.selectedItem,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.blackPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) {
                final item = options[index];
                final isSelected = item == selectedItem;

                return _buildOptionTile(
                  context: context,
                  item: item,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required T item,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.redPrimary.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColor.redPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (iconBuilder != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.redPrimary.withOpacity(0.2)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  iconBuilder!(item),
                  color: isSelected ? AppColor.redPrimary : Colors.grey,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
            ],

            // Label
            Expanded(
              child: Text(
                labelBuilder(item),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColor.redPrimary : Colors.black,
                ),
              ),
            ),

            // Check Icon
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColor.redPrimary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
