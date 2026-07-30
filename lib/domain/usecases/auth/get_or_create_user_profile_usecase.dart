import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';

class GetOrCreateUserProfileUseCase {
  final AuthRepository repository;

  GetOrCreateUserProfileUseCase(this.repository) {
    debugPrint(
      '[GetOrCreateUserProfileUseCase] Initialized',
    );
  }

  Future<dynamic> execute(dynamic user) async {
    debugPrint(
      '[GetOrCreateUserProfileUseCase] Started: '
      '${user?.uid}',
    );

    if (user == null ||
        user.uid == null ||
        user.uid!.isEmpty) {
      debugPrint(
        '[GetOrCreateUserProfileUseCase] User ID is required',
      );

      throw Exception(
        'User ID is required.',
      );
    }

    debugPrint(
      '[GetOrCreateUserProfileUseCase] Valid user ID: '
      '${user.uid}',
    );

    debugPrint(
      '[GetOrCreateUserProfileUseCase] '
      'Checking for existing profile...',
    );

    final existingProfile =
        await repository.getUserProfile(
      user.uid!,
    );

    if (existingProfile != null) {
      debugPrint(
        '[GetOrCreateUserProfileUseCase] '
        'Existing profile found: '
        '$existingProfile',
      );

      return existingProfile;
    }

    debugPrint(
      '[GetOrCreateUserProfileUseCase] '
      'No profile found, creating default',
    );

    final username =
        user.displayName ??
        user.email?.split('@').first ??
        'User';

    final email =
        user.email ?? '';

    debugPrint(
      '[GetOrCreateUserProfileUseCase] '
      'Creating profile with: '
      'uid=${user.uid}, '
      'username=$username, '
      'email=$email',
    );

    debugPrint(
      '[GetOrCreateUserProfileUseCase] '
      'Saving new profile to database...',
    );

    final newProfile =
        await repository.saveUserProfile(
      user.uid!,
      username,
      email,
    );

    debugPrint(
      '[GetOrCreateUserProfileUseCase] '
      'New profile created successfully: '
      '$newProfile',
    );

    return newProfile;
  }
}