import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/kot_providers.dart';
import '../../domain/models/kot_printer.dart';
import '../dialogs/station_form_dialog.dart';
import '../dialogs/printer_form_dialog.dart';
import '../dialogs/mapping_form_dialog.dart';
import '../dialogs/routing_form_dialog.dart';
import '../dialogs/template_form_dialog.dart';

class KotConfigurationScreen extends ConsumerStatefulWidget {
  const KotConfigurationScreen({super.key});

  @override
  ConsumerState<KotConfigurationScreen> createState() => _KotConfigurationScreenState();
}

class _KotConfigurationScreenState extends ConsumerState<KotConfigurationScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Sync KOT data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kotSyncNotifierProvider.notifier).syncAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KOT Configuration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/manage'),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.print_outlined),
            label: const Text('Test KOT'),
            onPressed: () => context.push('/kot-test'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Stations', icon: Icon(Icons.restaurant_menu)),
            Tab(text: 'Printers', icon: Icon(Icons.print)),
            Tab(text: 'Station Mapping', icon: Icon(Icons.link)),
            Tab(text: 'Item Routing', icon: Icon(Icons.route)),
            Tab(text: 'Templates', icon: Icon(Icons.description)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StationsTab(),
          _PrintersTab(),
          _StationMappingTab(),
          _ItemRoutingTab(),
          _TemplatesTab(),
        ],
      ),
    );
  }
}

