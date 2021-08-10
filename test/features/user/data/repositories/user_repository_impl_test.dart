import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/data/models/custom_user_model.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/user/data/datasources/user_remote_data_source.dart';
import 'package:the/tdd/features/user/data/repositories/user_repository_impl.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  UserRepositoryImpl repository;
  MockUserRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource);
  });

  group('fetch user', () {
    final String exceptionMessage = '';

    final CustomUserModel userModel = CustomUserModel(
      'uid',
      'name',
      'email',
      DateTime.now(),
    );
    final CustomUser user = userModel;

    test('should forward the call to remote data source', () async {
      // arrange

      // act
      repository.fetchUserData();
      //assert
      verify(remoteDataSource.fetchUser());
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return Right of user entity when remote datasource return user model',
        () async {
      // arrange
      when(remoteDataSource.fetchUser()).thenAnswer((_) async => userModel);
      // act
      final result = await repository.fetchUserData();
      //assert
      expect(result, Right(user));
    });

    test(
        'should return Left of connection failure when remote data source throw connection exception',
        () async {
      // arrange
      when(remoteDataSource.fetchUser())
          .thenThrow(ConnectionException(message: exceptionMessage));
      // act
      final result = await repository.fetchUserData();
      //assert
      expect(result, Left(ConnectionFailure(message: exceptionMessage)));
    });
  });

  group('toggle favorite product', () {
    final favoriteProducts = ['123', '456'];

    test('should forward the call to remote data source', () async {
      // arrange

      // act
      repository.toggleFavoriteProduct(favoriteProducts);
      //assert
      verify(remoteDataSource.toggleFavoriteProduct(favoriteProducts));
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return Right when update favorite product status successfully',
        () async {
      // arrange
      when(remoteDataSource.toggleFavoriteProduct(any))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.toggleFavoriteProduct(favoriteProducts);
      //assert
      expect(result, Right(null));
    });

    test(
        'should return Left of Connection Failure when remote data source throw Connection exception',
        () async {
      // arrange
      when(remoteDataSource.toggleFavoriteProduct(any))
          .thenThrow(ConnectionException());
      // act
      final result = await repository.toggleFavoriteProduct(favoriteProducts);
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });
}
