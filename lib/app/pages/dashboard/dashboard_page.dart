// lib/app/pages/dashboard/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:todovalidate/app/providers/auth_provider.dart';
import 'package:todovalidate/app/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/top_bar.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/filter_row.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/todo_table_widget.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/empty_state.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/add_task_dialog.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/delete_confirm_dialog.dart';
import 'package:todovalidate/app/pages/dashboard/widgets/app_sidebar.dart';
import 'package:todovalidate/core/autoroutes/routes.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: const DashboardView(),
    );
  }
}

//-----------------------------------------------------------------------------

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _showAddDialog = false;
  bool _showDeleteDialog = false;
  String? _deleteTaskId;
  bool _isSidebarOpen = false;
  String _selectedListKey = 'all';

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(FetchTasks());
  }

  void _openAddDialog() => setState(() => _showAddDialog = true);
  void _closeAddDialog() => setState(() => _showAddDialog = false);

  void _openDeleteDialog(String id) {
    setState(() {
      _deleteTaskId = id;
      _showDeleteDialog = true;
    });
  }

  void _closeDeleteDialog() {
    setState(() {
      _deleteTaskId = null;
      _showDeleteDialog = false;
    });
  }

  void _confirmDelete() {
    if (_deleteTaskId != null) {
      context.read<DashboardBloc>().add(RemoveTask(_deleteTaskId!));
      _closeDeleteDialog();
    }
  }

  void _toggleSidebar() => setState(() => _isSidebarOpen = !_isSidebarOpen);
  void _closeSidebar() => setState(() => _isSidebarOpen = false);

  void _selectList(String key) {
    setState(() {
      _selectedListKey = key;
    });
    context.read<DashboardBloc>().add(SetCategory(key));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final dashboardBloc = context.read<DashboardBloc>();

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A5F), Color(0xFF2D1B4E)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        TopBar(
                          username: authProvider.getUsername(),
                          activeCount: state.activeCount,
                          onMenuTap: _toggleSidebar,
                        ),
                        const SizedBox(height: 12),

                        if (state.error != null) _buildErrorToast(state, dashboardBloc),

                        FilterRow(
                          totalCount: state.totalCount,
                          activeCount: state.activeCount,
                          completedCount: state.completedCount,
                          currentFilter: state.filter.name,
                          onFilterChanged: (filter) =>
                              dashboardBloc.add(SetFilter(FilterType.values.firstWhere(
                                (e) => e.name == filter,
                                orElse: () => FilterType.all,
                              ))),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: state.loading
                              ? const Center(child: CircularProgressIndicator())
                              : state.filteredTasks.isEmpty
                                  ? EmptyState(
                                      filter: state.filter.name,
                                      onAddPressed: _openAddDialog,
                                    )
                                  : TodoTableWidget(
                                      tasks: state.filteredTasks,
                                      editId: state.editId,
                                      editText: state.editText,
                                      currentFilter: state.filter.name,
                                      onToggleComplete: (id) =>
                                          dashboardBloc.add(ToggleTaskComplete(id)),
                                      onStartEdit: (id, title) {
                                        dashboardBloc.add(SetEditId(id));
                                        dashboardBloc.add(SetEditText(title));
                                      },
                                      onSaveEdit: (id) => dashboardBloc.add(
                                        UpdateTask(id: id, title: state.editText),
                                      ),
                                      onCancelEdit: () =>
                                          dashboardBloc.add(ClearEdit()),
                                      onEditTextChanged: (text) =>
                                          dashboardBloc.add(SetEditText(text)),
                                      onDelete: _openDeleteDialog,
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: state.loading ? null : _openAddDialog, // ✅ Added loading check
                backgroundColor: const Color(0xFF4F46E5),
                shape: const CircleBorder(),
                elevation: 8,
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            ),

            AppSidebar(
              isOpen: _isSidebarOpen,
              totalCount: state.totalCount,
              activeCount: state.activeCount,
              completedCount: state.completedCount,
              personalCount: state.personalCount,
              shoppingCount: state.shoppingCount,
              wishlistCount: state.wishlistCount,
              workCount: state.workCount,
              selectedKey: _selectedListKey,
              onSelect: _selectList,
              onClose: _closeSidebar,
              onLogout: () {
                _closeSidebar();
                authProvider.logout();
                context.router.replace(const LoginRoute());
              },
            ),

            if (_showAddDialog)
              AddTaskDialog(
                onClose: _closeAddDialog,
              ),

            if (_showDeleteDialog)
              DeleteConfirmDialog(
                onCancel: _closeDeleteDialog,
                onConfirm: _confirmDelete,
              ),
          ],
        );
      },
    );
  }

  Widget _buildErrorToast(DashboardState state, DashboardBloc dashboardBloc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFECACA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.error!,
              style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () => dashboardBloc.add(ClearError()),
            child: const Icon(Icons.close, size: 16, color: Color(0xFFB91C1C)),
          ),
        ],
      ),
    );
  }
}