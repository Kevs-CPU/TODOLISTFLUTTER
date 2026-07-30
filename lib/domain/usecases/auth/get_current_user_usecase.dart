import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository) {
    debugPrint('[GetCurrentUserUseCase] Initialized');
  }

  Future<dynamic> execute() async {
    debugPrint('[GetCurrentUserUseCase] Getting current user...');

    try {
      final user = await repository.getCurrentUser();

      debugPrint(
        '[GetCurrentUserUseCase] Current user: '
        '${user?.uid}',
      );

      return user;
    } catch (error) {
      debugPrint(
        '[GetCurrentUserUseCase] Failed: $error',
      );

      rethrow;
    }
  }
}