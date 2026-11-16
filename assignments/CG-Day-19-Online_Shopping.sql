
-- =========================================================
-- PROJECT: COMPLETE ONLINE SHOPPING DATABASE AUTOMATION
-- DATABASE: MYSQL 8.0+
-- =========================================================


-- PART 1: DATABASE CREATION

CREATE DATABASE IF NOT EXISTS online_shopping_db;

USE online_shopping_db;


-- =========================================================
-- PART 2: TABLE CREATION
-- =========================================================


-- 1. CUSTOMERS TABLE

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    mobile VARCHAR(15),
    city VARCHAR(50),
    wallet_balance DECIMAL(10,2) DEFAULT 0
) ENGINE=InnoDB;


-- 2. PRODUCTS TABLE

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    status VARCHAR(20)
) ENGINE=InnoDB;


-- 3. ORDERS TABLE

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2) DEFAULT 0,
    order_status VARCHAR(30) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
) ENGINE=InnoDB;


-- 4. ORDER ITEMS TABLE

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2),

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
) ENGINE=InnoDB;


-- 5. PAYMENTS TABLE

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
) ENGINE=InnoDB;


-- 6. STOCK HISTORY TABLE

CREATE TABLE stock_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    old_stock INT,
    new_stock INT,
    change_type VARCHAR(40),
    changed_at DATETIME,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
) ENGINE=InnoDB;


-- 7. ORDER AUDIT TABLE

CREATE TABLE order_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_at DATETIME
) ENGINE=InnoDB;


-- 8. DELETED ORDER ITEMS TABLE

CREATE TABLE deleted_order_items (
    delete_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    order_id INT,
    product_id INT,
    deleted_quantity INT,
    subtotal DECIMAL(10,2),
    deleted_at DATETIME
) ENGINE=InnoDB;


-- =========================================================
-- PART 3: INSERT SAMPLE RECORDS
-- =========================================================


-- CUSTOMERS

INSERT INTO customers VALUES
(1, 'Rahul', 'rahul@gmail.com', '9876543210', 'Hyderabad', 5000),
(2, 'Priya', 'priya@gmail.com', '9876543211', 'Chennai', 8000),
(3, 'Arjun', 'arjun@gmail.com', '9876543212', 'Bangalore', 3000),
(4, 'Sneha', 'sneha@gmail.com', '9876543213', 'Vizag', 10000),
(5, 'Kiran', 'kiran@gmail.com', '9876543214', 'Pune', 2000);


-- PRODUCTS

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000, 20, 'AVAILABLE'),
(102, 'Mobile', 'Electronics', 25000, 15, 'AVAILABLE'),
(103, 'Headphones', 'Accessories', 2000, 50, 'AVAILABLE'),
(104, 'Keyboard', 'Accessories', 1500, 30, 'AVAILABLE'),
(105, 'Smart Watch', 'Electronics', 5000, 10, 'AVAILABLE'),
(106, 'Monitor', 'Electronics', 12000, 0, 'OUT_OF_STOCK'),
(107, 'Mouse', 'Accessories', 800, 40, 'AVAILABLE');


-- ORDERS

INSERT INTO orders VALUES
(1001, 1, CURDATE(), 0, 'PLACED'),
(1002, 2, CURDATE(), 0, 'PLACED'),
(1003, 3, CURDATE(), 0, 'PLACED'),
(1004, 4, CURDATE(), 0, 'PLACED'),
(1005, 5, CURDATE(), 0, 'PLACED');


-- =========================================================
-- PART 4: TRIGGER IMPLEMENTATION
-- =========================================================

DELIMITER $$


-- ---------------------------------------------------------
-- TRIGGER 1: BEFORE INSERT ON PRODUCTS
-- PRODUCT PRICE AND STOCK VALIDATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_product_validation
BEFORE INSERT ON products
FOR EACH ROW
BEGIN

    IF NEW.price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product price must be greater than zero';

    END IF;

    IF NEW.stock_quantity < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product stock cannot be negative';

    END IF;

    IF NEW.stock_quantity = 0 THEN
        SET NEW.status = 'OUT_OF_STOCK';
    ELSE
        SET NEW.status = 'AVAILABLE';
    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 2: BEFORE UPDATE ON PRODUCTS
-- VALIDATE PRICE AND STOCK
-- ---------------------------------------------------------

CREATE TRIGGER trg_product_update_validation
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN

    IF NEW.price < 100 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product price cannot be below 100';

    END IF;

    IF NEW.stock_quantity < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product stock cannot become negative';

    END IF;

    IF NEW.stock_quantity = 0 THEN
        SET NEW.status = 'OUT_OF_STOCK';
    ELSE
        SET NEW.status = 'AVAILABLE';
    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 3: AFTER UPDATE ON PRODUCTS
