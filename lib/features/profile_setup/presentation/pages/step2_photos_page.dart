import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/routes/app_page.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/resources/app_color.dart';
import '../../../../core/resources/app_theme.dart';
import '../../../../core/services/image/image_picker_service.dart';
import '../bloc/profile_setup_bloc.dart';
import '../bloc/profile_setup_event.dart';
import '../bloc/profile_setup_state.dart';

class Step2PhotosPage extends StatefulWidget {
  const Step2PhotosPage({super.key});

  @override
  State<Step2PhotosPage> createState() => _Step2PhotosPageState();
}

class _Step2PhotosPageState extends State<Step2PhotosPage> {
  static const int _maxPhotos = 6;

  // Cache để tránh tạo mới object mỗi lần build
  late final ImagePickerService _imagePickerService;

  @override
  void initState() {
    super.initState();
    _imagePickerService = getIt<ImagePickerService>();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePickerService.pickImage(source: source);

      if (image != null && mounted) {
        debugPrint('[Step2] Image picked: ${image.path}');
        context.read<ProfileSetupBloc>().add(
          ProfileSetupEvent.uploadPhotoRequested(image),
        );
      } else {
        debugPrint('[Step2] No image selected');
      }
    } catch (e) {
      debugPrint('[Step2] Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chọn ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Chọn nguồn ảnh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blackPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Máy ảnh',
                      color: AppColor.redPrimary,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildSourceOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Thư viện',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _onNext(List<String> photos) {
    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng thêm ít nhất 1 ảnh'),
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
    context.push(AppPage.onboardingInterests.toPath());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Thêm ảnh'),
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
        listenWhen: (previous, current) => current is ProfileSetupError,
        listener: (context, state) {
          if (state is ProfileSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          // Chỉ rebuild khi photos thay đổi hoặc upload state thay đổi
          if (previous is ProfileSetupInitial &&
              current is ProfileSetupInitial) {
            return previous.photoUrls != current.photoUrls;
          }
          // Rebuild khi chuyển state (uploading, error, etc.)
          return previous.runtimeType != current.runtimeType;
        },
        builder: (context, state) {
          final photos = state is ProfileSetupInitial
              ? state.photoUrls
              : <String>[];
          final isUploading = state is UploadingPhoto;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildPhotoGrid(photos, isUploading),
                const SizedBox(height: 16),
                _buildPhotoCounter(photos.length),
                const SizedBox(height: 32),
                _buildNextButton(photos),
                const SizedBox(height: 20),
              ],
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
            'Bước 2/5',
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
            'Khoe vẻ đẹp của cậu nào!',
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
          'Thêm ít nhất 1 ảnh để người khác có thể thấy bạn',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.blackLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGrid(List<String> photos, bool isUploading) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _maxPhotos,
      itemBuilder: (context, index) {
        final hasPhoto = index < photos.length;
        final isFirstEmpty = !hasPhoto && index == photos.length;

        if (hasPhoto) {
          return _buildPhotoItem(photos[index], index);
        } else {
          return _buildEmptySlot(
            index: index,
            isFirstEmpty: isFirstEmpty,
            isUploading: isUploading && isFirstEmpty,
          );
        }
      },
    );
  }

  Widget _buildPhotoItem(String photoUrl, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColor.redPrimary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Main photo badge
        if (index == 0)
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.redPrimary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Ảnh chính',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Delete button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              context.read<ProfileSetupBloc>().add(
                ProfileSetupEvent.deletePhotoRequested(photoUrl),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySlot({
    required int index,
    required bool isFirstEmpty,
    required bool isUploading,
  }) {
    return GestureDetector(
      onTap: isUploading ? null : _showImageSourceDialog,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isFirstEmpty
              ? AppColor.redPrimary.withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFirstEmpty
                ? AppColor.redPrimary.withOpacity(0.3)
                : Colors.grey.shade200,
            width: isFirstEmpty ? 2 : 1,
            style: BorderStyle.solid,
          ),
        ),
        child: isUploading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppColor.redPrimary,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đang tải...',
                    style: TextStyle(
                      color: AppColor.redPrimary.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isFirstEmpty
                          ? AppColor.redPrimary.withOpacity(0.1)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFirstEmpty
                          ? Icons.add_a_photo_rounded
                          : Icons.add_rounded,
                      size: 28,
                      color: isFirstEmpty
                          ? AppColor.redPrimary
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Thêm ảnh',
                    style: TextStyle(
                      color: isFirstEmpty
                          ? AppColor.redPrimary
                          : Colors.grey.shade400,
                      fontSize: 13,
                      fontWeight: isFirstEmpty
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPhotoCounter(int count) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: count > 0
              ? AppColor.redPrimary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              count > 0 ? Icons.check_circle : Icons.photo_library_outlined,
              size: 18,
              color: count > 0 ? AppColor.redPrimary : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              '$count / $_maxPhotos ảnh đã thêm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: count > 0 ? AppColor.redPrimary : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(List<String> photos) {
    final isEnabled = photos.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: isEnabled
          ? AppTheme.gradientButtonDecoration
          : BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
      child: ElevatedButton(
        onPressed: isEnabled ? () => _onNext(photos) : null,
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
    );
  }
}
