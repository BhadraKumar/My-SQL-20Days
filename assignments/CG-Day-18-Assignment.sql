
-- ============================================================
-- MYSQL ASSIGNMENT: REAL-TIME TRIGGER IMPLEMENTATION
-- ============================================================

-- PART 1: DATABASE CREATION

CREATE DATABASE ecommerce_trigger_db;
USE ecommerce_trigger_db;


-- 1. CUSTOMERS TABLE

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    mobile VARCHAR(15),
    city VARCHAR(50),
    wallet_balance DECIMAL(10,2)
);


-- 2. PRODUCTS TABLE

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    status VARCHAR(20)
);


-- 3. ORDERS TABLE

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


-- 4. ORDER_ITEMS TABLE

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
);


-- 5. PAYMENTS TABLE

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    customer_id INT,
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


-- 6. STOCK_HISTORY TABLE

CREATE TABLE stock_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    old_stock INT,
    new_stock INT,
    change_type VARCHAR(30),
    changed_at DATETIME,
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);


-- 7. ORDER_AUDIT TABLE

CREATE TABLE order_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_at DATETIME
);


-- PART 2: INSERT SAMPLE RECORDS

INSERT INTO customers VALUES
(1, 'Rahul', 'rahul@gmail.com', '9876543210', 'Hyderabad', 5000),
(2, 'Priya', 'priya@gmail.com', '9876543211', 'Chennai', 8000),
(3, 'Arjun', 'arjun@gmail.com', '9876543212', 'Bangalore', 3000),
(4, 'Sneha', 'sneha@gmail.com', '9876543213', 'Vizag', 10000),
(5, 'Kiran', 'kiran@gmail.com', '9876543214', 'Pune', 2000);


INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000, 20, 'AVAILABLE'),
(102, 'Mobile', 'Electronics', 25000, 15, 'AVAILABLE'),
(103, 'Headphones', 'Accessories', 2000, 50, 'AVAILABLE'),
(104, 'Keyboard', 'Accessories', 1500, 30, 'AVAILABLE'),
(105, 'Smart Watch', 'Electronics', 5000, 10, 'AVAILABLE'),
(106, 'Monitor', 'Electronics', 12000, 0, 'OUT_OF_STOCK'),
(107, 'Mouse', 'Accessories', 800, 40, 'AVAILABLE');


INSERT INTO orders VALUES
(1001, 1, '2026-11-01', 57000, 'PLACED'),
(1002, 2, '2026-11-02', 25000, 'CONFIRMED'),
(1003, 3, '2026-11-03', 7000, 'SHIPPED'),
(1004, 4, '2026-11-04', 12000, 'DELIVERED'),
(1005, 5, '2026-11-05', 5000, 'CANCELLED');


INSERT INTO order_items VALUES
(1, 1001, 101, 1, 55000, 55000),
(2, 1001, 103, 1, 2000, 2000),
(3, 1002, 102, 1, 25000, 25000),
(4, 1003, 105, 1, 5000, 5000),
(5, 1003, 107, 2, 800, 1600),
(6, 1004, 104, 8, 1500, 12000),
(7, 1005, 105, 1, 5000, 5000);


INSERT INTO payments VALUES
(501, 1001, '2026-11-01', 57000, 'UPI', 'SUCCESS', 1),
(502, 1002, '2026-11-02', 25000, 'CARD', 'SUCCESS', 2),
(503, 1003, '2026-11-03', 7000, 'NETBANKING', 'SUCCESS', 3),
(504, 1004, '2026-11-04', 12000, 'UPI', 'SUCCESS', 4),
(505, 1005, '2026-11-05', 5000, 'CARD', 'REFUNDED', 5);


-- ============================================================
-- PART 3: TRIGGER ASSIGNMENT QUESTIONS
-- ============================================================

-- ------------------------------------------------------------
-- SECTION A: BEFORE INSERT TRIGGERS
-- ------------------------------------------------------------

DELIMITER $$


-- Q1. PRODUCT PRICE VALIDATION

CREATE TRIGGER trg_product_price
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product price must be greater than zero';
    END IF;
END$$


-- Q2. STOCK VALIDATION

CREATE TRIGGER trg_stock_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Stock quantity cannot be negative';
    END IF;
END$$


-- Q3. CUSTOMER WALLET VALIDATION

CREATE TRIGGER trg_wallet_insert
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    IF NEW.wallet_balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Wallet balance cannot be negative';
    END IF;
END$$


