# Model:

### Overview

This document provides an overview of the data warehouse design for a retail store chain. The design is based on a star schema to optimize analytical queries and reporting. It consists of a central fact table, `factTransaction`, and six supporting dimension tables to capture various aspects of the retail business.

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/26ed88116f08381b6e28a623b9c1ffc78955d123.png)

------------------------------------------------------------------------

### 1. Fact Table: `factTransaction`

The `factTransaction` table contains transactional data representing sales activities.

**Columns:**

- **TransactionID**: Unique identifier for each transaction (Primary Key).
- **InvoiceID**: Business key for the invoice associated with the transaction.
- **CustomerFK**: Foreign key referencing `dimCustomer`.
- **StoreFK**: Foreign key referencing `dimStore`.
- **EmployeeFK**: Foreign key referencing `dimEmployee`.
- **Date_ID**: Foreign key referencing `dimDate`.
- **PromotionFK**: Foreign key referencing `dimPromotion`.
- **ProductFK**: Foreign key referencing `dimProduct`.
- **Quantity**: Number of units sold in the transaction.
- **Total_price**: Total price for the transaction (quantity × price).

**Grain:** One row per transaction line item (each product sold per transaction).

------------------------------------------------------------------------

### 2. Dimension Tables

#### a. `dimDate`

Captures date-related details for transaction time analysis.

**Columns:**

- **DateID**: Unique identifier for the date (Primary Key).
- **Hours**: Time component (optional, used for hourly granularity).
- **Date**: Calendar date.
- **Day_of_week**: Day of the week (e.g., Monday, Tuesday).
- **Month**: Month of the year.
- **Quarter**: Quarter of the year (e.g., Q1, Q2).
- **Year**: Year of the date.
- **Holiday_flag**: Indicates whether the date is a holiday.

------------------------------------------------------------------------

#### b. `dimEmployee`

Stores details about employees involved in transactions.

**Columns:**

- **EmployeeSK**: Surrogate key (Primary Key).
- **EmployeeBK**: Business key for the employee.
- **Employee_name**: Full name of the employee.
- **NationalID**: Unique identifier for the employee.
- **Job_title**: Job title of the employee.
- **Gender**: Gender of the employee.
- **Hire_date**: Employee's hire date.

------------------------------------------------------------------------

#### c. `dimCustomer`

Contains customer-related information for demographic and behavioral analysis.

**Columns:**

- **CustomerSK**: Surrogate key (Primary Key).
- **CustomerBK**: Business key for the customer.
- **Customer_name**: Full name of the customer.
- **Phone**: Contact phone number.
- **Gender**: Gender of the customer.
- **Age**: Age of the customer.
- **City**: City of residence.

------------------------------------------------------------------------

#### d. `dimStore`

Captures details about the retail stores.

**Columns:**

- **StoreSK**: Surrogate key (Primary Key).
- **StoreBK**: Business key for the store.
- **Location**: Address or geographic location of the store.
- **Size**: Size of the store (e.g., square footage).
- **Manager_ID**: ID of the store manager.

------------------------------------------------------------------------

#### e. `dimProduct`

Holds information about products sold in the stores.

**Columns:**

- **ProductSK**: Surrogate key (Primary Key).
- **ProductBK**: Business key for the product.
- **Product_name**: Name of the product.
- **Category_BK**: Business key for the product category.
- **Category_name**: Name of the product category.
- **Subcategory_BK**: Business key for the product subcategory.
- **Subcategory_name**: Name of the product subcategory.
- **Brand**: Brand of the product.
- **Price**: Unit price of the product.
- **Shelf_life**: expiration date - production date = shelf life in days.

##### Product details:

**Groceries**  
categoryBK 1, subcategoryBK starts from 100, ProductBK starts from 1

    - Fresh Produce 101
    - Bakery 102
    - Dairy 103
    - Meat and Chicken 104
    - dry goods 151
    - snacks 152
    - beverages 153
    - canned goods 154

**Toys and Games**
categoryBK 2, subcategoryBK starts from 200, ProductBK starts from 2000

    - board games 202
    - puzzles 204
    - educational games 201
    - toys 203

**Pet Supplies**
categoryBK 3, subcategoryBK starts from 300, ProductBK starts from 3000

    - Pet food 300
    - pet litter 301
    - pet toys 302
    - pet accessories 303

**Household**
categoryBK 4, subcategoryBK starts from 400, ProductBK starts from 4000

    - Cleaning supplies 400
    - paper products 401
    - Storage and Organization 402

**Stationary**
categoryBK 5, subcategoryBK starts from 500, ProductBK starts from 5000

    - Writing Supplies 500
    - Office Equipment 501
    - Paper and Notebooks 502
    - School Supplies 503

