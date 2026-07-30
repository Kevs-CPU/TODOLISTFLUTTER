import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/core/failure.dart';  // ✅ ADD THIS
import 'package:todovalidate/domain/usecases/dashboard/get_all_tasks_usecase.dart';

extension DashboardOnFetchTasks on DashboardBloc {
  Future<void> onFetchTasks(FetchTasks event, Emitter<DashboardState> emit) async {
    final getAllTasks = serviceLocator<GetAllTasksUseCase>();

    emit(state.copyWith(loading: true, clearError: true));

    try {
      final tasks = await getAllTasks.execute();
      emit(state.copyWith(tasks: tasks, loading: false));
    } on AuthFailure catch (e) {  // ✅ SPECIFIC ERROR HANDLING
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