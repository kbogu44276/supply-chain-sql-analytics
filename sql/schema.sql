PRAGMA foreign_keys = ON;
CREATE TABLE suppliers(supplier_id INTEGER PRIMARY KEY, supplier_name TEXT NOT NULL, lead_time_days INTEGER NOT NULL CHECK(lead_time_days>0));
CREATE TABLE warehouses(warehouse_id INTEGER PRIMARY KEY, warehouse_name TEXT NOT NULL);
CREATE TABLE products(product_id INTEGER PRIMARY KEY, product_name TEXT NOT NULL, category TEXT NOT NULL, unit_cost REAL NOT NULL CHECK(unit_cost>=0));
CREATE TABLE purchase_orders(order_id INTEGER PRIMARY KEY, supplier_id INTEGER NOT NULL REFERENCES suppliers(supplier_id), warehouse_id INTEGER NOT NULL REFERENCES warehouses(warehouse_id), order_date TEXT NOT NULL);
CREATE TABLE order_lines(line_id INTEGER PRIMARY KEY, order_id INTEGER NOT NULL REFERENCES purchase_orders(order_id), product_id INTEGER NOT NULL REFERENCES products(product_id), quantity INTEGER NOT NULL CHECK(quantity>0));
CREATE TABLE deliveries(delivery_id INTEGER PRIMARY KEY, order_id INTEGER NOT NULL UNIQUE REFERENCES purchase_orders(order_id), promised_date TEXT NOT NULL, actual_date TEXT NOT NULL);
CREATE TABLE inventory(warehouse_id INTEGER NOT NULL REFERENCES warehouses(warehouse_id), product_id INTEGER NOT NULL REFERENCES products(product_id), on_hand INTEGER NOT NULL CHECK(on_hand>=0), PRIMARY KEY(warehouse_id,product_id));
