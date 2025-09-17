BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "business_locations" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"address"	TEXT,
	"phone"	TEXT,
	"is_default"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	INTEGER NOT NULL,
	"updated_at"	INTEGER NOT NULL,
	"sync_status"	TEXT DEFAULT 'pending',
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "pos_devices" (
	"id"	TEXT,
	"location_id"	TEXT NOT NULL,
	"device_name"	TEXT NOT NULL,
	"device_code"	TEXT NOT NULL,
	"description"	TEXT,
	"is_default"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"last_sync_at"	INTEGER,
	"created_at"	INTEGER NOT NULL,
	"updated_at"	INTEGER NOT NULL,
	"sync_status"	TEXT DEFAULT 'pending',
	FOREIGN KEY("location_id") REFERENCES "business_locations"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "user_business_roles" (
	"id"	TEXT,
	"user_id"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"role"	TEXT NOT NULL,
	"permissions"	TEXT NOT NULL,
	"assigned_locations"	TEXT,
	"assigned_pos_devices"	TEXT,
	"created_at"	INTEGER NOT NULL,
	"updated_at"	INTEGER NOT NULL,
	"sync_status"	TEXT DEFAULT 'pending',
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "sync_queue" (
	"id"	TEXT,
	"table_name"	TEXT NOT NULL,
	"operation"	TEXT NOT NULL,
	"record_id"	TEXT NOT NULL,
	"data"	TEXT NOT NULL,
	"created_at"	INTEGER NOT NULL,
	"retry_count"	INTEGER DEFAULT 0,
	"error_message"	TEXT,
	"last_attempt_at"	INTEGER,
	"next_attempt_at"	INTEGER,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "sync_dead_letter" (
	"id"	TEXT,
	"table_name"	TEXT NOT NULL,
	"operation"	TEXT NOT NULL,
	"record_id"	TEXT NOT NULL,
	"data"	TEXT NOT NULL,
	"created_at"	INTEGER NOT NULL,
	"retry_count"	INTEGER NOT NULL,
	"error_message"	TEXT,
	"failed_at"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "sync_state" (
	"table_name"	TEXT,
	"last_synced_at"	TEXT,
	PRIMARY KEY("table_name")
);
CREATE TABLE IF NOT EXISTS "product_categories" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"name_in_alternate_language"	TEXT,
	"description"	TEXT,
	"image_url"	TEXT,
	"icon_name"	TEXT,
	"display_order"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"parent_category_id"	TEXT,
	"default_kot_printer_id"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "product_brands" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"logo_url"	TEXT,
	"display_order"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "products" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"name_in_alternate_language"	TEXT,
	"description"	TEXT,
	"description_in_alternate_language"	TEXT,
	"category_id"	TEXT NOT NULL,
	"brand_id"	TEXT,
	"image_url"	TEXT,
	"additional_image_urls"	TEXT,
	"unit_of_measure"	TEXT DEFAULT 'count',
	"barcode"	TEXT,
	"hsn"	TEXT,
	"tax_rate"	REAL DEFAULT 0.0,
	"tax_group_id"	TEXT,
	"tax_rate_id"	TEXT,
	"short_code"	TEXT,
	"tags"	TEXT,
	"product_type"	TEXT DEFAULT 'physical',
	"track_inventory"	INTEGER DEFAULT 1,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"available_in_pos"	INTEGER DEFAULT 1,
	"available_in_online_store"	INTEGER DEFAULT 0,
	"available_in_catalog"	INTEGER DEFAULT 1,
	"skip_kot"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "product_variations" (
	"id"	TEXT,
	"product_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"sku"	TEXT,
	"mrp"	REAL NOT NULL,
	"selling_price"	REAL NOT NULL,
	"purchase_price"	REAL,
	"barcode"	TEXT,
	"is_default"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"is_for_sale"	INTEGER DEFAULT 1,
	"is_for_purchase"	INTEGER DEFAULT 0,
	"cost"	REAL DEFAULT 0,
	"price"	REAL DEFAULT 0,
	"compare_at_price"	REAL,
	"track_inventory"	INTEGER DEFAULT 0,
	"inventory_quantity"	INTEGER DEFAULT 0,
	"low_stock_alert_quantity"	INTEGER DEFAULT 10,
	"weight"	REAL,
	"weight_unit"	TEXT,
	FOREIGN KEY("product_id") REFERENCES "products"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "product_stock" (
	"id"	TEXT,
	"product_variation_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"current_stock"	REAL DEFAULT 0,
	"reserved_stock"	REAL DEFAULT 0,
	"alert_quantity"	REAL DEFAULT 10,
	"last_updated"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("product_variation_id","location_id"),
	FOREIGN KEY("product_variation_id") REFERENCES "product_variations"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "price_categories" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	"description"	TEXT,
	"is_default"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"is_visible"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"icon_name"	TEXT,
	"color_hex"	TEXT,
	"settings"	TEXT DEFAULT '{}',
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("business_id","location_id","name"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "product_variation_prices" (
	"id"	TEXT,
	"variation_id"	TEXT NOT NULL,
	"price_category_id"	TEXT NOT NULL,
	"price"	REAL NOT NULL,
	"cost"	REAL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("variation_id","price_category_id"),
	FOREIGN KEY("price_category_id") REFERENCES "price_categories"("id") ON DELETE CASCADE,
	FOREIGN KEY("variation_id") REFERENCES "product_variations"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "table_areas" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"display_order"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"layout_config"	TEXT DEFAULT '{}',
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("business_id","location_id","name"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "tables" (
	"id"	TEXT,
	"area_id"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"table_number"	TEXT NOT NULL,
	"display_name"	TEXT,
	"capacity"	INTEGER DEFAULT 4,
	"status"	TEXT DEFAULT 'free',
	"current_order_id"	TEXT,
	"position_x"	INTEGER DEFAULT 0,
	"position_y"	INTEGER DEFAULT 0,
	"width"	INTEGER DEFAULT 100,
	"height"	INTEGER DEFAULT 100,
	"shape"	TEXT DEFAULT 'rectangle',
	"is_active"	INTEGER DEFAULT 1,
	"is_bookable"	INTEGER DEFAULT 1,
	"settings"	TEXT DEFAULT '{}',
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_occupied_at"	TEXT,
	"last_cleared_at"	TEXT,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("area_id","table_number"),
	FOREIGN KEY("area_id") REFERENCES "table_areas"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "table_price_overrides" (
	"id"	TEXT,
	"table_id"	TEXT NOT NULL,
	"variation_id"	TEXT NOT NULL,
	"price"	REAL NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"valid_from"	TEXT,
	"valid_until"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("table_id","variation_id"),
	FOREIGN KEY("variation_id") REFERENCES "product_variations"("id") ON DELETE CASCADE,
	FOREIGN KEY("table_id") REFERENCES "tables"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "sell_screen_preferences" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"show_on_hold_tab"	INTEGER DEFAULT 1,
	"show_settlement_tab"	INTEGER DEFAULT 1,
	"default_price_category_id"	TEXT,
	"product_view_mode"	TEXT DEFAULT 'grid',
	"grid_columns"	INTEGER DEFAULT 4,
	"show_quick_sale"	INTEGER DEFAULT 1,
	"show_add_expense"	INTEGER DEFAULT 0,
	"settings"	TEXT DEFAULT '{}',
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	UNIQUE("business_id","location_id"),
	FOREIGN KEY("default_price_category_id") REFERENCES "price_categories"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "employees" (
	"id"	TEXT,
	"user_id"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"employee_code"	TEXT NOT NULL,
	"display_name"	TEXT,
	"primary_role"	TEXT NOT NULL,
	"assigned_locations"	TEXT,
	"can_access_all_locations"	INTEGER DEFAULT 0,
	"employment_status"	TEXT DEFAULT 'active',
	"joined_at"	TEXT NOT NULL,
	"terminated_at"	TEXT,
	"termination_reason"	TEXT,
	"work_phone"	TEXT,
	"work_email"	TEXT,
	"emergency_contact"	TEXT,
	"permissions"	TEXT,
	"settings"	TEXT,
	"default_shift_start"	TEXT,
	"default_shift_end"	TEXT,
	"working_days"	TEXT,
	"hourly_rate"	REAL,
	"monthly_salary"	REAL,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"last_modified_by"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	"last_synced_at"	TEXT,
	UNIQUE("business_id","employee_code"),
	UNIQUE("user_id","business_id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "employee_sessions" (
	"id"	TEXT,
	"employee_id"	TEXT NOT NULL,
	"session_token"	TEXT NOT NULL UNIQUE,
	"device_id"	TEXT NOT NULL,
	"device_name"	TEXT,
	"device_type"	TEXT,
	"app_type"	TEXT,
	"app_version"	TEXT,
	"ip_address"	TEXT,
	"user_agent"	TEXT,
	"started_at"	TEXT NOT NULL,
	"last_activity_at"	TEXT NOT NULL,
	"expires_at"	TEXT,
	"last_known_latitude"	REAL,
	"last_known_longitude"	REAL,
	"last_location_update"	TEXT,
	"is_active"	INTEGER DEFAULT 1,
	"ended_at"	TEXT,
	"end_reason"	TEXT,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "employee_audit_log" (
	"id"	TEXT,
	"employee_id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"action"	TEXT NOT NULL,
	"entity_type"	TEXT,
	"entity_id"	TEXT,
	"old_values"	TEXT,
	"new_values"	TEXT,
	"performed_by"	TEXT,
	"performed_by_name"	TEXT,
	"performed_at"	TEXT NOT NULL,
	"ip_address"	TEXT,
	"user_agent"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "role_templates" (
	"id"	TEXT,
	"role_code"	TEXT NOT NULL UNIQUE,
	"role_name"	TEXT NOT NULL,
	"permissions"	TEXT,
	"description"	TEXT,
	"is_system_role"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "image_cache" (
	"id"	TEXT,
	"product_id"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"image_type"	TEXT NOT NULL,
	"local_path"	TEXT NOT NULL,
	"remote_url"	TEXT,
	"file_size"	INTEGER,
	"mime_type"	TEXT,
	"is_uploaded"	INTEGER DEFAULT 0,
	"upload_attempts"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "image_sync_queue" (
	"id"	TEXT,
	"product_id"	TEXT NOT NULL,
	"operation"	TEXT NOT NULL,
	"local_path"	TEXT,
	"remote_path"	TEXT,
	"retry_count"	INTEGER DEFAULT 0,
	"max_retries"	INTEGER DEFAULT 3,
	"created_at"	TEXT NOT NULL,
	"completed_at"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "kot_stations" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	"description"	TEXT,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"color"	TEXT,
	"created_at"	TEXT,
	"updated_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "kot_printers" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"printer_type"	TEXT NOT NULL,
	"ip_address"	TEXT,
	"port"	TEXT,
	"mac_address"	TEXT,
	"device_name"	TEXT,
	"is_active"	INTEGER DEFAULT 1,
	"is_default"	INTEGER DEFAULT 0,
	"print_copies"	INTEGER DEFAULT 1,
	"paper_size"	TEXT DEFAULT '80mm',
	"auto_cut"	INTEGER DEFAULT 1,
	"cash_drawer"	INTEGER DEFAULT 0,
	"notes"	TEXT,
	"created_at"	TEXT,
	"updated_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "kot_printer_stations" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"printer_id"	TEXT NOT NULL,
	"station_id"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"priority"	INTEGER DEFAULT 1,
	"created_at"	TEXT,
	"updated_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "kot_item_routing" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"station_id"	TEXT NOT NULL,
	"category_id"	TEXT,
	"product_id"	TEXT,
	"variation_id"	TEXT,
	"priority"	INTEGER DEFAULT 1,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT,
	"updated_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "kot_templates" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	"content"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"is_default"	INTEGER DEFAULT 0,
	"description"	TEXT,
	"settings"	TEXT,
	"created_at"	TEXT,
	"updated_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "orders" (
	"id"	TEXT,
	"order_number"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"pos_device_id"	TEXT NOT NULL,
	"order_type"	TEXT DEFAULT 'dine_in',
	"price_category_name"	TEXT,
	"order_source"	TEXT DEFAULT 'pos',
	"table_id"	TEXT,
	"table_name"	TEXT,
	"customer_id"	TEXT NOT NULL,
	"customer_name"	TEXT NOT NULL,
	"customer_phone"	TEXT,
	"customer_email"	TEXT,
	"delivery_address_line1"	TEXT,
	"delivery_address_line2"	TEXT,
	"delivery_city"	TEXT,
	"delivery_postal_code"	TEXT,
	"delivery_phone"	TEXT,
	"delivery_instructions"	TEXT,
	"ordered_at"	TEXT NOT NULL,
	"confirmed_at"	TEXT,
	"prepared_at"	TEXT,
	"ready_at"	TEXT,
	"served_at"	TEXT,
	"completed_at"	TEXT,
	"cancelled_at"	TEXT,
	"estimated_ready_time"	TEXT,
	"subtotal"	REAL DEFAULT 0,
	"discount_amount"	REAL DEFAULT 0,
	"tax_amount"	REAL DEFAULT 0,
	"charges_amount"	REAL DEFAULT 0,
	"delivery_charge"	REAL DEFAULT 0,
	"service_charge"	REAL DEFAULT 0,
	"tip_amount"	REAL DEFAULT 0,
	"round_off_amount"	REAL DEFAULT 0,
	"total"	REAL NOT NULL,
	"payment_status"	TEXT DEFAULT 'pending',
	"total_paid"	REAL DEFAULT 0,
	"change_amount"	REAL DEFAULT 0,
	"status"	TEXT DEFAULT 'draft',
	"kitchen_status"	TEXT,
	"created_by"	TEXT NOT NULL,
	"created_by_name"	TEXT,
	"served_by"	TEXT,
	"served_by_name"	TEXT,
	"customer_notes"	TEXT,
	"kitchen_notes"	TEXT,
	"internal_notes"	TEXT,
	"cancellation_reason"	TEXT,
	"token_number"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	"is_priority"	INTEGER DEFAULT 0,
	"is_void"	INTEGER DEFAULT 0,
	"void_reason"	TEXT,
	"voided_at"	TEXT,
	"voided_by"	TEXT,
	"preparation_time_minutes"	INTEGER,
	"service_time_minutes"	INTEGER,
	"total_time_minutes"	INTEGER,
	"items"	TEXT,
	"payments"	TEXT,
	"order_discounts"	TEXT,
	"prepared_by"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_items" (
	"id"	TEXT,
	"order_id"	TEXT NOT NULL,
	"product_id"	TEXT NOT NULL,
	"variation_id"	TEXT NOT NULL,
	"product_name"	TEXT NOT NULL,
	"variation_name"	TEXT NOT NULL,
	"product_code"	TEXT,
	"sku"	TEXT,
	"unit_of_measure"	TEXT,
	"quantity"	REAL DEFAULT 1,
	"unit_price"	REAL NOT NULL,
	"modifiers_price"	REAL DEFAULT 0,
	"modifiers"	TEXT,
	"special_instructions"	TEXT,
	"discount_amount"	REAL DEFAULT 0,
	"discount_percent"	REAL DEFAULT 0,
	"discount_reason"	TEXT,
	"applied_discount_id"	TEXT,
	"tax_rate"	REAL DEFAULT 0,
	"tax_amount"	REAL DEFAULT 0,
	"tax_group_id"	TEXT,
	"tax_group_name"	TEXT,
	"subtotal"	REAL NOT NULL,
	"total"	REAL NOT NULL,
	"skip_kot"	INTEGER DEFAULT 0,
	"kot_printed"	INTEGER DEFAULT 0,
	"kot_printed_at"	TEXT,
	"kot_number"	TEXT,
	"preparation_status"	TEXT DEFAULT 'pending',
	"prepared_at"	TEXT,
	"prepared_by"	TEXT,
	"station"	TEXT,
	"served_at"	TEXT,
	"served_by"	TEXT,
	"is_voided"	INTEGER DEFAULT 0,
	"voided_at"	TEXT,
	"voided_by"	TEXT,
	"void_reason"	TEXT,
	"is_complimentary"	INTEGER DEFAULT 0,
	"complimentary_reason"	TEXT,
	"is_returned"	INTEGER DEFAULT 0,
	"returned_quantity"	REAL DEFAULT 0,
	"returned_at"	TEXT,
	"return_reason"	TEXT,
	"refunded_amount"	REAL DEFAULT 0,
	"display_order"	INTEGER DEFAULT 0,
	"category"	TEXT,
	"category_id"	TEXT,
	"item_notes"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_payments" (
	"id"	TEXT,
	"order_id"	TEXT NOT NULL,
	"payment_method_id"	TEXT NOT NULL,
	"payment_method_name"	TEXT NOT NULL,
	"payment_method_code"	TEXT NOT NULL,
	"amount"	REAL NOT NULL,
	"tip_amount"	REAL DEFAULT 0,
	"processing_fee"	REAL DEFAULT 0,
	"total_amount"	REAL NOT NULL,
	"status"	TEXT DEFAULT 'pending',
	"reference_number"	TEXT,
	"transaction_id"	TEXT,
	"approval_code"	TEXT,
	"card_last_four"	TEXT,
	"card_type"	TEXT,
	"paid_at"	TEXT NOT NULL,
	"refunded_at"	TEXT,
	"refunded_amount"	REAL DEFAULT 0,
	"refund_reason"	TEXT,
	"refunded_by"	TEXT,
	"refund_transaction_id"	TEXT,
	"processed_by"	TEXT NOT NULL,
	"processed_by_name"	TEXT,
	"notes"	TEXT,
	"metadata"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_discounts" (
	"id"	TEXT,
	"order_id"	TEXT NOT NULL,
	"discount_id"	TEXT NOT NULL,
	"discount_name"	TEXT NOT NULL,
	"discount_code"	TEXT NOT NULL,
	"discount_type"	TEXT NOT NULL,
	"applied_to"	TEXT NOT NULL,
	"discount_percent"	REAL DEFAULT 0,
	"discount_amount"	REAL DEFAULT 0,
	"maximum_discount"	REAL DEFAULT 0,
	"applied_amount"	REAL NOT NULL,
	"minimum_purchase"	REAL DEFAULT 0,
	"minimum_quantity"	INTEGER DEFAULT 0,
	"applicable_categories"	TEXT,
	"applicable_products"	TEXT,
	"application_method"	TEXT DEFAULT 'auto',
	"coupon_code"	TEXT,
	"applied_by"	TEXT,
	"applied_by_name"	TEXT,
	"reason"	TEXT,
	"authorized_by"	TEXT,
	"applied_at"	TEXT NOT NULL,
	"metadata"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_status_history" (
	"id"	TEXT,
	"order_id"	TEXT NOT NULL,
	"from_status"	TEXT NOT NULL,
	"to_status"	TEXT NOT NULL,
	"changed_by"	TEXT NOT NULL,
	"changed_by_name"	TEXT NOT NULL,
	"changed_by_role"	TEXT,
	"changed_at"	TEXT NOT NULL,
	"reason"	TEXT,
	"notes"	TEXT,
	"device_id"	TEXT,
	"ip_address"	TEXT,
	"metadata"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "customer_groups" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"code"	TEXT NOT NULL,
	"description"	TEXT,
	"color"	TEXT,
	"discount_percent"	REAL DEFAULT 0,
	"credit_limit"	REAL DEFAULT 0,
	"payment_terms"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "customers" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"group_id"	TEXT,
	"customer_code"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"company_name"	TEXT,
	"customer_type"	TEXT DEFAULT 'individual',
	"email"	TEXT,
	"phone"	TEXT,
	"alternate_phone"	TEXT,
	"whatsapp_number"	TEXT,
	"website"	TEXT,
	"address_line1"	TEXT,
	"address_line2"	TEXT,
	"city"	TEXT,
	"state"	TEXT,
	"postal_code"	TEXT,
	"country"	TEXT,
	"shipping_address_line1"	TEXT,
	"shipping_address_line2"	TEXT,
	"shipping_city"	TEXT,
	"shipping_state"	TEXT,
	"shipping_postal_code"	TEXT,
	"shipping_country"	TEXT,
	"use_billing_for_shipping"	INTEGER DEFAULT 1,
	"tax_id"	TEXT,
	"tax_exempt"	INTEGER DEFAULT 0,
	"tax_exempt_reason"	TEXT,
	"credit_limit"	REAL DEFAULT 0,
	"current_credit"	REAL DEFAULT 0,
	"payment_terms"	INTEGER DEFAULT 0,
	"credit_status"	TEXT DEFAULT 'active',
	"credit_notes"	TEXT,
	"price_category_id"	TEXT,
	"discount_percent"	REAL DEFAULT 0,
	"loyalty_points"	INTEGER DEFAULT 0,
	"loyalty_tier"	TEXT,
	"membership_number"	TEXT,
	"membership_expiry"	TEXT,
	"date_of_birth"	TEXT,
	"anniversary_date"	TEXT,
	"first_purchase_date"	TEXT,
	"last_purchase_date"	TEXT,
	"total_purchases"	REAL DEFAULT 0,
	"total_payments"	REAL DEFAULT 0,
	"purchase_count"	INTEGER DEFAULT 0,
	"average_order_value"	REAL DEFAULT 0,
	"preferred_contact_method"	TEXT,
	"language_preference"	TEXT DEFAULT 'en',
	"currency_preference"	TEXT DEFAULT 'INR',
	"marketing_consent"	INTEGER DEFAULT 0,
	"sms_consent"	INTEGER DEFAULT 0,
	"email_consent"	INTEGER DEFAULT 0,
	"notes"	TEXT,
	"tags"	TEXT DEFAULT '[]',
	"is_active"	INTEGER DEFAULT 1,
	"is_blacklisted"	INTEGER DEFAULT 0,
	"blacklist_reason"	TEXT,
	"is_vip"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"last_modified_by"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "customer_transactions" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"customer_id"	TEXT NOT NULL,
	"transaction_type"	TEXT NOT NULL,
	"transaction_date"	TEXT NOT NULL,
	"reference_type"	TEXT,
	"reference_id"	TEXT,
	"reference_number"	TEXT,
	"amount"	REAL NOT NULL,
	"balance_before"	REAL NOT NULL,
	"balance_after"	REAL NOT NULL,
	"payment_method_id"	TEXT,
	"payment_reference"	TEXT,
	"payment_date"	TEXT,
	"cheque_number"	TEXT,
	"cheque_date"	TEXT,
	"cheque_status"	TEXT DEFAULT 'pending',
	"bank_name"	TEXT,
	"description"	TEXT,
	"notes"	TEXT,
	"created_at"	TEXT NOT NULL,
	"created_by"	TEXT,
	"is_verified"	INTEGER DEFAULT 0,
	"verified_by"	TEXT,
	"verified_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "tax_groups" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"is_default"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "tax_rates" (
	"id"	TEXT,
	"tax_group_id"	TEXT NOT NULL,
	"business_id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"rate"	REAL NOT NULL,
	"type"	TEXT DEFAULT 'percentage',
	"calculation_method"	TEXT DEFAULT 'exclusive',
	"apply_on"	TEXT DEFAULT 'base_price',
	"parent_tax_id"	TEXT,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	FOREIGN KEY("tax_group_id") REFERENCES "tax_groups"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "product_taxes" (
	"id"	TEXT,
	"product_id"	TEXT NOT NULL,
	"tax_group_id"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "category_taxes" (
	"id"	TEXT,
	"category_id"	TEXT NOT NULL,
	"tax_group_id"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "location_tax_overrides" (
	"id"	TEXT,
	"tax_rate_id"	TEXT NOT NULL,
	"location_id"	TEXT NOT NULL,
	"override_rate"	REAL NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "charges" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"location_id"	TEXT,
	"code"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"charge_type"	TEXT NOT NULL,
	"calculation_type"	TEXT NOT NULL,
	"value"	REAL,
	"scope"	TEXT DEFAULT 'order',
	"auto_apply"	INTEGER DEFAULT 0,
	"is_taxable"	INTEGER DEFAULT 0,
	"minimum_order_value"	REAL,
	"maximum_order_value"	REAL,
	"valid_from"	TEXT,
	"valid_until"	TEXT,
	"is_active"	INTEGER DEFAULT 1,
	"display_order"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"is_mandatory"	INTEGER DEFAULT 0,
	"apply_before_discount"	INTEGER DEFAULT 0,
	"applicable_days"	TEXT,
	"applicable_time_slots"	TEXT,
	"applicable_categories"	TEXT,
	"applicable_products"	TEXT,
	"excluded_categories"	TEXT,
	"excluded_products"	TEXT,
	"applicable_customer_groups"	TEXT,
	"excluded_customer_groups"	TEXT,
	"show_in_pos"	INTEGER DEFAULT 1,
	"show_in_invoice"	INTEGER DEFAULT 1,
	"show_in_online"	INTEGER DEFAULT 1,
	"icon_name"	TEXT,
	"color_hex"	TEXT,
	"created_by"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "charge_tiers" (
	"id"	TEXT,
	"charge_id"	TEXT NOT NULL,
	"min_value"	REAL NOT NULL,
	"max_value"	REAL,
	"charge_value"	REAL NOT NULL,
	"display_order"	INTEGER DEFAULT 0,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"tier_name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "customer_charge_exemptions" (
	"id"	TEXT,
	"charge_id"	TEXT NOT NULL,
	"customer_id"	TEXT NOT NULL,
	"exemption_type"	TEXT NOT NULL DEFAULT 'full',
	"percent_off"	REAL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"business_id"	TEXT,
	"exemption_value"	REAL,
	"reason"	TEXT,
	"valid_from"	TEXT,
	"valid_until"	TEXT,
	"approved_by"	TEXT,
	"approved_at"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "discount_rules" (
	"id"	TEXT,
	"business_id"	TEXT NOT NULL,
	"code"	TEXT UNIQUE,
	"name"	TEXT NOT NULL,
	"scope"	TEXT NOT NULL DEFAULT 'cart',
	"discount_type"	TEXT NOT NULL,
	"discount_value"	REAL NOT NULL,
	"max_discount_amount"	REAL,
	"min_purchase_amount"	REAL,
	"valid_from"	TEXT,
	"valid_until"	TEXT,
	"valid_from_time"	TEXT,
	"valid_until_time"	TEXT,
	"valid_days"	TEXT,
	"total_usage_limit"	INTEGER,
	"current_usage_count"	INTEGER DEFAULT 0,
	"auto_apply"	INTEGER DEFAULT 0,
	"priority"	INTEGER DEFAULT 0,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT NOT NULL,
	"requires_coupon"	INTEGER DEFAULT 0,
	"combinable"	INTEGER DEFAULT 0,
	"min_quantity"	INTEGER,
	"buy_quantity"	INTEGER,
	"get_quantity"	INTEGER,
	"get_discount_percent"	REAL,
	"per_customer_limit"	INTEGER,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "discount_products" (
	"id"	TEXT,
	"discount_rule_id"	TEXT NOT NULL,
	"product_id"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "discount_categories" (
	"id"	TEXT,
	"discount_rule_id"	TEXT NOT NULL,
	"category_id"	TEXT NOT NULL,
	"is_active"	INTEGER DEFAULT 1,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "discount_usage_history" (
	"id"	TEXT,
	"discount_rule_id"	TEXT NOT NULL,
	"order_id"	TEXT,
	"customer_id"	TEXT,
	"location_id"	TEXT,
	"discount_amount"	REAL NOT NULL,
	"used_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_item_charges" (
	"id"	TEXT,
	"order_item_id"	TEXT NOT NULL,
	"charge_id"	TEXT,
	"charge_name"	TEXT NOT NULL,
	"charge_type"	TEXT NOT NULL,
	"quantity"	REAL DEFAULT 1,
	"unit_charge"	REAL,
	"total_charge"	REAL NOT NULL,
	"is_manual"	INTEGER DEFAULT 0,
	"notes"	TEXT,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "order_charges" (
	"id"	TEXT,
	"order_id"	TEXT NOT NULL,
	"charge_id"	TEXT,
	"charge_code"	TEXT,
	"charge_name"	TEXT NOT NULL,
	"charge_type"	TEXT NOT NULL,
	"calculation_type"	TEXT NOT NULL,
	"base_amount"	REAL,
	"charge_rate"	REAL,
	"charge_amount"	REAL NOT NULL,
	"is_taxable"	INTEGER DEFAULT 1,
	"tax_amount"	REAL DEFAULT 0,
	"is_manual"	INTEGER DEFAULT 0,
	"original_amount"	REAL,
	"adjustment_reason"	TEXT,
	"added_by"	TEXT,
	"removed_by"	TEXT,
	"is_removed"	INTEGER DEFAULT 0,
	"removed_at"	TEXT,
	"notes"	TEXT,
	"created_at"	TEXT NOT NULL,
	"updated_at"	TEXT,
	"last_synced_at"	TEXT,
	"has_unsynced_changes"	INTEGER DEFAULT 1,
	FOREIGN KEY("order_id") REFERENCES "orders"("id") ON DELETE CASCADE,
	PRIMARY KEY("id")
);
CREATE INDEX IF NOT EXISTS "idx_products_business_id" ON "products" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_products_category_id" ON "products" (
	"category_id"
);
CREATE INDEX IF NOT EXISTS "idx_products_is_active" ON "products" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_product_variations_product_id" ON "product_variations" (
	"product_id"
);
CREATE INDEX IF NOT EXISTS "idx_product_stock_variation_id" ON "product_stock" (
	"product_variation_id"
);
CREATE INDEX IF NOT EXISTS "idx_product_stock_location_id" ON "product_stock" (
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_price_categories_business_location" ON "price_categories" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_price_categories_active" ON "price_categories" (
	"is_active",
	"is_visible"
);
CREATE INDEX IF NOT EXISTS "idx_product_variation_prices_variation" ON "product_variation_prices" (
	"variation_id"
);
CREATE INDEX IF NOT EXISTS "idx_product_variation_prices_category" ON "product_variation_prices" (
	"price_category_id"
);
CREATE INDEX IF NOT EXISTS "idx_table_areas_business_location" ON "table_areas" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_tables_area" ON "tables" (
	"area_id"
);
CREATE INDEX IF NOT EXISTS "idx_tables_business_location" ON "tables" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_tables_status" ON "tables" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_table_price_overrides_table" ON "table_price_overrides" (
	"table_id"
);
CREATE INDEX IF NOT EXISTS "idx_table_price_overrides_variation" ON "table_price_overrides" (
	"variation_id"
);
CREATE INDEX IF NOT EXISTS "idx_sell_screen_preferences_location" ON "sell_screen_preferences" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_employees_business" ON "employees" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_employees_user" ON "employees" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "idx_employees_status" ON "employees" (
	"employment_status"
);
CREATE INDEX IF NOT EXISTS "idx_employee_sessions_active" ON "employee_sessions" (
	"employee_id",
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_employee_audit_log_business" ON "employee_audit_log" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_image_cache_product_id" ON "image_cache" (
	"product_id"
);
CREATE INDEX IF NOT EXISTS "idx_image_cache_business_id" ON "image_cache" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_image_cache_is_uploaded" ON "image_cache" (
	"is_uploaded"
);
CREATE INDEX IF NOT EXISTS "idx_image_sync_queue_completed" ON "image_sync_queue" (
	"completed_at"
);
CREATE INDEX IF NOT EXISTS "idx_kot_stations_business_location" ON "kot_stations" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_kot_printers_business_location" ON "kot_printers" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_kot_printer_stations_business_location" ON "kot_printer_stations" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_kot_item_routing_business_location" ON "kot_item_routing" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_kot_templates_business_location" ON "kot_templates" (
	"business_id",
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_locations_business_id" ON "business_locations" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_locations_active" ON "business_locations" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_pos_devices_location_id" ON "pos_devices" (
	"location_id"
);
CREATE INDEX IF NOT EXISTS "idx_pos_devices_active" ON "pos_devices" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_sync_queue_table" ON "sync_queue" (
	"table_name"
);
CREATE INDEX IF NOT EXISTS "idx_sync_queue_created" ON "sync_queue" (
	"created_at"
);
CREATE INDEX IF NOT EXISTS "idx_orders_business_id" ON "orders" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_orders_status" ON "orders" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_orders_order_number" ON "orders" (
	"order_number"
);
CREATE INDEX IF NOT EXISTS "idx_orders_customer_id" ON "orders" (
	"customer_id"
);
CREATE INDEX IF NOT EXISTS "idx_order_items_order_id" ON "order_items" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_order_payments_order_id" ON "order_payments" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_customers_business" ON "customers" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_customers_code" ON "customers" (
	"business_id",
	"customer_code"
);
CREATE INDEX IF NOT EXISTS "idx_customers_phone" ON "customers" (
	"phone"
);
CREATE INDEX IF NOT EXISTS "idx_customer_groups_business" ON "customer_groups" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_customer_transactions_customer" ON "customer_transactions" (
	"customer_id"
);
CREATE INDEX IF NOT EXISTS "idx_customer_transactions_date" ON "customer_transactions" (
	"transaction_date"
);
CREATE INDEX IF NOT EXISTS "idx_tax_groups_business" ON "tax_groups" (
	"business_id"
);
CREATE INDEX IF NOT EXISTS "idx_tax_rates_group" ON "tax_rates" (
	"tax_group_id"
);
CREATE INDEX IF NOT EXISTS "idx_product_taxes_product" ON "product_taxes" (
	"product_id"
);
CREATE INDEX IF NOT EXISTS "idx_category_taxes_category" ON "category_taxes" (
	"category_id"
);
CREATE TRIGGER kot_printers_one_default
AFTER UPDATE OF is_default ON kot_printers
WHEN NEW.is_default = 1
BEGIN
  UPDATE kot_printers
  SET is_default = 0
  WHERE business_id = NEW.business_id
    AND location_id = NEW.location_id
    AND id <> NEW.id;
END;
CREATE TRIGGER kot_templates_one_default
AFTER UPDATE OF is_default ON kot_templates
WHEN NEW.is_default = 1
BEGIN
  UPDATE kot_templates
  SET is_default = 0
  WHERE business_id = NEW.business_id
    AND location_id = NEW.location_id
    AND type = NEW.type
    AND id <> NEW.id;
END;
COMMIT;
