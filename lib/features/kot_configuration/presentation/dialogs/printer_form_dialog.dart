import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/kot_printer.dart';
import '../../providers/kot_providers.dart';
import '../../../business/providers/business_provider.dart';
import '../../../location/providers/location_provider.dart';

class PrinterFormDialog extends ConsumerStatefulWidget {
  final KotPrinter? printer;

  const PrinterFormDialog({super.key, this.printer});

  static Future<void> show(BuildContext context, {KotPrinter? printer}) {
    return showDialog(
      context: context,
      builder: (context) => PrinterFormDialog(printer: printer),
    );
  }

  @override
  ConsumerState<PrinterFormDialog> createState() => _PrinterFormDialogState();
}

class _PrinterFormDialogState extends ConsumerState<PrinterFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _ipAddressController;
  late final TextEditingController _portController;
  late final TextEditingController _macAddressController;
  late final TextEditingController _deviceNameController;
  late final TextEditingController _notesController;
  
  late String _printerType;
  late bool _isActive;
  late bool _isDefault;
  late int _printCopies;
  late String _paperSize;
  late bool _autoCut;
  late bool _cashDrawer;
  
  bool _isLoading = false;

  final List<String> _printerTypes = ['network', 'bluetooth', 'usb', 'serial'];
  final List<String> _paperSizes = ['58mm', '80mm'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.printer?.name ?? '');
    _ipAddressController = TextEditingController(text: widget.printer?.ipAddress ?? '');
    _portController = TextEditingController(text: widget.printer?.port ?? '9100');
    _macAddressController = TextEditingController(text: widget.printer?.macAddress ?? '');
    _deviceNameController = TextEditingController(text: widget.printer?.deviceName ?? '');
    _notesController = TextEditingController(text: widget.printer?.notes ?? '');
    
    _printerType = widget.printer?.printerType ?? 'network';
    _isActive = widget.printer?.isActive ?? true;
    _isDefault = widget.printer?.isDefault ?? false;
    _printCopies = widget.printer?.printCopies ?? 1;
    _paperSize = widget.printer?.paperSize ?? '80mm';
    _autoCut = widget.printer?.autoCut ?? true;
    _cashDrawer = widget.printer?.cashDrawer ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipAddressController.dispose();
    _portController.dispose();
    _macAddressController.dispose();
    _deviceNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePrinter() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a printer name')),
      );
      return;
    }

    // Validate based on printer type
    if (_printerType == 'network') {
      if (_ipAddressController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter IP address for network printer')),
        );
        return;
      }
    } else if (_printerType == 'bluetooth') {
      if (_macAddressController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter MAC address for Bluetooth printer')),
        );
        return;
      }
    }

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

      final printer = KotPrinter(
        id: widget.printer?.id ?? '',
        businessId: business.id,
        locationId: location.id,
        name: _nameController.text.trim(),
        printerType: _printerType,
        ipAddress: _printerType == 'network' && _ipAddressController.text.trim().isNotEmpty 
            ? _ipAddressController.text.trim() 
            : null,
        port: _printerType == 'network' && _portController.text.trim().isNotEmpty 
            ? _portController.text.trim() 
            : null,
        macAddress: _printerType == 'bluetooth' && _macAddressController.text.trim().isNotEmpty 
            ? _macAddressController.text.trim() 
            : null,
        deviceName: _deviceNameController.text.trim().isEmpty 
            ? null 
            : _deviceNameController.text.trim(),
        isActive: _isActive,
        isDefault: _isDefault,
        printCopies: _printCopies,
        paperSize: _paperSize,
        autoCut: _autoCut,
        cashDrawer: _cashDrawer,
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        createdAt: widget.printer?.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(kotPrinterNotifierProvider.notifier).savePrinter(printer);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.printer == null 
                ? 'Printer created successfully' 
                : 'Printer updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving printer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.printer == null ? 'Add Printer' : 'Edit Printer'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Printer Name',
                  hintText: 'e.g., Kitchen Printer 1',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Printer Type
              DropdownButtonFormField<String>(
                value: _printerType,
                decoration: const InputDecoration(
                  labelText: 'Printer Type',
                  border: OutlineInputBorder(),
                ),
                items: _printerTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type[0].toUpperCase() + type.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _printerType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Connection details based on type
              if (_printerType == 'network') ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _ipAddressController,
                        decoration: const InputDecoration(
                          labelText: 'IP Address',
                          hintText: '192.168.1.100',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: '9100',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (_printerType == 'bluetooth') ...[
                TextField(
                  controller: _macAddressController,
                  decoration: const InputDecoration(
                    labelText: 'MAC Address',
                    hintText: '00:11:22:33:44:55',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_printerType == 'usb' || _printerType == 'serial') ...[
                TextField(
                  controller: _deviceNameController,
                  decoration: const InputDecoration(
                    labelText: 'Device Name',
                    hintText: 'e.g., /dev/usb/lp0',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Paper size and copies
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _paperSize,
                      decoration: const InputDecoration(
                        labelText: 'Paper Size',
                        border: OutlineInputBorder(),
                      ),
                      items: _paperSizes.map((size) {
                        return DropdownMenuItem(
                          value: size,
                          child: Text(size),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _paperSize = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _printCopies,
                      decoration: const InputDecoration(
                        labelText: 'Print Copies',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(5, (i) => i + 1).map((copies) {
                        return DropdownMenuItem(
                          value: copies,
                          child: Text(copies.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _printCopies = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Options
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Options',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text('Printer is available for use'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        dense: true,
                      ),
                      SwitchListTile(
                        title: const Text('Default Printer'),
                        subtitle: const Text('Use as default for this location'),
                        value: _isDefault,
                        onChanged: (value) => setState(() => _isDefault = value),
                        dense: true,
                      ),
                      SwitchListTile(
                        title: const Text('Auto Cut'),
                        subtitle: const Text('Cut paper after printing'),
                        value: _autoCut,
                        onChanged: (value) => setState(() => _autoCut = value),
                        dense: true,
                      ),
                      SwitchListTile(
                        title: const Text('Cash Drawer'),
                        subtitle: const Text('Open cash drawer after printing'),
                        value: _cashDrawer,
                        onChanged: (value) => setState(() => _cashDrawer = value),
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Additional information about this printer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _testPrinter,
          icon: const Icon(Icons.print, size: 18),
          label: const Text('Test Print'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _savePrinter,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.printer == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  void _testPrinter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test print functionality will be implemented with printer SDK integration'),
      ),
    );
  }
}