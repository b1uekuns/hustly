import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                            color: Colors.redAccent,
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
                _goPrevious(); // Swipe phải → tháng trước
              } else {
                _goNext(); // Swipe trái → tháng sau
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
                  onTap: () => setState(() => selected = day),
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: isSelected
                          ? const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Center(
                        child: Text(
                          "${day.day}",
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
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> pickYear() async {
    final years = List.generate(maxYear - minYear + 1, (i) => maxYear - i);

    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        int selectedYear = currentMonth.year;
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    const Text(
                      'Chọn năm',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, selectedYear),
                      child: const Text('Xong'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: years.indexOf(currentMonth.year),
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) => selectedYear = years[index],
                  children: years
                      .map(
                        (year) => Center(
                          child: Text(
                            '$year',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() => currentMonth = DateTime(result, currentMonth.month, 1));
    }
  }

  Future<void> pickMonth() async {
    final months = List.generate(12, (i) => i + 1);
    final monthNames = months
        .map((m) => DateFormat("MMMM").format(DateTime(0, m)))
        .toList();

    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        int selectedMonth = currentMonth.month;
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    const Text(
                      'Chọn tháng',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, selectedMonth),
                      child: const Text('Xong'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: currentMonth.month - 1,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) =>
                      selectedMonth = months[index],
                  children: monthNames
                      .map(
                        (name) => Center(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() => currentMonth = DateTime(currentMonth.year, result, 1));
    }
  }
}
