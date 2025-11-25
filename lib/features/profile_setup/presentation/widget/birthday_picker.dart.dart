import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({super.key});

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  late DateTime selected;
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();

    selected = DateTime(2000, 1, 1);
    currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

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
    // Kiểm tra có thể lùi về tháng trước không
    final minDate = DateTime(2000, 1); // Tháng 1/2000
    final prevMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    return prevMonth.isAfter(minDate) || prevMonth.isAtSameMomentAs(minDate);
  }

  bool _canGoNext() {
    // Kiểm tra có thể tiến tới tháng sau không
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month); // Tháng hiện tại
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    return nextMonth.isBefore(maxDate) || nextMonth.isAtSameMomentAs(maxDate);
  }

  @override
  Widget build(BuildContext context) {
    final days = daysInMonth(currentMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
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
                // ==== Arrow LEFT ====
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _canGoPrevious()
                      ? () {
                          setState(() {
                            currentMonth = DateTime(
                              currentMonth.year,
                              currentMonth.month - 1,
                            );
                          });
                        }
                      : null, // null = disabled
                ),

                // ==== Year + Month ====
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

                // ==== Arrow RIGHT ====
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _canGoNext()
                      ? () {
                          setState(() {
                            currentMonth = DateTime(
                              currentMonth.year,
                              currentMonth.month + 1,
                            );
                          });
                        }
                      : null, // null = disabled
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Thêm trước GridView
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

          // ==== Calendar grid ====
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: days.map((day) {
              if (day == null) {
                return const SizedBox(); // Empty cell
              }

              final selectedNow =
                  selected.year == day.year &&
                  selected.month == day.month &&
                  selected.day == day.day;

              return GestureDetector(
                onTap: () => setState(() => selected = day),
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: selectedNow
                        ? const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Center(
                      child: Text(
                        "${day.day}",
                        style: TextStyle(
                          color: selectedNow ? Colors.white : Colors.black87,
                          fontWeight: selectedNow
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

          const SizedBox(height: 25),

          // ==== Button ====
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
    final now = DateTime.now();
    final maxYear = now.year; // Năm hiện tại
    final minYear = 2000; // Giới hạn từ 2000

    final years = List.generate(
      maxYear - minYear + 1,
      (i) => maxYear - i, // Đảo ngược: năm gần nhất ở trên
    );

    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chọn năm"),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              final isSelected = year == currentMonth.year;

              return ListTile(
                title: Text(
                  "$year",
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.redAccent : Colors.black87,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: Colors.red.shade50,
                onTap: () => Navigator.pop(context, year),
              );
            },
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        currentMonth = DateTime(result, currentMonth.month, 1);
      });
    }
  }

  Future<void> pickMonth() async {
    final months = List.generate(12, (i) => i + 1);

    final result = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Chọn tháng"),
        children: months.map((m) {
          return SimpleDialogOption(
            child: Text(DateFormat("MMMM").format(DateTime(0, m))),
            onPressed: () => Navigator.pop(context, m),
          );
        }).toList(),
      ),
    );

    if (result != null) {
      setState(() {
        currentMonth = DateTime(currentMonth.year, result, 1);
      });
    }
  }
}
