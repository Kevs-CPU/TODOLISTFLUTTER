import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/core/failure.dart';
import 'package:todovalidate/domain/usecases/dashboard/remove_task_usecase.dart';
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';

extension DashboardOnRemoveTask on DashboardBloc {
  Future<void> onRemoveTask(RemoveTask event, Emitter<DashboardState> emit) async {
    final removeTask = serviceLocator<RemoveTaskUseCase>();

    // No loading:true here — deleting a task shouldn't flash a full-list
    emit(state.copyWith(clearError: true));

    try {
      await removeTask.execute(event.id);

      final getAllTasks = serviceLocator<GetAllTasksUseCase>();
      final tasks = await getAllTasks.execute();

      emit(state.copyWith(tasks: tasks));
    } on AuthFailure catch (e) {
      emit(state.copyWith(error: e.message));
    } on ServerFailure catch (e) {
      emit(state.copyWith(error: e.message));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}