import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';

@injectable
class MarkAsReadUseCase extends UseCase<void, MarkAsReadParams> {
  final ChatRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) {
    return repository.markAsRead(params.conversationId);
  }
}

class MarkAsReadParams extends Equatable {
  final String conversationId;

  const MarkAsReadParams(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}
