import 'package:dartz/dartz.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../auth/domain/entities/user/user_entity.dart';
import '../../data/models/interests_response.dart';
import '../entities/complete_profile_entity.dart';

abstract class ProfileRepository {
  /// Get list of majors (Trường/Khoa)
  Future<Either<Failure, List<String>>> getMajors();

  /// Get list of interests categorized
  Future<Either<Failure, List<InterestCategory>>> getInterests();

  Future<Either<Failure, UserEntity>> completeProfile(
    CompleteProfileEntity profile,
  );

  Future<Either<Failure, UserEntity>> getMyProfile();

  Future<Either<Failure, UserEntity>> updateProfile(
    Map<String, dynamic> updates,
  );
}

