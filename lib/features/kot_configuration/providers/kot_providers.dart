import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/business/providers/business_provider.dart';
import '../../../features/location/providers/location_provider.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../data/local/kot_local_database.dart';
import '../data/repositories/offline_first_kot_repository.dart';
import '../domain/models/kot_item_routing.dart';
import '../domain/models/kot_printer.dart';
import '../domain/models/kot_printer_station.dart';
import '../domain/models/kot_station.dart';
import '../domain/models/kot_template.dart';

part 'kot_providers.g.dart';

// Local database provider
@riverpod
Future<KotLocalDatabase> kotLocalDatabase(Ref ref) async {
  final localDatabaseService = LocalDatabaseService();
  final database = await localDatabaseService.database;
  final syncQueueService = SyncQueueService();
  return KotLocalDatabase(database, syncQueueService);
}

// Repository provider
@riverpod
Future<OfflineFirstKotRepository> kotRepository(Ref ref) async {
  final supabase = Supabase.instance.client;
  final localDatabase = await ref.watch(kotLocalDatabaseProvider.future);
  return OfflineFirstKotRepository(supabase, localDatabase);
}

// KOT Stations providers
@riverpod
Future<List<KotStation>> kotStations(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);

  if (business == null) return [];

  return locationAsync.when(
    data: (location) async {
      if (location == null) return [];

      final repository = await ref.watch(kotRepositoryProvider.future);
      final result = await repository.getStations(business.id, location.id);

      return result.fold((error) => [], (stations) => stations);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
}

@riverpod
class KotStationNotifier extends _$KotStationNotifier {
  @override
  Future<void> build() async {}

  Future<String> saveStation(KotStation station) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.saveStation(station);

    return result.fold((error) => throw error, (id) {
      ref.invalidate(kotStationsProvider);
      return id;
    });
  }

  Future<void> deleteStation(String id) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.deleteStation(id);

    result.fold(
      (error) => throw error,
      (_) => ref.invalidate(kotStationsProvider),
    );
  }
}

// KOT Printers providers
@riverpod
Future<List<KotPrinter>> kotPrinters(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);

  if (business == null) return [];

  return locationAsync.when(
    data: (location) async {
      if (location == null) return [];

      final repository = await ref.watch(kotRepositoryProvider.future);
      final result = await repository.getPrinters(business.id, location.id);

      return result.fold((error) => [], (printers) => printers);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
}

@riverpod
class KotPrinterNotifier extends _$KotPrinterNotifier {
  @override
  Future<void> build() async {}

  Future<String> savePrinter(KotPrinter printer) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.savePrinter(printer);

    return result.fold((error) => throw error, (id) {
      ref.invalidate(kotPrintersProvider);
      return id;
    });
  }

  Future<void> deletePrinter(String id) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.deletePrinter(id);

    result.fold(
      (error) => throw error,
      (_) => ref.invalidate(kotPrintersProvider),
    );
  }
}

// KOT Printer Stations providers
@riverpod
Future<List<KotPrinterStation>> kotPrinterStations(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);

  if (business == null) return [];

  return locationAsync.when(
    data: (location) async {
      if (location == null) return [];

      final repository = await ref.watch(kotRepositoryProvider.future);
      final result = await repository.getPrinterStations(
        business.id,
        location.id,
      );

      return result.fold((error) => [], (printerStations) => printerStations);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
}

@riverpod
class KotPrinterStationNotifier extends _$KotPrinterStationNotifier {
  @override
  Future<void> build() async {}

  Future<String> savePrinterStation(KotPrinterStation printerStation) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.savePrinterStation(printerStation);

    return result.fold((error) => throw error, (id) {
      ref.invalidate(kotPrinterStationsProvider);
      return id;
    });
  }

  Future<void> deletePrinterStation(String id) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.deletePrinterStation(id);

    result.fold(
      (error) => throw error,
      (_) => ref.invalidate(kotPrinterStationsProvider),
    );
  }
}

// KOT Item Routing providers
@riverpod
Future<List<KotItemRouting>> kotItemRoutings(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);

  if (business == null) return [];

  return locationAsync.when(
    data: (location) async {
      if (location == null) return [];

      final repository = await ref.watch(kotRepositoryProvider.future);
      final result = await repository.getItemRoutings(business.id, location.id);

      return result.fold((error) => [], (routings) => routings);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
}

@riverpod
class KotItemRoutingNotifier extends _$KotItemRoutingNotifier {
  @override
  Future<void> build() async {}

  Future<String> saveItemRouting(KotItemRouting routing) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.saveItemRouting(routing);

    return result.fold((error) => throw error, (id) {
      ref.invalidate(kotItemRoutingsProvider);
      return id;
    });
  }

  Future<void> deleteItemRouting(String id) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.deleteItemRouting(id);

    result.fold(
      (error) => throw error,
      (_) => ref.invalidate(kotItemRoutingsProvider),
    );
  }
}

// KOT Templates providers
@riverpod
Future<List<KotTemplate>> kotTemplates(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);

  if (business == null) return [];

  return locationAsync.when(
    data: (location) async {
      if (location == null) return [];

      final repository = await ref.watch(kotRepositoryProvider.future);
      final result = await repository.getTemplates(business.id, location.id);

      return result.fold((error) => [], (templates) => templates);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
}

@riverpod
class KotTemplateNotifier extends _$KotTemplateNotifier {
  @override
  Future<void> build() async {}

  Future<String> saveTemplate(KotTemplate template) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.saveTemplate(template);

    return result.fold((error) => throw error, (id) {
      ref.invalidate(kotTemplatesProvider);
      return id;
    });
  }

  Future<void> deleteTemplate(String id) async {
    final repository = await ref.read(kotRepositoryProvider.future);
    final result = await repository.deleteTemplate(id);

    result.fold(
      (error) => throw error,
      (_) => ref.invalidate(kotTemplatesProvider),
    );
  }
}

// Sync provider for initial data fetch
@riverpod
class KotSyncNotifier extends _$KotSyncNotifier {
  @override
  Future<void> build() async {}

  Future<void> syncAllData() async {
    final business = ref.read(selectedBusinessProvider);
    final locationAsync = ref.read(selectedLocationNotifierProvider);

    if (business == null) return;

    await locationAsync.when(
      data: (location) async {
        if (location == null) return;

        final repository = await ref.read(kotRepositoryProvider.future);

        await Future.wait([
          repository.syncStationsFromSupabase(business.id, location.id),
          repository.syncPrintersFromSupabase(business.id, location.id),
          repository.syncPrinterStationsFromSupabase(business.id, location.id),
          repository.syncItemRoutingsFromSupabase(business.id, location.id),
          repository.syncTemplatesFromSupabase(business.id, location.id),
        ]);

        // Invalidate all providers to refresh data
        ref.invalidate(kotStationsProvider);
        ref.invalidate(kotPrintersProvider);
        ref.invalidate(kotPrinterStationsProvider);
        ref.invalidate(kotItemRoutingsProvider);
        ref.invalidate(kotTemplatesProvider);
      },
      loading: () => Future.value(),
      error: (_, __) => Future.value(),
    );
  }
}
