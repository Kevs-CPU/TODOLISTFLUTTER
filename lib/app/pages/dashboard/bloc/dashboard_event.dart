part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends DashboardEvent {}

class AddTask extends DashboardEvent {
  final String gmail;
  final String title;
  final String? category;
  final DateTime? dueDate;

  const AddTask({
    required this.gmail,
    required this.title,
    this.category,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
        gmail,
        title,
        category,
        dueDate,
      ];
}

class UpdateTask extends DashboardEvent {
  final String id;
  final String? title;
  final bool? completed;
  final String? category;

  const UpdateTask({
    required this.id,
    this.title,
    this.completed,
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        completed,
        category,
      ];
}

class RemoveTask extends DashboardEvent {
  final String id;

  const RemoveTask(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTaskComplete extends DashboardEvent {
  final String id;

  const ToggleTaskComplete(this.id);

  @override
  List<Object?> get props => [id];
}

class SetFilter extends DashboardEvent {
  final FilterType filter;

  const SetFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SetCategory extends DashboardEvent {
  final String category;

  const SetCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SetEditId extends DashboardEvent {
  final String? editId;

  const SetEditId(this.editId);

  @override
  List<Object?> get props => [editId];
}

class SetEditText extends DashboardEvent {
  final String editText;

  const SetEditText(this.editText);

  @override
  List<Object?> get props => [editText];
}

class ClearEdit extends DashboardEvent {}

class ClearError extends DashboardEvent {}

class ClearTasks extends DashboardEvent {}

class SetError extends DashboardEvent {
  final String message;

  const SetError(this.message);

  @override
  List<Object?> get props => [message];
}