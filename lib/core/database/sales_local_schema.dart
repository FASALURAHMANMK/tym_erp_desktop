/// Local SQLite schema for Sales Module (offline-first support)
class SalesLocalSchema {
  /// Creates all sales-related tables in local SQLite database
  static const String createTables = '''
    -- =====================================================
    -- PRICE CATEGORIES TABLE
    -- =====================================================
    CREATE TABLE IF NOT EXISTS price_categories (
      id TEXT PRIMARY KEY,
      business_id TEXT NOT NULL,
      location_id TEXT NOT NULL,
      
      -- Basic Info
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      description TEXT,
      
      -- Configuration
      is_default INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      is_visible INTEGER DEFAULT 1,
      display_order INTEGER DEFAULT 0,
      
      -- Icon and styling
      icon_name TEXT,
      color_hex TEXT,
      
      -- Settings (JSON string)
      settings TEXT DEFAULT '{}',
      
      -- Sync metadata
      sync_status TEXT DEFAULT 'pending',
      last_synced_at TEXT,
      
      -- Metadata
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      created_by TEXT,
      
      -- Unique constraint
      UNIQUE(business_id, location_id, name)
    );

    -- (Removed) Product variation prices table is no longer used

    -- =====================================================
    -- TABLE AREAS TABLE
    -- =====================================================
    CREATE TABLE IF NOT EXISTS table_areas (
      id TEXT PRIMARY KEY,
      business_id TEXT NOT NULL,
      location_id TEXT NOT NULL,
      
      -- Basic Info
      name TEXT NOT NULL,
      description TEXT,
      
      -- Configuration
      display_order INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      
      -- Layout settings (JSON string)
      layout_config TEXT DEFAULT '{}',
      
      -- Sync metadata
      sync_status TEXT DEFAULT 'pending',
      last_synced_at TEXT,
      
      -- Metadata
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      
      -- Unique constraint
      UNIQUE(business_id, location_id, name)
    );

    -- =====================================================
    -- TABLES TABLE
    -- =====================================================
    CREATE TABLE IF NOT EXISTS tables (
      id TEXT PRIMARY KEY,
      area_id TEXT NOT NULL,
      business_id TEXT NOT NULL,
      location_id TEXT NOT NULL,
      
      -- Basic Info
      table_number TEXT NOT NULL,
      display_name TEXT,
      capacity INTEGER DEFAULT 4,
      
      -- Status Management
      status TEXT DEFAULT 'free',
      current_order_id TEXT,
      
      -- Visual Position
      position_x INTEGER DEFAULT 0,
      position_y INTEGER DEFAULT 0,
      width INTEGER DEFAULT 100,
      height INTEGER DEFAULT 100,
      shape TEXT DEFAULT 'rectangle',
      
      -- Configuration
      is_active INTEGER DEFAULT 1,
      is_bookable INTEGER DEFAULT 1,
      
      -- Additional settings (JSON string)
      settings TEXT DEFAULT '{}',
      
      -- Sync metadata
      sync_status TEXT DEFAULT 'pending',
      last_synced_at TEXT,
      
      -- Metadata
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      last_occupied_at TEXT,
      last_cleared_at TEXT,
      
      -- Unique constraint
      UNIQUE(area_id, table_number),
      
      -- Foreign keys
      FOREIGN KEY (area_id) REFERENCES table_areas(id) ON DELETE CASCADE
    );

    -- =====================================================
    -- TABLE PRICE OVERRIDES TABLE
    -- =====================================================
    CREATE TABLE IF NOT EXISTS table_price_overrides (
      id TEXT PRIMARY KEY,
      table_id TEXT NOT NULL,
      variation_id TEXT NOT NULL,
      
      -- Pricing
      price REAL NOT NULL,
      
      -- Status
      is_active INTEGER DEFAULT 1,
      
      -- Valid period
      valid_from TEXT,
      valid_until TEXT,
      
      -- Sync metadata
      sync_status TEXT DEFAULT 'pending',
      last_synced_at TEXT,
      
      -- Metadata
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      created_by TEXT,
      
      -- Unique constraint
      UNIQUE(table_id, variation_id),
      
      -- Foreign keys
      FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE CASCADE,
      FOREIGN KEY (variation_id) REFERENCES product_variations(id) ON DELETE CASCADE
    );

    -- =====================================================
    -- SELL SCREEN PREFERENCES TABLE
    -- =====================================================
    CREATE TABLE IF NOT EXISTS sell_screen_preferences (
      id TEXT PRIMARY KEY,
      business_id TEXT NOT NULL,
      location_id TEXT NOT NULL,
      
      -- Tab visibility
      show_on_hold_tab INTEGER DEFAULT 1,
      show_settlement_tab INTEGER DEFAULT 1,
      
      -- Default selections
      default_price_category_id TEXT,
      
      -- UI Preferences
      product_view_mode TEXT DEFAULT 'grid',
      grid_columns INTEGER DEFAULT 4,
      
      -- Quick actions
      show_quick_sale INTEGER DEFAULT 1,
      show_add_expense INTEGER DEFAULT 0,
      
      -- Additional settings (JSON string)
      settings TEXT DEFAULT '{}',
      
      -- Sync metadata
      sync_status TEXT DEFAULT 'pending',
      last_synced_at TEXT,
      
      -- Metadata
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      
      -- Unique constraint
      UNIQUE(business_id, location_id),
      
      -- Foreign key
      FOREIGN KEY (default_price_category_id) REFERENCES price_categories(id)
    );

    -- =====================================================
    -- INDEXES FOR BETTER PERFORMANCE
    -- =====================================================
    CREATE INDEX IF NOT EXISTS idx_price_categories_business_location 
      ON price_categories(business_id, location_id);
    CREATE INDEX IF NOT EXISTS idx_price_categories_active 
      ON price_categories(is_active, is_visible);
    CREATE INDEX IF NOT EXISTS idx_price_categories_sync 
      ON price_categories(sync_status);
    
    -- (Removed) Indexes for product_variation_prices
    
    CREATE INDEX IF NOT EXISTS idx_table_areas_business_location 
      ON table_areas(business_id, location_id);
    CREATE INDEX IF NOT EXISTS idx_table_areas_sync 
      ON table_areas(sync_status);
    
    CREATE INDEX IF NOT EXISTS idx_tables_area 
      ON tables(area_id);
    CREATE INDEX IF NOT EXISTS idx_tables_business_location 
      ON tables(business_id, location_id);
    CREATE INDEX IF NOT EXISTS idx_tables_status 
      ON tables(status);
    CREATE INDEX IF NOT EXISTS idx_tables_sync 
      ON tables(sync_status);
    
    CREATE INDEX IF NOT EXISTS idx_table_price_overrides_table 
      ON table_price_overrides(table_id);
    CREATE INDEX IF NOT EXISTS idx_table_price_overrides_variation 
      ON table_price_overrides(variation_id);
    CREATE INDEX IF NOT EXISTS idx_table_price_overrides_sync 
      ON table_price_overrides(sync_status);
    
    CREATE INDEX IF NOT EXISTS idx_sell_screen_preferences_location 
      ON sell_screen_preferences(business_id, location_id);
    CREATE INDEX IF NOT EXISTS idx_sell_screen_preferences_sync 
      ON sell_screen_preferences(sync_status);
  ''';

