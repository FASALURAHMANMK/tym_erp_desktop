import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  final Customer? customer;
  
  const CustomerFormDialog({
    super.key,
    this.customer,
  });

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> with SingleTickerProviderStateMixin {
  static final _logger = Logger('CustomerFormDialog');
  static const _uuid = Uuid();
  
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _customerCodeController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _alternatePhoneController;
  late final TextEditingController _whatsappNumberController;
  late final TextEditingController _websiteController;
  
  // Address controllers
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  
  // Shipping address controllers
  late final TextEditingController _shippingAddressLine1Controller;
  late final TextEditingController _shippingAddressLine2Controller;
  late final TextEditingController _shippingCityController;
  late final TextEditingController _shippingStateController;
  late final TextEditingController _shippingPostalCodeController;
  late final TextEditingController _shippingCountryController;
  
  // Tax & Credit controllers
  late final TextEditingController _taxIdController;
  late final TextEditingController _creditLimitController;
  late final TextEditingController _paymentTermsController;
  late final TextEditingController _discountPercentController;
  late final TextEditingController _notesController;
  
  // State variables
  String _customerType = 'individual';
  bool _useBillingForShipping = true;
  bool _taxExempt = false;
  bool _marketingConsent = false;
  bool _smsConsent = false;
  bool _emailConsent = false;
  bool _isVip = false;
  String _creditStatus = 'active';
  String _preferredContactMethod = 'phone';
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize controllers with existing customer data or defaults
    final customer = widget.customer;
    
    _nameController = TextEditingController(text: customer?.name ?? '');
    _companyNameController = TextEditingController(text: customer?.companyName ?? '');
    _customerCodeController = TextEditingController(text: customer?.customerCode ?? _generateCustomerCode());
    _emailController = TextEditingController(text: customer?.email ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _alternatePhoneController = TextEditingController(text: customer?.alternatePhone ?? '');
    _whatsappNumberController = TextEditingController(text: customer?.whatsappNumber ?? '');
    _websiteController = TextEditingController(text: customer?.website ?? '');
    
    _addressLine1Controller = TextEditingController(text: customer?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: customer?.addressLine2 ?? '');
    _cityController = TextEditingController(text: customer?.city ?? '');
    _stateController = TextEditingController(text: customer?.state ?? '');
    _postalCodeController = TextEditingController(text: customer?.postalCode ?? '');
    _countryController = TextEditingController(text: customer?.country ?? 'India');
    
    _shippingAddressLine1Controller = TextEditingController(text: customer?.shippingAddressLine1 ?? '');
    _shippingAddressLine2Controller = TextEditingController(text: customer?.shippingAddressLine2 ?? '');
    _shippingCityController = TextEditingController(text: customer?.shippingCity ?? '');
    _shippingStateController = TextEditingController(text: customer?.shippingState ?? '');
    _shippingPostalCodeController = TextEditingController(text: customer?.shippingPostalCode ?? '');
    _shippingCountryController = TextEditingController(text: customer?.shippingCountry ?? 'India');
    
    _taxIdController = TextEditingController(text: customer?.taxId ?? '');
    _creditLimitController = TextEditingController(text: customer?.creditLimit.toString() ?? '0');
    _paymentTermsController = TextEditingController(text: customer?.paymentTerms.toString() ?? '0');
    _discountPercentController = TextEditingController(text: customer?.discountPercent.toString() ?? '0');
    _notesController = TextEditingController(text: customer?.notes ?? '');
    
    if (customer != null) {
      _customerType = customer.customerType;
      _useBillingForShipping = customer.useBillingForShipping;
      _taxExempt = customer.taxExempt;
      _marketingConsent = customer.marketingConsent;
      _smsConsent = customer.smsConsent;
      _emailConsent = customer.emailConsent;
      _isVip = customer.isVip;
      _creditStatus = customer.creditStatus;
      _preferredContactMethod = customer.preferredContactMethod ?? 'phone';
    }
    
    // Auto-fill WhatsApp number from phone if empty
    _phoneController.addListener(() {
      if (_whatsappNumberController.text.isEmpty) {
        _whatsappNumberController.text = _phoneController.text;
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    
    _nameController.dispose();
    _companyNameController.dispose();
    _customerCodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _whatsappNumberController.dispose();
    _websiteController.dispose();
    
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    
    _shippingAddressLine1Controller.dispose();
    _shippingAddressLine2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostalCodeController.dispose();
    _shippingCountryController.dispose();
    
    _taxIdController.dispose();
    _creditLimitController.dispose();
    _paymentTermsController.dispose();
    _discountPercentController.dispose();
    _notesController.dispose();
    
    super.dispose();
  }
  
  String _generateCustomerCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'CUST-${timestamp.substring(timestamp.length - 8)}';
  }
  
  void _copyBillingToShipping() {
    setState(() {
      _shippingAddressLine1Controller.text = _addressLine1Controller.text;
      _shippingAddressLine2Controller.text = _addressLine2Controller.text;
      _shippingCityController.text = _cityController.text;
      _shippingStateController.text = _stateController.text;
      _shippingPostalCodeController.text = _postalCodeController.text;
      _shippingCountryController.text = _countryController.text;
    });
  }
  
  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    final selectedBusiness = ref.read(selectedBusinessProvider);
    if (selectedBusiness == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a business first'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    try {
      final now = DateTime.now();
      final customer = Customer(
        id: widget.customer?.id ?? _uuid.v4(),
        businessId: selectedBusiness.id,
        customerCode: _customerCodeController.text,
        name: _nameController.text,
        companyName: _companyNameController.text.isNotEmpty ? _companyNameController.text : null,
        customerType: _customerType,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        alternatePhone: _alternatePhoneController.text.isNotEmpty ? _alternatePhoneController.text : null,
        whatsappNumber: _whatsappNumberController.text.isNotEmpty ? _whatsappNumberController.text : null,
        website: _websiteController.text.isNotEmpty ? _websiteController.text : null,
        addressLine1: _addressLine1Controller.text.isNotEmpty ? _addressLine1Controller.text : null,
        addressLine2: _addressLine2Controller.text.isNotEmpty ? _addressLine2Controller.text : null,
        city: _cityController.text.isNotEmpty ? _cityController.text : null,
        state: _stateController.text.isNotEmpty ? _stateController.text : null,
        postalCode: _postalCodeController.text.isNotEmpty ? _postalCodeController.text : null,
        country: _countryController.text.isNotEmpty ? _countryController.text : null,
        shippingAddressLine1: _useBillingForShipping ? null : (_shippingAddressLine1Controller.text.isNotEmpty ? _shippingAddressLine1Controller.text : null),
        shippingAddressLine2: _useBillingForShipping ? null : (_shippingAddressLine2Controller.text.isNotEmpty ? _shippingAddressLine2Controller.text : null),
        shippingCity: _useBillingForShipping ? null : (_shippingCityController.text.isNotEmpty ? _shippingCityController.text : null),
        shippingState: _useBillingForShipping ? null : (_shippingStateController.text.isNotEmpty ? _shippingStateController.text : null),
        shippingPostalCode: _useBillingForShipping ? null : (_shippingPostalCodeController.text.isNotEmpty ? _shippingPostalCodeController.text : null),
        shippingCountry: _useBillingForShipping ? null : (_shippingCountryController.text.isNotEmpty ? _shippingCountryController.text : null),
        useBillingForShipping: _useBillingForShipping,
        taxId: _taxIdController.text.isNotEmpty ? _taxIdController.text : null,
        taxExempt: _taxExempt,
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0,
        currentCredit: widget.customer?.currentCredit ?? 0,
        paymentTerms: int.tryParse(_paymentTermsController.text) ?? 0,
        creditStatus: _creditStatus,
        discountPercent: double.tryParse(_discountPercentController.text) ?? 0,
        preferredContactMethod: _preferredContactMethod,
        marketingConsent: _marketingConsent,
        smsConsent: _smsConsent,
        emailConsent: _emailConsent,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        isVip: _isVip,
        createdAt: widget.customer?.createdAt ?? now,
        updatedAt: now,
      );
      
      if (widget.customer == null) {
        await ref.read(customerNotifierProvider.notifier).addCustomer(customer);
      } else {
        await ref.read(customerNotifierProvider.notifier).updateCustomer(customer);
      }
      
      if (mounted) {
        Navigator.of(context).pop(customer);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.customer == null
                  ? 'Customer added successfully'
                  : 'Customer updated successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to save customer', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save customer: $e'),
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
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.customer == null ? 'Add Customer' : 'Edit Customer',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tab bar
            Theme(
              data: theme.copyWith(
                tabBarTheme: TabBarThemeData(
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Basic Info'),
                  Tab(text: 'Address'),
                  Tab(text: 'Credit & Tax'),
                  Tab(text: 'Preferences'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tab content
            Expanded(
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Basic Info tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer type
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'individual',
                                label: Text('Individual'),
                                icon: Icon(Icons.person),
                              ),
                              ButtonSegment(
                                value: 'company',
                                label: Text('Company'),
                                icon: Icon(Icons.business),
                              ),
                            ],
                            selected: {_customerType},
                            onSelectionChanged: (value) {
                              setState(() {
                                _customerType = value.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name *',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _customerCodeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Customer Code *',
                                    prefixIcon: Icon(Icons.qr_code),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Customer code is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          if (_customerType == 'company') ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _companyNameController,
                              decoration: const InputDecoration(
                                labelText: 'Company Name',
                                prefixIcon: Icon(Icons.business),
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _alternatePhoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Alternate Phone',
                                    prefixIcon: Icon(Icons.phone_android),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _whatsappNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'WhatsApp Number',
                                    prefixIcon: Icon(Icons.chat),
                                    helperText: 'For marketing & orders',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Invalid email format';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _websiteController,
                            decoration: const InputDecoration(
                              labelText: 'Website',
                              prefixIcon: Icon(Icons.language),
                            ),
                            keyboardType: TextInputType.url,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // VIP status
                          SwitchListTile(
                            title: const Text('VIP Customer'),
                            subtitle: const Text('Mark as VIP for special treatment'),
                            value: _isVip,
                            onChanged: (value) {
                              setState(() {
                                _isVip = value;
                              });
                            },
                            secondary: Icon(
                              Icons.star,
                              color: _isVip ? Colors.amber : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Address tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billing Address',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _addressLine1Controller,
                            decoration: const InputDecoration(
                              labelText: 'Address Line 1',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _addressLine2Controller,
                            decoration: const InputDecoration(
                              labelText: 'Address Line 2',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    prefixIcon: Icon(Icons.location_city),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _stateController,
                                  decoration: const InputDecoration(
                                    labelText: 'State',
                                    prefixIcon: Icon(Icons.map),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _postalCodeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Postal Code',
                                    prefixIcon: Icon(Icons.pin_drop),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _countryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Country',
                                    prefixIcon: Icon(Icons.public),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Row(
                            children: [
                              Text(
                                'Shipping Address',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: _copyBillingToShipping,
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy from billing'),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SwitchListTile(
                            title: const Text('Same as billing address'),
                            value: _useBillingForShipping,
                            onChanged: (value) {
                              setState(() {
                                _useBillingForShipping = value;
                                if (value) {
                                  _copyBillingToShipping();
                                }
                              });
                            },
                          ),
                          
                          if (!_useBillingForShipping) ...[
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _shippingAddressLine1Controller,
                              decoration: const InputDecoration(
                                labelText: 'Address Line 1',
                                prefixIcon: Icon(Icons.location_on),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _shippingAddressLine2Controller,
                              decoration: const InputDecoration(
                                labelText: 'Address Line 2',
                                prefixIcon: Icon(Icons.location_on),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _shippingCityController,
                                    decoration: const InputDecoration(
                                      labelText: 'City',
                                      prefixIcon: Icon(Icons.location_city),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _shippingStateController,
                                    decoration: const InputDecoration(
                                      labelText: 'State',
                                      prefixIcon: Icon(Icons.map),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _shippingPostalCodeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Postal Code',
                                      prefixIcon: Icon(Icons.pin_drop),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _shippingCountryController,
                                    decoration: const InputDecoration(
                                      labelText: 'Country',
                                      prefixIcon: Icon(Icons.public),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Credit & Tax tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit Management',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _creditLimitController,
                                  decoration: const InputDecoration(
                                    labelText: 'Credit Limit',
                                    prefixIcon: Icon(Icons.account_balance_wallet),
                                    prefixText: '₹',
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _paymentTermsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Payment Terms (days)',
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'active',
                                label: Text('Active'),
                                icon: Icon(Icons.check_circle),
                              ),
                              ButtonSegment(
                                value: 'hold',
                                label: Text('Hold'),
                                icon: Icon(Icons.pause_circle),
                              ),
                              ButtonSegment(
                                value: 'blocked',
                                label: Text('Blocked'),
                                icon: Icon(Icons.block),
                              ),
                            ],
                            selected: {_creditStatus},
                            onSelectionChanged: (value) {
                              setState(() {
                                _creditStatus = value.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Tax Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _taxIdController,
                            decoration: const InputDecoration(
                              labelText: 'Tax ID / GST Number',
                              prefixIcon: Icon(Icons.receipt),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          SwitchListTile(
                            title: const Text('Tax Exempt'),
                            subtitle: const Text('Customer is exempt from taxes'),
                            value: _taxExempt,
                            onChanged: (value) {
                              setState(() {
                                _taxExempt = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Pricing',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _discountPercentController,
                            decoration: const InputDecoration(
                              labelText: 'Default Discount %',
                              prefixIcon: Icon(Icons.discount),
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Preferences tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Communication Preferences',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          const Text('Preferred Contact Method'),
                          const SizedBox(height: 8),
                          
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'phone',
                                label: Text('Phone'),
                                icon: Icon(Icons.phone),
                              ),
                              ButtonSegment(
                                value: 'email',
                                label: Text('Email'),
                                icon: Icon(Icons.email),
                              ),
                              ButtonSegment(
                                value: 'sms',
                                label: Text('SMS'),
                                icon: Icon(Icons.sms),
                              ),
                              ButtonSegment(
                                value: 'whatsapp',
                                label: Text('WhatsApp'),
                                icon: Icon(Icons.chat),
                              ),
                            ],
                            selected: {_preferredContactMethod},
                            onSelectionChanged: (value) {
                              setState(() {
                                _preferredContactMethod = value.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Marketing Consent',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SwitchListTile(
                            title: const Text('General Marketing'),
                            subtitle: const Text('Allow marketing communications'),
                            value: _marketingConsent,
                            onChanged: (value) {
                              setState(() {
                                _marketingConsent = value;
                              });
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('SMS Marketing'),
                            subtitle: const Text('Receive promotional SMS'),
                            value: _smsConsent,
                            onChanged: (value) {
                              setState(() {
                                _smsConsent = value;
                              });
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Email Marketing'),
                            subtitle: const Text('Receive promotional emails'),
                            value: _emailConsent,
                            onChanged: (value) {
                              setState(() {
                                _emailConsent = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Internal Notes',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              hintText: 'Internal notes about this customer...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer actions
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveCustomer,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(widget.customer == null ? 'Add Customer' : 'Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
