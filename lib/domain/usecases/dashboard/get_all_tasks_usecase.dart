import 'package:flutter/foundation.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/failure.dart'; 

class GetAllTasksUseCase {
  final TaskRepository taskRepository;
  final AuthRepository authRepository;

  GetAllTasksUseCase(this.taskRepository, this.authRepository) {
    debugPrint('[GetAllTasksUseCase] Initialized');
  }

  Future<List<Task>> execute() async {
    debugPrint('[GetAllTasksUseCase] Started');

    try {
      final currentUser = await authRepository.getCurrentUser();
      debugPrint('[GetAllTasksUseCase] Current user: uid=${currentUser?.uid}');

      if (currentUser == null) {
        debugPrint('[GetAllTasksUseCase] User is not authenticated');
        throw AuthFailure(message: 'User not authenticated. Please log in again.'); 
      }

      if (currentUser.uid.isEmpty) {
        debugPrint('[GetAllTasksUseCase] User ID is missing');
        throw ValidationFailure(message: 'User ID is required.');  
      }

      debugPrint('[GetAllTasksUseCase] Fetching tasks for user: ${currentUser.uid}');

      final tasks = await taskRepository.getAll(currentUser.uid);
      debugPrint('[GetAllTasksUseCase] Tasks fetched successfully: ${tasks.length} tasks');
      return tasks;
    } on AuthFailure catch (e) {  
      debugPrint('[GetAllTasksUseCase] AuthFailure: ${e.message}');
      rethrow;
    } on ValidationFailure catch (e) { 
      debugPrint('[GetAllTasksUseCase] ValidationFailure: ${e.message}');
      rethrow;
    } on ServerFailure catch (e) {  
      debugPrint('[GetAllTasksUseCase] ServerFailure: ${e.message}');
      rethrow;
    } catch (error) {
      debugPrint('[GetAllTasksUseCase] Failed to fetch tasks: $error');
      throw ServerFailure(message: error.toString());
    }
  }
}