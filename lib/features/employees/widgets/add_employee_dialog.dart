import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employee.dart';
import '../providers/employee_provider.dart';

class AddEmployeeDialog extends ConsumerStatefulWidget {
  const AddEmployeeDialog({super.key});

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  EmployeeRole _selectedRole = EmployeeRole.waiter;
  final List<String> _selectedLocations = [];
  bool _allLocations = true;
  bool _isChecking = false;
  bool _userExists = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.person_add,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          const Text('Add New Employee'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number*',
                    hintText: '+1234567890',
                    prefixIcon: const Icon(Icons.phone),
                    suffixIcon: _isChecking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _userExists
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                              )
                            : null,
                    helperText: _userExists
                        ? 'User already has an account. They will be added as employee.'
                        : 'Include country code (e.g., +1 for US)',
                    helperStyle: TextStyle(
                      color: _userExists ? Colors.green.shade600 : null,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!value.startsWith('+')) {
                      return 'Include country code (e.g., +1234567890)';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: _checkUserExists,
                ),
                
                const SizedBox(height: 16),
                
                // Full Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name*',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Email Field (Optional)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Password Field (Only for new users)
                if (!_userExists) ...[
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Temporary Password*',
                      prefixIcon: const Icon(Icons.lock),
                      helperText: 'Minimum 6 characters. Share this with the employee.',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.auto_fix_high),
                        onPressed: _generatePassword,
                        tooltip: 'Generate password',
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (!_userExists) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required for new users';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Role Selection
                DropdownButtonFormField<EmployeeRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role*',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  items: EmployeeRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Row(
                        children: [
                          _getRoleIcon(role),
                          const SizedBox(width: 8),
                          Text(_getRoleDisplayName(role)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Location Access
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Access',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          title: const Text('Can access all locations'),
                          subtitle: const Text(
                            'Employee can work at any business location',
                          ),
                          value: _allLocations,
                          onChanged: (value) {
                            setState(() => _allLocations = value ?? true);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        
                        if (!_allLocations) ...[
                          const Divider(),
                          const Text(
                            'Select specific locations:',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          // TODO: Add location selector when locations are available
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Location selection will be available once locations are configured',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userExists
                                  ? 'Existing User'
                                  : 'New User Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userExists
                                  ? 'This phone number already has an account. They can use their existing password to sign in.'
                                  : 'A new user account will be created. Share the temporary password with the employee.',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _createEmployee,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Add Employee'),
        ),
      ],
    );
  }

  Future<void> _checkUserExists(String phone) async {
    if (phone.length < 10 || !phone.startsWith('+')) {
      setState(() {
        _userExists = false;
        _isChecking = false;
      });
      return;
    }

    setState(() => _isChecking = true);

    // Check if user exists
    bool exists = false;
    try {
      final service = await ref.read(employeeServiceProvider.future);
      exists = await service.checkUserExists(phone);
    } catch (e) {
      // If we can't check, assume user doesn't exist
      exists = false;
    }

    if (mounted) {
      setState(() {
        _userExists = exists;
        _isChecking = false;
      });
    }
  }

  void _generatePassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final password = List.generate(8, (index) {
      final charIndex = (timestamp + index) % chars.length;
      return chars[charIndex];
    }).join();
    
    _passwordController.text = password;
  }

  Future<void> _createEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final notifier = ref.read(employeesNotifierProvider.notifier);
    final success = await notifier.createEmployee(
      phone: _phoneController.text.trim(),
      fullName: _nameController.text.trim(),
      role: _selectedRole,
      locationIds: _allLocations ? null : _selectedLocations,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      temporaryPassword: _userExists ? null : _passwordController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _userExists
                  ? 'Employee added successfully! They can sign in with their existing credentials.'
                  : 'Employee created! Share the login credentials:\nPhone: ${_phoneController.text}\nPassword: ${_passwordController.text}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'Failed to create employee. Please try again.';
        });
      }
    }
  }

  Icon _getRoleIcon(EmployeeRole role) {
    IconData iconData;
    Color color;
    
    switch (role) {
      case EmployeeRole.owner:
        iconData = Icons.star;
        color = Colors.purple;
      case EmployeeRole.manager:
        iconData = Icons.supervisor_account;
        color = Colors.blue;
      case EmployeeRole.cashier:
        iconData = Icons.point_of_sale;
        color = Colors.teal;
      case EmployeeRole.waiter:
        iconData = Icons.restaurant;
        color = Colors.green;
      case EmployeeRole.kitchenStaff:
        iconData = Icons.kitchen;
        color = Colors.orange;
      case EmployeeRole.delivery:
        iconData = Icons.delivery_dining;
        color = Colors.indigo;
      case EmployeeRole.accountant:
        iconData = Icons.calculate;
        color = Colors.brown;
    }
    
    return Icon(iconData, size: 20, color: color);
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
}