-- Q4. ORDER QUANTITY VALIDATION

CREATE TRIGGER trg_quantity_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Order quantity must be greater than zero';
    END IF;
END$$


-- Q5. AUTOMATIC SUBTOTAL CALCULATION

CREATE TRIGGER trg_subtotal_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.quantity * NEW.unit_price;
END$$


-- Q25. VALIDATE AVAILABLE STOCK BEFORE PURCHASE

CREATE TRIGGER trg_check_available_stock
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT stock_quantity
    INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF v_stock IS NULL OR NEW.quantity > v_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Insufficient product stock';
    END IF;
END$$


-- Q10. VALIDATE WALLET PAYMENT BEFORE INSERT

CREATE TRIGGER trg_wallet_payment_check
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_balance DECIMAL(10,2);

    IF NEW.payment_method = 'WALLET'
       AND NEW.payment_status = 'SUCCESS' THEN

        SELECT wallet_balance
        INTO v_balance
        FROM customers
        WHERE customer_id = NEW.customer_id;

        IF v_balance IS NULL
           OR v_balance < NEW.payment_amount THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Insufficient wallet balance';

        END IF;
    END IF;
END$$


-- ------------------------------------------------------------
-- SECTION B: AFTER INSERT TRIGGERS
-- ------------------------------------------------------------


-- Q6, Q7 AND Q25.
-- AUTOMATIC STOCK REDUCTION AND STOCK HISTORY

-- The product AFTER UPDATE trigger below records the stock change.

CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    SET @stock_change_type = 'PURCHASE';

    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity,
        status = CASE
            WHEN stock_quantity - NEW.quantity = 0
            THEN 'OUT_OF_STOCK'
            ELSE 'AVAILABLE'
        END
    WHERE product_id = NEW.product_id;

    SET @stock_change_type = NULL;
END$$


-- Q8. AUTOMATICALLY UPDATE ORDER TOTAL

CREATE TRIGGER trg_order_total_insert
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


-- Q9 AND Q10. PAYMENT STATUS AUTOMATION
-- AND CUSTOMER WALLET DEDUCTION

CREATE TRIGGER trg_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN

    IF NEW.payment_status = 'SUCCESS' THEN

        UPDATE orders
        SET order_status = 'CONFIRMED'
        WHERE order_id = NEW.order_id
        AND order_status = 'PLACED';

        IF NEW.payment_method = 'WALLET' THEN

            UPDATE customers
            SET wallet_balance =
                wallet_balance - NEW.payment_amount
            WHERE customer_id = NEW.customer_id;

        END IF;

    END IF;

    IF NEW.payment_status IN ('FAILED', 'PENDING') THEN

        UPDATE orders
        SET order_status = 'PLACED'
        WHERE order_id = NEW.order_id;

    END IF;

END$$


-- ------------------------------------------------------------
-- SECTION C: BEFORE UPDATE TRIGGERS
-- ------------------------------------------------------------


-- Q11. PREVENT PRODUCT PRICE BELOW ₹100

CREATE TRIGGER trg_price_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.price < 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Product price cannot be below 100';
    END IF;
END$$


-- Q12. PREVENT NEGATIVE STOCK

CREATE TRIGGER trg_stock_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Stock cannot become negative';
    END IF;
END$$


-- Q13. PREVENT ORDER MODIFICATION AFTER DELIVERY

CREATE TRIGGER trg_order_status_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status = 'DELIVERED'
       AND NEW.order_status <> OLD.order_status THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Delivered order status cannot be modified';

    END IF;
END$$


-- Q14. VALIDATE PAYMENT STATUS UPDATES

CREATE TRIGGER trg_payment_status_update
BEFORE UPDATE ON payments
FOR EACH ROW
BEGIN
    IF OLD.payment_status = 'SUCCESS'
       AND NEW.payment_status IN ('PENDING', 'FAILED') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Successful payment cannot be changed to PENDING or FAILED';

    END IF;
END$$


-- Q15. AUTOMATICALLY CALCULATE UPDATED SUBTOTAL

CREATE TRIGGER trg_subtotal_update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 OR NEW.unit_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Quantity and unit price must be positive';
    END IF;

    SET NEW.subtotal = NEW.quantity * NEW.unit_price;
END$$


-- ------------------------------------------------------------
-- SECTION D: AFTER UPDATE TRIGGERS
-- ------------------------------------------------------------


-- Q16. MAINTAIN ORDER STATUS HISTORY