**Personal Care**  
categoryBK 6, subcategoryBK starts from 600, ProductBK starts from 6000

    - skincare 601
    - hair care 600
    - oral care 602
    - hygiene products 603

**Electronics**  
categoryBK 7, subcategoryBK starts from 700, ProductBK starts from 7000

    - Smartphones 700
    - Appliances 701
    - Laptops 702
    - Gaming Consoles 703
    - Wearables 704
    - Tablets 705
    - Cameras 706
    - Smart Home 707
    - TVs 708
    - Audio Equipment 709

------------------------------------------------------------------------

#### f. `dimPromotion`

Captures promotional campaign details.

**Columns:**

- **PromotionSK**: Surrogate key (Primary Key).
- **PromotionBK**: Business key for the promotion.
- **Promotion_name**: Name of the promotional campaign.
- **Discount_percentage**: Percentage of the discount.
- **Type**: Type of promotion (e.g., discount, bundle).
- **Start_date**: Start date of the promotion.
- **End_date**: End date of the promotion.

------------------------------------------------------------------------

### 3. Relationships

The `factTransaction` table links to all dimension tables via foreign keys:

- **dimDate** via `Date_ID`
- **dimEmployee** via `EmployeeFK`
- **dimCustomer** via `CustomerFK`
- **dimStore** via `StoreFK`
- **dimProduct** via `ProductFK`
- **dimPromotion** via `PromotionFK`

------------------------------------------------------------------------

# Analytical SQL

## Task 1:

## What are the top-selling products in each category?

The results of our analysis reveal the top-performing products in each category, providing valuable insights into customer preferences and sales trends. Here's a breakdown of the findings:

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/5d4fcb084f81c98fbce22228dee6f9a9eb8c158f.png)

### Key Insights and Business Implications

#### Groceries: Egyptian Lychees (1,941 units sold)

Insight: Egyptian Lychees are the top-selling product in the Groceries category, indicating strong customer demand for exotic and premium fruits.

**Actionable Strategy:**

- Increase stock levels of Egyptian Lychees to meet high demand.

- Explore sourcing similar exotic fruits to expand this high-performing product line.

- Highlight these products in promotional campaigns to attract health-conscious customers.

#### Personal Care: Amir Olive Oil Soap (1,275 units sold)

Insight: Amir Olive Oil Soap leads the Personal Care category, suggesting a preference for natural and premium personal care products.

**Actionable Strategy:**

- Expand the range of natural and organic personal care products.

- Bundle Amir Olive Oil Soap with complementary products (e.g., lotions or scrubs) to increase average transaction value.

- Leverage this product in marketing campaigns targeting eco-conscious consumers.

#### Stationaries: Moleskine Sketchbook (1,027 units sold)

Insight: The Moleskine Sketchbook is the top seller in the Stationaries category, reflecting demand for high-quality, premium stationery.

**Actionable Strategy:**

- Stock additional Moleskine products (e.g., notebooks, planners) to cater to this customer segment.

- Partner with Moleskine for exclusive designs or promotions to drive further sales.

- Position these products as back-to-school or holiday gift items.

#### Electronics: Apple Watch Series 8 (895 units sold)

Insight: The Apple Watch Series 8 dominates the Electronics category, highlighting the popularity of wearable technology.

**Actionable Strategy:**

- Ensure consistent stock availability of the Apple Watch Series 8 and related accessories.

- Promote the product during key shopping periods (e.g., Black Friday, holiday season).

- Bundle the Apple Watch with complementary products (e.g., AirPods) to increase sales.

#### Toys and Games: Science Experiment Kit (834 units sold)

Insight: The Science Experiment Kit is the top seller in the Toys and Games category, indicating strong demand for educational and STEM-focused toys.

**Actionable Strategy:**

- Expand the range of educational toys and STEM kits to capitalize on this trend.

- Promote these products during back-to-school and holiday seasons.

- Partner with schools or educational organizations to increase brand visibility.

#### Household: Flora Multipurpose Rolls (52 units sold)

Insight: Flora Multipurpose Rolls lead the Household category, but with significantly lower sales compared to other categories.

**Actionable Strategy:**

- Investigate whether low sales are due to limited stock or low customer awareness.

- Consider bundling Flora Multipurpose Rolls with other household products to increase visibility.

- Run targeted promotions to boost sales in this category.

#### Pets: Cat Grooming Brush (50 units sold)

Insight: The Cat Grooming Brush is the top seller in the Pets category, but sales are relatively low compared to other categories.

**Actionable Strategy:**

- Explore expanding the pet care product line to include more high-demand items (e.g., pet food, toys).

