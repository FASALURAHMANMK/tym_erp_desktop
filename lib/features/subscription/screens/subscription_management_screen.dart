import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/subscription_provider.dart';
import '../models/business_subscription.dart';
import '../models/subscription_plan.dart';
import '../../business/providers/business_provider.dart';
import '../../auth/providers/auth_provider.dart';

class SubscriptionManagementScreen extends ConsumerStatefulWidget {
  final String businessId;

  const SubscriptionManagementScreen({
    super.key,
    required this.businessId,
  });

  @override
  ConsumerState<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends ConsumerState<SubscriptionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(businessSubscriptionNotifierProvider(widget.businessId));
    final plansAsync = ref.watch(subscriptionNotifierProvider);
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    final screenPadding = ResponsiveDimensions.getScreenPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Management'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () => _showLogoutConfirmation(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Info Header
            if (selectedBusiness != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.business,
                        color: Theme.of(context).colorScheme.primary,
                        size: ResponsiveDimensions.getIconSize(context),
                      ),
                      ResponsiveSpacing.getHorizontalSpacing(context, 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedBusiness.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedBusiness.businessType.displayName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),
            ],

            // Current Subscription Status
            subscriptionAsync.when(
              data: (subscription) => _buildCurrentSubscription(context, subscription),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => _buildErrorCard(context, 'Subscription Error', error.toString()),
            ),

            ResponsiveSpacing.getVerticalSpacing(context, 24),

            // Available Plans
            Text(
              'Available Plans',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 16),

            Expanded(
              child: plansAsync.when(
                data: (plans) => _buildPlansList(context, plans, selectedBusiness),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _buildErrorCard(context, 'Plans Error', error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSubscription(BuildContext context, BusinessSubscription? subscription) {
    if (subscription == null) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),
              Text(
                'No Active Subscription',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 8),
              Text(
                'Start your free trial to explore TYM ERP features',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),
              ElevatedButton(
                onPressed: () => _startTrial(),
                child: const Text('Start Free Trial'),
              ),
            ],
          ),
        ),
      );
    }

    final statusColor = subscription.canAccessERP ? Colors.green : Colors.red;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  subscription.canAccessERP ? Icons.check_circle : Icons.error,
                  color: statusColor,
                  size: ResponsiveDimensions.getIconSize(context),
                ),
                ResponsiveSpacing.getHorizontalSpacing(context, 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Subscription',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subscription.statusMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Subscription Details
            _buildDetailRow(context, 'Status', subscription.status.displayName),
            if (subscription.daysRemaining > 0)
              _buildDetailRow(context, 'Days Remaining', '${subscription.daysRemaining} days'),
            if (subscription.currency.isNotEmpty && subscription.amountPaid != null)
              _buildDetailRow(context, 'Last Payment', 
                '${_getCurrencySymbol(subscription.currency)}${subscription.amountPaid!.toStringAsFixed(2)}'),
            
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Action Button
            if (!subscription.canAccessERP)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentInstructions(context),
                  icon: const Icon(Icons.payment),
                  label: const Text('Renew Subscription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, List<SubscriptionPlan> plans, selectedBusiness) {
    final currency = selectedBusiness != null 
        ? ref.read(subscriptionServiceProvider).getCurrencyForBusiness(selectedBusiness)
        : 'INR';

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final price = plan.getPriceForCurrency(currency);
        final currencySymbol = plan.getCurrencySymbol(currency);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${plan.planType.displayName} Plan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 4),
                      Text(
                        '$currencySymbol${price.toStringAsFixed(0)} per ${plan.planType.displayName.toLowerCase()}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 8),
                      if (plan.planType == SubscriptionPlanType.yearly)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Save ${((plan.priceInr * 12 - plan.priceInr) / (plan.priceInr * 12) * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showPaymentInstructions(context, plan: plan),
                  child: const Text('Choose Plan'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(BuildContext context, String title, String error) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
        child: Column(
          children: [
            Icon(Icons.error, size: 48, color: Colors.red),
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _startTrial() async {
    try {
      await ref.read(businessSubscriptionNotifierProvider(widget.businessId).notifier)
          .createTrialSubscription(widget.businessId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trial subscription started successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start trial: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPaymentInstructions(BuildContext context, {SubscriptionPlan? plan}) {
    final selectedBusiness = ref.read(selectedBusinessProvider);
    final currency = selectedBusiness != null 
        ? ref.read(subscriptionServiceProvider).getCurrencyForBusiness(selectedBusiness)
        : 'INR';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Instructions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan != null) ...[
                Text(
                  '${plan.planType.displayName} Plan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount: ${plan.getCurrencySymbol(currency)}${plan.getPriceForCurrency(currency).toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              const Text(
                'Please make payment to the following account:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              
              _buildPaymentDetail('Bank Name', 'TYM ERP Solutions'),
              _buildPaymentDetail('Account Number', '1234567890'),
              _buildPaymentDetail('IFSC Code', 'TYMERP001'),
              _buildPaymentDetail('UPI ID', 'tym.erp@paytm'),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'After payment, contact our support team with transaction details. Your subscription will be activated within 24 hours.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // You can add contact support functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact support at +91-9876543210 or support@tymerp.com'),
                ),
              );
            },
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'SAR':
        return 'ر.س';
      case 'AED':
        return 'د.إ';
      default:
        return currency;
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from TYM ERP?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await _performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Logging out...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Perform logout
      await ref.read(authNotifierProvider.notifier).signOut();
      
      // Close loading dialog and navigation will be handled by auth state change
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }
      
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}