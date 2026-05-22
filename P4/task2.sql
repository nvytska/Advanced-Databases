SELECT 'users' AS layer, count(*) FROM users
UNION ALL
SELECT 'products' AS layer, count(*) FROM products
UNION ALL
SELECT 'orders (master table)' AS layer, count(*) FROM orders
UNION ALL
SELECT 'orders_2024 (child partition)' AS layer, count(*) FROM orders_2024
UNION ALL
SELECT 'orders_2025 (child partition)' AS layer, count(*) FROM orders_2025
UNION ALL
SELECT 'order_items' AS layer, count(*) FROM order_items;

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date >= '2024-06-01 00:00:00' AND order_date < '2024-07-01 00:00:00';

