-- 1. The Trigger Function
CREATE OR REPLACE FUNCTION check_order_modification_eligibility()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_status order_status_enum;
BEGIN
    -- Look up the current status of the parent order using the incoming NEW data
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE order_id = NEW.order_id
      AND order_date = NEW.order_date;

    -- If the order is already finalized, block any insert or update
    IF v_current_status IN ('completed', 'shipped') THEN
        RAISE EXCEPTION 'Cannot modify items. The parent order status is already: %', v_current_status;
    END IF;

    -- Return NEW to allow the insert or update operation to proceed
    RETURN NEW;
END;
$$;

-- 2. The Trigger Binding (Listening to INSERT OR UPDATE at the ROW level)
CREATE OR REPLACE TRIGGER trg_prevent_isolated_order_items
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION check_order_modification_eligibility();


INSERT INTO order_items (order_item_id, order_id,order_date,
    product_id,quantity,item_price)
VALUES ('TEST_OK_1','O00000017','2024-08-05 20:28:39.309665',
    'P000001',2,50.00);


INSERT INTO order_items (order_item_id,order_id,order_date,product_id,quantity,item_price
)
VALUES ('TEST_FAIL_1','O00000006',
    '2024-10-13 09:02:26.848944','P000001',
    1,25.00);
