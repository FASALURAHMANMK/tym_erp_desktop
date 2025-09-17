import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

import '../core/utils/logger.dart';

class DatabaseSchema {
  static final _logger = Logger('DatabaseSchema');

  /// Apply the SQLite schema from the bundled SQL file to the provided [db].
  /// - Loads `database/schema_sqlite.sql` from assets
  /// - Splits it into executable statements (handling triggers)
  /// - Skips transaction wrappers in the file (BEGIN/COMMIT)
  /// - Executes statements idempotently (the SQL uses IF NOT EXISTS)
  static Future<void> applySqliteSchema(Database db) async {
    try {
      final sql = await rootBundle.loadString('database/schema_sqlite.sql');
      final statements = _splitSqlStatements(sql);

      _logger.info('Applying SQLite schema (${statements.length} statements)');

      // Execute sequentially to preserve order and avoid nested transactions.
      for (final stmt in statements) {
        final s = stmt.trim();
        if (s.isEmpty) continue;

        // Skip transaction wrappers from the file; sqflite manages transactions in onCreate.
        final upper = s.toUpperCase();
        if (upper == 'BEGIN TRANSACTION;' || upper == 'BEGIN TRANSACTION') continue;
        if (upper == 'COMMIT;' || upper == 'COMMIT') continue;

        try {
          await db.execute(s);
        } catch (e) {
          // Log and continue; some objects may already exist or differ slightly.
          _logger.warning('Schema statement failed, continuing: ${_truncate(s)}  Error: $e');
        }
      }

      _logger.info('SQLite schema applied');
    } catch (e, st) {
      _logger.error('Failed to apply SQLite schema', e, st);
      rethrow;
    }
  }

  // Split SQL script into executable statements while preserving trigger bodies.
  static List<String> _splitSqlStatements(String sql) {
    final lines = sql.replaceAll('\r\n', '\n').split('\n');
    final result = <String>[];
    final current = StringBuffer();

    var inTrigger = false;

    for (var rawLine in lines) {
      var line = rawLine;

      // Simple skip of full-line comments (none expected, but safe)
      final trimmed = line.trim();
      if (trimmed.startsWith('--')) {
        continue;
      }

      // Detect trigger start
      if (!inTrigger && trimmed.toUpperCase().startsWith('CREATE TRIGGER')) {
        inTrigger = true;
      }

      current.write(line);
      current.write('\n');

      if (inTrigger) {
        // Wait until we see END; which terminates the trigger definition
        if (trimmed.toUpperCase() == 'END;' || trimmed.toUpperCase() == 'END') {
          result.add(current.toString());
          current.clear();
          inTrigger = false;
        }
        continue;
      }

      // For non-trigger statements, split on semicolons that terminate statements.
      // A line may contain multiple semicolons; handle them by splitting the buffer.
      var buffer = current.toString();
      var semicolonIndex = buffer.indexOf(';');
      while (semicolonIndex != -1) {
        final statement = buffer.substring(0, semicolonIndex + 1);
        result.add(statement);
        buffer = buffer.substring(semicolonIndex + 1);
        semicolonIndex = buffer.indexOf(';');
      }

      // Keep any remainder in the current buffer (incomplete statement)
      current
        ..clear()
        ..write(buffer);
    }

    // Flush any trailing content
    final tail = current.toString().trim();
    if (tail.isNotEmpty) {
      result.add(tail);
    }

    return result;
  }

  static String _truncate(String s, {int max = 120}) {
    final t = s.replaceAll('\n', ' ').trim();
    return t.length <= max ? t : t.substring(0, max) + '...';
    }
}

