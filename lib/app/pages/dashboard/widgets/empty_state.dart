import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String filter;
  final VoidCallback onAddPressed;

  const EmptyState({
    super.key,
    required this.filter,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;

    switch (filter) {
      case 'active':
        title = 'No active tasks';
        subtitle = 'All tasks are completed!';
        break;
      case 'completed':
        title = 'No completed tasks';
        subtitle = 'Complete your tasks to see them here';
        break;
      default:
        title = 'No tasks found';
        subtitle = 'Add your first task';
        break;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📭',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            if (filter == 'all')
              ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '+ Add your first task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}