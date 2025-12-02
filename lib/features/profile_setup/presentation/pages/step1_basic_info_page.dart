import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/features/profile_setup/presentation/widget/birthday_picker.dart.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

class Step1BasicInfoPage extends StatefulWidget {
  const Step1BasicInfoPage({super.key});

  @override
  State<Step1BasicInfoPage> createState() => _Step1BasicInfoPageState();
}

class _Step1BasicInfoPageState extends State<Step1BasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _classController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  String? _selectedMajor;
  DateTime? _selectedDate;

  // Danh sách khoa/viện HUST
  final List<String> _majors = [
    'Trường Công nghệ thông tin và Truyền thông',
    'Trường Điện - Điện tử',
    'Trường Cơ khí',
    'Trường Kinh tế',
    'Trường Hóa và Khoa học sự sống',
    'Trường Vật liệu',
    'Khoa Toán - Tin',
    'Khoa Vật lý Kỹ thuật',
    'Khoa Ngoại ngữ',
    'Khoa Khoa học và công nghệ giáo dục',
    'TT Đào tạo liên tục',
  ];

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

  Future<void> _showGenderPicker() async {
    final genders = [
      {'value': 'male', 'label': 'Nam', 'icon': Icons.male},
      {'value': 'female', 'label': 'Nữ', 'icon': Icons.female},
      {'value': 'other', 'label': 'Khác', 'icon': Icons.transgender},
    ];

    final result = await showModalBottomSheet<String>(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chọn giới tính',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.blackPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...genders.map(
              (g) => _buildOptionTile(
                value: g['value'] as String,
                label: g['label'] as String,
                icon: g['icon'] as IconData,
                isSelected: _selectedGender == g['value'],
                onTap: () => Navigator.pop(context, g['value'] as String),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedGender = result);
    }
  }

  Future<void> _showMajorPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag indicator
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chọn Khoa/Viện',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.blackPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _majors.length,
                itemBuilder: (context, index) {
                  final major = _majors[index];
                  final isSelected = _selectedMajor == major;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.redPrimary.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        color: isSelected ? AppColor.redPrimary : Colors.grey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      major,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColor.redPrimary
                            : AppColor.blackPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColor.redPrimary,
                          )
                        : null,
                    onTap: () => Navigator.pop(context, major),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedMajor = result);
    }
  }

  Widget _buildOptionTile({
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.redPrimary.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColor.redPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.redPrimary.withOpacity(0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColor.redPrimary : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColor.redPrimary
                      : AppColor.blackPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColor.redPrimary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedGender != null &&
        _selectedMajor != null) {
      context.read<ProfileSetupBloc>().add(
        ProfileSetupEvent.basicInfoUpdated(
          name: _nameController.text.trim(),
          dateOfBirth: _selectedDate!.toIso8601String(),
          gender: _selectedGender!,
          major: _selectedMajor!,
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
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildStudentIdField(),
                  const SizedBox(height: 20),
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildDateOfBirthField(),
                  const SizedBox(height: 20),
                  _buildGenderField(),
                  const SizedBox(height: 20),
                  _buildMajorField(),
                  const SizedBox(height: 20),
                  _buildClassField(),
                  const SizedBox(height: 40),
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

  // Field với khung mềm mại
  Widget _buildSoftField({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildStudentIdField() {
    return TextFormField(
      controller: _studentIdController,
      decoration: _softInputDecoration(
        labelText: 'Mã sinh viên',
        prefixIcon: Icons.badge_outlined,
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
      decoration: _softInputDecoration(
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
      decoration: _softInputDecoration(
        labelText: 'Ngày sinh',
        prefixIcon: Icons.calendar_month_outlined,
        suffixIcon: Icons.keyboard_arrow_down_rounded,
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
    return GestureDetector(
      onTap: _showGenderPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.wc_outlined, color: Colors.grey.shade600, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedGender != null
                    ? _getGenderLabel(_selectedGender!)
                    : 'Giới tính',
                style: TextStyle(
                  fontSize: 15,
                  color: _selectedGender != null
                      ? AppColor.blackPrimary
                      : Colors.grey.shade500,
                  fontWeight: _selectedGender != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMajorField() {
    return GestureDetector(
      onTap: _showMajorPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.school_outlined, color: Colors.grey.shade600, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedMajor ?? 'Khoa/Viện',
                style: TextStyle(
                  fontSize: 15,
                  color: _selectedMajor != null
                      ? AppColor.blackPrimary
                      : Colors.grey.shade500,
                  fontWeight: _selectedMajor != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassField() {
    return TextFormField(
      controller: _classController,
      decoration: _softInputDecoration(
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
        child: const Text(
          'Tiếp theo',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _getGenderLabel(String value) {
    switch (value) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return '';
    }
  }

  InputDecoration _softInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600, size: 22),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: Colors.grey.shade600)
          : null,
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
        borderSide: const BorderSide(color: AppColor.redPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
