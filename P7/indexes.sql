CREATE INDEX idx_transactions_analytics_filter
ON transactions (
    customer_id,
    event_time)
INCLUDE (txn_id,product_id,store_id,
    staff_id,quantity,payment_method
)
WHERE quantity > 0 AND payment_method IN ('Card', 'Cash', 'Apple Pay', 'Google Pay');

CREATE INDEX idx_customers_analytics_filter
ON customers (loyalty_tier,registration_date,customer_id)
INCLUDE (first_name,last_name,email,phone,
    date_of_birth,gender,city,postcode,country
)
WHERE loyalty_tier IN ('Silver', 'Gold', 'Platinum');

CREATE INDEX idx_customers_lower_email
ON customers (LOWER(email));

CREATE INDEX idx_customers_dob
ON customers (date_of_birth);