SELECT COALESCE(category, 'ALL CATEGORIES') AS category,
COALESCE(brand, 'ALL BRANDS') AS brand,
SUM(quantity * item_price) AS total_revenue
FROM ecom_sales
WHERE order_status = 'completed'
GROUP BY GROUPING SETS (
    (category, brand),
    (category), ()
)
ORDER BY category ASC, total_revenue DESC;