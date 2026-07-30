import 'package:flutter/foundation.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class RemoveTaskUseCase {
  final TaskRepository taskRepository;
  final AuthRepository authRepository;

  RemoveTaskUseCase(this.taskRepository, this.authRepository) {
    debugPrint('[RemoveTaskUseCase] Initialized');
  }

  Future<String> execute(String id) async {
    debugPrint('[RemoveTaskUseCase] Started: $id');

    try {
      final currentUser = await authRepository.getCurrentUser();
      debugPrint('[RemoveTaskUseCase] Current user: ${currentUser?.uid}');

      if (currentUser == null) {
        throw AuthFailure(message: 'User not authenticated');
      }

      if (currentUser.uid.isEmpty) {
        throw ValidationFailure(message: 'User ID is required');
      }

      if (id.trim().isEmpty) {
        throw ValidationFailure(message: 'Task ID is required');
      }

      final cleanId = id.trim();
      debugPrint('[RemoveTaskUseCase] Getting task: $cleanId');

      final task = await taskRepository.getById(cleanId);
      debugPrint('[RemoveTaskUseCase] Task found: $task');

      if (task == null) {
        throw NotFoundFailure(message: 'Task not found');
      }

      if (task.userId != currentUser.uid) {
        throw AuthFailure(message: 'You do not have permission to delete this task');
      }

      debugPrint('[RemoveTaskUseCase] Removing task: $cleanId');

      final result = await taskRepository.remove(cleanId);
      debugPrint('[RemoveTaskUseCase] Remove successful: $result');
      return result;
    } catch (error) {
      debugPrint('[RemoveTaskUseCase] Remove failed: $error');
      if (error is Failure) rethrow;
      throw ServerFailure(message: error.toString());
    }
  }
}