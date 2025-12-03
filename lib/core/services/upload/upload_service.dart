import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../error/failures/failure.dart';
import '../../error/failures/server_failure.dart';
import '../../error/handlers/token_provider.dart';

@lazySingleton
class UploadService {
  final Dio dio;
  final TokenProvider tokenProvider;

  UploadService(@Named('mainDio') this.dio, this.tokenProvider);

  /// Upload single image to backend (returns Either for error handling)
  Future<Either<Failure, String>> uploadImage(XFile imageFile) async {
    try {
      print('[UploadService] Uploading image: ${imageFile.path}');

      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        print('[UploadService] No token found');
        return const Left(ServerFailure('No authentication token'));
      }

      // Create multipart file (field name must match backend: 'image')
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      // Upload to backend
      final response = await dio.post(
        '/api/v1/upload/image',
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
        if (url != null) {
          print('[UploadService] Upload successful: $url');
          return Right(url);
        }
        return const Left(ServerFailure('No URL in response'));
      }

      print('[UploadService] Upload failed: ${response.data}');
      return Left(ServerFailure(response.data['error']?['message'] ?? 'Upload failed'));
    } on DioException catch (e) {
      print('[UploadService] DioException: ${e.message}');
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      print('[UploadService] Error uploading image: $e');
      return Left(ServerFailure(e.toString()));
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

