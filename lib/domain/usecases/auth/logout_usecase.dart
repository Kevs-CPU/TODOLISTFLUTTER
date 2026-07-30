import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository) {
    debugPrint('[LogoutUseCase] Initialized');
  }

  Future<void> execute() async {
    debugPrint('[LogoutUseCase] Started');

    try {
      await repository.logout();
      debugPrint('[LogoutUseCase] Logout successful');
    } catch (error) {
      debugPrint('[LogoutUseCase] Logout failed: $error');
      if (error is Failure) rethrow;
      throw ServerFailure(message: error.toString());
    }
  }
}