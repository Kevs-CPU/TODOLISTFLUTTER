part of 'dashboard_bloc.dart';

enum FilterType { all, active, completed }

class DashboardState extends Equatable {
  final List<Task> tasks;
  final bool loading;
  final String? error;
  final FilterType filter;
  final String? editId;
  final String editText;
  final String category;

  const DashboardState({
    this.tasks = const [],
    this.loading = false,
    this.error,
    this.filter = FilterType.all,
    this.editId,
    this.editText = '',
    this.category = 'all',
  });

  List<Task> get filteredTasks {
    // First filter by category
    List<Task> categoryFiltered = category == 'all'
        ? tasks
        : tasks.where((t) => t.category == category).toList();

    // Then filter by status
    if (filter == FilterType.completed) {
      return categoryFiltered.where((t) => t.completed).toList();
    }
    if (filter == FilterType.active) {
      return categoryFiltered.where((t) => !t.completed).toList();
    }
    return categoryFiltered;
  }

  int get activeCount => tasks.where((t) => !t.completed).length;
  int get completedCount => tasks.where((t) => t.completed).length;
  int get totalCount => tasks.length;

  // Category counts (active tasks only)
  int get personalCount => tasks.where((t) => t.category == 'personal' && !t.completed).length;
  int get shoppingCount => tasks.where((t) => t.category == 'shopping' && !t.completed).length;
  int get wishlistCount => tasks.where((t) => t.category == 'wishlist' && !t.completed).length;
  int get workCount => tasks.where((t) => t.category == 'work' && !t.completed).length;

  DashboardState copyWith({
    List<Task>? tasks,
    bool? loading,
    String? error,
    bool clearError = false,
    FilterType? filter,
    String? editId,
    bool clearEditId = false,
    String? editText,
    String? category,
  }) {
    return DashboardState(
      tasks: tasks ?? this.tasks,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      filter: filter ?? this.filter,
      editId: clearEditId ? null : (editId ?? this.editId),
      editText: editText ?? this.editText,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [tasks, loading, error, filter, editId, editText, category];
}