import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../auth/domain/entities/user/user_entity.dart';
import '../../data/models/interests_response.dart';
import '../entities/complete_profile_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetInterestsUseCase {
  final ProfileRepository repository;

  GetInterestsUseCase(this.repository);

  Future<Either<Failure, List<InterestCategory>>> call() async {
    return await repository.getInterests();
  }
}

@injectable
class GetMajorsUseCase {
  final ProfileRepository repository;

  GetMajorsUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getMajors();
  }
}

@injectable
class CompleteProfileUseCase {
  final ProfileRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    CompleteProfileEntity profile,
  ) async {
    return await repository.completeProfile(profile);
  }
}

@injectable
class GetMyProfileUseCase {
  final ProfileRepository repository;

  GetMyProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getMyProfile();
  }
}

