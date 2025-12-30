import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/failures/server_failure.dart';
import '../../../../core/error/handlers/token_provider.dart';
import '../../../auth/domain/entities/user/user_entity.dart';
import '../../domain/entities/complete_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_source/remote/user_api.dart';
import '../models/complete_profile_request.dart';
import '../models/interests_response.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final UserApi userApi;
  final TokenProvider tokenProvider;

  ProfileRepositoryImpl(this.userApi, this.tokenProvider);

  @override
  Future<Either<Failure, List<String>>> getMajors() async {
    try {
      print('[ProfileRepository] Fetching majors...');
      final response = await userApi.getMajors();
      print('[ProfileRepository] Got ${response.data.majors.length} majors');
      return Right(response.data.majors);
    } catch (e) {
      print('[ProfileRepository] Error fetching majors: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InterestCategory>>> getInterests() async {
    try {
      print('[ProfileRepository] Fetching interests...');
      final response = await userApi.getInterests();
      print(
        '[ProfileRepository] Got ${response.data.interests.length} categories',
      );
      return Right(response.data.interests);
    } catch (e) {
      print('[ProfileRepository] Error fetching interests: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> completeProfile(
    CompleteProfileEntity profile,
  ) async {
    try {
      print('[ProfileRepository] Completing profile...');

      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        return Left(ServerFailure('No authentication token'));
      }

      final request = CompleteProfileRequest(
        name: profile.name,
        dateOfBirth: _formatDate(profile.dateOfBirth),
        gender: profile.gender,
        bio: profile.bio ?? '', // Convert null to empty string
        interests: profile.interests,
        interestedIn: profile.interestedIn,
        datingPurpose: profile.datingPurpose,
        studentId: profile.studentId ?? '',
        major: profile.major,
        classField: profile.className,
        photos: profile.photos
            .map(
              (photo) => PhotoRequest(
                url: photo.url,
                publicId: photo.publicId ?? '', // Convert null to empty string
                isMain: photo.isMain,
              ),
            )
            .toList(),
      );

      final requestJson = request.toJson();
      // Ensure photos are properly serialized as JSON objects
      requestJson['photos'] = (requestJson['photos'] as List)
          .map((p) => p is PhotoRequest ? p.toJson() : p)
          .toList();
      print('[ProfileRepository] Request JSON: $requestJson');

      final response = await userApi.completeProfile(
        requestJson,
        'Bearer $token',
      );

      print('[ProfileRepository] Response: ${response.data.email}');

      return Right(response.data.toEntity());
    } catch (e) {
      print('[ProfileRepository] Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMyProfile() async {
    try {
      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        return Left(ServerFailure('No authentication token'));
      }

      final response = await userApi.getMyProfile('Bearer $token');
      return Right(response.data.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    try {
      final token = await tokenProvider.getAccessToken();
      if (token == null) {
        return Left(ServerFailure('No authentication token'));
      }

      final response = await userApi.updateProfile(updates, 'Bearer $token');
      return Right(response.data.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
