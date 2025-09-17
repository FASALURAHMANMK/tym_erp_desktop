import 'package:flutter/material.dart';

enum ERPModule {
  sell,
  sales,
  onlineOrders,
  inventory,
  accounts,
  customers,
  employees,
  manage,
}

extension ERPModuleExtension on ERPModule {
  String get name {
    switch (this) {
      case ERPModule.sell:
        return 'sell';
      case ERPModule.sales:
        return 'sales';
      case ERPModule.onlineOrders:
        return 'online-orders';
      case ERPModule.inventory:
        return 'inventory';
      case ERPModule.accounts:
        return 'accounts';
      case ERPModule.customers:
        return 'customers';
      case ERPModule.employees:
        return 'employees';
      case ERPModule.manage:
        return 'manage';
    }
  }

  String get displayName {
    switch (this) {
      case ERPModule.sell:
        return 'Sell';
      case ERPModule.sales:
        return 'Sales';
      case ERPModule.onlineOrders:
        return 'Orders';
      case ERPModule.inventory:
        return 'Inventory';
      case ERPModule.accounts:
        return 'Accounts';
      case ERPModule.customers:
        return 'Customers';
      case ERPModule.employees:
        return 'Employees';
      case ERPModule.manage:
        return 'Manage';
    }
  }

  IconData get icon {
    switch (this) {
      case ERPModule.sell:
        return Icons.point_of_sale;
      case ERPModule.sales:
        return Icons.trending_up;
      case ERPModule.onlineOrders:
        return Icons.shopping_bag;
      case ERPModule.inventory:
        return Icons.inventory_2;
      case ERPModule.accounts:
        return Icons.account_balance;
      case ERPModule.customers:
        return Icons.people;
      case ERPModule.employees:
        return Icons.badge;
      case ERPModule.manage:
        return Icons.settings;
    }
  }

  String get route {
    return '/home/$name';
  }

  String get description {
    switch (this) {
      case ERPModule.sell:
        return 'Point of Sale and Billing';
      case ERPModule.sales:
        return 'Sales Analytics and Reports';
      case ERPModule.onlineOrders:
        return 'Online Orders Management';
      case ERPModule.inventory:
        return 'Inventory Management';
      case ERPModule.accounts:
        return 'Financial Accounts';
      case ERPModule.customers:
        return 'Customer Relationship Management';
      case ERPModule.employees:
        return 'Human Resources';
      case ERPModule.manage:
        return 'Business Management Settings';
    }
  }
}