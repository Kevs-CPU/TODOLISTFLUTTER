import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class LocalStorageTaskRepository implements TaskRepository {
  static const String storageKey = 'tasks';

  // ============================================================================
  // Read Methods
  // ============================================================================

  @override
  Future<List<Task>> getAll(String userId) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final data = preferences.getString(storageKey);

      if (data == null || data.isEmpty) {
        return [];
      }

      final List<dynamic> decodedData = jsonDecode(data);
      
      return decodedData.map((item) {
        final map = Map<String, dynamic>.from(item);
        
        return Task(
          id: map['id'] ?? '',
          userId: map['userId'] ?? '',
          username: map['username'] ?? '',
          gmail: map['gmail'] ?? '',
          title: map['title'] ?? '',
          completed: map['isDone'] ?? false,
          category: map['category'] ?? 'personal',
          createdAt: map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(),
          dueDate: map['dueDate'] != null
              ? DateTime.parse(map['dueDate'])
              : null,
        );
      }).toList();
    } catch (error) {
      debugPrint('[LocalStorageTaskRepository] Failed to read tasks: $error');
      return [];
    }
  }

  @override
  Future<Task?> getById(String id) async {
    final tasks = await getAll('');
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Task?> findByGmail(String gmail) async {
    final tasks = await getAll('');
    final cleanGmail = gmail.trim().toLowerCase();
    try {
      return tasks.firstWhere((task) => task.gmail.toLowerCase() == cleanGmail);
    } catch (_) {
      return null;
    }
  }

  // ============================================================================
  // Write Methods
  // ============================================================================

  @override
  Future<Task> add(Task task) async {
    final tasks = await getAll('');
    tasks.add(task);
    await _saveTasks(tasks);
    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final tasks = await getAll('');
    final index = tasks.indexWhere((existingTask) => existingTask.id == task.id);
    if (index == -1) {
      throw Exception('Task not found.');
    }
    tasks[index] = task;
    await _saveTasks(tasks);
    return tasks[index];
  }

  @override
  Future<String> remove(String id) async {
    final tasks = await getAll('');
    final initialLength = tasks.length;
    tasks.removeWhere((task) => task.id == id);
    if (tasks.length == initialLength) {
      throw Exception('Task not found.');
    }
    await _saveTasks(tasks);
    return id;
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  Future<void> _saveTasks(List<Task> tasks) async {
    final preferences = await SharedPreferences.getInstance();

    final data = tasks.map((task) {
      return {
        'id': task.id,
        'userId': task.userId,
        'username': task.username,
        'gmail': task.gmail,
        'title': task.title,
        'isDone': task.completed,
        'category': task.category,
        'createdAt': task.createdAt.toIso8601String(),
        'dueDate': task.dueDate?.toIso8601String(),
      };
    }).toList();

    await preferences.setString(
      storageKey,
      jsonEncode(data),
    );
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  @override
  Future<User?> getCurrentUser() async {
    // Local storage doesn't have user authentication
    return null;
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(storageKey);
  }
}