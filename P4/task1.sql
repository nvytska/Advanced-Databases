CREATE TABLE users (
    user_id VARCHAR PRIMARY KEY,
    name VARCHAR,
    email VARCHAR UNIQUE
);

CREATE TABLE products (
    product_id VARCHAR PRIMARY KEY,
    product_name VARCHAR,
    category VARCHAR,
    brand VARCHAR,
    price DECIMAL CHECK (price > 0),
    rating FLOAT CHECK (rating BETWEEN 0 AND 5)
);

-- Define custom ENUM type for order lifecycle states
CREATE TYPE order_status_enum AS ENUM ('shipped', 'processing', 'completed', 'cancelled', 'returned');

-- Define the Partitioned Master Orders Table
CREATE TABLE orders (
    order_id     VARCHAR(50) NOT NULL,
    user_id      VARCHAR(50) NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    order_date   TIMESTAMP NOT NULL,
    order_status order_status_enum NOT NULL,
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

-- Create physical standalone child partitions for 2024 and 2025
CREATE TABLE orders_2024 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');

CREATE TABLE orders_2025 PARTITION OF orders
    FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2026-01-01 00:00:00');

CREATE TABLE order_items (
    order_item_id VARCHAR PRIMARY KEY,
    order_id VARCHAR NOT NULL,
    order_date TIMESTAMP NOT NULL,
    product_id VARCHAR NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    item_price DECIMAL NOT NULL CHECK (item_price >= 0),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT,

    FOREIGN KEY (order_id, order_date)
        REFERENCES orders(order_id, order_date)
        ON DELETE CASCADE
);
