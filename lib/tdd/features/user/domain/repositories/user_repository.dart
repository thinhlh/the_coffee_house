import 'package:dartz/dartz.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, CustomUser>> fetchUserData();
  Future<Either<Failure, void>> toggleFavoriteProduct(List<String> productId);
}
