import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';
import '../widget/birthday_picker.dart.dart';

class Step1BasicInfoPage extends StatefulWidget {
  const Step1BasicInfoPage({super.key});

  @override
  State<Step1BasicInfoPage> createState() => _Step1BasicInfoPageState();
}

class _Step1BasicInfoPageState extends State<Step1BasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final _classController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Extract studentId from logged-in user's email
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      authState.maybeWhen(
        authenticated:
            (
              user,
              token,
              isNewUser,
              needsApproval,
              isApproved,
              isRejected,
              rejectionReason,
            ) {
              final email = user.email;
              final studentId = _extractStudentId(email);
              if (studentId.isNotEmpty) {
                setState(() {
                  _studentIdController.text = studentId;
                });
              }
            },
        orElse: () {},
      );
    });
  }

  /// Extract student ID from email
  /// Format: thao.lt231631@sis.hust.edu.vn -> 20231631
  String _extractStudentId(String email) {
    if (email.isEmpty) return '';

    try {
      // Get part before @
      final localPart = email.split('@').first;

      // Pattern 1: After underscore (e.g., thao.lt_231631)
      if (localPart.contains('_')) {
        final afterUnderscore = localPart.split('_').last;
        final match = RegExp(r'\d+').firstMatch(afterUnderscore);
        if (match != null) {
          final digits = match.group(0)!;
          // If 6 digits, add '20' prefix
          if (digits.length == 6) {
            return '20$digits';
          }
          // If 8 digits, return as is
          if (digits.length == 8) {
            return digits;
          }
        }
      }

      // Pattern 2: After dot+letters (e.g., thao.lt231631)
      final match = RegExp(
        r'\.([a-z]+)(\d{6,8})',
        caseSensitive: false,
      ).firstMatch(localPart);
      if (match != null) {
        final digits = match.group(2)!;
        // If 6 digits, add '20' prefix
        if (digits.length == 6) {
          return '20$digits';
        }
        // If 8 digits, return as is
        if (digits.length == 8) {
          return digits;
        }
      }

      // Pattern 3: Any 6-8 consecutive digits
      final digitsMatch = RegExp(r'\d{6,8}').firstMatch(localPart);
      if (digitsMatch != null) {
        final digits = digitsMatch.group(0)!;
        if (digits.length == 6) {
          return '20$digits';
        }
        return digits;
      }

      return '';
    } catch (e) {
      print('[Step1] Error extracting student ID: $e');
      return '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _majorController.dispose();
    _classController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<DateTime?> showBirthdayPicker(BuildContext context) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => const BirthdayPicker(),
    );
  }

  void _onNext() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedGender != null) {
      context.read<ProfileSetupBloc>().add(
        ProfileSetupEvent.basicInfoUpdated(
          name: _nameController.text.trim(),
          dateOfBirth: _selectedDate!.toIso8601String(),
          gender: _selectedGender!,
          major: _majorController.text.trim(),
          className: _classController.text.trim(),
          studentId: _studentIdController.text.trim(),
        ),
      );
      context.push(AppPage.onboardingPhotos.toPath());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân'), centerTitle: true),
      body: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          if (state is ProfileSetupInitial) {
            // Pre-fill with existing data if any
            if (_studentIdController.text.isEmpty &&
                state.studentId.isNotEmpty) {
              _studentIdController.text = state.studentId;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bước 1/4',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Điền đúng thông tin để có trải nghiệm tốt nhất!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  // Student ID (readonly)
                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(
                      labelText: 'Mã sinh viên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập họ tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày sinh *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final birthday = await showBirthdayPicker(context);

                      if (birthday != null) {
                        setState(() {
                          _selectedDate = birthday;
                          _dobController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(birthday);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Giới tính *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Nam')),
                      DropdownMenuItem(value: 'female', child: Text('Nữ')),
                      DropdownMenuItem(value: 'other', child: Text('Khác')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn giới tính';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Major
                  TextFormField(
                    controller: _majorController,
                    decoration: const InputDecoration(
                      labelText: 'Khoa/Viện *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập khoa/viện';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Class
                  TextFormField(
                    controller: _classController,
                    decoration: const InputDecoration(
                      labelText: 'Lớp *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.class_),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập lớp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Tiếp theo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
