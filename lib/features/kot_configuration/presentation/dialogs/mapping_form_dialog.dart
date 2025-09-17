import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/kot_printer_station.dart';
import '../../domain/models/kot_station.dart';
import '../../domain/models/kot_printer.dart';
import '../../providers/kot_providers.dart';
import '../../../business/providers/business_provider.dart';
import '../../../location/providers/location_provider.dart';

class MappingFormDialog extends ConsumerStatefulWidget {
  final KotStation station;
  final List<KotPrinter> availablePrinters;
  final KotPrinterStation? existingMapping;

  const MappingFormDialog({
    super.key,
    required this.station,
    required this.availablePrinters,
    this.existingMapping,
  });

  static Future<void> show(
    BuildContext context, {
    required KotStation station,
    required List<KotPrinter> availablePrinters,
    KotPrinterStation? existingMapping,
  }) {
    return showDialog(
      context: context,
      builder: (context) => MappingFormDialog(
        station: station,
        availablePrinters: availablePrinters,
        existingMapping: existingMapping,
      ),
    );
  }

  @override
  ConsumerState<MappingFormDialog> createState() => _MappingFormDialogState();
}

class _MappingFormDialogState extends ConsumerState<MappingFormDialog> {
  late String? _selectedPrinterId;
  late int _priority;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPrinterId = widget.existingMapping?.printerId;
    _priority = widget.existingMapping?.priority ?? 1;
    _isActive = widget.existingMapping?.isActive ?? true;
  }

  Future<void> _saveMapping() async {
    if (_selectedPrinterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a printer')),
      );
      return;
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

      final mapping = KotPrinterStation(
        id: widget.existingMapping?.id ?? '',
        businessId: business.id,
        locationId: location.id,
        printerId: _selectedPrinterId!,
        stationId: widget.station.id,
        isActive: _isActive,
        priority: _priority,
        createdAt: widget.existingMapping?.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(kotPrinterStationNotifierProvider.notifier).savePrinterStation(mapping);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingMapping == null 
                ? 'Printer mapping created successfully' 
                : 'Printer mapping updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving mapping: $e')),
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
    final selectedPrinter = _selectedPrinterId != null 
        ? widget.availablePrinters.firstWhere((p) => p.id == _selectedPrinterId)
        : null;

    return AlertDialog(
      title: Text('Map Printer to ${widget.station.name}'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Printer selection
              DropdownButtonFormField<String>(
                value: _selectedPrinterId,
                decoration: const InputDecoration(
                  labelText: 'Select Printer',
                  border: OutlineInputBorder(),
                ),
                items: widget.availablePrinters.map((printer) {
                  return DropdownMenuItem(
                    value: printer.id,
                    child: Row(
                      children: [
                        Icon(
                          _getPrinterIcon(printer.printerType),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(printer.name),
                        if (printer.isDefault) ...[
                          const SizedBox(width: 8),
                          const Chip(
                            label: Text('Default', style: TextStyle(fontSize: 10)),
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedPrinterId = value);
                },
              ),
              const SizedBox(height: 16),

              // Show selected printer details
              if (selectedPrinter != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Printer Details',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Type: ${selectedPrinter.printerType}'),
                        if (selectedPrinter.ipAddress != null)
                          Text('IP: ${selectedPrinter.ipAddress}:${selectedPrinter.port}'),
                        if (selectedPrinter.macAddress != null)
                          Text('MAC: ${selectedPrinter.macAddress}'),
                        Text('Paper Size: ${selectedPrinter.paperSize}'),
                        Text('Print Copies: ${selectedPrinter.printCopies}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Priority
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Priority', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Slider(
                          value: _priority.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: _priority.toString(),
                          onChanged: (value) {
                            setState(() => _priority = value.toInt());
                          },
                        ),
                        Text(
                          'Priority: $_priority (Lower number = Higher priority)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active switch
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Enable this printer mapping'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
                contentPadding: EdgeInsets.zero,
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
        FilledButton(
          onPressed: _isLoading ? null : _saveMapping,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.existingMapping == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  IconData _getPrinterIcon(String type) {
    switch (type) {
      case 'network':
        return Icons.wifi;
      case 'bluetooth':
        return Icons.bluetooth;
      case 'usb':
        return Icons.usb;
      default:
        return Icons.print;
    }
  }
}