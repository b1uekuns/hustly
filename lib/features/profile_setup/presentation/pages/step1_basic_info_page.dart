import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
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
    _extractStudentIdFromAuth();
  }

  void _extractStudentIdFromAuth() {
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

  String _extractStudentId(String email) {
    try {
      final localPart = email.split('@').first;

      //Tìm 6 chữ số sau dấu . cuối cùng
      final match = RegExp(
        r'\.([a-z]+)(\d{6})$',
        caseSensitive: false,
      ).firstMatch(localPart);

      if (match != null) {
        final digits = match.group(2)!;
        return '20$digits';
      }

      return '';
    } catch (e) {
      debugPrint('[Step1] Error extracting student ID: $e');
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

  Future<DateTime?> _showBirthdayPicker() {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
        ),
        child: const BirthdayPicker(),
      ),
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
        SnackBar(
          content: const Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: AppColor.redPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          if (state is ProfileSetupInitial) {
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
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 40),

                  // Student ID (readonly)
                  _buildStudentIdField(),
                  const SizedBox(height: 20),

                  // Name
                  _buildNameField(),
                  const SizedBox(height: 20),

                  // Date of Birth
                  _buildDateOfBirthField(),
                  const SizedBox(height: 20),

                  // Gender
                  _buildGenderField(),
                  const SizedBox(height: 20),

                  // Major
                  _buildMajorField(),
                  const SizedBox(height: 20),

                  // Class
                  _buildClassField(),
                  const SizedBox(height: 40),

                  // Next Button
                  _buildNextButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress badge
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
            'Bước 1/4',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Title with gradient
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Text(
            'Hãy cho chúng tôi\nbiết về bạn 💕',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle
        Text(
          'Điền thông tin để bắt đầu hành trình tìm kiếm người ấy',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.blackLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentIdField() {
    return TextFormField(
      controller: _studentIdController,
      decoration: AppTheme.customInput(
        labelText: 'Mã sinh viên',
        prefixIcon: Icons.badge_outlined,
        readOnly: true,
      ),
      readOnly: true,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.redPrimarySecond,
        fontSize: 15,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: AppTheme.customInput(
        labelText: 'Họ và tên',
        prefixIcon: Icons.person_outline,
      ),
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập họ tên';
        }
        if (value.trim().length < 2) {
          return 'Tên quá ngắn';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return TextFormField(
      controller: _dobController,
      decoration: AppTheme.customInput(
        labelText: 'Ngày sinh',
        prefixIcon: Icons.calendar_month_outlined,
      ),
      readOnly: true,
      style: const TextStyle(
        fontSize: 15,
        color: AppColor.blackPrimary,
        fontWeight: FontWeight.w500,
      ),
      onTap: () async {
        final birthday = await _showBirthdayPicker();
        if (birthday != null) {
          setState(() {
            _selectedDate = birthday;
            _dobController.text = DateFormat('dd/MM/yyyy').format(birthday);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn ngày sinh';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: AppTheme.customInput(
        labelText: 'Giới tính',
        prefixIcon: Icons.wc_outlined,
      ),
      dropdownColor: AppColor.white,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColor.greyBold,
        size: 24,
      ),
      style: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
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
    );
  }

  Widget _buildMajorField() {
    return TextFormField(
      controller: _majorController,
      decoration: AppTheme.customInput(
        labelText: 'Khoa/Viện',
        prefixIcon: Icons.school_outlined,
      ),
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập khoa/viện';
        }
        return null;
      },
    );
  }

  Widget _buildClassField() {
    return TextFormField(
      controller: _classController,
      decoration: AppTheme.customInput(
        labelText: 'Lớp',
        prefixIcon: Icons.class_outlined,
      ),
      textCapitalization: TextCapitalization.characters,
      style: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập lớp';
        }
        return null;
      },
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: AppTheme.gradientButtonDecoration,
      child: ElevatedButton(
        onPressed: _onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Tiếp theo',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
