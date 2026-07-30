import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';

extension DashboardOnSetCategory on DashboardBloc {
  void onSetCategory(SetCategory event, Emitter<DashboardState> emit) {
    emit(state.copyWith(category: event.category));
  }
}