CREATE TRIGGER trg_order_audit
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status <> NEW.order_status THEN

        INSERT INTO order_audit
        (order_id, old_status, new_status, changed_at)

        VALUES
        (NEW.order_id, OLD.order_status,
         NEW.order_status, NOW());

    END IF;
END$$


-- Q17 AND Q25. MAINTAIN PRODUCT STOCK HISTORY
-- ALSO RECORD MANUAL STOCK UPDATES

CREATE TRIGGER trg_stock_history
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.stock_quantity <> NEW.stock_quantity THEN

        INSERT INTO stock_history
        (product_id, old_stock, new_stock,
         change_type, changed_at)

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


-- Q18. AUTOMATICALLY UPDATE ORDER TOTAL
-- WHEN AN EXISTING ITEM IS UPDATED

CREATE TRIGGER trg_order_total_update
AFTER UPDATE ON order_items
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


-- ------------------------------------------------------------
-- SECTION E: BEFORE DELETE TRIGGERS
-- ------------------------------------------------------------


-- Q19. PREVENT PRODUCT DELETION
-- IF PRODUCT IS USED IN ACTIVE ORDERS

CREATE TRIGGER trg_product_delete
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
        'Cannot delete product associated with active orders';

    END IF;
END$$


-- Q20. PREVENT CUSTOMER DELETION
-- IF ACTIVE ORDERS EXIST

CREATE TRIGGER trg_customer_delete
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
        'Customer has active orders and cannot be deleted';

    END IF;
END$$


-- Q21. PREVENT DELETING SUCCESSFUL PAYMENTS

CREATE TRIGGER trg_payment_delete
BEFORE DELETE ON payments
FOR EACH ROW
BEGIN
    IF OLD.payment_status = 'SUCCESS' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Successful payments cannot be deleted';

    END IF;
END$$


-- ------------------------------------------------------------
-- SECTION F: AFTER DELETE TRIGGERS
-- ------------------------------------------------------------


-- Q24. CREATE DELETED ORDER ITEMS TABLE

CREATE TABLE deleted_order_items (
    delete_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    order_id INT,
    product_id INT,
    deleted_quantity INT,
    subtotal DECIMAL(10,2),
    deleted_at DATETIME
);


-- Q22, Q23 AND Q24.
-- RESTORE STOCK, UPDATE ORDER TOTAL
-- AND MAINTAIN DELETED ITEM HISTORY

CREATE TRIGGER trg_order_item_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN

    -- Q22: RESTORE PRODUCT STOCK

    SET @stock_change_type = 'RESTORE';

    UPDATE products
    SET stock_quantity = stock_quantity + OLD.quantity,
        status = CASE
            WHEN stock_quantity + OLD.quantity > 0
            THEN 'AVAILABLE'
            ELSE 'OUT_OF_STOCK'
        END
    WHERE product_id = OLD.product_id;

    SET @stock_change_type = NULL;


    -- Q23: RECALCULATE ORDER TOTAL

    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM order_items
        WHERE order_id = OLD.order_id
    )
    WHERE order_id = OLD.order_id;


    -- Q24: MAINTAIN DELETED ITEM HISTORY

    INSERT INTO deleted_order_items
    (
        item_id, order_id, product_id,
        deleted_quantity, subtotal, deleted_at
    )
    VALUES
    (
        OLD.item_id, OLD.order_id, OLD.product_id,
        OLD.quantity, OLD.subtotal, NOW()
    );

END$$


DELIMITER ;


-- ============================================================
-- PART 4: ADVANCED REAL-TIME BUSINESS SCENARIOS
-- ============================================================


-- ------------------------------------------------------------
-- Q26. ONLINE SHOPPING ORDER CANCELLATION
-- ------------------------------------------------------------

DELIMITER $$

-- PREVENT CANCELLATION AFTER SHIPPING OR DELIVERY

CREATE TRIGGER trg_cancel_validation
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.order_status = 'CANCELLED'
       AND OLD.order_status IN ('SHIPPED', 'DELIVERED') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Shipped or delivered orders cannot be cancelled';

    END IF;
END$$


-- RESTORE PURCHASED ITEMS WHEN ORDER IS CANCELLED

CREATE TRIGGER trg_cancel_restore_stock
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.order_status = 'CANCELLED'
       AND OLD.order_status <> 'CANCELLED' THEN

        DELETE FROM order_items
        WHERE order_id = NEW.order_id;

    END IF;
END$$


