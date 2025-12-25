import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

/// Constants for Dating Purpose options
class DatingPurposeConstants {
  static const Map<String, Map<String, dynamic>> options = {
    'relationship': {
      'icon': Icons.favorite,
      'color': Colors.pink,
      'title': 'Tìm người yêu',
      'subtitle': 'Mình đang tìm một mối quan hệ nghiêm túc',
      'emoji': '💕',
    },
    'friends': {
      'icon': Icons.people,
      'color': Colors.blue,
      'title': 'Tìm bạn mới',
      'subtitle': 'Muốn mở rộng mối quan hệ xã hội',
      'emoji': '👋',
    },
    'casual': {
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'title': 'Không ràng buộc',
      'subtitle': 'Thoải mái, không áp lực',
      'emoji': '🔥',
    },
    'unsure': {
      'icon': Icons.help_outline,
      'color': Colors.purple,
      'title': 'Chưa rõ lắm',
      'subtitle': 'Để xem duyên số thế nào đã',
      'emoji': '🤔',
    },
  };

  static String getEmoji(String? value) {
    if (value == null || !options.containsKey(value)) return '🤔';
    return options[value]!['emoji'] as String;
  }

  static String getTitle(String? value) {
    if (value == null || !options.containsKey(value)) return 'Chưa rõ lắm';
    return options[value]!['title'] as String;
  }

  static String getSubtitle(String? value) {
    if (value == null || !options.containsKey(value)) return 'Để xem duyên số thế nào đã';
    return options[value]!['subtitle'] as String;
  }

  static Color getColor(String? value) {
    if (value == null || !options.containsKey(value)) return Colors.purple;
    return options[value]!['color'] as Color;
  }

  static IconData getIcon(String? value) {
    if (value == null || !options.containsKey(value)) return Icons.help_outline;
    return options[value]!['icon'] as IconData;
  }

  static List<Map<String, dynamic>> get allOptions {
    return options.entries.map((entry) {
      return {
        'value': entry.key,
        ...entry.value,
      };
    }).toList();
  }
}

class Step5DatingPurposePage extends StatefulWidget {
  const Step5DatingPurposePage({super.key});

  @override
  State<Step5DatingPurposePage> createState() => _Step5DatingPurposePageState();
}

class _Step5DatingPurposePageState extends State<Step5DatingPurposePage> {
  String? _selectedOption;

  void _onSubmit() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn mục đích tìm kiếm'),
          backgroundColor: AppColor.redPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<ProfileSetupBloc>().add(
      ProfileSetupEvent.datingPurposeUpdated(_selectedOption!),
    );

    // Submit profile - final step
    context.read<ProfileSetupBloc>().add(
      const ProfileSetupEvent.submitProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Mục đích tìm kiếm'),
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
        listenWhen: (previous, current) =>
            current is ProfileSetupCompleted || current is ProfileSetupError,
        listener: (context, state) {
          if (state is ProfileSetupCompleted) {
            context.go(AppPage.onboardingPending.toPath());
          } else if (state is ProfileSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.redPrimary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is ProfileSetupLoading ||
            current is ProfileSetupInitial ||
            current is ProfileSetupError,
        builder: (context, state) {
          final isLoading = state is ProfileSetupLoading;

          // Pre-fill with existing data
          if (state is ProfileSetupInitial && _selectedOption == null) {
            if (state.datingPurpose.isNotEmpty) {
              _selectedOption = state.datingPurpose;
            }
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildOptions(isLoading),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.redPrimary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Bước 5/5',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Text(
            'Bạn đang tìm gì? 🎯',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Điều này giúp mọi người hiểu mong muốn của bạn',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.blackLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOptions(bool isLoading) {
    return Column(
      children: DatingPurposeConstants.allOptions.map((option) {
        final isSelected = _selectedOption == option['value'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isLoading
                ? null
                : () => setState(
                    () => _selectedOption = option['value'] as String,
                  ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColor.redPrimary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (option['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        option['emoji'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option['title'] as String,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColor.blackPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : AppColor.blackLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColor.redPrimary,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(bool isLoading) {
    final isEnabled = _selectedOption != null && !isLoading;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: isEnabled
            ? AppTheme.gradientButtonDecoration
            : BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
        child: ElevatedButton(
          onPressed: isEnabled ? _onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hoàn thành',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? Colors.white : Colors.grey.shade400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isEnabled) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
