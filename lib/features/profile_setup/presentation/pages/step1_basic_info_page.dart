import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/features/profile_setup/presentation/widget/birthday_picker.dart.dart';
import 'package:hust_chill_app/widgets/selection_bottom_sheet/selection_bottom_sheet.dart';
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

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isInitialized = false; // Flag để tránh initialize nhiều lần

  static const List<String> _fallbackMajors = [
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  /// Initialize data: extract student ID and fetch majors
  void _initializeData() {
    // 1. Extract student ID from auth state
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
            final studentId = _extractStudentId(user.email);
            if (studentId.isNotEmpty) {
              setState(() {
                _studentIdController.text = studentId;
              });
            }
          },
      orElse: () {},
    );

    // 2. Fetch majors from backend
    context.read<ProfileSetupBloc>().add(const ProfileSetupEvent.fetchMajors());
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

  /// Unfocus any text field before showing picker
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  Future<DateTime?> _showBirthdayPicker() {
    _unfocusAll(); // Unfocus text fields
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
    _unfocusAll(); // Unfocus TRƯỚC khi mở picker
    
    final genders = [
      {'value': 'male', 'label': 'Nam', 'icon': Icons.male},
      {'value': 'female', 'label': 'Nữ', 'icon': Icons.female},
      {'value': 'other', 'label': 'Khác', 'icon': Icons.transgender},
    ];

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionBottomSheet<Map<String, dynamic>>(
        title: 'Chọn giới tính',
        options: genders,
        selectedItem: genders.firstWhere(
          (g) => g['value'] == _selectedGender,
          orElse: () => {},
        ),
        labelBuilder: (item) => item['label'] as String,
        iconBuilder: (item) => item['icon'] as IconData,
      ),
    );

    _unfocusAll(); // Unfocus SAU KHI picker đóng

    if (result != null) {
      setState(() => _selectedGender = result['value'] as String);
      if (_autovalidateMode == AutovalidateMode.onUserInteraction) {
        _formKey.currentState?.validate();
      }
    }
  }

  Future<void> _showMajorPicker() async {
    _unfocusAll(); // Unfocus TRƯỚC khi mở picker
    
    // Get majors from state, fallback to hardcoded list if empty
    final state = context.read<ProfileSetupBloc>().state;
    List<String> majors = _fallbackMajors;

    if (state is ProfileSetupInitial && state.availableMajors.isNotEmpty) {
      majors = state.availableMajors;
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SelectionBottomSheet<String>(
        title: 'Chọn Trường/Khoa',
        options: majors,
        selectedItem: _selectedMajor,
        labelBuilder: (item) => item,
        iconBuilder: (item) => Icons.school_outlined,
      ),
    );

    _unfocusAll(); // Unfocus SAU KHI picker đóng

    if (result != null) {
      setState(() => _selectedMajor = result);
      if (_autovalidateMode == AutovalidateMode.onUserInteraction) {
        _formKey.currentState?.validate();
      }
    }
  }

  void _onNext() {
    // Enable auto-validate after first submit attempt
    if (_autovalidateMode != AutovalidateMode.onUserInteraction) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }

    final isFormValid = _formKey.currentState!.validate();
    final isAllFieldsFilled = _selectedDate != null &&
        _selectedGender != null &&
        _selectedMajor != null;

    if (isFormValid && isAllFieldsFilled) {
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
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
        listenWhen: (previous, current) {
          // Chỉ listen khi studentId thay đổi
          if (previous is ProfileSetupInitial && current is ProfileSetupInitial) {
            return previous.studentId != current.studentId;
          }
          return false;
        },
        listener: (context, state) {
          // Update controller trong listener (không phải builder) để tránh rebuild
          if (state is ProfileSetupInitial && !_isInitialized) {
            if (state.studentId.isNotEmpty && _studentIdController.text.isEmpty) {
              _studentIdController.text = state.studentId;
              _isInitialized = true;
            }
          }
        },
        buildWhen: (previous, current) {
          // Chỉ rebuild khi cần thiết
          if (previous is ProfileSetupInitial && current is ProfileSetupInitial) {
            return previous.availableMajors != current.availableMajors ||
                   previous.isMajorsLoading != current.isMajorsLoading;
          }
          return previous != current;
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
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
            'Hãy cho tớ biết về cậu 💕',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
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
      style: const TextStyle(
        fontSize: 15,
        color: AppColor.blackPrimary,
        fontWeight: FontWeight.w500,
      ),
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
    return FormField<DateTime>(
      validator: (value) {
        if (_selectedDate == null) {
          return 'Vui lòng chọn ngày sinh';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return GestureDetector(
          onTap: () async {
            final birthday = await _showBirthdayPicker();
            _unfocusAll(); // Unfocus SAU KHI picker đóng
            if (birthday != null) {
              setState(() {
                _selectedDate = birthday;
                _dobController.text = DateFormat('dd/MM/yyyy').format(birthday);
              });
              state.didChange(birthday);
            }
          },
          child: InputDecorator(
            decoration: _softInputDecoration(
              labelText: 'Ngày sinh',
              prefixIcon: Icons.calendar_month_outlined,
              suffixIcon: Icons.keyboard_arrow_down_rounded,
            ).copyWith(errorText: state.errorText),
            isEmpty: _selectedDate == null,
            child: Text(
              _dobController.text.isNotEmpty ? _dobController.text : '',
              style: const TextStyle(
                fontSize: 15,
                color: AppColor.blackPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderField() {
    return FormField<String>(
      validator: (value) {
        if (_selectedGender == null) {
          return 'Vui lòng chọn giới tính';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await _showGenderPicker();
                state.didChange(_selectedGender);
              },
              child: InputDecorator(
                decoration: _softInputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icons.wc_outlined,
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                ).copyWith(errorText: state.errorText),
                isEmpty: _selectedGender == null,
                child: Text(
                  _selectedGender != null
                      ? _getGenderLabel(_selectedGender!)
                      : '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColor.blackPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMajorField() {
    return FormField<String>(
      validator: (value) {
        if (_selectedMajor == null) return 'Vui lòng chọn Trường/Khoa';
        return null;
      },
      builder: (FormFieldState<String> state) {
        return GestureDetector(
          onTap: () async {
            await _showMajorPicker();
            state.didChange(_selectedMajor);
          },
          child: InputDecorator(
            decoration: _softInputDecoration(
              labelText: 'Trường/Khoa',
              prefixIcon: Icons.school_outlined,
              suffixIcon: Icons.keyboard_arrow_down_rounded,
            ).copyWith(errorText: state.errorText),
            isEmpty: _selectedMajor == null,
            child: Text(
              _selectedMajor ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: AppColor.blackPrimary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
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
      style: const TextStyle(
        fontSize: 15,
        color: AppColor.blackPrimary,
        fontWeight: FontWeight.w500,
      ),
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