-- ------------------------------------------------------------
-- Q27. PHARMACY MEDICINE EXPIRY MANAGEMENT
-- ------------------------------------------------------------

CREATE TABLE medicines (
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(100),
    manufacturing_date DATE,
    expiry_date DATE,
    price DECIMAL(10,2),
    available_quantity INT
);


CREATE TABLE medicine_stock_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT,
    old_quantity INT,
    new_quantity INT,
    changed_at DATETIME
);


-- TABLE FOR MEDICINE SALES

CREATE TABLE medicine_sales (
    sale_id INT PRIMARY KEY,
    medicine_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (medicine_id)
    REFERENCES medicines(medicine_id)
);


DELIMITER $$


-- REJECT EXPIRED MEDICINE INSERTION

CREATE TRIGGER trg_medicine_insert
BEFORE INSERT ON medicines
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Expired medicines cannot be added';
    END IF;

    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Medicine price cannot be negative';
    END IF;

    IF NEW.available_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Medicine quantity cannot be negative';
    END IF;
END$$


-- PREVENT SELLING EXPIRED MEDICINES

CREATE TRIGGER trg_medicine_sale
BEFORE INSERT ON medicine_sales
FOR EACH ROW
BEGIN
    DECLARE v_expiry DATE;
    DECLARE v_quantity INT;

    SELECT expiry_date, available_quantity
    INTO v_expiry, v_quantity
    FROM medicines
    WHERE medicine_id = NEW.medicine_id;

    IF v_expiry IS NULL OR v_expiry < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Cannot sell expired medicine';
    END IF;

    IF NEW.quantity <= 0 OR NEW.quantity > v_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid medicine sale quantity';
    END IF;
END$$


-- REDUCE MEDICINE STOCK AFTER SALE

CREATE TRIGGER trg_medicine_stock
AFTER INSERT ON medicine_sales
FOR EACH ROW
BEGIN
    UPDATE medicines
    SET available_quantity =
        available_quantity - NEW.quantity
    WHERE medicine_id = NEW.medicine_id;
END$$


-- PREVENT NEGATIVE MEDICINE STOCK

CREATE TRIGGER trg_medicine_stock_update
BEFORE UPDATE ON medicines
FOR EACH ROW
BEGIN
    IF NEW.available_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Medicine stock cannot be negative';
    END IF;
END$$


-- MAINTAIN MEDICINE STOCK HISTORY

CREATE TRIGGER trg_medicine_history
AFTER UPDATE ON medicines
FOR EACH ROW
BEGIN
    IF OLD.available_quantity <> NEW.available_quantity THEN

        INSERT INTO medicine_stock_history
        (
            medicine_id, old_quantity,
            new_quantity, changed_at
        )
        VALUES
        (
            NEW.medicine_id,
            OLD.available_quantity,
            NEW.available_quantity,
            NOW()
        );

    END IF;
END$$


-- ------------------------------------------------------------
-- Q28. HOSPITAL APPOINTMENT MANAGEMENT
-- ------------------------------------------------------------


CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    appointment_count INT DEFAULT 0
);


CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_name VARCHAR(100),
    appointment_datetime DATETIME,
    status VARCHAR(30),
    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id),
    UNIQUE (doctor_id, appointment_datetime)
);


CREATE TABLE appointment_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_at DATETIME
);


DELIMITER $$


-- PREVENT APPOINTMENTS IN THE PAST

CREATE TRIGGER trg_appointment_insert
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    IF NEW.appointment_datetime < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Past appointments are not allowed';
    END IF;
END$$


-- UPDATE DOCTOR APPOINTMENT COUNT

CREATE TRIGGER trg_appointment_count_insert
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
    UPDATE doctors
    SET appointment_count = appointment_count + 1
    WHERE doctor_id = NEW.doctor_id;
END$$


-- PREVENT DELETING COMPLETED APPOINTMENTS

CREATE TRIGGER trg_appointment_delete
BEFORE DELETE ON appointments
FOR EACH ROW
BEGIN
    IF OLD.status = 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Completed appointments cannot be deleted';
    END IF;
END$$


-- UPDATE COUNT AFTER APPOINTMENT DELETION

CREATE TRIGGER trg_appointment_count_delete
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    UPDATE doctors
    SET appointment_count = appointment_count - 1
    WHERE doctor_id = OLD.doctor_id;
END$$


-- MAINTAIN APPOINTMENT STATUS HISTORY

