import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';

class FilterBottomSheet extends StatefulWidget {
  final double currentDistance;
  final RangeValues currentAgeRange;
  final String currentGender;

  const FilterBottomSheet({
    super.key,
    this.currentDistance = 10,
    this.currentAgeRange = const RangeValues(18, 25),
    this.currentGender = 'everyone',
  });

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _distance;
  late RangeValues _ageRange;
  late String _gender;

  final Color primaryColor = const Color(0xFFE94057);

  @override
  void initState() {
    super.initState();
    _distance = widget.currentDistance;
    _ageRange = widget.currentAgeRange;
    _gender = widget.currentGender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // Chiếm 85% màn hình
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag Handle (Thanh nắm)
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                // --- Distance Section ---
                _buildSectionTitle('Khoảng cách', '${_distance.round()} km'),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: Colors.grey[200],
                    trackHeight: 2,
                    thumbColor: AppColor.redLight,
                    thumbShape: _CustomThumbShape(),
                    overlayColor: primaryColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _distance,
                    min: 1,
                    max: 100,
                    onChanged: (val) => setState(() => _distance = val),
                  ),
                ),

                const SizedBox(height: 32),

                // --- Age Section ---
                _buildSectionTitle(
                  'Tuổi',
                  '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: Colors.grey[200],
                    trackHeight: 2,
                    thumbColor: AppColor.redLight,
                    rangeThumbShape: _CustomRangeThumbShape(),
                    overlayColor: primaryColor.withOpacity(0.2),
                  ),
                  child: RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 25,
                    onChanged: (val) => setState(() => _ageRange = val),
                  ),
                ),

                const SizedBox(height: 32),

                // --- Gender Section ---
                _buildSectionTitle('Quan tâm đến', ''),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildGenderButton('Nữ', 'women')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildGenderButton('Nam', 'men')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildGenderButton('Tất cả', 'everyone')),
                  ],
                ),
              ],
            ),
          ),

          // Buttons (Sticky Bottom)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _distance = 10;
                            _ageRange = const RangeValues(18, 25);
                            _gender = 'everyone';
                          });
                        },
                        child: Text(
                          'Xóa',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Gọi BLoC event ở đây
                          // context.read<DiscoverBloc>().add(DiscoverEvent.filter(...));
                        },
                        child: const Text(
                          'Áp dụng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: 1, // isSelected ? 0 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    canvas.drawCircle(
      center,
      12, // radius
      Paint()..color = AppColor.redLight,
    );
  }
}

// Custom Range Thumb Shape
class _CustomRangeThumbShape extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    canvas.drawCircle(center, 12, Paint()..color = AppColor.redLight);
  }
}
