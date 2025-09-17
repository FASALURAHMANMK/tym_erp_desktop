import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/charge.dart';

class ChargeFormDialog extends StatefulWidget {
  final Charge? charge;
  final Function(Charge) onSave;

  const ChargeFormDialog({
    super.key,
    this.charge,
    required this.onSave,
  });

  @override
  State<ChargeFormDialog> createState() => _ChargeFormDialogState();
}

class _ChargeFormDialogState extends State<ChargeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  
  // Form controllers
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _minOrderController;
  late TextEditingController _maxOrderController;
  late TextEditingController _displayOrderController;
  
  // Form values
  late ChargeType _chargeType;
  late CalculationType _calculationType;
  late ChargeScope _scope;
  late bool _autoApply;
  late bool _isMandatory;
  late bool _isTaxable;
  late bool _applyBeforeDiscount;
  late bool _isActive;
  
  // Tiered charges
  List<ChargeTier> _tiers = [];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing values or defaults
    _codeController = TextEditingController(text: widget.charge?.code ?? '');
    _nameController = TextEditingController(text: widget.charge?.name ?? '');
    _descriptionController = TextEditingController(text: widget.charge?.description ?? '');
    _valueController = TextEditingController(
      text: widget.charge?.value?.toString() ?? '',
    );
    _minOrderController = TextEditingController(
      text: widget.charge?.minimumOrderValue?.toString() ?? '',
    );
    _maxOrderController = TextEditingController(
      text: widget.charge?.maximumOrderValue?.toString() ?? '',
    );
    _displayOrderController = TextEditingController(
      text: widget.charge?.displayOrder.toString() ?? '0',
    );
    
    // Initialize form values
    _chargeType = widget.charge?.chargeType ?? ChargeType.service;
    _calculationType = widget.charge?.calculationType ?? CalculationType.percentage;
    _scope = widget.charge?.scope ?? ChargeScope.order;
    _autoApply = widget.charge?.autoApply ?? false;
    _isMandatory = widget.charge?.isMandatory ?? false;
    _isTaxable = widget.charge?.isTaxable ?? true;
    _applyBeforeDiscount = widget.charge?.applyBeforeDiscount ?? false;
    _isActive = widget.charge?.isActive ?? true;
    
    // Initialize tiers if editing and has tiers
    if (widget.charge != null && widget.charge!.tiers.isNotEmpty) {
      _tiers = List.from(widget.charge!.tiers);
    } else if (_calculationType == CalculationType.tiered && _tiers.isEmpty) {
      // Add default tiers for new tiered charges
      _addDefaultTiers();
    }
  }
  
  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _minOrderController.dispose();
    _maxOrderController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }
  
  void _addDefaultTiers() {
    _tiers = [
      ChargeTier(
        id: _uuid.v4(),
        chargeId: '',
        tierName: 'Base',
        minValue: 0,
        maxValue: 500,
        chargeValue: 50,
        displayOrder: 1,
        createdAt: DateTime.now(),
      ),
      ChargeTier(
        id: _uuid.v4(),
        chargeId: '',
        tierName: 'Standard',
        minValue: 500,
        maxValue: 1000,
        chargeValue: 30,
        displayOrder: 2,
        createdAt: DateTime.now(),
      ),
      ChargeTier(
        id: _uuid.v4(),
        chargeId: '',
        tierName: 'Premium',
        minValue: 1000,
        maxValue: null,
        chargeValue: 0,
        displayOrder: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.charge == null ? 'Add Charge' : 'Edit Charge'),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _saveCharge,
                child: const Text('Save'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'Code *',
                          hintText: 'e.g., SERVICE, DELIVERY',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Code is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          hintText: 'e.g., Service Charge',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                
                // Charge Configuration Section
                const SizedBox(height: 24),
                _buildSectionHeader('Charge Configuration'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ChargeType>(
                        value: _chargeType,
                        decoration: const InputDecoration(
                          labelText: 'Charge Type',
                          border: OutlineInputBorder(),
                        ),
                        items: ChargeType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_getChargeTypeName(type)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _chargeType = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<CalculationType>(
                        value: _calculationType,
                        decoration: const InputDecoration(
                          labelText: 'Calculation Type',
                          border: OutlineInputBorder(),
                        ),
                        items: CalculationType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_getCalculationTypeName(type)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _calculationType = value;
                              if (value == CalculationType.tiered && _tiers.isEmpty) {
                                _addDefaultTiers();
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Value field (for fixed and percentage)
                if (_calculationType == CalculationType.fixed ||
                    _calculationType == CalculationType.percentage)
                  TextFormField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      labelText: _calculationType == CalculationType.percentage
                          ? 'Percentage Value *'
                          : 'Fixed Amount *',
                      hintText: _calculationType == CalculationType.percentage
                          ? 'e.g., 10'
                          : 'e.g., 50',
                      border: const OutlineInputBorder(),
                      suffixText: _calculationType == CalculationType.percentage ? '%' : '₹',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Value is required';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                
                // Tiered configuration
                if (_calculationType == CalculationType.tiered) ...[
                  const SizedBox(height: 16),
                  _buildTiersConfiguration(),
                ],
                
                // Application Rules Section
                const SizedBox(height: 24),
                _buildSectionHeader('Application Rules'),
                const SizedBox(height: 8),
                DropdownButtonFormField<ChargeScope>(
                  value: _scope,
                  decoration: const InputDecoration(
                    labelText: 'Scope',
                    border: OutlineInputBorder(),
                  ),
                  items: ChargeScope.values.map((scope) {
                    return DropdownMenuItem(
                      value: scope,
                      child: Text(scope.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _scope = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minOrderController,
                        decoration: const InputDecoration(
                          labelText: 'Minimum Order Value',
                          hintText: 'Optional',
                          border: OutlineInputBorder(),
                          prefixText: '₹',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxOrderController,
                        decoration: const InputDecoration(
                          labelText: 'Maximum Order Value',
                          hintText: 'Optional',
                          border: OutlineInputBorder(),
                          prefixText: '₹',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Settings Section
                const SizedBox(height: 24),
                _buildSectionHeader('Settings'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildSwitch('Auto Apply', _autoApply, (value) {
                      setState(() {
                        _autoApply = value;
                      });
                    }),
                    _buildSwitch('Mandatory', _isMandatory, (value) {
                      setState(() {
                        _isMandatory = value;
                      });
                    }),
                    _buildSwitch('Taxable', _isTaxable, (value) {
                      setState(() {
                        _isTaxable = value;
                      });
                    }),
                    _buildSwitch('Apply Before Discount', _applyBeforeDiscount, (value) {
                      setState(() {
                        _applyBeforeDiscount = value;
                      });
                    }),
                    if (widget.charge != null)
                      _buildSwitch('Active', _isActive, (value) {
                        setState(() {
                          _isActive = value;
                        });
                      }),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayOrderController,
                  decoration: const InputDecoration(
                    labelText: 'Display Order',
                    hintText: 'Order in which charge appears',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  
  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
  
  Widget _buildTiersConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Charge Tiers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _addTier,
              icon: const Icon(Icons.add),
              label: const Text('Add Tier'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_tiers.isEmpty)
          const Text(
            'No tiers configured. Add at least one tier.',
            style: TextStyle(color: Colors.grey),
          )
        else
          ..._tiers.asMap().entries.map((entry) {
            final index = entry.key;
            final tier = entry.value;
            return _buildTierItem(index, tier);
          }),
      ],
    );
  }
  
  Widget _buildTierItem(int index, ChargeTier tier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: tier.tierName,
                decoration: const InputDecoration(
                  labelText: 'Tier Name',
                  isDense: true,
                ),
                onChanged: (value) {
                  setState(() {
                    _tiers[index] = tier.copyWith(tierName: value);
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: tier.minValue.toString(),
                decoration: const InputDecoration(
                  labelText: 'Min Value',
                  prefixText: '₹',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() {
                      _tiers[index] = tier.copyWith(minValue: parsed);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: tier.maxValue?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Max Value',
                  prefixText: '₹',
                  hintText: 'Leave empty for no limit',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (value) {
                  final parsed = value.isEmpty ? null : double.tryParse(value);
                  setState(() {
                    _tiers[index] = tier.copyWith(maxValue: parsed);
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: tier.chargeValue.toString(),
                decoration: const InputDecoration(
                  labelText: 'Charge',
                  prefixText: '₹',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() {
                      _tiers[index] = tier.copyWith(chargeValue: parsed);
                    });
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () => _removeTier(index),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Remove Tier',
            ),
          ],
        ),
      ),
    );
  }
  
  void _addTier() {
    setState(() {
      // Calculate the min value for the new tier
      double minValue = 0;
      if (_tiers.isNotEmpty) {
        final lastTier = _tiers.last;
        minValue = lastTier.maxValue ?? lastTier.minValue + 500;
      }
      
      _tiers.add(
        ChargeTier(
          id: _uuid.v4(),
          chargeId: '',
          tierName: 'Tier ${_tiers.length + 1}',
          minValue: minValue,
          maxValue: null,
          chargeValue: 0,
          displayOrder: _tiers.length + 1,
          createdAt: DateTime.now(),
        ),
      );
    });
  }
  
  void _removeTier(int index) {
    setState(() {
      _tiers.removeAt(index);
    });
  }
  
  void _saveCharge() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Validate tiers if tiered calculation
    if (_calculationType == CalculationType.tiered && _tiers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one tier for tiered charges'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Create the charge object
    final charge = Charge(
      id: widget.charge?.id ?? _uuid.v4(),
      businessId: widget.charge?.businessId ?? '', // Will be set by provider
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      chargeType: _chargeType,
      calculationType: _calculationType,
      value: _valueController.text.isEmpty 
          ? null 
          : double.tryParse(_valueController.text),
      scope: _scope,
      autoApply: _autoApply,
      isMandatory: _isMandatory,
      isTaxable: _isTaxable,
      applyBeforeDiscount: _applyBeforeDiscount,
      minimumOrderValue: _minOrderController.text.isEmpty 
          ? null 
          : double.tryParse(_minOrderController.text),
      maximumOrderValue: _maxOrderController.text.isEmpty 
          ? null 
          : double.tryParse(_maxOrderController.text),
      displayOrder: int.tryParse(_displayOrderController.text) ?? 0,
      tiers: _calculationType == CalculationType.tiered ? _tiers : [],
      isActive: _isActive,
      createdAt: widget.charge?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    widget.onSave(charge);
  }
  
  String _getChargeTypeName(ChargeType type) {
    switch (type) {
      case ChargeType.service:
        return 'Service';
      case ChargeType.delivery:
        return 'Delivery';
      case ChargeType.packaging:
        return 'Packaging';
      case ChargeType.convenience:
        return 'Convenience';
      case ChargeType.custom:
        return 'Custom';
    }
  }
  
  String _getCalculationTypeName(CalculationType type) {
    switch (type) {
      case CalculationType.fixed:
        return 'Fixed Amount';
      case CalculationType.percentage:
        return 'Percentage';
      case CalculationType.tiered:
        return 'Tiered';
      case CalculationType.formula:
        return 'Formula Based';
    }
  }
}