// lib/task_use_case_provider.dart
import 'package:flutter/foundation.dart';
import 'package:todovalidate/data/repositories/firebase_task_repository.dart';
import 'package:todovalidate/data/repositories/in_memory_task_repository.dart';
import 'package:todovalidate/data/repositories/local_storage_task_repository.dart';
import 'package:todovalidate/domain/repositories/task_repository.dart';
import 'package:todovalidate/domain/usecases/dashboard/add_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/remove_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/update_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';
import 'package:todovalidate/auth_use_case_provider.dart';
import 'package:todovalidate/core/injection_container.dart';

const String repositoryType = 'firebase';

TaskRepository? _repositoryInstance;

TaskRepository getTaskRepository() {
  if (_repositoryInstance != null) {
    return _repositoryInstance!;
  }

  try {
    switch (repositoryType) {
      case 'firebase':
        _repositoryInstance = FirebaseTaskRepository();
        break;
      case 'localStorage':
        _repositoryInstance = LocalStorageTaskRepository();
        break;
      case 'memory':
      default:
        _repositoryInstance = InMemoryTaskRepository();
        break;
    }
  } catch (error) {
    debugPrint('Failed to initialize repository: $error');
    _repositoryInstance = InMemoryTaskRepository();
  }

  return _repositoryInstance!;
}

final taskRepository = getTaskRepository();

final addTaskUseCase = AddTaskUseCase(taskRepository, authRepository);
final removeTaskUseCase = RemoveTaskUseCase(taskRepository, authRepository);
final updateTaskUseCase = UpdateTaskUseCase(taskRepository, authRepository);
final getAllTasksUseCase = GetAllTasksUseCase(taskRepository, authRepository);

void registerTaskDependencies() {
  serviceLocator.registerLazySingleton<TaskRepository>(() => taskRepository);
  serviceLocator.registerLazySingleton<AddTaskUseCase>(() => addTaskUseCase);
  serviceLocator.registerLazySingleton<RemoveTaskUseCase>(() => removeTaskUseCase);
  serviceLocator.registerLazySingleton<UpdateTaskUseCase>(() => updateTaskUseCase);
  serviceLocator.registerLazySingleton<GetAllTasksUseCase>(() => getAllTasksUseCase);
}

void main() {
  debugPrint('Task use cases initialized successfully');
}