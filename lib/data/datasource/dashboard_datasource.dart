// lib/data/datasource/dashboard_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/task.dart';

class DashboardDataSource {
  // Constants
  static const String _tasksCollection = 'tasks';

  // Dependencies
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Constructor
  DashboardDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // ============================================================================
  // User Methods
  // ============================================================================

  /// Get the currently authenticated user
  Future<User?> getCurrentUser() async {
    debugPrint('[DashboardDataSource] Getting current user');
    final user = _auth.currentUser;
    debugPrint(
      '[DashboardDataSource] Current user: ${user?.uid ?? "No authenticated user"}',
    );
    return user;
  }

  // ============================================================================
  // Read Methods
  // ============================================================================

  /// Get all tasks for a specific user
  /// Latest added task will appear first
  Future<List<Task>> getTasks(String userId) async {
    debugPrint('[DashboardDataSource] getTasks started for user: $userId');

    try {
      _validateUserId(userId);

      final snapshot = await _firestore
          .collection(_tasksCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final tasks = snapshot.docs.map(_mapDocumentToTask).toList();

      debugPrint(
        '[DashboardDataSource] getTasks success: ${tasks.length} tasks found',
      );

      return tasks;
    } catch (error) {
      debugPrint('[DashboardDataSource] getTasks failed: $error');
      rethrow;
    }
  }

  /// Get a specific task by its ID
  Future<Task?> getTaskById(String taskId) async {
    debugPrint('[DashboardDataSource] getTaskById started: $taskId');

    try {
      _validateTaskId(taskId);

      final document = await _firestore
          .collection(_tasksCollection)
          .doc(taskId)
          .get();

      if (!document.exists) {
        debugPrint('[DashboardDataSource] getTaskById: Task not found');
        return null;
      }

      final data = document.data();
      if (data == null) return null;

      final task = _mapDocumentToTask(document);

      debugPrint('[DashboardDataSource] getTaskById success: ${task.id}');
      return task;
    } catch (error) {
      debugPrint('[DashboardDataSource] getTaskById failed: $error');
      rethrow;
    }
  }

  /// Find a task by Gmail address
  Future<Task?> findTaskByGmail(String gmail) async {
    debugPrint('[DashboardDataSource] findTaskByGmail started: $gmail');

    try {
      _validateGmail(gmail);

      final cleanGmail = gmail.trim().toLowerCase();

      final snapshot = await _firestore
          .collection(_tasksCollection)
          .where('gmail', isEqualTo: cleanGmail)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('[DashboardDataSource] findTaskByGmail: No task found');
        return null;
      }

      final task = _mapDocumentToTask(snapshot.docs.first);

      debugPrint('[DashboardDataSource] findTaskByGmail success: ${task.id}');
      return task;
    } catch (error) {
      debugPrint('[DashboardDataSource] findTaskByGmail failed: $error');
      rethrow;
    }
  }

  // ============================================================================
  // Write Methods
  // ============================================================================

  /// Add a new task to Firestore
  Future<Task> addTask(Task task) async {
    debugPrint('[DashboardDataSource] addTask started: ${task.id}');

    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(task.id)
          .set(_taskToJson(task));

      debugPrint('[DashboardDataSource] addTask success: ${task.id}');
      return task;
    } catch (error) {
      debugPrint('[DashboardDataSource] addTask failed: $error');
      rethrow;
    }
  }

  /// Update an existing task in Firestore
  Future<Task> updateTask(Task task) async {
    debugPrint('[DashboardDataSource] updateTask started: ${task.id}');

    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(task.id)
          .update(_taskToUpdateJson(task));

      debugPrint('[DashboardDataSource] updateTask success: ${task.id}');
      return task;
    } catch (error) {
      debugPrint('[DashboardDataSource] updateTask failed: $error');
      rethrow;
    }
  }

  /// Delete a task from Firestore
  Future<String> deleteTask(String taskId) async {
    debugPrint('[DashboardDataSource] deleteTask started: $taskId');

    try {
      _validateTaskId(taskId);

      await _firestore
          .collection(_tasksCollection)
          .doc(taskId)
          .delete();

      debugPrint('[DashboardDataSource] deleteTask success: $taskId');
      return taskId;
    } catch (error) {
      debugPrint('[DashboardDataSource] deleteTask failed: $error');
      rethrow;
    }
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Map a Firestore document to a Task entity
  Task _mapDocumentToTask(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    
    return Task(
      id: document.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      gmail: data['gmail'] ?? '',
      title: data['title'] ?? '',
      completed: data['isDone'] ?? false,
      category: data['category'] ?? 'personal',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert a Task entity to a Map for Firestore storage
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'userId': task.userId,
      'username': task.username,
      'gmail': task.gmail,
      'title': task.title,
      'isDone': task.completed,
      'category': task.category,
      'createdAt': FieldValue.serverTimestamp(),
      if (task.dueDate != null) 'dueDate': Timestamp.fromDate(task.dueDate!),
    };
  }

  /// Convert a Task entity to a Map for updating Firestore
  Map<String, dynamic> _taskToUpdateJson(Task task) {
    final updateData = <String, dynamic>{
      'title': task.title,
      'isDone': task.completed,
    };

    if (task.dueDate != null) {
      updateData['dueDate'] = Timestamp.fromDate(task.dueDate!);
    }

    return updateData;
  }

  // ============================================================================
  // Validation Methods
  // ============================================================================

  /// Validate that the userId is not empty
  void _validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }
  }

  /// Validate that the taskId is not empty
  void _validateTaskId(String taskId) {
    if (taskId.trim().isEmpty) {
      throw Exception('Task ID is required.');
    }
  }

  /// Validate that the gmail is not empty
  void _validateGmail(String gmail) {
    if (gmail.trim().isEmpty) {
      throw Exception('Gmail is required.');
    }
  }
}