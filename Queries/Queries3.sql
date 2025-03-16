--6. Employee Performance and Purchasing Patterns
WITH EmployeeSales AS (
    SELECT 
        E.EMPLOYEE_NAME,
        SUM(FT.TOTAL_PRICE) AS total_revenue
    FROM 
        FACTTRANSACTION FT
    JOIN 
        DIMEMPLOYEE E ON FT.EMPLOYEEFK = E.EMPLOYEESK
    GROUP BY 
        E.EMPLOYEE_NAME
)
SELECT 
    EMPLOYEE_NAME,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_dense_rank
FROM 
    EmployeeSales
ORDER BY 
    revenue_dense_rank;