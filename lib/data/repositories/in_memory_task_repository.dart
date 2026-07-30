import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAll(String userId) async {
    return List<Task>.from(_tasks);
  }

  @override
  Future<Task?> getById(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Task> add(Task task) async {
    _tasks.add(task);
    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final index = _tasks.indexWhere((existingTask) => existingTask.id == task.id);
    if (index == -1) {
      throw Exception('Task not found.');
    }
    _tasks[index] = task;
    return _tasks[index];
  }

  @override
  Future<String> remove(String id) async {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    if (_tasks.length == initialLength) {
      throw Exception('Task not found.');
    }
    return id;
  }

  @override
  Future<Task?> findByGmail(String gmail) async {
    try {
      return _tasks.firstWhere((task) => task.gmail == gmail);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _tasks.clear();
  }

  @override
  Future<User?> getCurrentUser() async {
    return null;
  }
}