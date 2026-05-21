WITH ranked_products AS (
    SELECT category,product_name,item_price,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY item_price DESC) AS product_rank
    FROM ecom_sales
    WHERE order_status = 'completed'
    GROUP BY category, product_name,item_price
)
SELECT category, product_name, item_price, DENSE_RANK() OVER (PARTITION BY category ORDER BY item_price DESC) AS product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY category ASC,product_rank ASC;