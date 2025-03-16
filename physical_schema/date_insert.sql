DECLARE
    v_current_date DATE := TO_DATE('2022-01-01', 'YYYY-MM-DD');
    v_end_date DATE := TO_DATE('2023-01-01', 'YYYY-MM-DD');
    v_hour NUMBER;
    v_date_id NUMBER;
    v_day_of_week VARCHAR2(20);
    v_month VARCHAR2(20);
    v_quarter NUMBER;
    v_year NUMBER;
    v_holiday_flag NUMBER(1);
BEGIN
    -- Loop through each date
    WHILE v_current_date < v_end_date LOOP
        -- Loop through each hour of the current date
        FOR v_hour IN 0 .. 23 LOOP
            -- Generate the DateID
            v_date_id := TO_NUMBER(TO_CHAR(v_current_date, 'YYYYMMDD') || LPAD(v_hour, 2, '0'));
            
            -- Extract date components
            v_day_of_week := TRIM(TO_CHAR(v_current_date, 'Day'));
            v_month := TO_CHAR(v_current_date, 'Month');
            v_quarter := TO_NUMBER(TO_CHAR(v_current_date, 'Q'));
            v_year := TO_NUMBER(TO_CHAR(v_current_date, 'YYYY'));
            
            -- Initialize holiday flag
            v_holiday_flag := 0; -- Default to non-holiday
            
            -- Set holiday flag for Egypt's holidays
            IF TO_CHAR(v_current_date, 'YYYY-MM-DD') IN (
                '2022-01-07', -- Coptic Christmas
                '2022-01-25', -- Police Day
                '2022-04-25', -- Sinai Liberation Day
                '2022-05-01', -- Labor Day
                '2022-05-02', -- Eid al-Fitr
                '2022-05-03', -- Eid al-Fitr (second day)
                '2022-07-08', -- Eid al-Adha
                '2022-07-09', -- Eid al-Adha (second day)
                '2022-07-23', -- Revolution Day
                '2022-10-06'  -- Armed Forces Day
            ) THEN
                v_holiday_flag := 1;
            END IF;
            
            -- Insert into dimDate table
            INSERT INTO dimDate (
                DateID, Hours, fulldate, Day_of_week, Month, Quarter, Year, Holiday_flag
            ) VALUES (
                v_date_id, v_hour, v_current_date, v_day_of_week, v_month, v_quarter, v_year, v_holiday_flag
            );
        END LOOP;
        
        -- Move to the next day
        v_current_date := v_current_date + 1;
    END LOOP;

    -- Commit the transaction
    --COMMIT;
END;

show errors;