  /// SQL to drop all sales-related tables (for testing/reset)
  static const String dropTables = '''
    DROP TABLE IF EXISTS table_price_overrides;
    DROP TABLE IF EXISTS tables;
    DROP TABLE IF EXISTS table_areas;
    -- product_variation_prices table removed; nothing to drop
    DROP TABLE IF EXISTS sell_screen_preferences;
    DROP TABLE IF EXISTS price_categories;
  ''';

  /// Creates default price categories for a new business/location
  static String createDefaultPriceCategories({
    required String businessId,
    required String locationId,
    required String createdBy,
  }) {
    final now = DateTime.now().toIso8601String();
    return '''
      INSERT OR IGNORE INTO price_categories (
        id, business_id, location_id, name, type, is_default, 
        is_active, is_visible, display_order, icon_name, color_hex,
        created_at, updated_at, created_by, sync_status
      ) VALUES 
        ('${_generateUuid()}', '$businessId', '$locationId', 'Dine-In', 'dine_in', 
         1, 1, 1, 1, 'restaurant', '#4CAF50', '$now', '$now', '$createdBy', 'pending'),
        ('${_generateUuid()}', '$businessId', '$locationId', 'Parcel', 'takeaway', 
         1, 1, 1, 2, 'takeout_dining', '#FF9800', '$now', '$now', '$createdBy', 'pending'),
        ('${_generateUuid()}', '$businessId', '$locationId', 'Delivery', 'delivery', 
         1, 1, 1, 3, 'delivery_dining', '#2196F3', '$now', '$now', '$createdBy', 'pending');
      
      INSERT OR IGNORE INTO sell_screen_preferences (
        id, business_id, location_id, created_at, updated_at, sync_status
      ) VALUES (
        '${_generateUuid()}', '$businessId', '$locationId', '$now', '$now', 'pending'
      );
    ''';
  }

  /// Helper method to generate UUID (should use uuid package in actual implementation)
  static String _generateUuid() {
    // This is a placeholder - use the uuid package in actual implementation
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
