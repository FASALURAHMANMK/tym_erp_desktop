import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class QuickAddCustomerDialog extends ConsumerStatefulWidget {
  final String businessId;
  final Function(Customer)? onCustomerAdded;
  
  const QuickAddCustomerDialog({
    super.key,
    required this.businessId,
    this.onCustomerAdded,
  });

  @override
  ConsumerState<QuickAddCustomerDialog> createState() => _QuickAddCustomerDialogState();
}

class _QuickAddCustomerDialogState extends ConsumerState<QuickAddCustomerDialog> {
  static final _logger = Logger('QuickAddCustomerDialog');
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _usePhoneForWhatsApp = true;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  void _onPhoneChanged() {
    if (_usePhoneForWhatsApp) {
      _whatsappController.text = _phoneController.text;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.person_add, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Quick Add Customer'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name *',
                    hintText: 'Enter customer name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter customer name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: 'Enter 10-digit phone number',
                    prefixIcon: Icon(Icons.phone),
                    prefixText: '+91 ',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // WhatsApp field with checkbox
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _whatsappController,
                        decoration: InputDecoration(
                          labelText: 'WhatsApp Number',
                          hintText: 'WhatsApp number',
                          prefixIcon: Icon(Icons.chat, color: Colors.green[700]),
                          prefixText: '+91 ',
                          enabled: !_usePhoneForWhatsApp,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (!_usePhoneForWhatsApp && 
                              value != null && 
                              value.isNotEmpty && 
                              value.length != 10) {
                            return 'Must be 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                CheckboxListTile(
                  value: _usePhoneForWhatsApp,
                  onChanged: (value) {
                    setState(() {
                      _usePhoneForWhatsApp = value ?? true;
                      if (_usePhoneForWhatsApp) {
                        _whatsappController.text = _phoneController.text;
                      }
                    });
                  },
                  title: const Text('Same as phone'),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                
                const SizedBox(height: 8),
                
                // Email field (optional)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    hintText: 'customer@example.com',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Basic email validation
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Info box
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
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You can add more details later from customer management',
                          style: theme.textTheme.bodySmall,
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
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveCustomer,
          icon: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_isLoading ? 'Saving...' : 'Save & Select'),
        ),
      ],
    );
  }
  
  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final data = QuickCustomerData(
        businessId: widget.businessId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsapp: _usePhoneForWhatsApp 
            ? _phoneController.text.trim()
            : _whatsappController.text.trim().isNotEmpty 
                ? _whatsappController.text.trim()
                : null,
        email: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim()
            : null,
      );
      
      final customer = await ref.read(quickAddCustomerProvider(data).future);
      
      _logger.info('Customer added successfully: ${customer.name}');
      
      if (mounted) {
        widget.onCustomerAdded?.call(customer);
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer "${customer.name}" added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to add customer: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add customer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}