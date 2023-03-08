import 'dart:math';

import 'package:remedypractice/services/auth/auth_exceptions.dart';
import 'package:remedypractice/services/auth/auth_provider.dart';
import 'package:remedypractice/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(
        provider.isInitialized,
        false,
      );
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(
          const TypeMatcher<NotIntializedException>(),
        ),
      );
    });

    test('User should be null after initialization', () {
      expect(
        provider.currentUser,
        null,
      );
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(
          provider._isInitialized,
          true,
        );
      },
      timeout: const Timeout(
        Duration(
          seconds: 2,
        ),
      ),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foobar@gmail',
        password: 'foobar',
      );
      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<UserNotFoundAuthException>(),
        ),
      );
      final badPasswordUser = provider.createUser(
        email: 'someone@gmail.com',
        password: 'foobar',
      );
      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<WrongPasswordAuthException>(),
        ),
      );
      final correctUser = await provider.createUser(
        email: 'someone@gmail.com',
        password: 'foobar2',
      );
      expect(
        provider.currentUser,
        correctUser,
      );

      expect(provider.currentUser, correctUser);
      expect(correctUser.isEmailVerified, false);
    });

    test('Logged in user should be able to verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test("Should be able to logout and login again", () async {
      await provider.logOut();
      await provider.logIn(
        email: 'someone@gmail.com',
        password: 'foobar2',
      );
      final user = provider.currentUser;
      // print(user);
      expect(user, isNotNull);
    });
  });
}

class NotIntializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotIntializedException();

    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotIntializedException();
    if (email == 'foobar@gmail') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotIntializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user == null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotIntializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
