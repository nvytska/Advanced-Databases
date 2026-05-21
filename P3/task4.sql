SELECT order_date, customer_email,(quantity * item_price) AS order_revenue,
SUM(quantity * item_price) OVER w AS cumulative_spend,
COUNT(order_id) OVER w AS running_order_count
FROM ecom_sales
WHERE order_status = 'completed'
WINDOW w AS (
    PARTITION BY customer_email
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
);