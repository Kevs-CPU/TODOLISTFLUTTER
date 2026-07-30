// lib/app/pages/dashboard/bloc/handlers/dashboard_on_toggle_complete.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/core/failure.dart';
import 'package:todovalidate/domain/entities/task.dart';
import 'package:todovalidate/domain/usecases/dashboard/update_task_usecase.dart';

extension DashboardOnToggleComplete on DashboardBloc {
  Future<void> onToggleComplete(
    ToggleTaskComplete event,
    Emitter<DashboardState> emit,
  ) async {
    final updateTask = serviceLocator<UpdateTaskUseCase>();

    final currentTask = state.tasks
        .where((t) => t.id == event.id)
        .firstOrNull;

    if (currentTask == null) {
      emit(state.copyWith(error: 'Task not found.'));
      return;
    }

    try {
      final newCompletedStatus = !currentTask.completed;

      await updateTask.execute(
        id: event.id,
        completed: newCompletedStatus,
      );

      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.id) {
          return Task(
                    id: task.id,
                    userId: task.userId,
                    username: task.username,
                    gmail: task.gmail,
                    title: task.title,
                    completed: newCompletedStatus,
                    category: task.category,
                    createdAt: task.createdAt,
                    dueDate: task.dueDate,
                    );
                 }

        return task;
      }).toList();

      emit(
        state.copyWith(
          tasks: updatedTasks,
          clearError: true,
        ),
      );
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(
          error: e.message,
        ),
      );
    } on ServerFailure catch (e) {
      emit(
        state.copyWith(
          error: e.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          error: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}