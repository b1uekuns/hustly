import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../../data/models/interests_response.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

class Step3InterestsPage extends StatefulWidget {
  const Step3InterestsPage({super.key});

  @override
  State<Step3InterestsPage> createState() => _Step3InterestsPageState();
}

class _Step3InterestsPageState extends State<Step3InterestsPage> {
  final _bioController = TextEditingController();
  final Set<String> _selectedInterests = {};
  String? _expandedCategory;

  // Fallback interests nếu API fail
  static const List<Map<String, dynamic>> _fallbackInterests = [
    {'icon': '🎮', 'label': 'Gaming'},
    {'icon': '💃', 'label': 'Dancing'},
    {'icon': '🎵', 'label': 'Music'},
    {'icon': '🎬', 'label': 'Movie'},
    {'icon': '📷', 'label': 'Photography'},
    {'icon': '👗', 'label': 'Fashion'},
    {'icon': '📚', 'label': 'Book'},
    {'icon': '⚽', 'label': 'Sports'},
    {'icon': '💪', 'label': 'Gym & Fitness'},
    {'icon': '🍔', 'label': 'Food & Drink'},
    {'icon': '✈️', 'label': 'Travel'},
    {'icon': '☕', 'label': 'Coffee'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSetupBloc>().add(
        const ProfileSetupEvent.fetchInterests(),
      );
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interestLabel) {
    setState(() {
      if (_selectedInterests.contains(interestLabel)) {
        _selectedInterests.remove(interestLabel);
      } else if (_selectedInterests.length < 10) {
        _selectedInterests.add(interestLabel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tối đa 10 sở thích'),
            backgroundColor: AppColor.redPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });
  }

  void _onNext() {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn ít nhất 1 sở thích'),
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
      ProfileSetupEvent.interestsUpdated(
        interests: _selectedInterests.toList(),
        bio: _bioController.text.trim(),
      ),
    );
    context.push(AppPage.onboardingInterestedIn.toPath());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Sở thích'),
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
        listenWhen: (previous, current) {
          if (previous is ProfileSetupInitial &&
              current is ProfileSetupInitial) {
            return previous.interests != current.interests;
          }
          return false;
        },
        listener: (context, state) {
          if (state is ProfileSetupInitial && state.interests.isNotEmpty) {
            setState(() {
              _selectedInterests.addAll(state.interests);
              if (_bioController.text.isEmpty && state.bio.isNotEmpty) {
                _bioController.text = state.bio;
              }
            });
          }
        },
        buildWhen: (previous, current) {
          if (previous is ProfileSetupInitial &&
              current is ProfileSetupInitial) {
            return previous.availableInterests != current.availableInterests ||
                previous.isInterestsLoading != current.isInterestsLoading;
          }
          return previous != current;
        },
        builder: (context, state) {
          final categories = state is ProfileSetupInitial
              ? state.availableInterests
              : <InterestCategory>[];
          final isLoading =
              state is ProfileSetupInitial && state.isInterestsLoading;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildSelectedCounter(),
                      const SizedBox(height: 20),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.redPrimary,
                          ),
                        )
                      else if (categories.isNotEmpty)
                        _buildCategorizedInterests(categories)
                      else
                        _buildFallbackInterests(),
                      const SizedBox(height: 32),
                      _buildBioSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(),
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
            'Bước 3/4',
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
            'Cậu thích gì nào? 🎯',
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
          'Chọn sở thích để tìm những người cùng đam mê',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.blackLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _selectedInterests.isNotEmpty
            ? AppColor.redPrimary.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _selectedInterests.isNotEmpty
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _selectedInterests.isNotEmpty
                    ? AppColor.redPrimary
                    : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Đã chọn: ${_selectedInterests.length}/10',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _selectedInterests.isNotEmpty
                      ? AppColor.redPrimary
                      : Colors.grey,
                ),
              ),
            ],
          ),
          if (_selectedInterests.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _selectedInterests.clear()),
              child: Text(
                'Xóa tất cả',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorizedInterests(List<InterestCategory> categories) {
    return Column(
      children: categories.map((category) {
        final isExpanded = _expandedCategory == category.category;
        final selectedInCategory = category.items
            .where((item) => _selectedInterests.contains(item.label))
            .length;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedInCategory > 0
                  ? AppColor.redPrimary.withOpacity(0.3)
                  : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              // Category header - tap anywhere on row to expand
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _expandedCategory = isExpanded ? null : category.category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(category.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackPrimary,
                              ),
                            ),
                            if (selectedInCategory > 0)
                              Text(
                                '$selectedInCategory đã chọn',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.redPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded items
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: category.items.map((item) {
                      final isSelected = _selectedInterests.contains(
                        item.label,
                      );
                      return _buildInterestChip(
                        icon: item.icon,
                        label: item.label,
                        isSelected: isSelected,
                        onTap: () => _toggleInterest(item.label),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFallbackInterests() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _fallbackInterests.map((interest) {
        final isSelected = _selectedInterests.contains(interest['label']);
        return _buildInterestChip(
          icon: interest['icon'] as String,
          label: interest['label'] as String,
          isSelected: isSelected,
          onTap: () => _toggleInterest(interest['label'] as String),
        );
      }).toList(),
    );
  }

  Widget _buildInterestChip({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.redPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColor.blackPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check, color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit_note, color: AppColor.redPrimary, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Giới thiệu bản thân',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.blackPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Không bắt buộc',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 500,
          style: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
          decoration: InputDecoration(
            hintText: 'Viết vài dòng về bản thân bạn...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColor.redPrimary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final isEnabled = _selectedInterests.isNotEmpty;

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
          onPressed: isEnabled ? _onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Tiếp theo',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isEnabled ? Colors.white : Colors.grey.shade400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
