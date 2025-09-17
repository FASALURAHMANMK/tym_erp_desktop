import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employee.dart';
import '../providers/employee_provider.dart';
import '../widgets/add_employee_dialog.dart';
import '../widgets/employee_details_dialog.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  String _searchQuery = '';
  EmployeeRole? _selectedRole;
  EmploymentStatus _statusFilter = EmploymentStatus.active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final employeesAsync = ref.watch(employeesNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Header
          _buildHeader(theme),
          
          // Content
          Expanded(
            child: employeesAsync.when(
              data: (employees) => _buildContent(theme, employees),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load employees',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => ref.refresh(employeesNotifierProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Employees',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Human Resources',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Stats
              _buildStats(theme),
            ],
          ),
          const SizedBox(height: 24),
          // Filters bar
          _buildFiltersBar(theme),
        ],
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    final stats = ref.watch(employeeStatsProvider);
    
    return Row(
      children: [
        _buildStatCard(
          theme,
          'Total',
          stats['total'].toString(),
          Icons.people_outline,
          theme.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          theme,
          'Active',
          stats['active'].toString(),
          Icons.check_circle_outline,
          Colors.green,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          theme,
          'Inactive',
          stats['inactive'].toString(),
          Icons.pause_circle_outline,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(ThemeData theme) {
    return Row(
      children: [
        // Search
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search employees...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(width: 16),
        
        // Role Filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<EmployeeRole?>(
            value: _selectedRole,
            hint: const Text('All Roles'),
            underline: const SizedBox(),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All Roles'),
              ),
              ...EmployeeRole.values.map((role) {
                final displayName = _getRoleDisplayName(role);
                return DropdownMenuItem(
                  value: role,
                  child: Text(displayName),
                );
              }),
            ],
            onChanged: (value) => setState(() => _selectedRole = value),
          ),
        ),
        const SizedBox(width: 16),
        
        // Status Filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<EmploymentStatus>(
            value: _statusFilter,
            underline: const SizedBox(),
            items: EmploymentStatus.values.map((status) {
              final displayName = _getStatusDisplayName(status);
              return DropdownMenuItem(
                value: status,
                child: Text(displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _statusFilter = value);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        
        // Add Employee Button
        FilledButton.icon(
          onPressed: _showAddEmployeeDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Employee'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, List<Employee> allEmployees) {
    // Apply filters
    final employees = ref.watch(
      filteredEmployeesProvider(
        searchQuery: _searchQuery,
        role: _selectedRole,
        status: _statusFilter,
      ),
    );

    if (employees.isEmpty) {
      return _buildEmptyState(theme);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            columns: [
              DataColumn(
                label: Text(
                  'Employee',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Code',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Role',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Location',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Joined',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const DataColumn(label: Text('')),
            ],
            rows: employees.map((employee) => _buildEmployeeRow(theme, employee)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildEmployeeRow(ThemeData theme, Employee employee) {
    return DataRow(
      cells: [
        // Employee Name & Avatar
        DataCell(
          InkWell(
            onTap: () => _showEmployeeDetails(employee),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(employee.primaryRole).withValues(alpha: 0.2),
                  child: Text(
                    (employee.displayName ?? 'E')[0].toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(employee.primaryRole),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      employee.displayName ?? 'Unknown',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (employee.workPhone != null)
                      Text(
                        employee.workPhone!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Employee Code
        DataCell(Text(employee.employeeCode)),
        
        // Role
        DataCell(
          Chip(
            label: Text(
              employee.roleDisplayName,
              style: TextStyle(
                color: _getRoleColor(employee.primaryRole),
                fontSize: 12,
              ),
            ),
            backgroundColor: _getRoleColor(employee.primaryRole).withValues(alpha: 0.1),
            side: BorderSide.none,
          ),
        ),
        
        // Location
        DataCell(
          Text(employee.canAccessAllLocations ? 'All Locations' : 'Assigned'),
        ),
        
        // Status
        DataCell(_buildStatusChip(theme, employee.employmentStatus)),
        
        // Joined Date
        DataCell(
          Text(
            '${employee.joinedAt.day}/${employee.joinedAt.month}/${employee.joinedAt.year}',
            style: theme.textTheme.bodySmall,
          ),
        ),
        
        // Actions
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text('View Details'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (employee.employmentStatus == EmploymentStatus.active)
                const PopupMenuItem(
                  value: 'suspend',
                  child: ListTile(
                    leading: Icon(Icons.pause),
                    title: Text('Suspend'),
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              else if (employee.employmentStatus != EmploymentStatus.terminated)
                const PopupMenuItem(
                  value: 'activate',
                  child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('Activate'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) => _handleEmployeeAction(value, employee),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No employees found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Add your first employee to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _showAddEmployeeDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add First Employee'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, EmploymentStatus status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case EmploymentStatus.active:
        color = Colors.green;
        icon = Icons.check_circle;
      case EmploymentStatus.inactive:
        color = Colors.grey;
        icon = Icons.pause_circle;
      case EmploymentStatus.suspended:
        color = Colors.orange;
        icon = Icons.warning;
      case EmploymentStatus.terminated:
        color = Colors.red;
        icon = Icons.cancel;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            _getStatusDisplayName(status),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.owner:
        return Colors.purple;
      case EmployeeRole.manager:
        return Colors.blue;
      case EmployeeRole.cashier:
        return Colors.teal;
      case EmployeeRole.waiter:
        return Colors.green;
      case EmployeeRole.kitchenStaff:
        return Colors.orange;
      case EmployeeRole.delivery:
        return Colors.indigo;
      case EmployeeRole.accountant:
        return Colors.brown;
    }
  }

  String _getRoleDisplayName(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.owner:
        return 'Owner';
      case EmployeeRole.manager:
        return 'Manager';
      case EmployeeRole.cashier:
        return 'Cashier';
      case EmployeeRole.waiter:
        return 'Waiter';
      case EmployeeRole.kitchenStaff:
        return 'Kitchen Staff';
      case EmployeeRole.delivery:
        return 'Delivery';
      case EmployeeRole.accountant:
        return 'Accountant';
    }
  }

  String _getStatusDisplayName(EmploymentStatus status) {
    switch (status) {
      case EmploymentStatus.active:
        return 'Active';
      case EmploymentStatus.inactive:
        return 'Inactive';
      case EmploymentStatus.suspended:
        return 'Suspended';
      case EmploymentStatus.terminated:
        return 'Terminated';
    }
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddEmployeeDialog(),
    );
  }

  void _showEmployeeDetails(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => EmployeeDetailsDialog(employee: employee),
    );
  }

  void _handleEmployeeAction(String action, Employee employee) async {
    final notifier = ref.read(employeesNotifierProvider.notifier);
    
    switch (action) {
      case 'view':
        _showEmployeeDetails(employee);
        break;
        
      case 'edit':
        // TODO: Show edit dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
        
      case 'suspend':
        final confirmed = await _showConfirmationDialog(
          'Suspend Employee',
          'Are you sure you want to suspend ${employee.displayName}?',
        );
        if (confirmed) {
          final success = await notifier.updateEmployeeStatus(
            employeeId: employee.id,
            newStatus: EmploymentStatus.suspended,
            reason: 'Suspended by admin',
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success 
                      ? 'Employee suspended successfully' 
                      : 'Failed to suspend employee',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        }
        break;
        
      case 'activate':
        final success = await notifier.updateEmployeeStatus(
          employeeId: employee.id,
          newStatus: EmploymentStatus.active,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success 
                    ? 'Employee activated successfully' 
                    : 'Failed to activate employee',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
        break;
        
      case 'delete':
        final confirmed = await _showConfirmationDialog(
          'Remove Employee',
          'Are you sure you want to remove ${employee.displayName}? This action cannot be undone.',
        );
        if (confirmed) {
          final success = await notifier.deleteEmployee(employee.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success 
                      ? 'Employee removed successfully' 
                      : 'Failed to remove employee',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        }
        break;
    }
  }

  Future<bool> _showConfirmationDialog(String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }
}