import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todovalidate/app/pages/dashboard/dashboard_page.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/domain/usecases/dashboard/add_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/update_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/remove_task_usecase.dart';
import 'package:todovalidate/data/repositories/in_memory_task_repository.dart';
import 'package:todovalidate/data/repositories/firebase_auth_repository.dart';

void main() {
  testWidgets('Dashboard page renders correctly', (WidgetTester tester) async {
    final taskRepository = InMemoryTaskRepository();
    final authRepository = FirebaseAuthRepository();

    // I-register ang test dependencies papalit sa totoong Firebase ones
  if (serviceLocator.isRegistered<GetAllTasksUseCase>()) {
      serviceLocator.unregister<GetAllTasksUseCase>();
      serviceLocator.unregister<AddTaskUseCase>();
      serviceLocator.unregister<UpdateTaskUseCase>();
      serviceLocator.unregister<RemoveTaskUseCase>();
    }

    serviceLocator.registerLazySingleton<GetAllTasksUseCase>(
      () => GetAllTasksUseCase(taskRepository, authRepository),
    );
    serviceLocator.registerLazySingleton<AddTaskUseCase>(
      () => AddTaskUseCase(taskRepository, authRepository),
    );
    serviceLocator.registerLazySingleton<UpdateTaskUseCase>(
      () => UpdateTaskUseCase(taskRepository, authRepository),
    );
    serviceLocator.registerLazySingleton<RemoveTaskUseCase>(
      () => RemoveTaskUseCase(taskRepository, authRepository),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => DashboardBloc(),
          child: const DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No tasks found'), findsOneWidget);
    expect(find.text('+ Add your first task'), findsOneWidget);
  });
}