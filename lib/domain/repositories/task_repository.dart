import 'package:firebase_auth/firebase_auth.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  // Get all tasks for a specific user
  Future<List<Task>> getAll(String userId);
  
  // Get a single task by ID
  Future<Task?>  getById(String id);
  
  // Find a task by Gmail
  Future<Task?>  findByGmail(String gmail);
  
  // Add a new task
  Future<Task>  add(Task task);
  
  // Update an existing task
  Future<Task> update(Task task);
  
  // Remove a task by ID
  Future<String> remove(String id);
  
  // Get current authenticated user
  Future<User?> getCurrentUser();
}