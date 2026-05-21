WITH ordertotals AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY o.customer_id, o.order_id
)
SELECT
    c.customer_name,
    sub.total_revenue
FROM customers c
JOIN (
    SELECT customer_id,SUM(order_revenue) AS total_revenue
    FROM ordertotals
    GROUP BY customer_id
) AS sub ON c.customer_id = sub.customer_id
ORDER BY sub.total_revenue DESC;
