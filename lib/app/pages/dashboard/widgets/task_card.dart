import 'package:flutter/material.dart';
import 'package:todovalidate/domain/entities/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final bool isEditing;
  final String editText;
  final VoidCallback onToggleComplete;
  final VoidCallback onStartEdit;
  final VoidCallback onSaveEdit;
  final VoidCallback onCancelEdit;
  final Function(String) onEditTextChanged;
  final VoidCallback onDelete;
  final bool showRemoveAction;

  const TaskCard({
    super.key,
    required this.task,
    required this.isEditing,
    required this.editText,
    required this.onToggleComplete,
    required this.onStartEdit,
    required this.onSaveEdit,
    required this.onCancelEdit,
    required this.onEditTextChanged,
    required this.onDelete,
    this.showRemoveAction = true,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isChecked = false;

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'personal':
        return const Color(0xFF4A90D9);
      case 'work':
        return const Color(0xFF10B981);
      case 'shopping':
        return const Color(0xFFF59E0B);
      case 'wishlist':
        return const Color(0xFFEC4899);
      default:
        return Colors.grey.shade400;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'personal':
        return 'Personal';
      case 'work':
        return 'Work';
      case 'shopping':
        return 'Shopping';
      case 'wishlist':
        return 'Wishlist';
      default:
        return category;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTaskCompleted = widget.task.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isTaskCompleted ? const Color(0xFFF8FAFB) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isTaskCompleted
            ? Border.all(color: const Color(0xFF4CAF50), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Checkbox (only for incomplete tasks)
          if (!isTaskCompleted)
            GestureDetector(
              onTap: () {
                setState(() => _isChecked = !_isChecked);
                widget.onToggleComplete();
              },
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _isChecked ? Colors.transparent : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                  color: _isChecked ? const Color(0xFF4A90D9) : Colors.transparent,
                ),
                child: _isChecked
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
          const SizedBox(width: 8),

          // Task Content
          Expanded(
            child: widget.isEditing
                ? _buildEditContainer()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Task Title
                      Text(
                        widget.task.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isTaskCompleted ? const Color(0xFF9CA3AF) : const Color(0xFF1A2A3A),
                          decoration: isTaskCompleted ? TextDecoration.lineThrough : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),

                      // Row with Category, Gmail, Due Date, and Created Date
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Category Badge - Only show if category is not empty and not 'default'
                          if (widget.task.category.isNotEmpty && widget.task.category != 'default')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(widget.task.category).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _getCategoryLabel(widget.task.category),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: _getCategoryColor(widget.task.category),
                                ),
                              ),
                            ),

                          // Gmail
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 10,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                widget.task.gmail,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),

                          // Due Date
                          if (widget.task.dueDate != null) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event,
                                  size: 10,
                                  color: Colors.orange.shade600,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Due: ${_formatDate(widget.task.dueDate!)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Created Date
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 10,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Created: ${_formatDate(widget.task.createdAt)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),

                          // Finished badge for completed tasks
                          if (isTaskCompleted && widget.showRemoveAction)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 10,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Finished',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),

          // Action buttons
          if (isTaskCompleted && !widget.showRemoveAction)
            _buildRemoveButton()
          else if (widget.isEditing)
            _buildEditActions()
          else if (!isTaskCompleted)
            _buildDefaultActions(),
        ],
      ),
    );
  }

  Widget _buildEditContainer() {
    return TextField(
      autofocus: true,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2A3A)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF4A90D9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
      ),
      controller: TextEditingController(text: widget.editText)
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: widget.editText.length),
        ),
      onChanged: widget.onEditTextChanged,
      onSubmitted: (_) => widget.onSaveEdit(),
    );
  }

  Widget _buildDefaultActions() {
    return Row(
      children: [
        _buildIconButton(
          icon: Icons.edit,
          color: const Color(0xFF9CA3AF),
          onTap: widget.onStartEdit,
        ),
        _buildIconButton(
          icon: Icons.delete_outline,
          color: const Color(0xFF9CA3AF),
          onTap: widget.onDelete,
        ),
      ],
    );
  }

  Widget _buildEditActions() {
    return Row(
      children: [
        _buildIconButton(
          icon: Icons.check,
          color: const Color(0xFF15803D),
          onTap: widget.onSaveEdit,
        ),
        _buildIconButton(
          icon: Icons.close,
          color: const Color(0xFF374151),
          onTap: widget.onCancelEdit,
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: widget.onDelete,
        child: const Text(
          'Remove',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFFDC2626),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}