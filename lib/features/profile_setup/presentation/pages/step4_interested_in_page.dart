import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

class Step4InterestedInPage extends StatefulWidget {
  const Step4InterestedInPage({super.key});

  @override
  State<Step4InterestedInPage> createState() => _Step4InterestedInPageState();
}

class _Step4InterestedInPageState extends State<Step4InterestedInPage> {
  String? _selectedOption;

  static final List<Map<String, dynamic>> _options = [
    {
      'value': 'women',
      'icon': Icons.female,
      'color': Colors.pink,
      'title': 'Nữ',
      'subtitle': 'Tìm kiếm bạn nữ',
    },
    {
      'value': 'men',
      'icon': Icons.male,
      'color': Colors.blue,
      'title': 'Nam',
      'subtitle': 'Tìm kiếm bạn nam',
    },
    {
      'value': 'everyone',
      'icon': Icons.people,
      'color': Colors.purple,
      'title': 'Tất cả',
      'subtitle': 'Tìm kiếm mọi người',
    },
  ];

  void _onSubmit() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn đối tượng quan tâm'),
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
      ProfileSetupEvent.interestedInUpdated(_selectedOption!),
    );

    // Navigate to step 5
    context.push(AppPage.onboardingStep5.toPath());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Đối tượng quan tâm'),
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
            if (state.interestedIn.isNotEmpty) {
              _selectedOption = state.interestedIn;
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
                      const SizedBox(height: 40),
                      _buildOptions(isLoading),
                      const SizedBox(height: 100),
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
            'Bước 4/5',
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
            'Cậu quan tâm đến ai? 💕',
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
          'Chọn đối tượng bạn muốn kết nối',
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
      children: _options.map((option) {
        final isSelected = _selectedOption == option['value'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isLoading
                ? null
                : () => setState(
                    () => _selectedOption = option['value'] as String,
                  ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
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
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (option['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: !isSelected
                          ? [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      size: 32,
                      color: isSelected
                          ? Colors.white
                          : option['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option['title'] as String,
                          style: TextStyle(
                            fontSize: 18,
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
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColor.redPrimary,
                            size: 18,
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
                      'Tiếp tục',
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
                        Icons.arrow_forward_rounded,
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