CREATE TRIGGER trg_appointment_history
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN

        INSERT INTO appointment_history
        (
            appointment_id, old_status,
            new_status, changed_at
        )
        VALUES
        (
            NEW.appointment_id,
            OLD.status,
            NEW.status,
            NOW()
        );

    END IF;
END$$


-- ------------------------------------------------------------
-- Q29. BANKING TRANSACTION MANAGEMENT
-- ------------------------------------------------------------


CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(100),
    balance DECIMAL(12,2)
);


CREATE TABLE bank_transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_status VARCHAR(30),
    transaction_date DATETIME,
    FOREIGN KEY (account_id)
    REFERENCES bank_accounts(account_id)
);


CREATE TABLE bank_transaction_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    audit_time DATETIME
);


DELIMITER $$


-- VALIDATE TRANSACTION AMOUNT AND BALANCE

CREATE TRIGGER trg_bank_transaction
BEFORE INSERT ON bank_transactions
FOR EACH ROW
BEGIN
    DECLARE v_balance DECIMAL(12,2);

    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transaction amount must be positive';
    END IF;

    IF NEW.transaction_type NOT IN ('DEPOSIT', 'WITHDRAWAL') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid transaction type';
    END IF;

    IF NEW.transaction_status = 'COMPLETED'
       AND NEW.transaction_type = 'WITHDRAWAL' THEN

        SELECT balance
        INTO v_balance
        FROM bank_accounts
        WHERE account_id = NEW.account_id;

        IF v_balance IS NULL OR v_balance < NEW.amount THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Insufficient account balance';
        END IF;

    END IF;
END$$


-- AUTOMATIC DEPOSIT AND WITHDRAWAL

CREATE TRIGGER trg_bank_balance
AFTER INSERT ON bank_transactions
FOR EACH ROW
BEGIN
    IF NEW.transaction_status = 'COMPLETED' THEN

        IF NEW.transaction_type = 'DEPOSIT' THEN

            UPDATE bank_accounts
            SET balance = balance + NEW.amount
            WHERE account_id = NEW.account_id;

        ELSEIF NEW.transaction_type = 'WITHDRAWAL' THEN

            UPDATE bank_accounts
            SET balance = balance - NEW.amount
            WHERE account_id = NEW.account_id;

        END IF;

    END IF;
END$$


-- MAINTAIN BANK TRANSACTION AUDIT

CREATE TRIGGER trg_bank_audit
AFTER INSERT ON bank_transactions
FOR EACH ROW
BEGIN
    INSERT INTO bank_transaction_audit
    (
        transaction_id, account_id,
        transaction_type, amount, audit_time
    )
    VALUES
    (
        NEW.transaction_id,
        NEW.account_id,
        NEW.transaction_type,
        NEW.amount,
        NOW()
    );
END$$


-- PREVENT DELETING COMPLETED TRANSACTIONS

CREATE TRIGGER trg_bank_delete
BEFORE DELETE ON bank_transactions
FOR EACH ROW
BEGIN
    IF OLD.transaction_status = 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Completed bank transactions cannot be deleted';
    END IF;
END$$


-- ------------------------------------------------------------
-- Q30. STUDENT ATTENDANCE MANAGEMENT
-- ------------------------------------------------------------


CREATE TABLE attendance_students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    total_present_days INT DEFAULT 0
);


CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    attendance_date DATE,
    attendance_status VARCHAR(20),
    FOREIGN KEY (student_id)
    REFERENCES attendance_students(student_id),
    UNIQUE (student_id, attendance_date)
);


CREATE TABLE finalized_attendance_months (
    student_id INT,
    attendance_month DATE,
    PRIMARY KEY (student_id, attendance_month),
    FOREIGN KEY (student_id)
    REFERENCES attendance_students(student_id)
);


-- VALIDATE ATTENDANCE DATE

DELIMITER $$

CREATE TRIGGER trg_attendance_insert
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    IF NEW.attendance_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Future attendance dates are not allowed';
    END IF;

    IF NEW.attendance_status NOT IN ('PRESENT', 'ABSENT') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid attendance status';
    END IF;
END$$


-- UPDATE TOTAL PRESENT DAYS AFTER INSERT

CREATE TRIGGER trg_attendance_count_insert
AFTER INSERT ON attendance
FOR EACH ROW
BEGIN
    IF NEW.attendance_status = 'PRESENT' THEN

        UPDATE attendance_students
        SET total_present_days = total_present_days + 1
        WHERE student_id = NEW.student_id;

    END IF;
END$$


