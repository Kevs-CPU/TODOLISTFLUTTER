// lib/data/repositories/firebase_task_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasource/dashboard_datasource.dart';

class FirebaseTaskRepository implements TaskRepository {
  final DashboardDataSource _dataSource;

  FirebaseTaskRepository({DashboardDataSource? dataSource})
      : _dataSource = dataSource ?? DashboardDataSource();

  @override
  Future<User?> getCurrentUser() async {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<List<Task>> getAll(String userId) async {
    return _dataSource.getTasks(userId);
  }

  @override
  Future<Task?> getById(String id) async {
    return _dataSource.getTaskById(id);
  }

  @override
  Future<Task?> findByGmail(String gmail) async {
    return _dataSource.findTaskByGmail(gmail);
  }

  @override
  Future<Task> add(Task task) async {
    return _dataSource.addTask(task);
  }

  @override
  Future<Task> update(Task task) async {
    return _dataSource.updateTask(task);
  }

  @override
  Future<String> remove(String id) async {
    return _dataSource.deleteTask(id);
  }
}