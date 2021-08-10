import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';

abstract class PromotionsRepository {
  Future<Either<Failure, List<Promotion>>> fetchPromotions();
}