// Stations Tab
class _StationsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(kotStationsProvider);

    return Scaffold(
      body: stationsAsync.when(
        data: (stations) {
          if (stations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No stations configured',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add your first KOT station to get started'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final station = stations[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: station.color != null
                        ? Color(int.parse(station.color!.replaceAll('#', '0xFF')))
                        : Theme.of(context).colorScheme.primary,
                    child: Text(
                      station.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(station.name),
                  subtitle: Text('${station.type} - ${station.isActive ? "Active" : "Inactive"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showStationDialog(context, ref, station),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteStation(context, ref, station.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading stations: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStationDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStationDialog(BuildContext context, WidgetRef ref, dynamic station) {
    StationFormDialog.show(context, station: station);
  }

  void _deleteStation(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Station'),
        content: const Text('Are you sure you want to delete this station?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(kotStationNotifierProvider.notifier).deleteStation(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Station deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting station: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Printers Tab
class _PrintersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printersAsync = ref.watch(kotPrintersProvider);

    return Scaffold(
      body: printersAsync.when(
        data: (printers) {
          if (printers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.print,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No printers configured',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add your first KOT printer to get started'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: printers.length,
            itemBuilder: (context, index) {
              final printer = printers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: printer.isDefault
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                    child: Icon(
                      _getPrinterIcon(printer.printerType),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(printer.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${printer.printerType}'),
                      if (printer.ipAddress != null)
                        Text('IP: ${printer.ipAddress}:${printer.port}'),
                      if (printer.macAddress != null)
                        Text('MAC: ${printer.macAddress}'),
                      Text('Paper: ${printer.paperSize} | Copies: ${printer.printCopies}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (printer.isDefault)
                        const Chip(
                          label: Text('Default'),
                          backgroundColor: Colors.green,
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showPrinterDialog(context, ref, printer),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePrinter(context, ref, printer.id),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading printers: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPrinterDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
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

  void _showPrinterDialog(BuildContext context, WidgetRef ref, dynamic printer) {
    PrinterFormDialog.show(context, printer: printer);
  }

  void _deletePrinter(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Printer'),
        content: const Text('Are you sure you want to delete this printer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(kotPrinterNotifierProvider.notifier).deletePrinter(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Printer deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting printer: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Station Mapping Tab
class _StationMappingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(kotStationsProvider);
    final printersAsync = ref.watch(kotPrintersProvider);
    final mappingsAsync = ref.watch(kotPrinterStationsProvider);

    return Scaffold(
      body: stationsAsync.when(
        data: (stations) => printersAsync.when(
          data: (printers) => mappingsAsync.when(
            data: (mappings) {
              if (stations.isEmpty || printers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.link_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Configure stations and printers first',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('You need at least one station and one printer'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final station = stations[index];
                  final stationMappings = mappings
                      .where((m) => m.stationId == station.id)
                      .toList()
                    ..sort((a, b) => a.priority.compareTo(b.priority));

                  return Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: station.color != null
                            ? Color(int.parse(station.color!.replaceAll('#', '0xFF')))
                            : Theme.of(context).colorScheme.primary,
                        child: Text(
                          station.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(station.name),
                      subtitle: Text('${stationMappings.length} printer(s) mapped'),
                      children: [
                        ...stationMappings.map((mapping) {
                          final printer = printers.firstWhere(
                            (p) => p.id == mapping.printerId,
                            orElse: () => printers.first,
                          );
                          return ListTile(
                            leading: const Icon(Icons.print),
                            title: Text(printer.name),
                            subtitle: Text('Priority: ${mapping.priority}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteMapping(context, ref, mapping.id),
                            ),
                          );
                        }),
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Add Printer'),
                          onTap: () => _showMappingDialog(context, ref, station, printers),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showMappingDialog(BuildContext context, WidgetRef ref, dynamic station, List<dynamic> printers) {
    MappingFormDialog.show(
      context,
      station: station,
      availablePrinters: printers.cast<KotPrinter>(),
    );
  }

  void _deleteMapping(BuildContext context, WidgetRef ref, String id) {
    ref.read(kotPrinterStationNotifierProvider.notifier).deletePrinterStation(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mapping removed')),
    );
  }
}

// Item Routing Tab
class _ItemRoutingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routingsAsync = ref.watch(kotItemRoutingsProvider);
    final stationsAsync = ref.watch(kotStationsProvider);

    return Scaffold(
      body: routingsAsync.when(
        data: (routings) => stationsAsync.when(
          data: (stations) {
            if (stations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.route,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Configure stations first',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('You need at least one station to set up routing'),
                  ],
                ),
              );
            }

            if (routings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.route,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No routing rules configured',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Add routing rules to direct items to stations'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routings.length,
              itemBuilder: (context, index) {
                final routing = routings[index];
                final station = stations.firstWhere(
                  (s) => s.id == routing.stationId,
                  orElse: () => stations.first,
                );

                String routingType = 'Unknown';
                String routingTarget = '';
                
                if (routing.categoryId != null) {
                  routingType = 'Category';
                  routingTarget = 'Category routing';
                } else if (routing.productId != null) {
                  routingType = 'Product';
                  routingTarget = 'Product routing';
                } else if (routing.variationId != null) {
                  routingType = 'Variation';
                  routingTarget = 'Variation routing';
                }

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(routing.priority.toString()),
                    ),
                    title: Text('$routingType → ${station.name}'),
                    subtitle: Text(routingTarget),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showRoutingDialog(context, ref, routing),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRouting(context, ref, routing.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoutingDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showRoutingDialog(BuildContext context, WidgetRef ref, dynamic routing) {
    RoutingFormDialog.show(context, routing: routing);
  }

  void _deleteRouting(BuildContext context, WidgetRef ref, String id) {
    ref.read(kotItemRoutingNotifierProvider.notifier).deleteItemRouting(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Routing rule deleted')),
    );
  }
}

// Templates Tab
class _TemplatesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(kotTemplatesProvider);

    return Scaffold(
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No templates configured',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Create templates for KOT printing'),
                ],
              ),
            );
          }

          // Group templates by type
          final Map<String, List<dynamic>> groupedTemplates = {};
          for (final template in templates) {
            groupedTemplates.putIfAbsent(template.type, () => []).add(template);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: groupedTemplates.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _getTemplateTypeLabel(entry.key),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ...entry.value.map((template) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: template.isDefault
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.description, color: Colors.white),
                      ),
                      title: Text(template.name),
                      subtitle: Text(template.description ?? 'No description'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (template.isDefault)
                            const Chip(
                              label: Text('Default'),
                              backgroundColor: Colors.green,
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showTemplateDialog(context, ref, template),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTemplate(context, ref, template.id),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading templates: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTemplateDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getTemplateTypeLabel(String type) {
    switch (type) {
      case 'header':
        return 'Header Templates';
      case 'footer':
        return 'Footer Templates';
      case 'item_format':
        return 'Item Format Templates';
      case 'full':
        return 'Full Templates';
      default:
        return type;
    }
  }

  void _showTemplateDialog(BuildContext context, WidgetRef ref, dynamic template) {
    TemplateFormDialog.show(context, template: template);
  }

  void _deleteTemplate(BuildContext context, WidgetRef ref, String id) {
    ref.read(kotTemplateNotifierProvider.notifier).deleteTemplate(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Template deleted')),
    );
  }
}