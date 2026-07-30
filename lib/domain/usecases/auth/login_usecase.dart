import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository) {
    debugPrint('[LoginUseCase] Initialized');
  }

  Future<User?> execute({
    required String username,
    required String password,
  }) async {
    debugPrint('[LoginUseCase] Started: username=$username');

    try {
      // ✅ Validate inputs
      final usernameLower = username.trim().toLowerCase();
      final passwordTrimmed = password.trim();

      if (usernameLower.isEmpty) {
        throw ValidationFailure(message: 'Username is required.');
      }

      if (usernameLower.length < 3) {
        throw ValidationFailure(message: 'Username must be at least 3 characters.');
      }

      if (passwordTrimmed.isEmpty) {
        throw ValidationFailure(message: 'Password is required.');
      }

      if (passwordTrimmed.length < 6) {
        throw ValidationFailure(message: 'Password must be at least 6 characters.');
      }

      debugPrint('[LoginUseCase] Calling AuthRepository.login...');

      // ✅ Call repository
      final result = await repository.login(usernameLower, passwordTrimmed);

      if (result == null) {
        debugPrint('[LoginUseCase] ❌ Login failed: User not found');
        throw AuthFailure(message: 'Invalid username or password.');
      }

      debugPrint('[LoginUseCase] ✅ Login successful: uid=${result.uid}');
      return result;

    } on FirebaseAuthException catch (e) {
      // ✅ Handle Firebase Auth specific errors
      debugPrint('[LoginUseCase] ❌ FirebaseAuthException: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'user-not-found':
          throw AuthFailure(message: 'No account found with that username.');
        case 'wrong-password':
          throw AuthFailure(message: 'Incorrect password. Please try again.');
        case 'invalid-email':
          throw ValidationFailure(message: 'Invalid email format.');
        case 'user-disabled':
          throw AuthFailure(message: 'This account has been disabled.');
        case 'too-many-requests':
          throw AuthFailure(message: 'Too many failed attempts. Please try again later.');
        case 'network-request-failed':
          throw ServerFailure(message: 'Network error. Please check your internet connection.');
        default:
          throw ServerFailure(message: e.message ?? 'Login failed. Please try again.');
      }

    } on AuthFailure catch (e) {
      debugPrint('[LoginUseCase] ❌ AuthFailure: ${e.message}');
      rethrow;

    } on ValidationFailure catch (e) {
      debugPrint('[LoginUseCase] ❌ ValidationFailure: ${e.message}');
      rethrow;

    } on ServerFailure catch (e) {
      debugPrint('[LoginUseCase] ❌ ServerFailure: ${e.message}');
      rethrow;

    } catch (error) {
      debugPrint('[LoginUseCase] ❌ Unknown error: $error');
      throw ServerFailure(message: error.toString());
    }
  }
}