-- AUTOMATIC STOCK HISTORY
-- ---------------------------------------------------------

CREATE TRIGGER trg_product_stock_history
AFTER UPDATE ON products
FOR EACH ROW
BEGIN

    IF OLD.stock_quantity <> NEW.stock_quantity THEN

        INSERT INTO stock_history
        (
            product_id,
            old_stock,
            new_stock,
            change_type,
            changed_at
        )
        VALUES
        (
            NEW.product_id,
            OLD.stock_quantity,
            NEW.stock_quantity,
            COALESCE(@stock_change_type, 'MANUAL_UPDATE'),
            NOW()
        );

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 4: BEFORE INSERT ON CUSTOMERS
-- WALLET VALIDATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_customer_wallet_validation
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN

    IF NEW.wallet_balance < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Wallet balance cannot be negative';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 5: BEFORE INSERT ON ORDER_ITEMS
-- QUANTITY, ORDER AND STOCK VALIDATION
-- AUTOMATIC SUBTOTAL CALCULATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_item_validation
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN

    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_status VARCHAR(30) DEFAULT NULL;

    IF NEW.quantity <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Quantity must be greater than zero';

    END IF;

    IF NEW.unit_price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Unit price must be greater than zero';

    END IF;

    SELECT stock_quantity
    INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id
    FOR UPDATE;

    IF v_stock IS NULL OR NEW.quantity > v_stock THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Insufficient stock or invalid product';

    END IF;

    SELECT order_status
    INTO v_status
    FROM orders
    WHERE order_id = NEW.order_id;

    IF v_status IS NULL OR v_status <> 'PLACED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Items can only be added to placed orders';

    END IF;

    SET NEW.subtotal =
        NEW.quantity * NEW.unit_price;

END$$


-- ---------------------------------------------------------
-- TRIGGER 6: AFTER INSERT ON ORDER_ITEMS
-- AUTOMATIC STOCK REDUCTION
-- ---------------------------------------------------------

CREATE TRIGGER trg_reduce_product_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN

    SET @stock_change_type = 'PURCHASE';

    UPDATE products
    SET stock_quantity =
        stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;

    SET @stock_change_type = NULL;

END$$


-- ---------------------------------------------------------
-- TRIGGER 7: AFTER INSERT ON ORDER_ITEMS
-- AUTOMATIC ORDER TOTAL CALCULATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_calculate_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN

    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;

END$$


-- ---------------------------------------------------------
-- TRIGGER 8: BEFORE UPDATE ON ORDER_ITEMS
-- VALIDATE AND RECALCULATE SUBTOTAL
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_item_update_validation
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN

    DECLARE v_stock INT DEFAULT NULL;

    IF NEW.quantity <= 0 OR NEW.unit_price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Quantity and unit price must be positive';

    END IF;

    IF NEW.product_id <> OLD.product_id
       OR NEW.order_id <> OLD.order_id THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Changing product or order is not allowed';

    END IF;

    IF NEW.quantity > OLD.quantity THEN

        SELECT stock_quantity
        INTO v_stock
        FROM products
        WHERE product_id = OLD.product_id
        FOR UPDATE;

        IF v_stock IS NULL
           OR NEW.quantity - OLD.quantity > v_stock THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Insufficient stock for quantity increase';

        END IF;

    END IF;

    SET NEW.subtotal =
        NEW.quantity * NEW.unit_price;

END$$


-- ---------------------------------------------------------
-- TRIGGER 9: AFTER UPDATE ON ORDER_ITEMS
-- UPDATE STOCK AND ORDER TOTAL
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_item_after_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN

    IF NEW.quantity <> OLD.quantity THEN

        SET @stock_change_type = 'PURCHASE';

        UPDATE products
        SET stock_quantity =
            stock_quantity + OLD.quantity - NEW.quantity
        WHERE product_id = OLD.product_id;

        SET @stock_change_type = NULL;

    END IF;

    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;

END$$


