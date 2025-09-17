import 'package:flutter/material.dart';
import '../data/test_order_fix.dart';
import '../../../core/utils/logger.dart';

class DebugOrderScreen extends StatefulWidget {
  const DebugOrderScreen({super.key});

  @override
  State<DebugOrderScreen> createState() => _DebugOrderScreenState();
}

class _DebugOrderScreenState extends State<DebugOrderScreen> {
  static final _logger = Logger('DebugOrderScreen');
  String _output = 'Ready to test...';
  bool _isRunning = false;

  Future<void> _runTest() async {
    setState(() {
      _isRunning = true;
      _output = 'Running test...\n';
    });

    try {
      await TestOrderFix.runTest();
      setState(() {
        _output += '\n✅ Test completed successfully!';
      });
    } catch (e) {
      setState(() {
        _output += '\n❌ Test failed: $e';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  Future<void> _cleanData() async {
    setState(() {
      _isRunning = true;
      _output = 'Cleaning corrupted data...\n';
    });

    try {
      await TestOrderFix.cleanCorruptedData();
      setState(() {
        _output += '\n✅ Data cleaned successfully!';
      });
    } catch (e) {
      setState(() {
        _output += '\n❌ Cleaning failed: $e';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: Order JSON Fix'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order JSON Fix Testing',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This screen helps test and fix JSON corruption issues in the orders database.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isRunning ? null : _runTest,
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Test JSON Parsing'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isRunning ? null : _cleanData,
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Clean Corrupted Data'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Output:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _output,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isRunning)
              const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}