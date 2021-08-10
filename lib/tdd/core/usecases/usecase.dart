import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:the/tdd/core/errors/failures.dart';

// ReturnType is the type the usecase will return to the UI
// Params is the params that the usecase use as parameter
abstract class BaseUseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// No parameter for this use case
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
