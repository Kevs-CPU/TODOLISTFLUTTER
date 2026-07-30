import '../../repositories/auth_repository.dart';

class UpdateVerifiedEmailUseCase {
  final AuthRepository repository;

  UpdateVerifiedEmailUseCase(this.repository);

  Future<void> execute({required String uid, required String email}) async {
    if (uid.isEmpty) {
      throw Exception('User ID is required.');
    }

    if (email.isEmpty || email.trim().isEmpty) {
      throw Exception('Email is required.');
    }

    try {
      await repository.updateVerifiedEmail(uid, email);
    } catch (e) {
      rethrow;
    }
  }
}