- Promote pet care products through loyalty programs or partnerships with pet influencers.

- Bundle grooming tools with other pet care products to increase sales.

## Which types of promotions result in the highest sales?

The results of our analysis highlight the performance of the Summer Sale promotion, which ran from June 1st to June 31st. This promotion was the top-performing campaign in terms of total sales and quantity sold. Here's a detailed breakdown of the results:

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/3c289c679c2743cdbcb767920365f95543540158.png)

#### The Summer Sale generated \$30,256.08 in total sales and sold 440 units, making it the most effective promotion during the analyzed period.

**Actionable Strategy:**

- Replicate Success: Consider running similar discount-based promotions during other peak shopping periods (e.g., Back-to-School, Holiday Season).

- Increase marketing efforts for future Summer Sales to attract even more customers.

- Discounts Drive High Sales Volume

## How do purchasing patterns change based on time or customer demographics?

### Revenue Trends Over the Year

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/118bcc454bb5f5f9d10923b97548465d167ccd61.png)

#### The running total revenue shows a steady increase throughout the year, with significant spikes in **April** (\$80,997) and **August** (\$50,969.60). However, there are noticeable dips in **February** (\$38,313.70) and **July** (\$30,215.57).

**Actionable Strategy:**

- Leverage High-Performing Months:

Focus on maximizing revenue during peak months (e.g., April, August) through targeted promotions, inventory optimization, and enhanced customer engagement.

- Boost Low-Performing Months:

Introduce creative marketing campaigns, discounts, and events to drive sales during slower months (e.g., February, July).

### Demographic-based purchasing patterns

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/8f3ac4cf1feaa40dcb53bf6dfa77bbd0268c9801.png)

#### Highest Spending Age Group:

The age group 26-35 generates the highest total revenue (\$402,861.7), ranking first in both revenue rank and dense rank. This indicates that customers in this age group are the most significant contributors to Walmart's revenue.

#### Second Highest Spending Age Group:

The 18-25 age group follows with \$95,501.8 in total revenue, ranking second. This suggests that younger adults are also a substantial market segment.

#### Moderate Spending Age Groups:

The 36-45 age group contributes \$87,522.47, ranking third. While their spending is lower than the top two groups, they still represent a valuable customer base.

#### Lowest Spending Age Group:

The 45+ age group generates the least revenue (\$8,509.37), ranking fourth. This indicates a potential area for growth, as this demographic may be underserved or less engaged.

**Actionable strategy:**

###### Targeted Marketing Campaigns:

26-35 Age Group: Continue to engage this demographic with personalized offers and loyalty programs to maintain their high spending levels.

18-25 Age Group: Develop marketing strategies that resonate with younger adults, such as social media campaigns and promotions on trendy products.

### Gender and monthly purchasing patterns

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/344389f0a58392406041ebeb0c8ad0446e37fd33.png)

#### Gender-Based Spending:

- **Female Customers**: Female customers generally contribute higher revenue in several months, such as April (\$51,370.59) and August (\$31,348.73). However, their spending drops significantly in months like June (\$9,996.98) and July (\$15,509.92).
- **Male Customers**: Male customers show more consistent spending across months, with notable peaks in January (\$42,813.99) and December (\$31,598.70). Their spending is relatively stable compared to female customers.

#### Monthly Revenue Trends:

- **High Revenue Months**: April and January are high-revenue months for both genders, indicating potential seasonal shopping trends.
- **Low Revenue Months**: June and July are low-revenue months, particularly for female customers, suggesting a possible dip in purchasing activity during these periods.

#### Revenue Quartiles:

- **Female Customers**: Female spending is distributed across all quartiles, with some months in the top quartile (e.g., April, August) and others in the bottom quartile (e.g., June, July).
- **Male Customers**: Male spending is more concentrated in the top quartiles, with several months (e.g., April, December, January) consistently ranking high.

**Actionable Strategy:**

###### Targeted Marketing Campaigns:

- **Female Customers**: Develop targeted promotions and marketing campaigns for female customers, especially during low-revenue months like June and July. Highlight products that appeal to this demographic, such as fashion, beauty, and home goods.
- **Male Customers**: Continue to engage male customers with promotions on high-demand products, particularly during peak months like January and December. Focus on categories like electronics.

###### Seasonal Strategies:

- **High-Revenue Months**: Capitalize on high-revenue months by increasing inventory and marketing efforts. For example, run special promotions and events in April and January to maximize sales.
- **Low-Revenue Months**: Implement strategies to boost sales during low-revenue months. Consider offering discounts, loyalty rewards, and exclusive deals to encourage spending in June and July.

``` sql
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
```

## Task 2:

``` sql
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
```

## Task 3

