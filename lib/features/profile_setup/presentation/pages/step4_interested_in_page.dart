import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';
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

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'women',
      'icon': Icons.female,
      'title': 'Nữ',
      'color': Colors.pink,
    },
    {
      'value': 'men',
      'icon': Icons.male,
      'title': 'Nam',
      'color': Colors.blue,
    },
    {
      'value': 'everyone',
      'icon': Icons.people,
      'title': 'Tất cả',
      'color': Colors.purple,
    },
  ];

  void _onSubmit() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đối tượng quan tâm')),
      );
      return;
    }

    context.read<ProfileSetupBloc>().add(
          ProfileSetupEvent.interestedInUpdated(_selectedOption!),
        );
    
    // Submit profile
    context.read<ProfileSetupBloc>().add(const ProfileSetupEvent.submitProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đối tượng quan tâm'),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
        listener: (context, state) {
          if (state is ProfileSetupCompleted) {
            // Navigate to pending approval page
            context.go(AppPage.onboardingPending.toPath());
          } else if (state is ProfileSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileSetupLoading;

          // Pre-fill with existing data
          if (state is ProfileSetupInitial && _selectedOption == null) {
            if (state.interestedIn.isNotEmpty) {
              _selectedOption = state.interestedIn;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bước 4/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bạn quan tâm đến ai?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn đối tượng bạn muốn tìm hiểu',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Options
                ..._options.map((option) {
                  final isSelected = _selectedOption == option['value'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: isLoading
                          ? null
                          : () => setState(() => _selectedOption = option['value']),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? option['color'].withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? option['color']
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? option['color']
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                option['icon'],
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? option['color']
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: option['color'],
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 40),
                
                // Navigation Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Quay lại'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Hoàn thành'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

