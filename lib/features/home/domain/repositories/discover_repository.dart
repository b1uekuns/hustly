import 'package:dartz/dartz.dart';
import '../../../../core/error/failures/failure.dart';
import '../../data/models/discover_user_model.dart';

abstract class DiscoverRepository {
  /// Get discover suggestions
  Future<Either<Failure, DiscoverData>> getDiscover({
    int page = 1,
    int limit = 10,
  });

  /// Like a user
  Future<Either<Failure, LikeData>> likeUser(String userId);

  /// Pass (skip) a user
  Future<Either<Failure, void>> passUser(String userId);

  /// Get matches
  Future<Either<Failure, DiscoverData>> getMatches({
    int page = 1,
    int limit = 20,
  });
}
