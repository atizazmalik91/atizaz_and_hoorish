-- ============================================================
--  KIFAYAT AUTO PARTS — E-Commerce Database
--  Milestone 4: DDL Scripts
--  Database: MySQL 8.x / MariaDB 10.6+
--  Author : Atizaz Shah & Hoorish Kiyani  |  BSSE-A
--  Date   : 2026
-- ============================================================
--  Load order (foreign-key dependency):
--    1. categories
--    2. customers
--    3. products       (FK → categories)
--    4. orders         (FK → customers)
--    5. order_items    (FK → orders, products)
-- ============================================================

-- ── Safety guards ─────────────────────────────────────────
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
--  1. CATEGORIES
-- ============================================================
CREATE TABLE categories (
    category_id    INT            NOT NULL AUTO_INCREMENT,
    category_name  VARCHAR(100)   NOT NULL,
    description    TEXT           NULL,

    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);

-- Index: category_name is used in JOIN / GROUP BY queries
CREATE INDEX idx_categories_name ON categories (category_name);

-- ============================================================
--  2. CUSTOMERS
-- ============================================================
CREATE TABLE customers (
    customer_id      INT           NOT NULL AUTO_INCREMENT,
    full_name        VARCHAR(100)  NOT NULL,
    email            VARCHAR(100)  NOT NULL,
    phone            VARCHAR(20)   NULL,
    city             VARCHAR(100)  NULL,
    role             VARCHAR(20)   NOT NULL DEFAULT 'customer',
    is_active        TINYINT(1)    NOT NULL DEFAULT 1,
    registered_date  DATE          NOT NULL,

    CONSTRAINT pk_customers  PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT chk_customers_role
        CHECK (role IN ('customer', 'admin')),
    CONSTRAINT chk_customers_active
        CHECK (is_active IN (0, 1))
);

-- Indexes: email (login lookup), city (regional reports), role (admin filter)
CREATE INDEX idx_customers_email ON customers (email);
CREATE INDEX idx_customers_city  ON customers (city);
CREATE INDEX idx_customers_role  ON customers (role);

-- ============================================================
--  3. PRODUCTS
-- ============================================================
CREATE TABLE products (
    product_id         INT             NOT NULL AUTO_INCREMENT,
    category_id        INT             NOT NULL,
    product_name       VARCHAR(200)    NOT NULL,
    avg_cost_price     DECIMAL(10, 2)  NULL,
    avg_selling_price  DECIMAL(10, 2)  NOT NULL,
    stock_qty          INT             NOT NULL DEFAULT 0,
    times_sold         INT             NOT NULL DEFAULT 0,
    is_active          TINYINT(1)      NOT NULL DEFAULT 1,

    CONSTRAINT pk_products      PRIMARY KEY (product_id),
    CONSTRAINT fk_products_cat  FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_products_selling_price
        CHECK (avg_selling_price > 0),
    CONSTRAINT chk_products_cost_price
        CHECK (avg_cost_price IS NULL OR avg_cost_price >= 0),
    CONSTRAINT chk_products_stock
        CHECK (stock_qty >= 0),
    CONSTRAINT chk_products_times_sold
        CHECK (times_sold >= 0),
    CONSTRAINT chk_products_active
        CHECK (is_active IN (0, 1))
);

-- Indexes: FK column + frequently queried columns
CREATE INDEX idx_products_category_id     ON products (category_id);
CREATE INDEX idx_products_is_active       ON products (is_active);
CREATE INDEX idx_products_times_sold      ON products (times_sold DESC);
CREATE INDEX idx_products_avg_sell_price  ON products (avg_selling_price);

-- ============================================================
--  4. ORDERS
-- ============================================================
CREATE TABLE orders (
    order_id        INT             NOT NULL AUTO_INCREMENT,
    customer_id     INT             NOT NULL,
    order_date      DATE            NOT NULL,
    items_count     INT             NOT NULL DEFAULT 0,
    total_cost      DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    total_revenue   DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    total_profit    DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    status          VARCHAR(30)     NOT NULL DEFAULT 'pending',
    payment_method  VARCHAR(30)     NOT NULL,

    CONSTRAINT pk_orders          PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_orders_status
        CHECK (status IN ('pending', 'confirmed', 'delivered')),
    CONSTRAINT chk_orders_payment
        CHECK (payment_method IN ('cash_on_delivery', 'bank_transfer')),
    CONSTRAINT chk_orders_items_count
        CHECK (items_count >= 0),
    CONSTRAINT chk_orders_total_cost
        CHECK (total_cost >= 0),
    CONSTRAINT chk_orders_total_revenue
        CHECK (total_revenue >= 0)
);

-- Indexes: FK + frequent query columns
CREATE INDEX idx_orders_customer_id  ON orders (customer_id);
CREATE INDEX idx_orders_order_date   ON orders (order_date);
CREATE INDEX idx_orders_status       ON orders (status);
CREATE INDEX idx_orders_payment      ON orders (payment_method);

-- ============================================================
--  5. ORDER_ITEMS
-- ============================================================
CREATE TABLE order_items (
    item_id        INT             NOT NULL AUTO_INCREMENT,
    order_id       INT             NOT NULL,
    product_id     INT             NOT NULL,
    product_name   VARCHAR(200)    NOT NULL,
    cost_price     DECIMAL(10, 2)  NULL,
    selling_price  DECIMAL(10, 2)  NOT NULL,
    profit         DECIMAL(10, 2)  NULL,
    sale_date      DATE            NOT NULL,

    CONSTRAINT pk_order_items         PRIMARY KEY (item_id),
    CONSTRAINT fk_order_items_order   FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_order_items_selling_price
        CHECK (selling_price > 0),
    CONSTRAINT chk_order_items_cost_price
        CHECK (cost_price IS NULL OR cost_price >= 0)
);

-- Indexes: both FK columns + sale_date for date-range reports
CREATE INDEX idx_order_items_order_id    ON order_items (order_id);
CREATE INDEX idx_order_items_product_id  ON order_items (product_id);
CREATE INDEX idx_order_items_sale_date   ON order_items (sale_date);

-- ============================================================
--  VERIFICATION QUERIES
--  Run these after executing the DDL to confirm correctness
-- ============================================================

-- Check all 5 tables were created
-- SHOW TABLES;

-- Confirm column definitions and constraints
-- DESCRIBE categories;
-- DESCRIBE customers;
-- DESCRIBE products;
-- DESCRIBE orders;
-- DESCRIBE order_items;

-- Confirm foreign keys
-- SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
--   FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
--  WHERE TABLE_SCHEMA = DATABASE()
--    AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Confirm indexes
-- SHOW INDEX FROM products;
-- SHOW INDEX FROM orders;
-- SHOW INDEX FROM order_items;

-- ============================================================
--  END OF DDL SCRIPT
-- ============================================================
