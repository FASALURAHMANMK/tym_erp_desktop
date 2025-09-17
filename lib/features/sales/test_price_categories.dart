import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/logger.dart';
import '../../services/local_database_service.dart';
import '../../services/sync_queue_service.dart';
import 'repositories/price_category_repository.dart';

/// Test function to create default price categories manually
Future<void> testCreateDefaultPriceCategories(String businessId, String locationId) async {
  final logger = Logger('TestPriceCategories');
  
  try {
    logger.info('🧪 Testing price category creation...');
    
    final repository = PriceCategoryRepository(
      localDb: LocalDatabaseService(),
      supabase: Supabase.instance.client,
      syncQueueService: SyncQueueService(),
    );
    
    final result = await repository.createDefaultCategories(
      businessId: businessId,
      locationId: locationId,
    );
    
    result.fold(
      (error) => logger.error('❌ Error creating categories', error),
      (categories) {
        logger.info('✅ Successfully created ${categories.length} default categories:');
        for (final category in categories) {
          logger.info('  - ${category.name} (${category.type})');
        }
      },
    );
  } catch (e, stack) {
    logger.error('❌ Exception in test', e, stack);
  }
}

/// Widget to test price categories in the app
class TestPriceCategoriesButton extends ConsumerWidget {
  final String businessId;
  final String locationId;
  
  const TestPriceCategoriesButton({
    super.key,
    required this.businessId,
    required this.locationId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await testCreateDefaultPriceCategories(businessId, locationId);
      },
      child: const Text('Test Create Price Categories'),
    );
  }
}