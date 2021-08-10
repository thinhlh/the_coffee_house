import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_out.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/tdd/features/user/domain/usecases/fetch_user.dart';

class MockSignInWithEmailAndPassword extends Mock
    implements SignInWithEmailAndPassword {}

class MockSignUp extends Mock implements SignUp {}

class MockSignOut extends Mock implements SignOut {}

class MockFetchUser extends Mock implements FetchUser {}

void main() {
  //TODO HANDLE TEST FOR FETCHING USER INFO
  MockFetchUser fetchUser;
  MockSignInWithEmailAndPassword signInWithEmailAndPassword;
  MockSignUp signUp;
  MockSignOut signOut;
  AuthProvider provider;

  setUp(() {
    fetchUser = MockFetchUser();
    signInWithEmailAndPassword = MockSignInWithEmailAndPassword();
    signUp = MockSignUp();
    signOut = MockSignOut();

    provider = AuthProvider(
      signInWithEmailAndPassword,
      signUp,
      signOut,
      fetchUser,
    );
  });

  final SignInParams signInParams = SignInParams(
    email: 'email',
    password: 'password',
  );
  final SignUpParams signUpParams = SignUpParams(
    email: 'email',
    password: 'password',
    name: 'name',
    birthday: DateTime.now(),
  );

  // group('Loading Progress', () {
  //   test(
  //       'should show loading progress while signing in and dispatch loading when finished',
  //       () async {
  //     // arrange

  //     // act
  //     provider
  //         .signIn(signInParams)
  //         .whenComplete(() => expect(provider.loading, isFalse));
  //     //assert
  //     expect(provider.loading, isTrue);
  //   });

  //   test(
  //       'should show loading progress while register and dispatch loading when finished',
  //       () async {
  //     // arrange

  //     // act
  //     provider
  //         .signUp(signUpParams)
  //         .whenComplete(() => expect(provider.loading, isFalse));
  //     //assert
  //     expect(provider.loading, isTrue);
  //   });
  // });

  group('Should forward the call to appropriate usecase', () {
    test('should forward the call to sign in with email and password usecase',
        () async {
      // arrange
      when(signInWithEmailAndPassword(any)).thenAnswer(
        (_) async => Right(
          CustomUser(
            uid: 'uid',
            name: 'name',
            email: 'email',
            birthday: DateTime.now(),
          ),
        ),
      );
      // act
      provider.signIn(signInParams);
      //assert
      verify(signInWithEmailAndPassword(signInParams));
      verifyNoMoreInteractions(signInWithEmailAndPassword);
    });

    test('should forward the call to sign up use case', () async {
      // arrange
      when(signUp(any)).thenAnswer(
        (_) async => Right(
          CustomUser(
            uid: 'uid',
            name: 'name',
            email: 'email',
            birthday: DateTime.now(),
          ),
        ),
      );
      // act
      provider.signUp(signUpParams);
      //assert
      verify(signUp(signUpParams));
      verifyNoMoreInteractions(signUp);
    });

    test('should forward the call to sign out use case', () async {
      // arrange
      when(signOut(any)).thenAnswer((_) async => Right(null));
      // act
      provider.signOut();
      //assert
      verify(signOut(NoParams()));
      verifyNoMoreInteractions(signOut);
    });
  });

  group('Sign In with email and password', () {
    //TODO testing when sign in here
  });

  group('Sign up', () {
    //TODO testing when create account here
  });

  group('Sign out', () {
    //TODO testing when sign out here
  });
}
