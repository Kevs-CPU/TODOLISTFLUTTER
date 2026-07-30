import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/core/failure.dart';
import 'package:todovalidate/domain/usecases/dashboard/add_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';

extension DashboardOnAddTask on DashboardBloc {
  Future<void> onAddTask(
    AddTask event,
    Emitter<DashboardState> emit,
  ) async {
    final addTask = serviceLocator<AddTaskUseCase>();

    emit(
      state.copyWith(
        loading: true,
        clearError: true,
      ),
    );

    try {
      await addTask.execute(
        gmail: event.gmail,
        title: event.title,
        category: event.category,
        dueDate: event.dueDate,
      );

      final getAllTasks = serviceLocator<GetAllTasksUseCase>();
      final tasks = await getAllTasks.execute();

      emit(
        state.copyWith(
          tasks: tasks,
          loading: false,
        ),
      );
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(
          error: e.message,
          loading: false,
        ),
      );
    } on ValidationFailure catch (e) {
      emit(
        state.copyWith(
          error: e.message,
          loading: false,
        ),
      );
    } on ServerFailure catch (e) {
      emit(
        state.copyWith(
          error: e.message,
          loading: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          error: error.toString().replaceFirst('Exception: ', ''),
          loading: false,
        ),
      );
    }
  }
}