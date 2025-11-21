import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/image/image_picker_service.dart';
import '../../../../core/services/upload/upload_service.dart';
import '../../domain/entities/complete_profile_entity.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _majorController = TextEditingController();
  final _classController = TextEditingController();
  final _studentIdController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedInterestedIn;
  List<String> _selectedInterests = [];
  List<File> _pickedImages = [];
  List<String> _uploadedPhotoUrls = [];
  bool _isUploadingPhotos = false;

  final List<String> _availableInterests = [
    'Âm nhạc',
    'Du lịch',
    'Đọc sách',
    'Thể thao',
    'Ẩm thực',
    'Điện ảnh',
    'Chơi game',
    'Nhiếp ảnh',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _majorController.dispose();
    _classController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileSetupBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hoàn thiện hồ sơ'),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
          listener: (context, state) {
            state.maybeWhen(
              completed: (user) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hoàn thiện profile thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.go('/home');
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ và tên *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_selectedDate == null
                          ? 'Chọn ngày sinh *'
                          : 'Ngày sinh: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Giới tính *',
                        border: OutlineInputBorder(),
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
                    const SizedBox(height: 24),
                    const Text(
                      'Giới thiệu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        hintText: 'Giới thiệu về bản thân...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 500,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sở thích *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableInterests.map((interest) {
                        final isSelected =
                            _selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedInterestedIn,
                      decoration: const InputDecoration(
                        labelText: 'Quan tâm đến *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'men', child: Text('Nam')),
                        DropdownMenuItem(value: 'women', child: Text('Nữ')),
                        DropdownMenuItem(
                            value: 'everyone', child: Text('Tất cả')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedInterestedIn = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Vui lòng chọn quan tâm đến';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Thông tin trường học',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _majorController,
                      decoration: const InputDecoration(
                        labelText: 'Khoa/Viện *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập khoa/viện';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _classController,
                      decoration: const InputDecoration(
                        labelText: 'Lớp *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập lớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _studentIdController,
                      decoration: const InputDecoration(
                        labelText: 'Mã sinh viên (tùy chọn)',
                        hintText: 'Để trống sẽ tự động lấy từ email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ảnh đại diện',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isUploadingPhotos ? null : _pickAndUploadImage,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(_isUploadingPhotos ? 'Đang tải ảnh...' : 'Thêm ảnh'),
                    ),
                    if (_uploadedPhotoUrls.isNotEmpty || _pickedImages.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _uploadedPhotoUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _uploadedPhotoUrls[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey,
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _uploadedPhotoUrls.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                  if (index == 0)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.black54,
                                        padding: const EdgeInsets.all(4),
                                        child: const Text(
                                          'Ảnh chính',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Hoàn thành',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2002),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    // Show bottom sheet to choose source
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    // Pick image
    final imagePickerService = getIt<ImagePickerService>();
    final File? pickedFile = source == ImageSource.gallery
        ? await imagePickerService.pickImageFromGallery()
        : await imagePickerService.pickImageFromCamera();

    if (pickedFile == null) return;

    // Upload image
    setState(() {
      _isUploadingPhotos = true;
    });

    final uploadService = getIt<UploadService>();
    final uploadedUrl = await uploadService.uploadImage(pickedFile);

    setState(() {
      _isUploadingPhotos = false;
      if (uploadedUrl != null) {
        _uploadedPhotoUrls.add(uploadedUrl);
        _pickedImages.add(pickedFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload ảnh thất bại')),
        );
      }
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày sinh')),
      );
      return;
    }

    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sở thích')),
      );
      return;
    }

    if (_uploadedPhotoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất 1 ảnh')),
      );
      return;
    }

    final profile = CompleteProfileEntity(
      name: _nameController.text.trim(),
      dateOfBirth: _selectedDate!,
      gender: _selectedGender!,
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      interests: _selectedInterests,
      interestedIn: _selectedInterestedIn!,
      studentId: _studentIdController.text.trim().isEmpty
          ? null
          : _studentIdController.text.trim(),
      major: _majorController.text.trim(),
      className: _classController.text.trim(),
      photos: _uploadedPhotoUrls
          .asMap()
          .entries
          .map((entry) => PhotoEntity(
                url: entry.value,
                isMain: entry.key == 0,
              ))
          .toList(),
    );

    context.read<ProfileSetupBloc>().add(
          ProfileSetupEvent.completeProfileRequested(profile),
        );
  }
}

