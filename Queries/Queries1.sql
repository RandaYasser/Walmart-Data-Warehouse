-- 1- What are the top-selling products in each category? 
WITH SumSales AS(
    SELECT p.Category_name,  p.ProductSK , p.Product_name,
        SUM(ft.Quantity) OVER (PARTITION BY p.Category_name , p.ProductSK )AS TotalQuantitySold
    FROM factTransaction ft JOIN dimProduct p ON ft.ProductFK = p.ProductSK
),ProductSales AS (
    SELECT Category_name, ProductSK, Product_name, TotalQuantitySold, 
        RANK() OVER (PARTITION BY Category_name ORDER BY TotalQuantitySold DESC) AS SalesRank
    FROM SumSales )
SELECT distinct Category_name, Product_name, TotalQuantitySold  
FROM ProductSales
WHERE SalesRank = 1
ORDER BY TotalQuantitySold DESC;
    
-- 2- Which types of promotions result in the highest sales? 
WITH SumSales AS (
    SELECT PR.Promotion_name, PR.Promotion_Type, 
        SUM(FT.Total_price) OVER (PARTITION BY PR.Promotion_name) AS TotalSales, 
        SUM(FT.Quantity) OVER (PARTITION BY PR.Promotion_name) AS TotalQuantitySold
    FROM factTransaction FT JOIN dimPromotion PR ON FT.PromotionFK = PR.PromotionSK 
), 
RankedPromotions AS (
    SELECT Promotion_name, Promotion_Type, TotalSales, TotalQuantitySold, 
        RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank 
    FROM SumSales
)
SELECT DISTINCT Promotion_name, Promotion_Type, TotalSales, TotalQuantitySold
FROM RankedPromotions
WHERE SalesRank = 1; 

--3. Time-Based Purchasing Patterns, Monthly Purchases with Running Total
WITH MonthlySales AS (
    SELECT 
        D.MONTH,
        D.YEAR,
        SUM(FT.TOTAL_PRICE) AS monthly_revenue
    FROM 
        FACTTRANSACTION FT
    JOIN 
        DIMDATE D ON FT.DATE_ID = D.DATEID
    GROUP BY 
        D.MONTH, D.YEAR
),
MonthOrder AS (
    SELECT 
        MONTH,
        YEAR,
        monthly_revenue,
        CASE 
            WHEN MONTH = 'January' THEN 1
            WHEN MONTH = 'February' THEN 2
            WHEN MONTH = 'March' THEN 3
            WHEN MONTH = 'April' THEN 4
            WHEN MONTH = 'May' THEN 5
            WHEN MONTH = 'June' THEN 6
            WHEN MONTH = 'July' THEN 7
            WHEN MONTH = 'August' THEN 8
            WHEN MONTH = 'September' THEN 9
            WHEN MONTH = 'October' THEN 10
            WHEN MONTH = 'November' THEN 11
            WHEN MONTH = 'December' THEN 12
        END AS month_order
    FROM 
        MonthlySales
)
SELECT 
    MONTH,
    YEAR,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY YEAR, month_order) AS running_total_revenue,
    LAG(monthly_revenue, 1) OVER (ORDER BY YEAR, month_order) AS prev_month_revenue,
    LEAD(monthly_revenue, 1) OVER (ORDER BY YEAR, month_order) AS next_month_revenue
FROM 
    MonthOrder
ORDER BY 
    month_order asc;
    
--4. Demographic-Based Purchasing Patterns, Purchases by Age Group with Rank
WITH AgeGroupSales AS (
    SELECT 
        CASE 
            WHEN C.AGE BETWEEN 18 AND 25 THEN '18-25'
            WHEN C.AGE BETWEEN 26 AND 35 THEN '26-35'
            WHEN C.AGE BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+'
        END AS age_group,
        SUM(FT.TOTAL_PRICE) AS total_revenue
    FROM 
        FACTTRANSACTION FT
    JOIN 
        DIMCUSTOMER C ON FT.CUSTOMERFK = C.CUSTOMERSK
    GROUP BY 
        CASE 
            WHEN C.AGE BETWEEN 18 AND 25 THEN '18-25'
            WHEN C.AGE BETWEEN 26 AND 35 THEN '26-35'
            WHEN C.AGE BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+'
        END
)
SELECT 
    age_group,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_dense_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC), 2) AS revenue_percent_rank
FROM 
    AgeGroupSales
ORDER BY 
    revenue_rank;  

--5. Combining Time and Demographics, Monthly Purchases by Gender with NTILE
WITH MonthlyGenderSales AS (
    SELECT 
        D.MONTH,
        C.GENDER,
        SUM(FT.TOTAL_PRICE) AS total_revenue
    FROM 
        FACTTRANSACTION FT
    JOIN 
        DIMDATE D ON FT.DATE_ID = D.DATEID
    JOIN 
        DIMCUSTOMER C ON FT.CUSTOMERFK = C.CUSTOMERSK
    GROUP BY 
        D.MONTH,  C.GENDER
)
SELECT 
    MONTH,
    GENDER,
    total_revenue,
    NTILE(4) OVER (PARTITION BY GENDER ORDER BY total_revenue DESC) AS revenue_quartile
FROM 
    MonthlyGenderSales
ORDER BY 
     MONTH, GENDER;