-- ---------------------------------------------------------
-- TRIGGER 10: BEFORE INSERT ON PAYMENTS
-- PAYMENT AND WALLET VALIDATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_payment_validation
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN

    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_customer INT;
    DECLARE v_total DECIMAL(10,2);

    IF NEW.payment_amount <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Payment amount must be positive';

    END IF;

    IF NEW.payment_method NOT IN
       ('UPI', 'CARD', 'NETBANKING', 'WALLET') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid payment method';

    END IF;

    IF NEW.payment_status = 'SUCCESS' THEN

        SELECT customer_id, total_amount
        INTO v_customer, v_total
        FROM orders
        WHERE order_id = NEW.order_id
        FOR UPDATE;

        IF v_customer IS NULL THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Invalid order';

        END IF;

        IF v_customer <> NEW.customer_id THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Customer does not own this order';

        END IF;

        IF NEW.payment_amount <> v_total THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Payment amount must match order total';

        END IF;

        IF NEW.payment_method = 'WALLET' THEN

            SELECT wallet_balance
            INTO v_balance
            FROM customers
            WHERE customer_id = NEW.customer_id
            FOR UPDATE;

            IF v_balance IS NULL
               OR v_balance < NEW.payment_amount THEN

                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Insufficient wallet balance';

            END IF;

        END IF;

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 11: AFTER INSERT ON PAYMENTS
-- WALLET DEDUCTION AND ORDER CONFIRMATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN

    IF NEW.payment_status = 'SUCCESS' THEN

        IF NEW.payment_method = 'WALLET' THEN

            UPDATE customers
            SET wallet_balance =
                wallet_balance - NEW.payment_amount
            WHERE customer_id = NEW.customer_id;

        END IF;

        UPDATE orders
        SET order_status = 'CONFIRMED'
        WHERE order_id = NEW.order_id
        AND order_status = 'PLACED';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 12: BEFORE UPDATE ON PAYMENTS
-- PREVENT INVALID PAYMENT STATUS CHANGES
-- ---------------------------------------------------------

CREATE TRIGGER trg_payment_update_validation
BEFORE UPDATE ON payments
FOR EACH ROW
BEGIN

    IF OLD.payment_status = 'SUCCESS'
       AND NEW.payment_status <> 'SUCCESS' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Successful payment status cannot be changed';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 13: BEFORE UPDATE ON ORDERS
-- ORDER STATUS VALIDATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_update_validation
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN

    IF OLD.order_status = 'DELIVERED'
       AND NEW.order_status <> 'DELIVERED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Delivered orders cannot be modified';

    END IF;

    IF NEW.order_status = 'CANCELLED'
       AND OLD.order_status IN
       ('SHIPPED', 'DELIVERED') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Shipped or delivered orders cannot be cancelled';

    END IF;

    IF NEW.order_status NOT IN
       ('PLACED', 'CONFIRMED', 'SHIPPED',
        'DELIVERED', 'CANCELLED') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid order status';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 14: AFTER UPDATE ON ORDERS
-- ORDER AUDIT AND CANCELLATION STOCK RESTORATION
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_after_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN

    DECLARE v_done INT DEFAULT 0;
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;

    DECLARE order_cursor CURSOR FOR
        SELECT product_id, quantity
        FROM order_items
        WHERE order_id = NEW.order_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;


    -- RECORD ORDER STATUS HISTORY

    IF OLD.order_status <> NEW.order_status THEN

        INSERT INTO order_audit
        (
            order_id,
            old_status,
            new_status,
            changed_at
        )
        VALUES
        (
            NEW.order_id,
            OLD.order_status,
            NEW.order_status,
            NOW()
        );

    END IF;


    -- RESTORE STOCK WHEN ORDER IS CANCELLED

    IF NEW.order_status = 'CANCELLED'
       AND OLD.order_status <> 'CANCELLED' THEN

        OPEN order_cursor;

        stock_loop: LOOP

            FETCH order_cursor
            INTO v_product_id, v_quantity;

            IF v_done = 1 THEN
                LEAVE stock_loop;
            END IF;

            SET @stock_change_type = 'CANCELLATION_RESTORE';

            UPDATE products
            SET stock_quantity =
                stock_quantity + v_quantity
            WHERE product_id = v_product_id;

            SET @stock_change_type = NULL;

        END LOOP;

        CLOSE order_cursor;

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 15: BEFORE DELETE ON ORDER_ITEMS
-- PREVENT INVALID ITEM DELETION
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_item_delete_validation
BEFORE DELETE ON order_items
FOR EACH ROW
BEGIN

    DECLARE v_status VARCHAR(30);

    SELECT order_status
    INTO v_status
    FROM orders
    WHERE order_id = OLD.order_id;

    IF v_status <> 'PLACED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Items can only be deleted from placed orders';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 16: AFTER DELETE ON ORDER_ITEMS
-- RESTORE STOCK, UPDATE TOTAL AND SAVE HISTORY
-- ---------------------------------------------------------

