DECLARE
    v_invoice_id NUMBER := 1;
    v_transaction_id NUMBER := 1;
    v_date DATE;
    v_date_id NUMBER;
    v_promotion_id NUMBER;
    v_product_id NUMBER;
    v_quantity NUMBER;
    v_total_price NUMBER(15, 2);
    v_discount_percentage NUMBER(5, 2);
    v_promotion_type VARCHAR2(50);
    v_product_price NUMBER(10, 2);
    v_store_fk NUMBER;
    v_customer_fk NUMBER;
    v_employee_fk NUMBER;
BEGIN
    FOR i IN 1..50 LOOP
        -- Generate a random date between 2022-01-01 and 2023-01-01
        v_date := TO_DATE('2022-01-01', 'YYYY-MM-DD') + DBMS_RANDOM.VALUE(0, 365);

        -- Generate a random hour (00 to 23) for the DateID
        v_date_id := TO_NUMBER(TO_CHAR(v_date, 'YYYYMMDD') || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 24)), 2, '0'));

        -- Generate fixed StoreFK, CustomerFK, and EmployeeFK for this invoice
        v_store_fk := FLOOR(DBMS_RANDOM.VALUE(1, 11)); -- Random store (StoreSK from 1 to 10)
        v_customer_fk := FLOOR(DBMS_RANDOM.VALUE(1, 88)); -- Random customer (CustomerSK from 1 to 87)
        v_employee_fk := FLOOR(DBMS_RANDOM.VALUE(21, 31)); -- Random employee (EmployeeSK from 21 to 30)

        -- Determine if a promotion applies based on the date
        BEGIN
            SELECT PromotionSK, Promotion_type, discount_percentage
            INTO v_promotion_id, v_promotion_type, v_discount_percentage
            FROM (
                SELECT PromotionSK, Promotion_type, discount_percentage
                FROM dimPromotion
                WHERE v_date BETWEEN Start_date AND End_date
                ORDER BY DBMS_RANDOM.VALUE
            )
            WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_promotion_id := NULL;
                v_discount_percentage := 0;
        END;

        -- Generate 10-15 products for this invoice
        FOR j IN 1..(10 + FLOOR(DBMS_RANDOM.VALUE(0, 6))) LOOP
            -- Select a random product (ProductSK from 1 to 326)
            BEGIN
                SELECT ProductSK, Price
                INTO v_product_id, v_product_price
                FROM (
                    SELECT ProductSK, Price
                    FROM dimProduct
                    WHERE ProductSK BETWEEN 1 AND 326
                    ORDER BY DBMS_RANDOM.VALUE
                )
                WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    CONTINUE; -- Skip if no product is found (unlikely)
            END;

            -- Generate a random quantity (1-5 for most products, 1-2 for expensive items like electronics)
            IF v_product_price > 100 THEN
                v_quantity := FLOOR(DBMS_RANDOM.VALUE(1, 3));
            ELSE
                v_quantity := FLOOR(DBMS_RANDOM.VALUE(1, 6));
            END IF;

            -- Calculate total price based on promotion type
            IF v_promotion_type = 'Bundle (Buy 2 Get 1)' AND v_quantity >= 2 THEN
                v_total_price := v_product_price * (v_quantity - FLOOR(v_quantity / 3));
            ELSIF v_promotion_type = 'Bundle (Buy 1 Get 1)' AND v_quantity >= 1 THEN
                v_total_price := v_product_price * CEIL(v_quantity / 2);
            ELSIF v_promotion_type = 'Bundle (Buy 3 Get 2)' AND v_quantity >= 3 THEN
                v_total_price := v_product_price * (v_quantity - FLOOR(v_quantity / 5 * 2));
            ELSE
                v_total_price := v_product_price * v_quantity * (1 - v_discount_percentage / 100);
            END IF;

            -- Insert into factTransaction
            INSERT INTO factTransaction (TransactionID, InvoiceID, CustomerFK, StoreFK, EmployeeFK, Date_ID, PromotionFK, ProductFK, Quantity, Total_price)
            VALUES (
                v_transaction_id,
                v_invoice_id,
                v_customer_fk, -- Fixed CustomerFK for this invoice
                v_store_fk, -- Fixed StoreFK for this invoice
                v_employee_fk, -- Fixed EmployeeFK for this invoice
                v_date_id, -- Date_ID in YYYYMMDDHH format
                v_promotion_id,
                v_product_id,
                v_quantity,
                v_total_price
            );

            -- Increment transaction ID
            v_transaction_id := v_transaction_id + 1;
        END LOOP;

        -- Increment invoice ID
        v_invoice_id := v_invoice_id + 1;
    END LOOP;
END;