-- VALIDATE ATTENDANCE UPDATES

CREATE TRIGGER trg_attendance_update
BEFORE UPDATE ON attendance
FOR EACH ROW
BEGIN
    IF NEW.attendance_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Future attendance dates are not allowed';
    END IF;

    IF NEW.attendance_status NOT IN ('PRESENT', 'ABSENT') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid attendance status';
    END IF;
END$$


-- UPDATE ATTENDANCE STATISTICS AFTER UPDATE

CREATE TRIGGER trg_attendance_count_update
AFTER UPDATE ON attendance
FOR EACH ROW
BEGIN
    IF OLD.attendance_status <> NEW.attendance_status THEN

        IF OLD.attendance_status = 'PRESENT' THEN

            UPDATE attendance_students
            SET total_present_days = total_present_days - 1
            WHERE student_id = OLD.student_id;

        END IF;

        IF NEW.attendance_status = 'PRESENT' THEN

            UPDATE attendance_students
            SET total_present_days = total_present_days + 1
            WHERE student_id = NEW.student_id;

        END IF;

    END IF;

END$$


-- PREVENT DELETING FINALIZED MONTH ATTENDANCE

CREATE TRIGGER trg_attendance_delete
BEFORE DELETE ON attendance
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM finalized_attendance_months
        WHERE student_id = OLD.student_id
        AND attendance_month =
            STR_TO_DATE(
                DATE_FORMAT(OLD.attendance_date, '%Y-%m-01'),
                '%Y-%m-%d'
            )
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Attendance for finalized month cannot be deleted';

    END IF;
END$$


-- UPDATE PRESENT DAYS AFTER DELETION

CREATE TRIGGER trg_attendance_count_delete
AFTER DELETE ON attendance
FOR EACH ROW
BEGIN
    IF OLD.attendance_status = 'PRESENT' THEN

        UPDATE attendance_students
        SET total_present_days = total_present_days - 1
        WHERE student_id = OLD.student_id;

    END IF;
END$$


DELIMITER ;


-- ============================================================
-- PART 5: TRIGGER MANAGEMENT AND TESTING
-- ============================================================


-- Q1. DISPLAY ALL TRIGGERS

SHOW TRIGGERS;


-- Q2. DISPLAY COMPLETE DEFINITION OF A TRIGGER

SHOW CREATE TRIGGER trg_product_price;


-- Q3. DROP AN EXISTING TRIGGER

-- DROP TRIGGER IF EXISTS trg_product_price;


-- Q4. DISPLAY TRIGGERS FOR A PARTICULAR TABLE

SHOW TRIGGERS LIKE 'products';


-- Q5. CHECK BEFORE INSERT AND AFTER INSERT TRIGGERS

SHOW TRIGGERS LIKE 'order_items';


-- Q6. TEST MULTIPLE-ROW INSERT

-- Use valid new product IDs.

-- INSERT INTO products VALUES
-- (108, 'Tablet', 'Electronics', 15000, 10, 'AVAILABLE'),
-- (109, 'Speaker', 'Accessories', 3000, 20, 'AVAILABLE');


-- Q7. TEST INVALID PRODUCT PRICE

-- This should generate an error.

-- INSERT INTO products VALUES
-- (110, 'Test Product', 'Electronics', -500, 10, 'AVAILABLE');


-- Q8. TEST TRANSACTION ROLLBACK

-- Use a new valid order item ID.

-- START TRANSACTION;

-- INSERT INTO order_items
-- VALUES (8, 1001, 107, 2, 800, 1600);

-- ROLLBACK;


-- Q9. VERIFY STOCK HISTORY

SELECT * FROM stock_history;


-- Q10. VERIFY ORDER AUDIT

SELECT * FROM order_audit;


-- ADDITIONAL VERIFICATION QUERIES

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT * FROM order_items;

SELECT * FROM payments;

SELECT * FROM stock_history;

SELECT * FROM order_audit;

SELECT * FROM deleted_order_items;

SELECT * FROM medicines;

SELECT * FROM medicine_stock_history;

SELECT * FROM doctors;

SELECT * FROM appointments;

SELECT * FROM appointment_history;

SELECT * FROM bank_accounts;

SELECT * FROM bank_transactions;

SELECT * FROM bank_transaction_audit;

SELECT * FROM attendance_students;

SELECT * FROM attendance;

SELECT * FROM finalized_attendance_months;

-- ============================================================
-- END OF MYSQL TRIGGER ASSIGNMENT
-- ============================================================