CREATE TRIGGER trg_order_item_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN

    -- RESTORE STOCK

    SET @stock_change_type = 'ITEM_DELETION_RESTORE';

    UPDATE products
    SET stock_quantity =
        stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;

    SET @stock_change_type = NULL;


    -- RECALCULATE ORDER TOTAL

    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM order_items
        WHERE order_id = OLD.order_id
    )
    WHERE order_id = OLD.order_id;


    -- RECORD DELETED ITEM

    INSERT INTO deleted_order_items
    (
        item_id,
        order_id,
        product_id,
        deleted_quantity,
        subtotal,
        deleted_at
    )
    VALUES
    (
        OLD.item_id,
        OLD.order_id,
        OLD.product_id,
        OLD.quantity,
        OLD.subtotal,
        NOW()
    );

END$$


-- ---------------------------------------------------------
-- TRIGGER 17: BEFORE DELETE ON PRODUCTS
-- PREVENT PRODUCT DELETION IN ACTIVE ORDERS
-- ---------------------------------------------------------

CREATE TRIGGER trg_product_delete_validation
BEFORE DELETE ON products
FOR EACH ROW
BEGIN

    IF EXISTS (
        SELECT 1
        FROM order_items oi
        INNER JOIN orders o
        ON oi.order_id = o.order_id
        WHERE oi.product_id = OLD.product_id
        AND o.order_status <> 'CANCELLED'
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product is associated with an active order';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 18: BEFORE DELETE ON CUSTOMERS
-- PREVENT CUSTOMER DELETION WITH ACTIVE ORDERS
-- ---------------------------------------------------------

CREATE TRIGGER trg_customer_delete_validation
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN

    IF EXISTS (
        SELECT 1
        FROM orders
        WHERE customer_id = OLD.customer_id
        AND order_status IN
        ('PLACED', 'CONFIRMED', 'SHIPPED')
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Customer has active orders';

    END IF;

END$$


-- ---------------------------------------------------------
-- TRIGGER 19: BEFORE DELETE ON PAYMENTS
-- PREVENT DELETING SUCCESSFUL PAYMENTS
-- ---------------------------------------------------------

CREATE TRIGGER trg_payment_delete_validation
BEFORE DELETE ON payments
FOR EACH ROW
BEGIN

    IF OLD.payment_status = 'SUCCESS' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Successful payments cannot be deleted';

    END IF;

END$$


DELIMITER ;


-- =========================================================
-- PART 5: SUCCESS TEST CASES
-- Execute in the given order.
-- =========================================================


-- SUCCESS 1: ADD A NEW PRODUCT

INSERT INTO products VALUES
(108, 'Tablet', 'Electronics', 15000, 10, 'AVAILABLE');

SELECT * FROM products WHERE product_id = 108;


-- SUCCESS 2: CREATE A NEW ORDER

INSERT INTO orders VALUES
(2001, 1, CURDATE(), 0, 'PLACED');

SELECT * FROM orders WHERE order_id = 2001;


-- SUCCESS 3: ADD AN ITEM TO THE ORDER

INSERT INTO order_items VALUES
(201, 2001, 107, 2, 800, 0);

SELECT * FROM order_items WHERE item_id = 201;


-- SUCCESS 4: VERIFY AUTOMATIC STOCK REDUCTION

SELECT product_id, stock_quantity, status
FROM products WHERE product_id = 107;


-- SUCCESS 5: VERIFY AUTOMATIC ORDER TOTAL

SELECT order_id, total_amount
FROM orders WHERE order_id = 2001;


-- SUCCESS 6: ADD ANOTHER ORDER ITEM

INSERT INTO order_items VALUES
(202, 2001, 103, 1, 2000, 0);

SELECT * FROM order_items WHERE order_id = 2001;


-- SUCCESS 7: MAKE A SUCCESSFUL WALLET PAYMENT

-- Current order total = 3600.
-- Rahul's wallet balance = 5000.

INSERT INTO payments VALUES
(601, 2001, 1, CURDATE(), 3600, 'WALLET', 'SUCCESS');

SELECT wallet_balance
FROM customers WHERE customer_id = 1;

SELECT order_status
FROM orders WHERE order_id = 2001;


-- SUCCESS 8: MANUALLY UPDATE PRODUCT STOCK

UPDATE products
SET stock_quantity = stock_quantity + 5
WHERE product_id = 108;

SELECT * FROM stock_history;


-- SUCCESS 9: UPDATE ORDER ITEM QUANTITY

-- Create another order first.

INSERT INTO orders VALUES
(2002, 2, CURDATE(), 0, 'PLACED');

INSERT INTO order_items VALUES
(203, 2002, 104, 2, 1500, 0);

UPDATE order_items
SET quantity = 3
WHERE item_id = 203;

SELECT * FROM order_items WHERE item_id = 203;


-- SUCCESS 10: DELETE AN ORDER ITEM

DELETE FROM order_items
WHERE item_id = 203;

SELECT * FROM deleted_order_items;

SELECT * FROM orders WHERE order_id = 2002;


-- SUCCESS 11: CANCEL AN ELIGIBLE ORDER

UPDATE orders
SET order_status = 'CANCELLED'
WHERE order_id = 2001;

SELECT * FROM stock_history;

SELECT * FROM order_audit;


-- SUCCESS 12: CHECK ORDER AUDIT

SELECT * FROM order_audit;


-- =========================================================
-- PART 6: FAILURE TEST CASES
-- Execute each query separately.
-- Each query is expected to generate an error.
-- =========================================================


-- FAILURE 1: NEGATIVE PRODUCT PRICE

-- INSERT INTO products VALUES
-- (109, 'Invalid Product', 'Electronics', -500, 10, 'AVAILABLE');


-- FAILURE 2: NEGATIVE PRODUCT STOCK

-- INSERT INTO products VALUES
-- (110, 'Invalid Stock', 'Electronics', 1000, -5, 'AVAILABLE');


-- FAILURE 3: NEGATIVE CUSTOMER WALLET

-- INSERT INTO customers VALUES
-- (6, 'Test User', 'test@gmail.com', '9999999999', 'Delhi', -100);


-- FAILURE 4: ZERO ORDER QUANTITY

-- INSERT INTO order_items VALUES
-- (204, 2002, 107, 0, 800, 0);


-- FAILURE 5: PURCHASE MORE THAN AVAILABLE STOCK

-- INSERT INTO order_items VALUES
-- (205, 2002, 107, 1000, 800, 0);


-- FAILURE 6: PRODUCT PRICE BELOW ₹100

-- UPDATE products
-- SET price = 50
-- WHERE product_id = 108;


-- FAILURE 7: NEGATIVE STOCK UPDATE

-- UPDATE products
-- SET stock_quantity = -10
-- WHERE product_id = 108;


-- FAILURE 8: INVALID PAYMENT AMOUNT

-- INSERT INTO payments VALUES
-- (602, 2001, 1, CURDATE(), -500, 'CARD', 'SUCCESS');


-- FAILURE 9: CANCEL SHIPPED ORDER

-- UPDATE orders
-- SET order_status = 'SHIPPED'
-- WHERE order_id = 2002;

-- UPDATE orders
-- SET order_status = 'CANCELLED'
-- WHERE order_id = 2002;


-- FAILURE 10: DELETE SUCCESSFUL PAYMENT

-- DELETE FROM payments
-- WHERE payment_id = 601;


-- FAILURE 11: DELETE PRODUCT USED IN ACTIVE ORDER

-- DELETE FROM products
-- WHERE product_id = 101;


-- FAILURE 12: DELETE CUSTOMER WITH ACTIVE ORDER

-- DELETE FROM customers
-- WHERE customer_id = 1;


-- FAILURE 13: CHANGE SUCCESSFUL PAYMENT STATUS

-- UPDATE payments
-- SET payment_status = 'FAILED'
-- WHERE payment_id = 601;


-- FAILURE 14: ADD ITEM TO CANCELLED ORDER

-- INSERT INTO order_items VALUES
-- (206, 2001, 107, 1, 800, 0);


-- =========================================================
-- PART 7: FINAL VERIFICATION
-- =========================================================


-- CUSTOMER DETAILS

SELECT * FROM customers;


-- PRODUCT DETAILS

SELECT * FROM products;


-- ORDER DETAILS

SELECT * FROM orders;


-- ORDER ITEM DETAILS

SELECT * FROM order_items;


-- PAYMENT DETAILS

SELECT * FROM payments;


-- STOCK HISTORY

SELECT * FROM stock_history
ORDER BY history_id DESC;


-- ORDER AUDIT HISTORY

SELECT * FROM order_audit
ORDER BY audit_id DESC;


-- DELETED ORDER ITEM HISTORY

SELECT * FROM deleted_order_items;


-- DISPLAY ALL TRIGGERS

SHOW TRIGGERS;


-- DISPLAY SPECIFIC TRIGGER DEFINITION

SHOW CREATE TRIGGER trg_order_item_validation;


-- =========================================================
-- END OF PROJECT
-- =========================================================
