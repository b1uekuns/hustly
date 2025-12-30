import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick single image with source selection
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('[ImagePickerService] Error picking image: $e');
      return null;
    }
  }

  /// Pick single image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('[ImagePickerService] Error picking from gallery: $e');
      return null;
    }
  }

  /// Pick single image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('[ImagePickerService] Error picking from camera: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({int maxImages = 6}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isEmpty) {
        return [];
      }

      // Limit to maxImages
      final limitedImages = images.take(maxImages).toList();
      return limitedImages.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      print('[ImagePickerService] Error picking multiple images: $e');
      return [];
    }
  }

  /// Show bottom sheet to choose image source
  Future<File?> showImageSourceDialog({
    required Function() onCameraPressed,
    required Function() onGalleryPressed,
  }) async {
    // This should be called from UI with showModalBottomSheet
    // Return null as placeholder
    return null;
  }
}
