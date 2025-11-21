import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../error/handlers/token_provider.dart';

@lazySingleton
class UploadService {
  final Dio dio;
  final TokenProvider tokenProvider;

  UploadService(@Named('mainDio') this.dio, this.tokenProvider);

  /// Upload single image to backend
  Future<String?> uploadImage(File imageFile) async {
    try {
      print('[UploadService] Uploading image: ${imageFile.path}');

      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        print('[UploadService] No token found');
        return null;
      }

      // Create multipart file
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Upload to backend
      final response = await dio.post(
        '/upload/image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final url = response.data['data']['url'] as String?;
        print('[UploadService] Upload successful: $url');
        return url;
      }

      print('[UploadService] Upload failed: ${response.data}');
      return null;
    } catch (e) {
      print('[UploadService] Error uploading image: $e');
      return null;
    }
  }

  /// Upload multiple images to backend
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    try {
      print('[UploadService] Uploading ${imageFiles.length} images');

      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        print('[UploadService] No token found');
        return [];
      }

      // Create multipart files
      final List<MultipartFile> files = [];
      for (final file in imageFiles) {
        files.add(await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ));
      }

      final formData = FormData.fromMap({
        'images': files,
      });

      // Upload to backend
      final response = await dio.post(
        '/upload/images',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        final urls = data.map((item) => item['url'] as String).toList();
        print('[UploadService] Upload successful: ${urls.length} images');
        return urls;
      }

      print('[UploadService] Upload failed: ${response.data}');
      return [];
    } catch (e) {
      print('[UploadService] Error uploading images: $e');
      return [];
    }
  }
}

