SELECT category,SUM(quantity) AS total_items_sold,
SUM(quantity * item_price) AS total_revenue,
AVG(item_price) AS average_item_price
FROM ecom_sales
WHERE order_status = 'completed'
GROUP BY category
HAVING SUM(quantity) > 3
ORDER BY total_revenue DESC;