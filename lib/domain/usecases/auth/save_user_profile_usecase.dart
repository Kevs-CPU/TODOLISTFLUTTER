import '../../repositories/auth_repository.dart';

class SaveUserProfileUseCase {
  final AuthRepository repository;

  SaveUserProfileUseCase(this.repository);

  Future<void> execute(
    String uid,
    String username,
    String email,
  ) async {
    if (uid.isEmpty) {
      throw Exception('User ID is required.');
    }

    if (username.trim().isEmpty) {
      throw Exception('Username is required.');
    }

    if (email.trim().isEmpty) {
      throw Exception('Email is required.');
    }

    await repository.saveUserProfile(
      uid,
      username.trim(),
      email.trim(),
    );
  }
}