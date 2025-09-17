import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/kot_station.dart';
import '../../providers/kot_providers.dart';
import '../../../business/providers/business_provider.dart';
import '../../../location/providers/location_provider.dart';

class StationFormDialog extends ConsumerStatefulWidget {
  final KotStation? station;

  const StationFormDialog({super.key, this.station});

  static Future<void> show(BuildContext context, {KotStation? station}) {
    return showDialog(
      context: context,
      builder: (context) => StationFormDialog(station: station),
    );
  }

  @override
  ConsumerState<StationFormDialog> createState() => _StationFormDialogState();
}

class _StationFormDialogState extends ConsumerState<StationFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _selectedType;
  late bool _isActive;
  late int _displayOrder;
  Color? _selectedColor;
  bool _isLoading = false;

  final List<String> _stationTypes = [
    'kitchen',
    'bar',
    'bakery',
    'grill',
    'dessert',
    'beverage',
    'pantry',
    'cold_station',
    'hot_station',
    'other',
  ];

  final List<Color> _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.pink,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.station?.name ?? '');
    _descriptionController = TextEditingController(text: widget.station?.description ?? '');
    _selectedType = widget.station?.type ?? 'kitchen';
    _isActive = widget.station?.isActive ?? true;
    _displayOrder = widget.station?.displayOrder ?? 0;
    
    if (widget.station?.color != null) {
      try {
        _selectedColor = Color(int.parse(widget.station!.color!.replaceAll('#', '0xFF')));
      } catch (_) {
        _selectedColor = null;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveStation() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a station name')),
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

      final station = KotStation(
        id: widget.station?.id ?? '',
        businessId: business.id,
        locationId: location.id,
        name: _nameController.text.trim(),
        type: _selectedType,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        isActive: _isActive,
        displayOrder: _displayOrder,
        color: _selectedColor != null 
            ? '#${(_selectedColor!.r * 255).round().toRadixString(16).padLeft(2, '0')}${(_selectedColor!.g * 255).round().toRadixString(16).padLeft(2, '0')}${(_selectedColor!.b * 255).round().toRadixString(16).padLeft(2, '0')}'.toUpperCase()
            : null,
        createdAt: widget.station?.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(kotStationNotifierProvider.notifier).saveStation(station);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.station == null 
                ? 'Station created successfully' 
                : 'Station updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving station: $e')),
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
      title: Text(widget.station == null ? 'Add Station' : 'Edit Station'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Station Name',
                hintText: 'e.g., Main Kitchen',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Type dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Station Type',
                border: OutlineInputBorder(),
              ),
              items: _stationTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_formatTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Additional details about this station',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Display Order
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Display Order',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: _displayOrder.toString()),
                    onChanged: (value) {
                      setState(() {
                        _displayOrder = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Active switch
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active', style: TextStyle(fontSize: 12)),
                    Switch(
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color selection
            const Text('Station Color (Optional)', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...(_colorOptions.map((color) => InkWell(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.grey.shade300,
                        width: _selectedColor == color ? 3 : 1,
                      ),
                    ),
                  ),
                ))),
                // Clear color option
                InkWell(
                  onTap: () => setState(() => _selectedColor = null),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == null 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.grey.shade300,
                        width: _selectedColor == null ? 3 : 1,
                      ),
                    ),
                    child: const Icon(Icons.clear, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveStation,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.station == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  String _formatTypeName(String type) {
    return type.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}