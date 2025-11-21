import 'package:dartz/dartz.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../auth/domain/entities/user/user_entity.dart';
import '../entities/complete_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> completeProfile(
    CompleteProfileEntity profile,
  );

  Future<Either<Failure, UserEntity>> getMyProfile();

  Future<Either<Failure, UserEntity>> updateProfile(
    Map<String, dynamic> updates,
  );
}

