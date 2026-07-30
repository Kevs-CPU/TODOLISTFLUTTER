// lib/app/providers/task_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String? _error;
  bool _isLoading = false;
  String _filter = 'all';
  String _selectedCategory = 'all';
  String? _editId;
  String _editText = '';

  // Getters
  List<Task> get tasks => _tasks;
  String? get error => _error;
  bool get isLoading => _isLoading;
  String get filter => _filter;
  String get selectedCategory => _selectedCategory;
  String? get editId => _editId;
  String get editText => _editText;
  int get totalCount => _tasks.length;
  int get activeCount => _tasks.where((t) => !t.completed).length;
  int get completedCount => _tasks.where((t) => t.completed).length;

  // Category Count Getters
  int get personalCount => _tasks.where((t) => t.category == 'personal' && !t.completed).length;
  int get shoppingCount => _tasks.where((t) => t.category == 'shopping' && !t.completed).length;
  int get wishlistCount => _tasks.where((t) => t.category == 'wishlist' && !t.completed).length;
  int get workCount => _tasks.where((t) => t.category == 'work' && !t.completed).length;

  // Get tasks by category
  List<Task> get tasksByCategory {
    if (_selectedCategory == 'all') {
      return _tasks;
    }
    return _tasks.where((t) => t.category == _selectedCategory).toList();
  }

  List<Task> get filteredTasks {
    List<Task> baseTasks = tasksByCategory;
    
    if (_filter == 'active') {
      return baseTasks.where((t) => !t.completed).toList();
    } else if (_filter == 'completed') {
      return baseTasks.where((t) => t.completed).toList();
    }
    return baseTasks;
  }

  // GET CURRENT USER
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  // VALIDATE GMAIL
  Future<bool> isValidGmail(String gmail) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: gmail.trim())
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // FETCH TASKS
  Future<void> fetchTasks() async {
    final user = _currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      _tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: doc.id,
          userId: data['userId'] ?? '',
          username: data['username'] ?? '',
          gmail: data['gmail'] ?? '',
          title: data['title'] ?? '',
          completed: data['isDone'] ?? false,
          category: data['category'] ?? 'default',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD TASK with category
  Future<void> addTask({
    required String gmail, 
    required String title,
    String category = 'default',
  }) async {
    final user = _currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _error = null;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final username = userDoc.data()?['username'] ?? 'User';

      final docRef = await FirebaseFirestore.instance.collection('tasks').add({
        'title': title.trim(),
        'isDone': false,
        'userId': user.uid,
        'gmail': gmail.trim(),
        'username': username,
        'category': category,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final newTask = Task(
        id: docRef.id,
        userId: user.uid,
        username: username,
        gmail: gmail.trim(),
        title: title.trim(),
        completed: false,
        category: category,
        createdAt: DateTime.now(),
        dueDate: null,
      );

      _tasks.insert(0, newTask);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // UPDATE TASK
  Future<void> updateTask({required String id, required String title}) async {
    _error = null;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(id)
          .update({
            'title': title.trim(),
          });

      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldTask = _tasks[index];
        _tasks[index] = Task(
          id: oldTask.id,
          userId: oldTask.userId,
          username: oldTask.username,
          gmail: oldTask.gmail,
          title: title.trim(),
          completed: oldTask.completed,
          category: oldTask.category,
          createdAt: oldTask.createdAt,
          dueDate: oldTask.dueDate,
        );
      }

      _editId = null;
      _editText = '';
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // TOGGLE COMPLETE
  Future<void> toggleTaskComplete(String id) async {
    _error = null;
    notifyListeners();

    try {
      final task = _tasks.firstWhere((t) => t.id == id);
      final newStatus = !task.completed;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(id)
          .update({
            'isDone': newStatus,
          });

      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldTask = _tasks[index];
        _tasks[index] = Task(
          id: oldTask.id,
          userId: oldTask.userId,
          username: oldTask.username,
          gmail: oldTask.gmail,
          title: oldTask.title,
          completed: newStatus,
          category: oldTask.category,
          createdAt: oldTask.createdAt,
          dueDate: oldTask.dueDate,
        );
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // DELETE TASK
  Future<void> removeTask(String id) async {
    _error = null;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(id)
          .delete();

      _tasks.removeWhere((t) => t.id == id);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // GET TASKS BY GMAIL
  Future<List<Task>> getTasksByGmail(String gmail) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('gmail', isEqualTo: gmail.trim())
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: doc.id,
          userId: data['userId'] ?? '',
          username: data['username'] ?? '',
          gmail: data['gmail'] ?? '',
          title: data['title'] ?? '',
          completed: data['isDone'] ?? false,
          category: data['category'] ?? 'default',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // SET CATEGORY FILTER
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // EDIT CONTROLS
  void setEditId(String id) {
    _editId = id;
    notifyListeners();
  }

  void setEditText(String text) {
    _editText = text;
    notifyListeners();
  }

  void clearEdit() {
    _editId = null;
    _editText = '';
    notifyListeners();
  }

  // FILTER
  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  // ERROR
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // CLEAR TASKS
  void clearTasks() {
    _tasks.clear();
    _error = null;
    _editId = null;
    _editText = '';
    notifyListeners();
  }
}