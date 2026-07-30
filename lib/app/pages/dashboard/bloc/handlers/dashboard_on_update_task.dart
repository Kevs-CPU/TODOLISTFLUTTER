// lib/app/pages/dashboard/bloc/handlers/dashboard_on_update_task.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/core/failure.dart';
import 'package:todovalidate/domain/usecases/dashboard/update_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';

extension DashboardOnUpdateTask on DashboardBloc {
  Future<void> onUpdateTask(UpdateTask event, Emitter<DashboardState> emit) async {
    final updateTask = serviceLocator<UpdateTaskUseCase>();

    emit(state.copyWith(loading: true, clearError: true));

    try {
      // ✅ Remove unused variable
      await updateTask.execute(
        id: event.id,
        title: event.title,
        completed: event.completed,
        category: event.category,
      );

      // Refresh tasks to get the latest from database
      final getAllTasks = serviceLocator<GetAllTasksUseCase>();
      final tasks = await getAllTasks.execute();

      emit(state.copyWith(
        tasks: tasks,
        loading: false,
        clearEditId: true,
        editText: '',
      ));
    } on AuthFailure catch (e) {
      emit(state.copyWith(
        error: e.message,
        loading: false,
      ));
    } on ValidationFailure catch (e) {
      emit(state.copyWith(
        error: e.message,
        loading: false,
      ));
    } on ServerFailure catch (e) {
      emit(state.copyWith(
        error: e.message,
        loading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString().replaceFirst('Exception: ', ''),
        loading: false,
      ));
    }
  }
}