DECLARE
    v_InvoiceID NUMBER ;
    v_TransactionID NUMBER;
    v_Products NUMBER;
    v_ProductSK NUMBER;
    v_Quantity NUMBER;
    v_TotalPrice NUMBER;
    v_PromotionFK NUMBER;
    v_DateID NUMBER;
    v_Discount NUMBER;
    v_EmployeeFK NUMBER;
    v_CustomerFK NUMBER;
    v_StoreFK NUMBER;

    -- Logical product pairs (products frequently bought together)
    TYPE ProductPair IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_ProductPairs ProductPair;

    -- Cross-category associations (e.g., groceries and personal care)
    TYPE CrossCategoryPair IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_CrossCategoryPairs CrossCategoryPair;

BEGIN

    select max(transactionid), max(invoiceid) into v_TransactionID, v_InvoiceID
    from facttransaction;
     
    -- Define logical product pairs (products frequently bought together)
    select min(productsk)+10 into  v_ProductPairs(1)  from dimproduct where subcategory_bk = 101; -- Fresh Produce
    select min(productsk)+6 into  v_ProductPairs(2)  from dimproduct where subcategory_bk = 103; --Dairy
    select min(productsk)+5 into  v_ProductPairs(3)  from dimproduct where subcategory_bk = 152; --Snacks
    select min(productsk)+9 into  v_ProductPairs(4)  from dimproduct where subcategory_bk = 603; --Hygiene products
    select min(productsk)+4 into  v_ProductPairs(5)  from dimproduct where subcategory_bk = 708; --TVs
    select min(productsk)+7 into  v_ProductPairs(6)  from dimproduct where subcategory_bk = 709; -- Audio Equipment
    select min(productsk)+6 into  v_ProductPairs(7)  from dimproduct where subcategory_bk = 201; --Educational Games
    select min(productsk)+5 into  v_ProductPairs(8)  from dimproduct where subcategory_bk = 501; -- Office Equipment
    select min(productsk)+3 into  v_ProductPairs(9)  from dimproduct where subcategory_bk = 502; -- Paper and Notebooks
   

    -- Define cross-category associations (e.g., groceries and personal care)
    
    select min(productsk)+6 into  v_CrossCategoryPairs(1)  from dimproduct where subcategory_bk = 101; -- Fresh Produce
    select min(productsk)+13 into  v_CrossCategoryPairs(2)  from dimproduct where subcategory_bk = 603; --Hygiene products
    select min(productsk)+10 into  v_CrossCategoryPairs(3)  from dimproduct where subcategory_bk = 152; --Snacks
    select min(productsk)+16 into  v_CrossCategoryPairs(4)  from dimproduct where subcategory_bk = 601; --Skincare
    select min(productsk)+10 into  v_CrossCategoryPairs(5)  from dimproduct where subcategory_bk = 103;--Dairy
    select min(productsk)+12 into  v_CrossCategoryPairs(6)  from dimproduct where subcategory_bk = 602;  --Oral care 


    -- Generate 50 invoices
    FOR i IN 1..50 LOOP
        -- Generate a random date between 2022-01-01 and 2023-01-01
        v_DateID := TO_NUMBER(TO_CHAR(TO_DATE('2022-01-01', 'YYYY-MM-DD') + DBMS_RANDOM.VALUE(0, 365), 'YYYYMMDD') || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 24)), 2, '0'));

        -- Assign random EmployeeFK, CustomerFK, and StoreFK for this invoice
        v_EmployeeFK := FLOOR(DBMS_RANDOM.VALUE(21, 31)); -- EmployeeSK from 21 to 30
        v_CustomerFK := FLOOR(DBMS_RANDOM.VALUE(1, 88));  -- CustomerSK from 1 to 87
        v_StoreFK := FLOOR(DBMS_RANDOM.VALUE(1, 11));     -- StoreSK from 1 to 10

        -- Select 10–15 random products for the invoice
        v_Products := TRUNC(DBMS_RANDOM.VALUE(10, 16));

        -- Initialize a variable to track the first product in the invoice
        DECLARE
            v_FirstProductSK NUMBER;
        BEGIN
            -- Select the first product in the invoice
            IF DBMS_RANDOM.VALUE(0, 1) < 0.7 THEN
                -- 70% chance: Select a product from logical pairs
                v_FirstProductSK := v_ProductPairs(TRUNC(DBMS_RANDOM.VALUE(1, v_ProductPairs.COUNT + 1)));
            ELSE
                -- 30% chance: Select a random product
                v_FirstProductSK := TRUNC(DBMS_RANDOM.VALUE(1, 564)); -- ProductSK from 1 to 563
            END IF;

            -- Insert the first product
            BEGIN
                SELECT Price 
                INTO v_TotalPrice
                FROM dimProduct
                WHERE ProductSK = v_FirstProductSK;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    CONTINUE; -- Skip if no product is found
            END;

            -- Set quantity based on product category
            IF v_FirstProductSK BETWEEN 82 AND 483 THEN -- Groceries
                v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 10));
            ELSIF v_FirstProductSK BETWEEN 1 AND 51 THEN -- Toys and Games
                v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 3));
            ELSIF v_FirstProductSK BETWEEN 514 AND 564 THEN -- Electronics
                v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 2));
            ELSE -- Other categories
                v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 5));
            END IF;

            -- Insert the first product into the invoice
            INSERT INTO factTransaction (
                TransactionID, InvoiceID, CustomerFK, StoreFK, EmployeeFK, Date_ID, 
                PromotionFK, ProductFK, Quantity, Total_price
            ) VALUES (
                v_TransactionID, v_InvoiceID, v_CustomerFK, v_StoreFK, v_EmployeeFK, 
                v_DateID, NULL, v_FirstProductSK, v_Quantity, v_TotalPrice
            );

            -- Increment TransactionID
            v_TransactionID := v_TransactionID + 1;

            -- Add remaining products to the invoice
            FOR j IN 2..v_Products LOOP
                -- Introduce weighted logic for product selection
                IF DBMS_RANDOM.VALUE(0, 1) < 0.8 THEN
                    -- 80% chance: Select a product from logical pairs or cross-category associations
                    IF j MOD 2 = 0 THEN
                        -- Favor paired products every second product
                        v_ProductSK := v_ProductPairs(TRUNC(DBMS_RANDOM.VALUE(1, v_ProductPairs.COUNT + 1)));
                    ELSE
                        -- Favor cross-category associations
                        v_ProductSK := v_CrossCategoryPairs(TRUNC(DBMS_RANDOM.VALUE(1, v_CrossCategoryPairs.COUNT + 1)));
                    END IF;
                ELSE
                    -- 20% chance: Select a random product
                    v_ProductSK := TRUNC(DBMS_RANDOM.VALUE(1, 564)); -- ProductSK from 1 to 563
                END IF;

                -- Get the product price
                BEGIN
                    SELECT Price 
                    INTO v_TotalPrice
                    FROM dimProduct
                    WHERE ProductSK = v_ProductSK;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        CONTINUE; -- Skip if no product is found
                END;

                -- Set quantity based on product category
                IF v_FirstProductSK BETWEEN 82 AND 483 THEN -- Groceries
                v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 10));
                ELSIF v_FirstProductSK BETWEEN 1 AND 51 THEN -- Toys and Games
                    v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 3));
                ELSIF v_FirstProductSK BETWEEN 514 AND 564 THEN -- Electronics
                    v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 2));
                ELSE -- Other categories
                    v_Quantity := TRUNC(DBMS_RANDOM.VALUE(1, 5));
                END IF;

                -- Insert the product into the invoice
                INSERT INTO factTransaction (
                    TransactionID, InvoiceID, CustomerFK, StoreFK, EmployeeFK, Date_ID, 
                    PromotionFK, ProductFK, Quantity, Total_price
                ) VALUES (
                    v_TransactionID, v_InvoiceID, v_CustomerFK, v_StoreFK, v_EmployeeFK, 
                    v_DateID, NULL, v_ProductSK, v_Quantity, v_TotalPrice
                );

                -- Increment TransactionID
                v_TransactionID := v_TransactionID + 1;
            END LOOP;
        END;

        -- Increment InvoiceID
        v_InvoiceID := v_InvoiceID + 1;
    END LOOP;

  
END;
/