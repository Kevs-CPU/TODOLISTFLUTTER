import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';

extension DashboardOnSetFilter on DashboardBloc {
  void onSetFilter(SetFilter event, Emitter<DashboardState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}