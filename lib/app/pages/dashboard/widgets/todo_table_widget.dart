import 'package:flutter/material.dart';
import 'package:todovalidate/domain/entities/task.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/task_card.dart';

class TodoTableWidget extends StatelessWidget {
  final List<Task> tasks;
  final String? editId;
  final String editText;
  final String currentFilter;
  final Function(String) onToggleComplete;
  final Function(String, String) onStartEdit;
  final Function(String) onSaveEdit;
  final VoidCallback onCancelEdit;
  final Function(String) onEditTextChanged;
  final Function(String) onDelete;

  const TodoTableWidget({
    super.key,
    required this.tasks,
    this.editId,
    required this.editText,
    required this.currentFilter,
    required this.onToggleComplete,
    required this.onStartEdit,
    required this.onSaveEdit,
    required this.onCancelEdit,
    required this.onEditTextChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isEditing = editId == task.id;

        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          isEditing: isEditing,
          editText: editText,
          showRemoveAction: currentFilter == 'completed',
          onToggleComplete: () => onToggleComplete(task.id),
          onStartEdit: () => onStartEdit(task.id, task.title),
          onSaveEdit: () => onSaveEdit(task.id),
          onCancelEdit: onCancelEdit,
          onEditTextChanged: onEditTextChanged,
          onDelete: () => onDelete(task.id),
        );
      },
    );
  }
}