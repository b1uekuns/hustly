import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:intl/intl.dart';

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({super.key});

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  DateTime? selected;

  static const minYear = 2000;
  int get maxYear => DateTime.now().year - 18;

  late DateTime currentMonth = DateTime(maxYear, 1);

  List<DateTime?> daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    int offset = firstDay.weekday % 7;
    return [
      ...List.filled(offset, null),
      ...List.generate(
        lastDay.day,
        (i) => DateTime(date.year, date.month, i + 1),
      ),
    ];
  }

  bool _canGoPrevious() {
    final minDate = DateTime(minYear, 1);
    final prevMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    return prevMonth.isAfter(minDate) || prevMonth.isAtSameMomentAs(minDate);
  }

  bool _canGoNext() {
    final maxDate = DateTime(maxYear, 12);
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    return nextMonth.isBefore(maxDate) || nextMonth.isAtSameMomentAs(maxDate);
  }

  void _goPrevious() {
    if (_canGoPrevious()) {
      setState(() {
        currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      });
    }
  }

  void _goNext() {
    if (_canGoNext()) {
      setState(() {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = daysInMonth(currentMonth);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _canGoPrevious() ? _goPrevious : null,
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickYear,
                        child: Text(
                          currentMonth.year.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColor.redPrimarySecond,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: pickMonth,
                        child: Text(
                          DateFormat("MMMM").format(currentMonth),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _canGoNext() ? _goNext : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']
                .map(
                  (day) => SizedBox(
                    width: 38,
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          // Swipe để đổi tháng
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! > 0) {
                _goPrevious();
              } else {
                _goNext();
              }
            },
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: days.map((day) {
                if (day == null) return const SizedBox();

                final isSelected =
                    selected != null &&
                    selected!.year == day.year &&
                    selected!.month == day.month &&
                    selected!.day == day.day;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => selected = day),
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: isSelected
                          ? const BoxDecoration(
                              color: AppColor.redPrimarySecond,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Center(
                        child: Text(
                          day.day.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.redPrimaryThird,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Lưu",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerSheet({
    required String title,
    required VoidCallback onCancel,
    required VoidCallback onDone,
    required Widget picker,
  }) {
    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: AppColor.redPrimary, fontSize: 16),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                TextButton(
                  onPressed: onDone,
                  child: const Text(
                    'Xong',
                    style: TextStyle(
                      color: AppColor.yellowPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: picker),
        ],
      ),
    );
  }

  CupertinoPicker _buildCupertinoPicker({
    required int initialItem,
    required ValueChanged<int> onChanged,
    required List<String> labels,
  }) {
    return CupertinoPicker(
      itemExtent: 40,
      magnification: 1.1,
      useMagnifier: true,
      diameterRatio: 1.2,
      squeeze: 1.05,
      scrollController: FixedExtentScrollController(initialItem: initialItem),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
      ),
      onSelectedItemChanged: onChanged,
      children: labels
          .map(
            (label) => Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  color: CupertinoColors.label,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> pickYear() async {
    final years = List.generate(maxYear - minYear + 1, (i) => maxYear - i);
    int selectedYear = currentMonth.year;

    final result = await showModalBottomSheet<int>(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _buildPickerSheet(
        title: 'Chọn năm',
        onCancel: () => Navigator.pop(context),
        onDone: () => Navigator.pop(context, selectedYear),
        picker: _buildCupertinoPicker(
          initialItem: years.indexOf(currentMonth.year),
          onChanged: (index) => selectedYear = years[index],
          labels: years.map((y) => '$y').toList(),
        ),
      ),
    );

    if (result != null) {
      setState(() => currentMonth = DateTime(result, currentMonth.month, 1));
    }
  }

  Future<void> pickMonth() async {
    final months = List.generate(12, (i) => i + 1);
    final monthNames = months
        .map((m) => DateFormat('MMMM').format(DateTime(0, m)))
        .toList();
    int selectedMonth = currentMonth.month;

    final result = await showModalBottomSheet<int>(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _buildPickerSheet(
        title: 'Chọn tháng',
        onCancel: () => Navigator.pop(context),
        onDone: () => Navigator.pop(context, selectedMonth),
        picker: _buildCupertinoPicker(
          initialItem: currentMonth.month - 1,
          onChanged: (index) => selectedMonth = months[index],
          labels: monthNames,
        ),
      ),
    );

    if (result != null) {
      setState(() => currentMonth = DateTime(currentMonth.year, result, 1));
    }
  }
}
