WITH ProductPairs AS (
    SELECT
        t1.InvoiceID,
        t1.ProductFK AS Product1,
        t2.ProductFK AS Product2
    FROM
        factTransaction t1
    JOIN
        factTransaction t2 ON t1.InvoiceID = t2.InvoiceID
    WHERE
        t1.ProductFK < t2.ProductFK -- Ensure each pair is counted only once
),
PurchaseCount AS (
    SELECT
        p1.Category_name AS Category,
        p1.ProductSK AS Product1,
        p2.ProductSK AS Product2,
        COUNT(*) AS Purchase_Count
    FROM
        ProductPairs pp
    JOIN
        dimProduct p1 ON pp.Product1 = p1.ProductSK
    JOIN
        dimProduct p2 ON pp.Product2 = p2.ProductSK
    WHERE
        p1.Category_BK = p2.Category_BK -- Ensure products are in the same category
        AND p1.Subcategory_BK != p2.Subcategory_BK -- Exclude variations of the same product
    GROUP BY
        p1.Category_name, p1.ProductSK, p2.ProductSK
)
SELECT
    p1.Category_name AS Category,
    p1.Subcategory_name AS Subcategory1,
    p1.Product_name AS Product1,
    p2.Subcategory_name AS Subcategory2,
    p2.Product_name AS Product2,
    pc.Purchase_Count AS Pair_Purchase_Count,
    SUM(pc.Purchase_Count) OVER(PARTITION BY p1.Category_name, p1.Subcategory_name, p2.Subcategory_name) AS Subcategory_Purchase_Count
FROM
    PurchaseCount pc
JOIN
    dimProduct p1 ON pc.Product1 = p1.ProductSK
JOIN
    dimProduct p2 ON pc.Product2 = p2.ProductSK
ORDER BY
    pc.Purchase_Count DESC;