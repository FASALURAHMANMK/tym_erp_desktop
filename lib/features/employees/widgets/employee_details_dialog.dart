import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employee.dart';

class EmployeeDetailsDialog extends ConsumerWidget {
  final Employee employee;

  const EmployeeDetailsDialog({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getRoleColor(employee.primaryRole).withValues(alpha: 0.2),
                    child: Text(
                      (employee.displayName ?? 'E')[0].toUpperCase(),
                      style: TextStyle(
                        color: _getRoleColor(employee.primaryRole),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.displayName ?? 'Unknown',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
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
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(theme, employee.employmentStatus),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildSection(
                      theme,
                      'Basic Information',
                      Icons.person,
                      [
                        _buildInfoRow('Employee Code', employee.employeeCode),
                        _buildInfoRow('Full Name', employee.displayName ?? 'Not provided'),
                        _buildInfoRow('User ID', employee.userId),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Contact Information
                    _buildSection(
                      theme,
                      'Contact Information',
                      Icons.contact_phone,
                      [
                        _buildInfoRow('Work Phone', employee.workPhone ?? 'Not provided'),
                        _buildInfoRow('Work Email', employee.workEmail ?? 'Not provided'),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Employment Details
                    _buildSection(
                      theme,
                      'Employment Details',
                      Icons.work,
                      [
                        _buildInfoRow('Role', employee.roleDisplayName),
                        _buildInfoRow('Status', employee.statusDisplayName),
                        _buildInfoRow(
                          'Joined Date',
                          '${employee.joinedAt.day}/${employee.joinedAt.month}/${employee.joinedAt.year}',
                        ),
                        if (employee.terminatedAt != null)
                          _buildInfoRow(
                            'Terminated Date',
                            '${employee.terminatedAt!.day}/${employee.terminatedAt!.month}/${employee.terminatedAt!.year}',
                          ),
                        if (employee.terminationReason != null)
                          _buildInfoRow('Termination Reason', employee.terminationReason!),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Access & Permissions
                    _buildSection(
                      theme,
                      'Access & Permissions',
                      Icons.security,
                      [
                        _buildInfoRow(
                          'Location Access',
                          employee.canAccessAllLocations
                              ? 'All Locations'
                              : 'Selected Locations (${employee.assignedLocations.length})',
                        ),
                        if (!employee.canAccessAllLocations && employee.assignedLocations.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: Wrap(
                              spacing: 8,
                              children: employee.assignedLocations.map((locationId) {
                                return Chip(
                                  label: Text(
                                    locationId,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  padding: EdgeInsets.zero,
                                );
                              }).toList(),
                            ),
                          ),
                        _buildInfoRow('Can Login', employee.canLogin ? 'Yes' : 'No'),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Work Schedule
                    if (employee.defaultShiftStart != null || employee.defaultShiftEnd != null)
                      _buildSection(
                        theme,
                        'Work Schedule',
                        Icons.schedule,
                        [
                          if (employee.shiftDisplay != null)
                            _buildInfoRow('Shift Timing', employee.shiftDisplay!),
                          _buildInfoRow('Working Days', employee.workingDaysDisplay),
                        ],
                      ),
                    
                    if (employee.defaultShiftStart != null || employee.defaultShiftEnd != null)
                      const SizedBox(height: 24),
                    
                    // Compensation (if available)
                    if (employee.hourlyRate != null || employee.monthlySalary != null) ...[
                      _buildSection(
                        theme,
                        'Compensation',
                        Icons.payments,
                        [
                          if (employee.hourlyRate != null)
                            _buildInfoRow('Hourly Rate', '\$${employee.hourlyRate!.toStringAsFixed(2)}'),
                          if (employee.monthlySalary != null)
                            _buildInfoRow('Monthly Salary', '\$${employee.monthlySalary!.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // Metadata
                    _buildSection(
                      theme,
                      'System Information',
                      Icons.info,
                      [
                        _buildInfoRow(
                          'Created At',
                          '${employee.createdAt.day}/${employee.createdAt.month}/${employee.createdAt.year} ${employee.createdAt.hour}:${employee.createdAt.minute.toString().padLeft(2, '0')}',
                        ),
                        _buildInfoRow(
                          'Last Updated',
                          '${employee.updatedAt.day}/${employee.updatedAt.month}/${employee.updatedAt.year} ${employee.updatedAt.hour}:${employee.updatedAt.minute.toString().padLeft(2, '0')}',
                        ),
                        if (employee.lastSyncedAt != null)
                          _buildInfoRow(
                            'Last Synced',
                            '${employee.lastSyncedAt!.day}/${employee.lastSyncedAt!.month}/${employee.lastSyncedAt!.year} ${employee.lastSyncedAt!.hour}:${employee.lastSyncedAt!.minute.toString().padLeft(2, '0')}',
                          ),
                        _buildInfoRow(
                          'Sync Status',
                          employee.hasUnsyncedChanges ? 'Pending Sync' : 'Synced',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement edit functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit functionality coming soon')),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, EmploymentStatus status) {
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
            status.name.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
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
}