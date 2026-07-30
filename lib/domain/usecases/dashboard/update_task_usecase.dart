import 'package:flutter/foundation.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;
  final AuthRepository authRepository;

  UpdateTaskUseCase(this.taskRepository, this.authRepository);

  Future<Task> execute({
    required String id,
    String? title,
    bool? completed,
    String? category,
    DateTime? dueDate,
  }) async {
    debugPrint('[UpdateTaskUseCase] Started: id=$id, title=$title, completed=$completed, category=$category, dueDate=$dueDate');

    try {
      final currentUser = await authRepository.getCurrentUser();
      debugPrint('[UpdateTaskUseCase] Current user: ${currentUser?.uid}');

      if (currentUser == null) {
        throw AuthFailure(message: 'User not authenticated');
      }

      if (currentUser.uid.isEmpty) {
        throw ValidationFailure(message: 'User ID is required.');
      }

      if (id.trim().isEmpty) {
        throw ValidationFailure(message: 'Task ID is required.');
      }

      debugPrint('[UpdateTaskUseCase] Getting existing task: $id');

      final task = await taskRepository.getById(id);
      debugPrint('[UpdateTaskUseCase] Existing task: $task');

      if (task == null) {
        throw NotFoundFailure(message: 'Task not found.');
      }

      if (task.userId != currentUser.uid) {
        throw AuthFailure(message: 'You do not have permission to update this task.');
      }

     
      if (title != null) {
        final trimmedTitle = title.trim();
        if (trimmedTitle.isEmpty) {
          throw ValidationFailure(message: 'Task description is required.');
        }
        if (trimmedTitle.length < 3) {
          throw ValidationFailure(message: 'Task must be at least 3 characters long.');
        }
        if (trimmedTitle.length > 200) {
          throw ValidationFailure(message: 'Task must be less than 200 characters.');
        }
      }

     
      if (category != null) {
        final validCategories = ['personal', 'shopping', 'wishlist', 'work', 'all'];
        if (!validCategories.contains(category)) {
          throw ValidationFailure(message: 'Invalid category. Must be one of: ${validCategories.join(", ")}');
        }
      }

      if (dueDate != null && dueDate.isBefore(DateTime.now())) {
        throw ValidationFailure(message: 'Due date cannot be in the past.');
      }

  
      Task updatedTask = Task(
        id: task.id,
        userId: task.userId,
        username: task.username,
        gmail: task.gmail,
        title: title != null ? title.trim() : task.title,
        completed: completed ?? task.completed,
        category: category ?? task.category,
        createdAt: task.createdAt, 
        dueDate: dueDate ?? task.dueDate, 
      );

      debugPrint('[UpdateTaskUseCase] Updating task: $updatedTask');

      final result = await taskRepository.update(updatedTask);
      debugPrint('[UpdateTaskUseCase] Update successful: $result');
      return result;
    } on AuthFailure catch (e) {
      debugPrint('[UpdateTaskUseCase] AuthFailure: ${e.message}');
      rethrow;
    } on ValidationFailure catch (e) {
      debugPrint('[UpdateTaskUseCase] ValidationFailure: ${e.message}');
      rethrow;
    } on NotFoundFailure catch (e) {
      debugPrint('[UpdateTaskUseCase] NotFoundFailure: ${e.message}');
      rethrow;
    } on ServerFailure catch (e) {
      debugPrint('[UpdateTaskUseCase] ServerFailure: ${e.message}');
      rethrow;
    } catch (error) {
      debugPrint('[UpdateTaskUseCase] Update failed: $error');
      if (error is Failure) rethrow;
      throw ServerFailure(message: error.toString());
    }
  }
}