import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';
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
  final List<String> _selectedInterests = [];

  final List<Map<String, dynamic>> _availableInterests = [
    {'icon': '🎮', 'label': 'Gaming'},
    {'icon': '💃', 'label': 'Dancing'},
    {'icon': '🗣️', 'label': 'Language'},
    {'icon': '🎵', 'label': 'Music'},
    {'icon': '🎬', 'label': 'Movie'},
    {'icon': '📷', 'label': 'Photography'},
    {'icon': '🏛️', 'label': 'Architecture'},
    {'icon': '👗', 'label': 'Fashion'},
    {'icon': '📚', 'label': 'Book'},
    {'icon': '✍️', 'label': 'Writing'},
    {'icon': '🌿', 'label': 'Nature'},
    {'icon': '🎨', 'label': 'Painting'},
    {'icon': '⚽', 'label': 'Football'},
    {'icon': '😊', 'label': 'People'},
    {'icon': '🐾', 'label': 'Animals'},
    {'icon': '💪', 'label': 'Gym & Fitness'},
    {'icon': '🍔', 'label': 'Food & Drink'},
    {'icon': '✈️', 'label': 'Travel & Places'},
  ];

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _onNext() {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sở thích')),
      );
      return;
    }

    context.read<ProfileSetupBloc>().add(
          ProfileSetupEvent.interestsUpdated(
            interests: _selectedInterests,
            bio: _bioController.text.trim(),
          ),
        );
    context.push(AppPage.onboardingInterestedIn.toPath());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sở thích'),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          // Pre-fill with existing data
          if (state is ProfileSetupInitial && _selectedInterests.isEmpty) {
            _selectedInterests.addAll(state.interests);
            if (_bioController.text.isEmpty && state.bio.isNotEmpty) {
              _bioController.text = state.bio;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bước 3/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sở thích của bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn sở thích để tìm những người có cùng đam mê',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Interests Grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest['label']);
                    return GestureDetector(
                      onTap: () => _toggleInterest(interest['label']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              interest['icon'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              interest['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                
                // Bio
                const Text(
                  'Giới thiệu bản thân (không bắt buộc)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Viết vài dòng về bản thân bạn...',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Navigation Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
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
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Tiếp theo'),
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

