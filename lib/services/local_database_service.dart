import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/utils/logger.dart';
import '../features/products/data/local/image_cache_database.dart';
import '../features/kot_configuration/data/local/kot_local_database.dart';
import 'database_schema.dart';

class LocalDatabaseService {
  static final _logger = Logger('LocalDatabaseService');
  
  static Database? _database;
  static const String _databaseName = 'tym_erp_local.db';
  static const int _databaseVersion = 14;

  // Singleton pattern
  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  // Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _logger.info('Initializing local database at: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        _logger.info('Database opened successfully, version: ${await db.getVersion()}');
      },
    );
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    _logger.info('Creating local database using bundled schema...');
    await DatabaseSchema.applySqliteSchema(db);
    _logger.info('Local database schema created successfully');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.info('Upgrading database from version $oldVersion to $newVersion');
    
    // Migration from version 1 to 2: Add description column to pos_devices
    if (oldVersion < 2) {
      _logger.info('Adding description column to pos_devices table');
      await db.execute('ALTER TABLE pos_devices ADD COLUMN description TEXT');
    }
    
    // Migration from version 2 to 3: Remove unique constraint from device_code
    if (oldVersion < 3) {
      _logger.info('Removing global unique constraint from device_code');
      
      // SQLite doesn't support dropping constraints directly, so we need to recreate the table
      // First, backup existing data
      await db.execute('''
        CREATE TABLE pos_devices_backup AS 
        SELECT * FROM pos_devices
      ''');
      
      // Drop the old table
      await db.execute('DROP TABLE pos_devices');
      
      // Recreate the table without the unique constraint on device_code
      await db.execute('''
        CREATE TABLE pos_devices (
          id TEXT PRIMARY KEY,
          location_id TEXT NOT NULL,
          device_name TEXT NOT NULL,
          device_code TEXT NOT NULL,
          description TEXT,
          is_default INTEGER DEFAULT 0,
          is_active INTEGER DEFAULT 1,
          last_sync_at INTEGER,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          sync_status TEXT DEFAULT 'pending',
          FOREIGN KEY (location_id) REFERENCES business_locations(id)
        )
      ''');
      
      // Restore the data
      await db.execute('''
        INSERT INTO pos_devices 
        SELECT * FROM pos_devices_backup
      ''');
      
      // Drop the backup table
      await db.execute('DROP TABLE pos_devices_backup');
    }
    
    // Migration from version 3 to 4: Add product tables
    if (oldVersion < 4) {
      _logger.info('Adding product-related tables');
      await _createProductTables(db);
    }
    
    // Migration from version 4 to 5: Add sales tables
    if (oldVersion < 5) {
      _logger.info('Adding sales-related tables');
      await _createSalesTables(db);
    }
    
    // Migration from version 5 to 6: Add tax_group_id and tax_rate_id columns to products
    if (oldVersion < 6) {
      _logger.info('Adding tax_group_id and tax_rate_id columns to products table');
      try {
        await db.execute('ALTER TABLE products ADD COLUMN tax_group_id TEXT');
      } catch (e) {
        _logger.warning('tax_group_id column may already exist: $e');
      }
      try {
        await db.execute('ALTER TABLE products ADD COLUMN tax_rate_id TEXT');
      } catch (e) {
        _logger.warning('tax_rate_id column may already exist: $e');
      }
    }
    
    // Migration from version 6 to 7: Add charges support
    if (oldVersion < 7) {
      _logger.info('Adding charges support to orders');
      
      // Add charges_amount column to orders table
      try {
        await db.execute('ALTER TABLE orders ADD COLUMN charges_amount REAL DEFAULT 0');
      } catch (e) {
        _logger.warning('charges_amount column may already exist: $e');
      }
      
      // Create order_charges table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS order_charges (
          id TEXT PRIMARY KEY,
          order_id TEXT NOT NULL,
          charge_id TEXT,
          charge_code TEXT NOT NULL,
          charge_name TEXT NOT NULL,
          charge_type TEXT NOT NULL,
          calculation_type TEXT NOT NULL,
          base_amount REAL NOT NULL,
          charge_rate REAL NOT NULL,
          charge_amount REAL NOT NULL,
          is_taxable INTEGER DEFAULT 0,
          is_manual INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT,
          last_synced_at TEXT,
          has_unsynced_changes INTEGER DEFAULT 1,
          FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
        )
      ''');
      
      // Create index for order_charges
      await db.execute('CREATE INDEX IF NOT EXISTS idx_order_charges_order_id ON order_charges(order_id)');
    }
    
    // Migration from version 7 to 8: Add price_category_name column to orders table
    if (oldVersion < 8) {
      _logger.info('Adding price_category_name column to orders table');
      try {
        await db.execute('ALTER TABLE orders ADD COLUMN price_category_name TEXT');
      } catch (e) {
        _logger.warning('price_category_name column may already exist: $e');
      }
    }
    
    // Migration from version 8 to 9: Add image cache tables
    if (oldVersion < 9) {
      _logger.info('Adding image cache tables for product images');
      await ImageCacheDatabase.initializeTables(db);
    }
    
    // Migration from version 9 to 10: Add employee tables
    if (oldVersion < 10) {
      _logger.info('Adding employee management tables');
      await _createEmployeeTables(db);
    }
    
    // Migration from version 10 to 11: Add KOT configuration tables
    if (oldVersion < 11) {
      _logger.info('Adding KOT configuration tables');
      await KotLocalDatabase.createTables(db);
    }
    
    // Migration from version 11 to 12: Update KOT printers table structure
    if (oldVersion < 12) {
      _logger.info('Updating KOT printers table structure');
      
      // Drop old kot_printers and kot_routing_rules tables if they exist (they had different structure)
      await db.execute('DROP TABLE IF EXISTS kot_printers');
      await db.execute('DROP TABLE IF EXISTS kot_routing_rules');
      
      // Recreate KOT tables with proper structure
      await KotLocalDatabase.createTables(db);
    }

    // Migration from version 12 to 13: Add backoff columns, dead letter, and sync_state
    if (oldVersion < 13) {
      _logger.info('Adding backoff and sync state tables');
      try {
        await db.execute('ALTER TABLE sync_queue ADD COLUMN last_attempt_at INTEGER');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE sync_queue ADD COLUMN next_attempt_at INTEGER');
      } catch (_) {}
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_dead_letter (
          id TEXT PRIMARY KEY,
          table_name TEXT NOT NULL,
          operation TEXT NOT NULL,
          record_id TEXT NOT NULL,
          data TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          retry_count INTEGER NOT NULL,
          error_message TEXT,
          failed_at INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_state (
          table_name TEXT PRIMARY KEY,
          last_synced_at TEXT
        )
      ''');
    }

    // Version 14: Ensure full schema alignment with bundled schema file
    if (oldVersion < 14) {
      _logger.info('Ensuring schema alignment with bundled SQL (v14)');
      await DatabaseSchema.applySqliteSchema(db);
    }
  }

  // Create product-related tables
  Future<void> _createProductTables(Database db) async {
    // Product Categories Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS product_categories (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_in_alternate_language TEXT,
        description TEXT,
        image_url TEXT,
        icon_name TEXT,
        display_order INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        parent_category_id TEXT,
        default_kot_printer_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0
      )
    ''');

    // Product Brands Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS product_brands (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        logo_url TEXT,
        display_order INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0
      )
    ''');

    // Products Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_in_alternate_language TEXT,
        description TEXT,
        description_in_alternate_language TEXT,
        category_id TEXT NOT NULL,
        brand_id TEXT,
        image_url TEXT,
        additional_image_urls TEXT,
        unit_of_measure TEXT DEFAULT 'count',
        barcode TEXT,
        hsn TEXT,
        tax_rate REAL DEFAULT 0.0,
        tax_group_id TEXT,
        tax_rate_id TEXT,
        short_code TEXT,
        tags TEXT,
        product_type TEXT DEFAULT 'physical',
        track_inventory INTEGER DEFAULT 1,
        is_active INTEGER DEFAULT 1,
        display_order INTEGER DEFAULT 0,
        available_in_pos INTEGER DEFAULT 1,
        available_in_online_store INTEGER DEFAULT 0,
        available_in_catalog INTEGER DEFAULT 1,
        skip_kot INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0
      )
    ''');

    // Product Variations Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS product_variations (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        sku TEXT,
        mrp REAL NOT NULL,
        selling_price REAL NOT NULL,
        purchase_price REAL,
        barcode TEXT,
        is_default INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        display_order INTEGER DEFAULT 0,
        is_for_sale INTEGER DEFAULT 1,
        is_for_purchase INTEGER DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Product Stock Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS product_stock (
        id TEXT PRIMARY KEY,
        product_variation_id TEXT NOT NULL,
        location_id TEXT NOT NULL,
        current_stock REAL DEFAULT 0,
        reserved_stock REAL DEFAULT 0,
        alert_quantity REAL DEFAULT 10,
        last_updated TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        FOREIGN KEY (product_variation_id) REFERENCES product_variations (id) ON DELETE CASCADE,
        UNIQUE(product_variation_id, location_id)
      )
    ''');


    // Create indexes for product tables
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_business_id ON products(business_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_product_variations_product_id ON product_variations(product_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_product_stock_variation_id ON product_stock(product_variation_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_product_stock_location_id ON product_stock(location_id)');
  }

  // Create sales-related tables
  Future<void> _createSalesTables(Database db) async {
    // Price Categories Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS price_categories (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        location_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        is_default INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        is_visible INTEGER DEFAULT 1,
        display_order INTEGER DEFAULT 0,
        icon_name TEXT,
        color_hex TEXT,
        settings TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        created_by TEXT,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        UNIQUE(business_id, location_id, name)
      )
    ''');

    // (Removed) product_variation_prices table is no longer used

    // Table Areas Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS table_areas (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        location_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        display_order INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        layout_config TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        UNIQUE(business_id, location_id, name)
      )
    ''');

    // Tables Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tables (
        id TEXT PRIMARY KEY,
        area_id TEXT NOT NULL,
        business_id TEXT NOT NULL,
        location_id TEXT NOT NULL,
        table_number TEXT NOT NULL,
        display_name TEXT,
        capacity INTEGER DEFAULT 4,
        status TEXT DEFAULT 'free',
        current_order_id TEXT,
        position_x INTEGER DEFAULT 0,
        position_y INTEGER DEFAULT 0,
        width INTEGER DEFAULT 100,
        height INTEGER DEFAULT 100,
        shape TEXT DEFAULT 'rectangle',
        is_active INTEGER DEFAULT 1,
        is_bookable INTEGER DEFAULT 1,
        settings TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_occupied_at TEXT,
        last_cleared_at TEXT,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        UNIQUE(area_id, table_number),
        FOREIGN KEY (area_id) REFERENCES table_areas(id) ON DELETE CASCADE
      )
    ''');

    // Table Price Overrides Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS table_price_overrides (
        id TEXT PRIMARY KEY,
        table_id TEXT NOT NULL,
        variation_id TEXT NOT NULL,
        price REAL NOT NULL,
        is_active INTEGER DEFAULT 1,
        valid_from TEXT,
        valid_until TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        created_by TEXT,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        UNIQUE(table_id, variation_id),
        FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE CASCADE,
        FOREIGN KEY (variation_id) REFERENCES product_variations(id) ON DELETE CASCADE
      )
    ''');

    // Sell Screen Preferences Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sell_screen_preferences (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        location_id TEXT NOT NULL,
        show_on_hold_tab INTEGER DEFAULT 1,
        show_settlement_tab INTEGER DEFAULT 1,
        default_price_category_id TEXT,
        product_view_mode TEXT DEFAULT 'grid',
        grid_columns INTEGER DEFAULT 4,
        show_quick_sale INTEGER DEFAULT 1,
        show_add_expense INTEGER DEFAULT 0,
        settings TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        UNIQUE(business_id, location_id),
        FOREIGN KEY (default_price_category_id) REFERENCES price_categories(id)
      )
    ''');

    // Create indexes for sales tables
    await db.execute('CREATE INDEX IF NOT EXISTS idx_price_categories_business_location ON price_categories(business_id, location_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_price_categories_active ON price_categories(is_active, is_visible)');
    // (Removed) indexes for product_variation_prices
    await db.execute('CREATE INDEX IF NOT EXISTS idx_table_areas_business_location ON table_areas(business_id, location_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_tables_area ON tables(area_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_tables_business_location ON tables(business_id, location_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_tables_status ON tables(status)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_table_price_overrides_table ON table_price_overrides(table_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_table_price_overrides_variation ON table_price_overrides(variation_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sell_screen_preferences_location ON sell_screen_preferences(business_id, location_id)');
  }

  // Create employee-related tables
  Future<void> _createEmployeeTables(Database db) async {
    // Employees table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS employees (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        business_id TEXT NOT NULL,
        employee_code TEXT NOT NULL,
        display_name TEXT,
        primary_role TEXT NOT NULL,
        assigned_locations TEXT,
        can_access_all_locations INTEGER DEFAULT 0,
        employment_status TEXT DEFAULT 'active',
        joined_at TEXT NOT NULL,
        terminated_at TEXT,
        termination_reason TEXT,
        work_phone TEXT,
        work_email TEXT,
        emergency_contact TEXT,
        permissions TEXT,
        settings TEXT,
        default_shift_start TEXT,
        default_shift_end TEXT,
        working_days TEXT,
        hourly_rate REAL,
        monthly_salary REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        created_by TEXT,
        last_modified_by TEXT,
        has_unsynced_changes INTEGER DEFAULT 0,
        last_synced_at TEXT,
        UNIQUE(business_id, employee_code),
        UNIQUE(user_id, business_id)
      )
    ''');

    // Employee sessions table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS employee_sessions (
        id TEXT PRIMARY KEY,
        employee_id TEXT NOT NULL,
        session_token TEXT UNIQUE NOT NULL,
        device_id TEXT NOT NULL,
        device_name TEXT,
        device_type TEXT,
        app_type TEXT,
        app_version TEXT,
        ip_address TEXT,
        user_agent TEXT,
        started_at TEXT NOT NULL,
        last_activity_at TEXT NOT NULL,
        expires_at TEXT,
        last_known_latitude REAL,
        last_known_longitude REAL,
        last_location_update TEXT,
        is_active INTEGER DEFAULT 1,
        ended_at TEXT,
        end_reason TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Employee audit log table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS employee_audit_log (
        id TEXT PRIMARY KEY,
        employee_id TEXT,
        business_id TEXT NOT NULL,
        action TEXT NOT NULL,
        entity_type TEXT,
        entity_id TEXT,
        old_values TEXT,
        new_values TEXT,
        performed_by TEXT,
        performed_by_name TEXT,
        performed_at TEXT NOT NULL,
        ip_address TEXT,
        user_agent TEXT,
        has_unsynced_changes INTEGER DEFAULT 0
      )
    ''');

    // Role templates table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS role_templates (
        id TEXT PRIMARY KEY,
        role_code TEXT UNIQUE NOT NULL,
        role_name TEXT NOT NULL,
        permissions TEXT,
        description TEXT,
        is_system_role INTEGER DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    // Create indexes for employee tables
    await db.execute('CREATE INDEX IF NOT EXISTS idx_employees_business ON employees(business_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_employees_user ON employees(user_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(employment_status)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_employee_sessions_active ON employee_sessions(employee_id, is_active)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_employee_audit_log_business ON employee_audit_log(business_id)');
  }

  // Helper method to get current timestamp
  int get currentTimestamp => DateTime.now().millisecondsSinceEpoch;

  // Execute raw SQL (for debugging/maintenance)
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  // Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _logger.info('Database connection closed');
    }
  }

  // Clear all user data (on logout)
  Future<void> clearAllUserData() async {
    try {
      final db = await database;
      
      _logger.info('Clearing all local database user data...');
      
      // Clear user/session scoped tables in a transaction
      // NOTE: Do NOT delete product/pricing tables here — users expect
      // created products/variations/prices to persist across login sessions.
      // Also keep table configuration so pricing and seating remain available offline.
      await db.transaction((txn) async {
        // Business and device/session selection
        await txn.delete('business_locations');
        await txn.delete('pos_devices');
        await txn.delete('sync_queue');

        // Keep products and pricing data for offline continuity
        // await txn.delete('product_categories');
        // await txn.delete('product_brands');
        // await txn.delete('products');
        // await txn.delete('product_variations');
        // await txn.delete('product_stock');

        // KOT configuration tables — keep printer/station mappings
        // await txn.delete('kot_stations');
        // await txn.delete('kot_printers');
        // await txn.delete('kot_printer_stations');
        // await txn.delete('kot_item_routing');
        // await txn.delete('kot_templates');

        // Sales layout/pricing overrides — preserve
        // await txn.delete('table_price_overrides');
        // await txn.delete('tables');
        // await txn.delete('table_areas');
        // await txn.delete('product_variation_prices');
        await txn.delete('sell_screen_preferences');
        // await txn.delete('price_categories');

        // Employee tables (logout should clear sessions, but keep employee master)
        await txn.delete('employee_audit_log');
        await txn.delete('employee_sessions');
        // Keep employees and role templates so the app retains context offline
        // await txn.delete('employees');
        // await txn.delete('role_templates');
      });
      
      _logger.info('Local user/session data cleared. Product/pricing retained.');
    } catch (e) {
      _logger.error('Error clearing local database user data', e);
      throw Exception('Failed to clear local database: $e');
    }
  }

  // Reset database (for development/testing)
  Future<void> resetDatabase() async {
    await close();
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    await deleteDatabase(path);
    _logger.info('Database reset successfully');
  }

  // Get database info for debugging
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    final version = await db.getVersion();
    final path = db.path;
    
    // Get table counts
    final locationCount = await db.rawQuery('SELECT COUNT(*) as count FROM business_locations');
    final posDeviceCount = await db.rawQuery('SELECT COUNT(*) as count FROM pos_devices');
    final syncQueueCount = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');

    return {
      'version': version,
      'path': path,
      'tables': {
        'business_locations': locationCount.first['count'],
        'pos_devices': posDeviceCount.first['count'],
        'sync_queue': syncQueueCount.first['count'],
      }
    };
  }
}
