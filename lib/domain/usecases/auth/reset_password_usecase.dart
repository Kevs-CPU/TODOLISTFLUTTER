import '../../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  static final RegExp gmailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  Future<void> execute(String gmail) async {
    final cleanGmail = gmail.trim().toLowerCase();

    if (cleanGmail.isEmpty) {
      throw Exception('Gmail address is required.');
    }

    if (!gmailRegex.hasMatch(cleanGmail)) {
      throw Exception(
        'Please enter a valid Gmail address (example@gmail.com).',
      );
    }

    await repository.resetPassword(cleanGmail);
  }
}