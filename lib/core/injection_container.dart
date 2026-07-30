// lib/core/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// =====================================================
// REPOSITORY INTERFACES
// =====================================================

import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/task_repository.dart';

// =====================================================
// REPOSITORY IMPLEMENTATIONS
// =====================================================

import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/firebase_task_repository.dart';

// =====================================================
// AUTH USE CASES
// =====================================================

import '../domain/usecases/auth/register_usecase.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/reset_password_usecase.dart';
import '../domain/usecases/auth/get_user_profile_usecase.dart';
import '../domain/usecases/auth/save_user_profile_usecase.dart';
import '../domain/usecases/auth/update_verified_email_usecase.dart';
import '../domain/usecases/auth/get_current_user_usecase.dart';
import '../domain/usecases/auth/get_or_create_user_profile_usecase.dart';
import '../domain/usecases/auth/get_username_usecase.dart';

// =====================================================
// TASK USE CASES
// =====================================================

import '../domain/usecases/dashboard/add_task_usecase.dart';
import '../domain/usecases/dashboard/remove_task_usecase.dart';
import '../domain/usecases/dashboard/update_task_usecase.dart';
import '../domain/usecases/dashboard/get_all_tasks_usecase.dart';
import '../domain/usecases/dashboard/get_task_usecase.dart';

// =====================================================
// SERVICE LOCATOR
// =====================================================

final serviceLocator = GetIt.instance;

// =====================================================
// INITIALIZE DEPENDENCIES
// =====================================================

Future<void> initializeDependencies() async {
  debugPrint('[ServiceLocator]  Initializing dependencies...');

  // Prevent duplicate registration
  if (serviceLocator.isRegistered<AuthRepository>()) {
    debugPrint('[ServiceLocator]  Dependencies already initialized');
    return;
  }

  try {
    // ===================================================
    // FIREBASE INSTANCES
    // ===================================================

    serviceLocator.registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    );

    serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );

    // ===================================================
    // REPOSITORIES
    // ===================================================

    serviceLocator.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(),
    );

    serviceLocator.registerLazySingleton<TaskRepository>(
      () => FirebaseTaskRepository(),
    );

    // ===================================================
    // AUTH USE CASES
    // ===================================================

    serviceLocator.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<SaveUserProfileUseCase>(
      () => SaveUserProfileUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<UpdateVerifiedEmailUseCase>(
      () => UpdateVerifiedEmailUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<GetOrCreateUserProfileUseCase>(
      () => GetOrCreateUserProfileUseCase(serviceLocator<AuthRepository>()),
    );

    serviceLocator.registerLazySingleton<GetUsernameUseCase>(
      () => GetUsernameUseCase(),
    );

    // ===================================================
    // TASK USE CASES
    // ===================================================

    serviceLocator.registerLazySingleton<AddTaskUseCase>(
      () => AddTaskUseCase(
        serviceLocator<TaskRepository>(),
        serviceLocator<AuthRepository>(),
      ),
    );

    serviceLocator.registerLazySingleton<RemoveTaskUseCase>(
      () => RemoveTaskUseCase(
        serviceLocator<TaskRepository>(),
        serviceLocator<AuthRepository>(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateTaskUseCase>(
      () => UpdateTaskUseCase(
        serviceLocator<TaskRepository>(),
        serviceLocator<AuthRepository>(),
      ),
    );

    serviceLocator.registerLazySingleton<GetAllTasksUseCase>(
      () => GetAllTasksUseCase(
        serviceLocator<TaskRepository>(),
        serviceLocator<AuthRepository>(),
      ),
    );

    serviceLocator.registerLazySingleton<GetTaskUseCase>(
      () => GetTaskUseCase(serviceLocator<TaskRepository>()),
    );

    debugPrint('[ServiceLocator]  All dependencies initialized successfully!');
    
    //  Verify registration
    assert(serviceLocator.isRegistered<AuthRepository>(), ' AuthRepository not registered!');
    assert(serviceLocator.isRegistered<LoginUseCase>(), ' LoginUseCase not registered!');
    assert(serviceLocator.isRegistered<TaskRepository>(), ' TaskRepository not registered!');
    assert(serviceLocator.isRegistered<AddTaskUseCase>(), ' AddTaskUseCase not registered!');
    
    debugPrint('[ServiceLocator]  All assertions passed!');
    
  } catch (e) {
    debugPrint('[ServiceLocator]  Failed to initialize dependencies: $e');
    rethrow;
  }
}