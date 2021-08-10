import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/common/data/models/custom_user_model.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';

void main() {
  final CustomUserModel userModel = CustomUserModel(
    'uid',
    'name',
    'email',
    DateTime.now(),
  );

  final CustomUser user = CustomUser(
    uid: 'uid',
    name: 'name',
    email: 'email',
    birthday: DateTime.now(),
  );
  test('should user model is a subclass of custom user', () async {
    // arrange

    // act
    expect(userModel, isA<CustomUser>());
    //assert
  });
}
