import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';

class GetUserProfileUseCase {
  final AuthRepository repository;

  GetUserProfileUseCase(this.repository) {
    debugPrint('[GetUserProfileUseCase] Initialized');
  }

  Future<dynamic> execute(String uid) async {
    debugPrint(
      '[GetUserProfileUseCase] Started: uid=$uid',
    );

    if (uid.trim().isEmpty) {
      debugPrint(
        '[GetUserProfileUseCase] User ID is required',
      );

      throw Exception(
        'User ID is required.',
      );
    }

    debugPrint(
      '[GetUserProfileUseCase] '
      'Fetching user profile: ${uid.trim()}',
    );

    final profile =
        await repository.getUserProfile(
      uid.trim(),
    );

    debugPrint(
      '[GetUserProfileUseCase] '
      'User profile fetched successfully: '
      '$profile',
    );

    return profile;
  }
}