### Insights and Recommendations for Product Pairing and Store Reorganization

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/36aa7fefaae153faf118a7d8a8bee764cbebed0c.png)

#### Most Common Product Pairs:

- **Groceries**:
  - **Fresh Produce & Dairy**: Egyptian Apples and Whole Milk are frequently purchased together, with a high purchase count of 150 out of 337 purchase count of pairs from both subcategories.
  - **Snacks & Dairy**: Crunchy Chicken Potato Chips and Whole Milk also show a high purchase count of 84 out of 220 purchase count of pairs from both subcategories.
  - **Snacks & Fresh Produce**: Apples and Whole Milk have a significant purchase count of 94 out of 324 purchase count of pairs from both subcategories.
- **Personal Care**:
  - **Oral Care & Hygiene Products**: Sensodyne Pronamel Toothpaste and other hygiene products are commonly bought together (e.g., 70).
  - **Skin Care & Hygiene Products**: Luna Soft Cream and hygiene products also show a notable purchase count (e.g., 77).
- **Stationaries**:
  - **Office Equipment & Paper and Notebooks**: Staples Clipboard and notebooks are paired frequently (e.g., 20).
- **Electronics**:
  - **TVs & Audio Equipment**: OLED C2 TVs and Bose SoundLink Revolve+ speakers are occasionally purchased together (e.g., 16).

#### Patterns for Store Reorganization:

- **Cross-Category Pairing**: Products from different subcategories within the same category are frequently purchased together, indicating a natural pairing that can be leveraged for store layout.
- **High-Frequency Pairs**: Items like Egyptian Apples and Whole Milk, or Crunchy Chicken Potato Chips and Whole Milk, should be placed near each other to facilitate easy access for customers.

#### Product Pairs for Bundled Promotions:

- **Groceries**:
  - **Fresh Produce & Dairy**: Bundle offers on Fruits and Milk could drive higher sales.
  - **Snacks & Dairy**: Promotions combining Potato Chips and Milk can attract more customers.
  - **Snacks & Fresh Produce**: Discounts on Potato Chips and Milk can increase purchase rates.
- **Personal Care**:
  - **Oral Care & Hygiene Products**: Bundled deals on oral care products and hygiene products can enhance sales.
  - **Skin Care & Hygiene Products**: Promotions on skin care products and hygiene products can attract more buyers.

### Actionable Strategy:

#### Store Reorganization:

- **Proximity Placement**: Place frequently paired products near each other to enhance the shopping experience and increase basket size. For example, position Fresh Produce and Dairy sections closer together.
- **Themed Aisles**: Create themed aisles that combine complementary products, such as a "Snack and Beverage" aisle or a "Health and Wellness" aisle.

#### Promotional Strategies:

- **Bundled Offers**: Develop bundled promotions for high-frequency pairs, such as discounts on Egyptian Apples and Whole Milk or Crunchy Chicken Potato Chips and Whole Milk.
- **Cross-Promotions**: Implement cross-promotional campaigns that encourage customers to buy complementary products, like offering a discount on Sensodyne Pronamel Toothpaste when purchasing hygiene products.

#### Customer Experience Improvements:

- **Signage and Displays**: Use clear signage and attractive displays to highlight product pairs and promotions, making it easier for customers to find and purchase complementary items.
- **Personalized Recommendations**: Leverage customer data to provide personalized recommendations and offers based on past purchase behavior.

### Employee Performance Patterns

![](Walmart%20Data%20Warehouse%20Design%20Documentation-media/9f0e4b8b2ceda15e4ef84ce445ca9a5a236ca199.png)

### Employee Performance:

- **Revenue Contribution**: The total revenue generated by each employee is ranked using the DENSE_RANK function. This ranking helps identify top-performing employees and those who may need additional support or training.
- **Top Performers**: Employees with the highest total revenue contributions are ranked at the top. These employees are crucial in driving sales and should be recognized and rewarded for their performance.
- **Performance Variability**: There is variability in revenue contributions among employees, indicating differences in sales effectiveness and customer engagement.

#### Actionable Strategy:

### Employee Recognition and Rewards:

- **Top Performers**: Recognize and reward top-performing employees to motivate them and set a benchmark for others. Consider incentives such as bonuses, awards, or public recognition.
- **Performance Reviews**: Conduct regular performance reviews to provide constructive feedback and set performance goals. This can help employees understand their strengths and areas for improvement.

### Training and Development:

- **Skill Enhancement**: Provide targeted training programs to employees who are not performing as well. Focus on areas such as customer service, product knowledge, and sales techniques.
- **Mentorship Programs**: Implement mentorship programs where top-performing employees can share their strategies and best practices with others.

``` plsql
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
```
