import 'package:flutter/foundation.dart';

class GetUsernameUseCase {
  GetUsernameUseCase() {
    debugPrint('[GetUsernameUseCase] Initialized');
  }

  String execute({
    Map<String, dynamic>? userProfile,
    dynamic user,
  }) {
    debugPrint(
      '[GetUsernameUseCase] Getting username '
      'hasProfile=${userProfile != null}, '
      'hasUser=${user != null}',
    );

    // Priority 1: Username from user profile
    final profileUsername =
        userProfile?['username'];

    if (profileUsername != null &&
        profileUsername.toString().isNotEmpty) {
      debugPrint(
        '[GetUsernameUseCase] Using username from profile: '
        '$profileUsername',
      );

      return profileUsername.toString();
    }

    // Priority 2: Display name from authenticated user
    final displayName =
        user?.displayName;

    if (displayName != null &&
        displayName.toString().isNotEmpty) {
      debugPrint(
        '[GetUsernameUseCase] Using display name: '
        '$displayName',
      );

      return displayName.toString();
    }

    // Priority 3: Email prefix
    final email =
        user?.email;

    if (email != null &&
        email.toString().isNotEmpty) {
      final username =
          email.toString().split('@').first;

      debugPrint(
        '[GetUsernameUseCase] Using email prefix: '
        '$username',
      );

      return username;
    }

    // Priority 4: Default fallback
    debugPrint(
      '[GetUsernameUseCase] Using default fallback: User',
    );

    return 'User';
  }
}