CREATE VIEW v_brand_summary AS
SELECT
    brand,
    SUM(quantity) AS total_units_sold,
    SUM(quantity * item_price) AS total_revenue
FROM order_items
JOIN products USING (product_id)
GROUP BY brand;

CREATE MATERIALIZED VIEW mv_brand_summary AS
SELECT
    brand,
    SUM(quantity) AS total_units_sold,
    SUM(quantity * item_price) AS total_revenue
FROM order_items
JOIN products USING (product_id)
GROUP BY brand;

SELECT 'Standard View Baseline' AS view_type, brand, total_units_sold, total_revenue
FROM v_brand_summary
WHERE brand = 'Willow'

UNION ALL

SELECT 'Materialized View Baseline', brand, total_units_sold, total_revenue
FROM mv_brand_summary
WHERE brand = 'Willow';

-- 1. Add a new customer
INSERT INTO users (user_id, name, email)
VALUES ('usr_willow_test', 'Willow Tester', 'willow.test@example.com');

-- 2. Add a new master transaction record
INSERT INTO orders (order_id, user_id, order_date, order_status)
VALUES ('ord_willow_test', 'usr_willow_test', '2025-06-01 10:00:00', 'completed');

-- 3. Introduce the new 'Willow' brand into the product catalog
INSERT INTO products (product_id, product_name, category, brand, price, rating)
VALUES ('prod_willow_test', 'Willow Eco Desk', 'Furniture', 'Willow', 250.00, 5.0);

-- 4. Create the corresponding purchase line item
INSERT INTO order_items (order_item_id, order_id, order_date, product_id, quantity, item_price)
VALUES ('item_willow_test', 'ord_willow_test', '2025-06-01 10:00:00', 'prod_willow_test', 1, 250.00);

SELECT 'Standard View Post-Insert' AS view_type, brand, total_units_sold, total_revenue
FROM v_brand_summary WHERE brand = 'Willow'
UNION ALL
SELECT 'Materialized View Post-Insert', brand, total_units_sold, total_revenue
FROM mv_brand_summary WHERE brand = 'Willow';

REFRESH MATERIALIZED VIEW mv_brand_summary;

SELECT 'Standard View Final' AS view_type, brand, total_units_sold, total_revenue
FROM v_brand_summary WHERE brand = 'Willow'
UNION ALL
SELECT 'Materialized View Final', brand, total_units_sold, total_revenue
FROM mv_brand_summary WHERE brand = 'Willow';
