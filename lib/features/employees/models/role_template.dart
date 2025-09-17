import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_template.freezed.dart';
part 'role_template.g.dart';

@freezed
class RoleTemplate with _$RoleTemplate {
  const factory RoleTemplate({
    required String id,
    required String roleCode,
    required String roleName,
    required Map<String, dynamic> permissions,
    String? description,
    @Default(true) bool isSystemRole,
    required DateTime createdAt,
  }) = _RoleTemplate;

  factory RoleTemplate.fromJson(Map<String, dynamic> json) =>
      _$RoleTemplateFromJson(json);

  const RoleTemplate._();

  // Permission checking helpers
  bool hasPermission(String module, String action) {
    // Check if has all permissions
    if (permissions['all'] == true) return true;
    
    // Check module-specific permissions
    final modulePerms = permissions[module] as List<dynamic>?;
    if (modulePerms != null) {
      return modulePerms.contains(action);
    }
    
    return false;
  }

  List<String> getModulePermissions(String module) {
    if (permissions['all'] == true) {
      // Return all possible actions for the module
      return ['view', 'create', 'edit', 'delete', 'export'];
    }
    
    final modulePerms = permissions[module] as List<dynamic>?;
    if (modulePerms != null) {
      return modulePerms.cast<String>();
    }
    
    return [];
  }

  // Get all modules this role has access to
  List<String> get accessibleModules {
    if (permissions['all'] == true) {
      return [
        'orders',
        'inventory',
        'employees',
        'reports',
        'payments',
        'settings',
        'customers',
        'menu',
        'tables',
      ];
    }
    
    return permissions.keys
        .where((key) => key != 'all' && permissions[key] != null)
        .toList();
  }

  // Static role definitions for easy reference
  static const Map<String, List<String>> defaultPermissions = {
    'owner': ['all'],
    'manager': [
      'orders.view', 'orders.create', 'orders.edit', 'orders.cancel',
      'inventory.view', 'inventory.edit',
      'employees.view',
      'reports.view', 'reports.export',
      'payments.process', 'payments.refund',
      'customers.view', 'customers.create', 'customers.edit',
    ],
    'cashier': [
      'orders.view', 'orders.create', 'orders.edit',
      'payments.process', 'payments.refund',
      'reports.view_daily',
      'cash_drawer.open', 'cash_drawer.close',
      'customers.view', 'customers.create',
    ],
    'waiter': [
      'orders.view', 'orders.create', 'orders.edit',
      'tables.view', 'tables.manage',
      'menu.view',
      'kot.create', 'kot.print',
      'customers.view',
    ],
    'kitchen_staff': [
      'orders.view', 'orders.update_status',
      'kot.view', 'kot.mark_ready',
      'inventory.view',
      'menu.view',
    ],
    'delivery': [
      'orders.view', 'orders.update_delivery_status',
      'customers.view',
      'routes.view', 'routes.update',
    ],
    'accountant': [
      'reports.view', 'reports.export', 'reports.create',
      'payments.view', 'payments.reconcile',
      'expenses.view', 'expenses.create', 'expenses.approve',
      'invoices.view', 'invoices.create', 'invoices.send',
      'taxes.view', 'taxes.file',
    ],
  };
}