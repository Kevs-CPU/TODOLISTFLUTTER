import 'package:flutter/foundation.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../../../core/failure.dart'; 

class GetTaskUseCase {
  final TaskRepository taskRepository;

  GetTaskUseCase(this.taskRepository) {
    debugPrint('[GetTaskUseCase] Initialized');
  }

  Future<Task?> execute(String id) async {
    debugPrint('[GetTaskUseCase] Started: id=$id');

    try {
      if (id.trim().isEmpty) {
        debugPrint('[GetTaskUseCase] Task ID is required');
        throw ValidationFailure(message: 'Task ID is required'); 
      }

      final task = await taskRepository.getById(id.trim());
      debugPrint('[GetTaskUseCase] Task fetched successfully');
      return task;
    } on ValidationFailure catch (e) {  
      debugPrint('[GetTaskUseCase] ValidationFailure: ${e.message}');
      rethrow;
    } on NotFoundFailure catch (e) { 
      debugPrint('[GetTaskUseCase] NotFoundFailure: ${e.message}');
      rethrow;
    } on ServerFailure catch (e) { 
      debugPrint('[GetTaskUseCase] ServerFailure: ${e.message}');
      rethrow;
    } catch (error) {
      debugPrint('[GetTaskUseCase] Failed to fetch task: $error');
      throw ServerFailure(message: error.toString());
    }
  }
}