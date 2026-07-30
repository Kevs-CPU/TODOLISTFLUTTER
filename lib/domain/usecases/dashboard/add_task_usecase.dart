import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class AddTaskUseCase {
  final TaskRepository taskRepository;
  final AuthRepository authRepository;
  final Uuid _uuid = const Uuid();

  AddTaskUseCase(this.taskRepository, this.authRepository) {
    debugPrint('[AddTaskUseCase] Initialized');
  }

  bool _validateGmail(String email) {
    debugPrint('[AddTaskUseCase] Validating Gmail address: $email');
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    final isValid = gmailRegex.hasMatch(email);
    debugPrint('[AddTaskUseCase] Gmail validation result: $isValid');
    return isValid;
  }

  Future<Task> execute({
    required String gmail,
    required String title,
    String? category,
    DateTime? dueDate,
  }) async {
    debugPrint(
      '[AddTaskUseCase] Started: gmail=$gmail, title=$title, category=$category, dueDate=$dueDate',
    );

    try {
      final currentUser = await authRepository.getCurrentUser();

      debugPrint(
        '[AddTaskUseCase] Current user: uid=${currentUser?.uid}, email=${currentUser?.email}',
      );

      if (currentUser == null) {
        throw AuthFailure(
          message: 'User not authenticated. Please log in again.',
        );
      }

      if (currentUser.uid.isEmpty) {
        throw ValidationFailure(
          message: 'User ID is required.',
        );
      }

      final cleanGmail = gmail.trim().toLowerCase();
      final cleanTitle = title.trim();
      final cleanCategory = category?.trim() ?? 'personal';

      if (cleanGmail.isEmpty) {
        throw ValidationFailure(
          message: 'Gmail address is required.',
        );
      }

      if (!_validateGmail(cleanGmail)) {
        throw ValidationFailure(
          message:
              'Please enter a valid Gmail address ending with @gmail.com.',
        );
      }

      final registeredGmail =
          currentUser.email?.trim().toLowerCase();

      if (registeredGmail == null || registeredGmail.isEmpty) {
        throw ValidationFailure(
          message:
              'No registered Gmail address was found for this account.',
        );
      }

      if (cleanGmail != registeredGmail) {
        throw ValidationFailure(
          message:
              'Invalid Gmail address. Please use the Gmail registered to this account.',
        );
      }

      if (cleanTitle.isEmpty) {
        throw ValidationFailure(
          message: 'Task description is required.',
        );
      }

      if (cleanTitle.length < 3) {
        throw ValidationFailure(
          message: 'Task title must be at least 3 characters.',
        );
      }

      final task = Task(
        id: _uuid.v4(),
        userId: currentUser.uid,
        username:
            currentUser.displayName ??
            currentUser.email?.split('@').first ??
            'User',
        gmail: cleanGmail,
        title: cleanTitle,
        completed: false,
        category: cleanCategory,

        // Automatic
        createdAt: DateTime.now(),

        // Optional
        dueDate: dueDate,
      );

      debugPrint('[AddTaskUseCase] Task created: $task');

      final result = await taskRepository.add(task);

      debugPrint('[AddTaskUseCase] Task added successfully: $result');

      return result;
    } catch (error) {
      debugPrint('[AddTaskUseCase] Failed: $error');

      if (error is Failure) rethrow;

      throw ServerFailure(
        message: error.toString(),
      );
    }
  }
}