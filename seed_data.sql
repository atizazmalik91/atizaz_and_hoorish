-- ============================================================
--  KIFAYAT AUTO PARTS — Sample Seed Data
--  Milestone 4: DDL Verification
--  Run AFTER schema.sql to confirm all constraints work
-- ============================================================

-- 1. CATEGORIES
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Accessories',        'Vehicle accessories including covers, organizers and misc add-ons'),
(2, 'Cleaning',           'Car cleaning supplies: shampoos, polishes, waxes and microfiber cloths'),
(3, 'Electrical',         'Electrical components: batteries, wiring, lights and fuses'),
(4, 'Exterior',           'Exterior body parts and panels for repair and replacement'),
(5, 'General Auto Parts', 'Common mechanical and replacement parts for everyday vehicle maintenance'),
(6, 'Interior',           'Interior accessories: seat covers, mats, steering covers and dash items'),
(7, 'Mechanical',         'Engine, transmission and drivetrain components'),
(8, 'Paint & Spray',      'Automotive paints, primers, sprays and rust-proofing solutions'),
(9, 'Wheels',             'Tyres, rims, hubcaps and wheel accessories');

-- 2. CUSTOMERS (sample 5)
INSERT INTO customers (customer_id, full_name, email, phone, city, role, is_active, registered_date) VALUES
(1,  'Ali Hassan',     'ali35@gmail.com',          '0325108603', 'Rawalpindi', 'admin',    1, '2018-10-13'),
(2,  'Muhammad Raza',  'muhammad614@gmail.com',     '0331533224', 'Karachi',    'admin',    1, '2018-07-11'),
(3,  'Ahmed Khan',     'ahmed584@gmail.com',        '0318038374', 'Rawalpindi', 'customer', 1, '2020-07-08'),
(4,  'Bilal Sheikh',   'bilal787@gmail.com',        '0318090293', 'Multan',     'customer', 1, '2019-07-24'),
(5,  'Usman Tariq',    'usman456@yahoo.com',        '0312774821', 'Lahore',     'customer', 1, '2021-03-15');

-- 3. PRODUCTS (sample 5)
INSERT INTO products (product_id, category_id, product_name, avg_cost_price, avg_selling_price, stock_qty, times_sold, is_active) VALUES
(1,  1, 'Steering Wheel Cover Leather',  173.22,   337.46,  13,  35, 1),
(2,  1, 'Car Phone Holder Magnetic',     212.32,   402.99,  19,  70, 1),
(11, 3, 'Car Battery 60Ah AGM',         8823.45, 11205.34,   6,  28, 1),
(31, 5, 'Spark Plug NGK Set 4pcs',      1235.88,  2156.72,  22,  91, 1),
(71, 7, 'Shock Absorber Front Toyota',  3622.50,  6188.40,   9,  44, 1);

-- 4. ORDERS (sample 3)
INSERT INTO orders (order_id, customer_id, order_date, items_count, total_cost, total_revenue, total_profit, status, payment_method) VALUES
(1, 3, '2021-06-24', 2,  9059.33, 15608.06,  6548.73, 'delivered',  'cash_on_delivery'),
(2, 4, '2022-03-15', 1,  3622.50,  6188.40,  2565.90, 'confirmed',  'bank_transfer'),
(3, 5, '2023-01-10', 2,  1409.10,  2559.71,  1150.61, 'pending',    'cash_on_delivery');

-- 5. ORDER_ITEMS (sample 4)
INSERT INTO order_items (item_id, order_id, product_id, product_name, cost_price, selling_price, profit, sale_date) VALUES
(1, 1, 11, 'Car Battery 60Ah AGM',          8823.45, 11205.34, 2381.89, '2021-06-24'),
(2, 1,  2, 'Car Phone Holder Magnetic',       235.88,   402.72,  166.84, '2021-06-25'),
(3, 2, 71, 'Shock Absorber Front Toyota',    3622.50,  6188.40, 2565.90, '2022-03-15'),
(4, 3,  1, 'Steering Wheel Cover Leather',    173.22,   337.46,  164.24, '2023-01-10');

-- ── Quick verification selects ──────────────────────────
-- SELECT * FROM categories;
-- SELECT * FROM customers;
-- SELECT * FROM products;
-- SELECT * FROM orders;
-- SELECT * FROM order_items;

-- JOIN test: order with customer name and items
-- SELECT o.order_id, c.full_name, o.order_date, o.total_profit, o.status
--   FROM orders o
--   JOIN customers c ON o.customer_id = c.customer_id;

-- JOIN test: items with product and category
-- SELECT oi.item_id, oi.order_id, p.product_name, cat.category_name,
--        oi.selling_price, oi.profit
--   FROM order_items oi
--   JOIN products p  ON oi.product_id  = p.product_id
--   JOIN categories cat ON p.category_id = cat.category_id;
