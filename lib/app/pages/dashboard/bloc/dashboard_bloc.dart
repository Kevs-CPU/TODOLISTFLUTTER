// lib/app/pages/dashboard/bloc/dashboard_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/domain/entities/task.dart';

import 'handlers/dashboard_on_fetch_tasks.dart';
import 'handlers/dashboard_on_add_task.dart';
import 'handlers/dashboard_on_update_task.dart';
import 'handlers/dashboard_on_remove_task.dart';
import 'handlers/dashboard_on_toggle_complete.dart';
import 'handlers/dashboard_on_set_filter.dart';
import 'handlers/dashboard_on_set_category.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<FetchTasks>(onFetchTasks);
    on<AddTask>(onAddTask);
    on<UpdateTask>(onUpdateTask);
    on<RemoveTask>(onRemoveTask);
    on<ToggleTaskComplete>(onToggleComplete);
    on<SetFilter>(onSetFilter);
    on<SetCategory>(onSetCategory);

    // Simpleng local-state events - diretso na lang dito, walang usecase
    on<SetEditId>((event, emit) => emit(state.copyWith(
          editId: event.editId,
          clearEditId: event.editId == null,
        )));
    on<SetEditText>((event, emit) => emit(state.copyWith(editText: event.editText)));
    on<ClearEdit>((event, emit) => emit(state.copyWith(clearEditId: true, editText: '')));
    on<ClearError>((event, emit) => emit(state.copyWith(clearError: true)));
    on<ClearTasks>((event, emit) => emit(const DashboardState()));
    on<SetError>((event, emit) => emit(state.copyWith(error: event.message)));
  }
}