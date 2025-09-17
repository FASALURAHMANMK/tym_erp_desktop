class ProductLocalSchema {
  static const String createProductCategoriesTable = '''
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
  ''';

  static const String createProductBrandsTable = '''
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
  ''';

  static const String createProductsTable = '''
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
  ''';

  static const String createProductVariationsTable = '''
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
  ''';

  static const String createProductStockTable = '''
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
  ''';

  static const String createKotPrintersTable = '''
    CREATE TABLE IF NOT EXISTS kot_printers (
      id TEXT PRIMARY KEY,
      business_id TEXT NOT NULL,
      location_id TEXT NOT NULL,
      name TEXT NOT NULL,
      ip_address TEXT NOT NULL,
      port INTEGER DEFAULT 9100,
      type TEXT DEFAULT 'network',
      description TEXT,
      is_active INTEGER DEFAULT 1,
      is_default INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      last_synced_at TEXT,
      has_unsynced_changes INTEGER DEFAULT 0
    )
  ''';

  static const String createKotRoutingRulesTable = '''
    CREATE TABLE IF NOT EXISTS kot_routing_rules (
      id TEXT PRIMARY KEY,
      product_id TEXT NOT NULL,
      printer_id TEXT NOT NULL,
      instruction TEXT,
      copies INTEGER DEFAULT 1,
      priority INTEGER DEFAULT 1,
      is_active INTEGER DEFAULT 1,
      order_type TEXT,
      time_range TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      last_synced_at TEXT,
      has_unsynced_changes INTEGER DEFAULT 0,
      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
      FOREIGN KEY (printer_id) REFERENCES kot_printers (id) ON DELETE CASCADE
    )
  ''';

  static const List<String> allTables = [
    createProductCategoriesTable,
    createProductBrandsTable,
    createProductsTable,
    createProductVariationsTable,
    createProductStockTable,
    createKotPrintersTable,
    createKotRoutingRulesTable,
  ];

  static const List<String> createIndexes = [
    'CREATE INDEX idx_products_business_id ON products(business_id)',
    'CREATE INDEX idx_products_category_id ON products(category_id)',
    'CREATE INDEX idx_products_is_active ON products(is_active)',
    'CREATE INDEX idx_product_variations_product_id ON product_variations(product_id)',
    'CREATE INDEX idx_product_stock_variation_id ON product_stock(product_variation_id)',
    'CREATE INDEX idx_product_stock_location_id ON product_stock(location_id)',
    'CREATE INDEX idx_kot_routing_rules_product_id ON kot_routing_rules(product_id)',
  ];
}