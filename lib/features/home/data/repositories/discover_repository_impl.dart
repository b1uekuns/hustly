import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/failures/server_failure.dart';
import '../../../../core/error/handlers/token_provider.dart';
import '../../domain/repositories/discover_repository.dart';
import '../data_sources/remote/discover_api.dart';
import '../models/discover_user_model.dart';

@LazySingleton(as: DiscoverRepository)
class DiscoverRepositoryImpl implements DiscoverRepository {
  final DiscoverApi discoverApi;
  final TokenProvider tokenProvider;

  DiscoverRepositoryImpl({
    required this.discoverApi,
    required this.tokenProvider,
  });

  Future<String> _getAuthHeader() async {
    final token = await tokenProvider.getAccessToken();
    return 'Bearer $token';
  }

  @override
  Future<Either<Failure, DiscoverData>> getDiscover({int page = 1, int limit = 10}) async {
    try {
      final auth = await _getAuthHeader();
      final response = await discoverApi.getDiscover(auth, page, limit);
      return Right(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Lỗi khi lấy danh sách gợi ý';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LikeData>> likeUser(String userId) async {
    try {
      final auth = await _getAuthHeader();
      final response = await discoverApi.likeUser(userId, auth);
      return Right(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Lỗi khi thích người dùng';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> passUser(String userId) async {
    try {
      final auth = await _getAuthHeader();
      await discoverApi.passUser(userId, auth);
      return const Right(null);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Lỗi khi bỏ qua người dùng';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LikeData>> superlikeUser(String userId) async {
    try {
      final auth = await _getAuthHeader();
      final response = await discoverApi.superlikeUser(userId, auth);
      return Right(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Lỗi khi super like';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DiscoverData>> getMatches({int page = 1, int limit = 20}) async {
    try {
      final auth = await _getAuthHeader();
      final response = await discoverApi.getMatches(auth, page, limit);
      return Right(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Lỗi khi lấy danh sách match';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

