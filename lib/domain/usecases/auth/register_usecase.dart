import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository) {
    debugPrint('[RegisterUseCase] Initialized');
  }

  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  Future<dynamic> execute({
    required String username,
    required String gmail,
    required String password,
  }) async {
    debugPrint('[RegisterUseCase] Started: username=$username, gmail=$gmail');

    final cleanUsername = username.trim();
    final cleanGmail = gmail.trim().toLowerCase();

    if (!usernameRegex.hasMatch(cleanUsername)) {
      throw ValidationFailure(
        message: 'Username must be 3-20 characters (letters, numbers, underscore only).',
      );
    }

    if (!gmailRegex.hasMatch(cleanGmail)) {
      throw ValidationFailure(
        message: 'Please enter a valid Gmail address (example@gmail.com).',
      );
    }

    if (password.trim().isEmpty) {
      throw ValidationFailure(message: 'Password is required.');
    }

    if (password.length < 6) {
      throw ValidationFailure(message: 'Password must be at least 6 characters.');
    }

    debugPrint('[RegisterUseCase] Calling AuthRepository.register');

    try {
      final result = await repository.register(cleanUsername, cleanGmail, password);
      debugPrint('[RegisterUseCase] Registration successful');
      return result;
    } catch (error) {
      debugPrint('[RegisterUseCase] Registration failed: $error');
      if (error is Failure) rethrow;
      throw ServerFailure(message: error.toString());
    }
  }
}