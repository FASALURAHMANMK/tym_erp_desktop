import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/kot_template.dart';
import '../../providers/kot_providers.dart';
import '../../../business/providers/business_provider.dart';
import '../../../location/providers/location_provider.dart';

class TemplateFormDialog extends ConsumerStatefulWidget {
  final KotTemplate? template;

  const TemplateFormDialog({super.key, this.template});

  static Future<void> show(BuildContext context, {KotTemplate? template}) {
    return showDialog(
      context: context,
      builder: (context) => TemplateFormDialog(template: template),
    );
  }

  @override
  ConsumerState<TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends ConsumerState<TemplateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  late String _type;
  late bool _isDefault;
  late bool _isActive;
  bool _isLoading = false;

  // Template variables for reference
  final List<Map<String, String>> _templateVariables = [
    {'variable': '{BUSINESS_NAME}', 'description': 'Business name'},
    {'variable': '{LOCATION_NAME}', 'description': 'Location name'},
    {'variable': '{ORDER_NUMBER}', 'description': 'Order number'},
    {'variable': '{TABLE_NUMBER}', 'description': 'Table number'},
    {'variable': '{DATE}', 'description': 'Current date'},
    {'variable': '{TIME}', 'description': 'Current time'},
    {'variable': '{CUSTOMER_NAME}', 'description': 'Customer name'},
    {'variable': '{ITEM_NAME}', 'description': 'Item name'},
    {'variable': '{ITEM_QUANTITY}', 'description': 'Item quantity'},
    {'variable': '{ITEM_PRICE}', 'description': 'Item price'},
    {'variable': '{SPECIAL_INSTRUCTIONS}', 'description': 'Special instructions'},
    {'variable': '{TOKEN_NUMBER}', 'description': 'Token number'},
    {'variable': '{STATION_NAME}', 'description': 'Station name'},
    {'variable': '{CASHIER_NAME}', 'description': 'Cashier name'},
  ];

  @override
  void initState() {
    super.initState();
    _type = widget.template?.type ?? 'full';  // Initialize _type first
    _isDefault = widget.template?.isDefault ?? false;
    _isActive = widget.template?.isActive ?? true;
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _descriptionController = TextEditingController(text: widget.template?.description ?? '');
    _contentController = TextEditingController(text: widget.template?.content ?? _getDefaultContent());
  }

  String _getDefaultContent() {
    switch (_type) {
      case 'header':
        return '''================================
        {BUSINESS_NAME}
        {LOCATION_NAME}
================================
Order: {ORDER_NUMBER}
Table: {TABLE_NUMBER}
Date: {DATE} {TIME}
================================''';
      
      case 'item_format':
        return '''{ITEM_QUANTITY} x {ITEM_NAME}
{SPECIAL_INSTRUCTIONS}''';
      
      case 'footer':
        return '''================================
Token: {TOKEN_NUMBER}
Station: {STATION_NAME}
================================''';
      
      case 'full':
      default:
        return '''================================
        {BUSINESS_NAME}
        {LOCATION_NAME}
================================
Order: {ORDER_NUMBER}
Table: {TABLE_NUMBER}
Date: {DATE} {TIME}
Customer: {CUSTOMER_NAME}
================================

{ITEM_QUANTITY} x {ITEM_NAME}
{SPECIAL_INSTRUCTIONS}

================================
Token: {TOKEN_NUMBER}
Station: {STATION_NAME}
Cashier: {CASHIER_NAME}
================================''';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final business = ref.read(selectedBusinessProvider);
      final locationAsync = ref.read(selectedLocationNotifierProvider);
      
      if (business == null) {
        throw Exception('No business selected');
      }

      final location = locationAsync.valueOrNull;
      if (location == null) {
        throw Exception('No location selected');
      }

      final template = KotTemplate(
        id: widget.template?.id ?? '',
        businessId: business.id,
        locationId: location.id,
        name: _nameController.text.trim(),
        type: _type,
        content: _contentController.text,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        isDefault: _isDefault,
        isActive: _isActive,
        createdAt: widget.template?.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(kotTemplateNotifierProvider.notifier).saveTemplate(template);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.template == null 
                ? 'Template created successfully' 
                : 'Template updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving template: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _insertVariable(String variable) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      variable,
    );
    _contentController.text = newText;
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.start + variable.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template == null ? 'Add KOT Template' : 'Edit KOT Template'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template Type
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(
                    labelText: 'Template Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'full',
                      child: Text('Full Template'),
                    ),
                    DropdownMenuItem(
                      value: 'header',
                      child: Text('Header Only'),
                    ),
                    DropdownMenuItem(
                      value: 'item_format',
                      child: Text('Item Format'),
                    ),
                    DropdownMenuItem(
                      value: 'footer',
                      child: Text('Footer Only'),
                    ),
                  ],
                  onChanged: widget.template == null
                      ? (value) {
                          setState(() {
                            _type = value!;
                            _contentController.text = _getDefaultContent();
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 16),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Template Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter template name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Template Variables Reference
                ExpansionTile(
                  title: const Text('Available Variables'),
                  subtitle: const Text('Click to insert into template'),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _templateVariables.map((variable) {
                        return Tooltip(
                          message: variable['description']!,
                          child: ActionChip(
                            label: Text(
                              variable['variable']!,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                            ),
                            onPressed: () => _insertVariable(variable['variable']!),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Template Content
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Template Content',
                    border: OutlineInputBorder(),
                    helperText: 'Use variables like {BUSINESS_NAME} that will be replaced with actual values',
                  ),
                  maxLines: 15,
                  style: const TextStyle(fontFamily: 'monospace'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter template content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Options
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Default Template'),
                        subtitle: const Text('Use this as default for the type'),
                        value: _isDefault,
                        onChanged: (value) => setState(() => _isDefault = value),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text('Enable this template'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
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
          onPressed: _isLoading ? null : _saveTemplate,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.template == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}