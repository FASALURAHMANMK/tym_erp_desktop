import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/subscription_provider.dart';

class SubscriptionStatusCard extends ConsumerWidget {
  final String businessId;
  final VoidCallback? onManageSubscription;

  const SubscriptionStatusCard({
    super.key,
    required this.businessId,
    this.onManageSubscription,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(subscriptionSummaryProvider(businessId));

    return Card(
      margin: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.subscriptions,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDimensions.getIconSize(context),
                ),
                ResponsiveSpacing.getHorizontalSpacing(context, 8),
                Text(
                  'Subscription Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onManageSubscription != null)
                  TextButton.icon(
                    onPressed: onManageSubscription,
                    icon: const Icon(Icons.manage_accounts, size: 16),
                    label: const Text('Manage'),
                  ),
              ],
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            summaryAsync.when(
              data: (summary) => _buildSubscriptionSummary(context, summary),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => _buildErrorState(context, error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSummary(BuildContext context, Map<String, dynamic> summary) {
    final canAccess = summary['canAccess'] as bool? ?? false;
    final status = summary['status'] as String? ?? 'Unknown';
    final statusMessage = summary['statusMessage'] as String? ?? '';
    final daysRemaining = summary['daysRemaining'] as int? ?? 0;
    final isExpiringSoon = summary['isExpiringSoon'] as bool? ?? false;
    final isTrialActive = summary['isTrialActive'] as bool? ?? false;

    Color statusColor;
    IconData statusIcon;

    if (isTrialActive) {
      statusColor = Colors.blue;
      statusIcon = Icons.schedule;
    } else if (canAccess) {
      statusColor = isExpiringSoon ? Colors.orange : Colors.green;
      statusIcon = isExpiringSoon ? Icons.warning : Icons.check_circle;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 6),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        ResponsiveSpacing.getVerticalSpacing(context, 12),
        
        // Status Message
        if (statusMessage.isNotEmpty)
          Text(
            statusMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        
        ResponsiveSpacing.getVerticalSpacing(context, 8),
        
        // Days Remaining (if applicable)
        if (daysRemaining > 0) ...[
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '$daysRemaining days remaining',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isExpiringSoon ? Colors.orange : null,
                ),
              ),
            ],
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
        ],
        
        // Action Buttons
        if (!canAccess) ...[
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onManageSubscription,
              icon: const Icon(Icons.payment, size: 18),
              label: const Text('Renew Subscription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ] else if (isExpiringSoon) ...[
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onManageSubscription,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Extend Subscription'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Failed to load subscription status: $error',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}