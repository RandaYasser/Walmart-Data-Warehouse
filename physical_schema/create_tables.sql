-- Creating the dimension tables

CREATE TABLE dimDate (
    DateID NUMBER PRIMARY KEY,
    Hours NUMBER CHECK (Hours BETWEEN 0 AND 23),
    fulldate DATE NOT NULL,
    Day_of_week VARCHAR2(20),
    Month VARCHAR2(20),
    Quarter NUMBER(1) CHECK (Quarter BETWEEN 1 AND 4),
    Year NUMBER NOT NULL,
    Holiday_flag NUMBER(1) CHECK (Holiday_flag IN (0, 1))
);

CREATE TABLE dimProduct (
    ProductSK NUMBER PRIMARY KEY,
    ProductBK NUMBER NOT NULL,
    Product_name VARCHAR2(255) NOT NULL,
    Category_BK NUMBER NOT NULL,
    Category_name VARCHAR2(255),
    Subcategory_BK NUMBER,
    Subcategory_name VARCHAR2(255),
    Brand VARCHAR2(255),
    Price NUMBER(10, 2) NOT NULL CHECK (Price > 0), -- Ensures Price is positive
    Production_date DATE,
    Expiration_date DATE
);

CREATE TABLE dimCustomer (
    CustomerSK NUMBER PRIMARY KEY,
    CustomerBK NUMBER NOT NULL,
    Customer_name VARCHAR2(255) NOT NULL,
    Phone VARCHAR2(20),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')), -- Ensures valid gender values
    Age NUMBER CHECK (Age >= 0), -- Ensures Age is non-negative
    City VARCHAR2(255)
);

CREATE TABLE dimEmployee (
    EmployeeSK NUMBER PRIMARY KEY,
    EmployeeBK NUMBER NOT NULL,
    Employee_name VARCHAR2(255) NOT NULL,
    NationalID VARCHAR2(50) NOT NULL,
    Job_title VARCHAR2(100),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')), -- Ensures valid gender values
    Hire_date DATE NOT NULL
);

CREATE TABLE dimStore (
    StoreSK NUMBER PRIMARY KEY,
    StoreBK NUMBER NOT NULL,
    Store_location VARCHAR2(255) NOT NULL,
    Store_size NUMBER CHECK (Store_Size > 0), 
    Manager_ID NUMBER
);

CREATE TABLE dimPromotion (
    PromotionSK NUMBER PRIMARY KEY,
    PromotionBK NUMBER NOT NULL,
    Promotion_name VARCHAR2(250) NOT NULL,
    Promotion_type VARCHAR2(50),
    discount_percentage NUMBER(5, 2) CHECK (discount_percentage BETWEEN 0 AND 100),
    Start_date DATE NOT NULL,
    End_date DATE,
    CONSTRAINT chk_date_range CHECK (End_date IS NULL OR End_date >= Start_date) -- Ensures valid date range
);

-- Creating the fact table
-- Grain: One row per transaction line item (each product sold per transaction).
CREATE TABLE factTransaction (
    TransactionID NUMBER PRIMARY KEY,
    InvoiceID NUMBER NOT NULL,
    CustomerFK NUMBER,
    StoreFK NUMBER,
    EmployeeFK NUMBER,
    Date_ID NUMBER,
    PromotionFK NUMBER,
    ProductFK NUMBER,
    Quantity NUMBER NOT NULL CHECK (Quantity > 0), -- Ensures Quantity is positive
    Total_price NUMBER(15, 2) NOT NULL CHECK (Total_price >= 0), -- Ensures Total_price is non-negative
    CONSTRAINT fk_Customer FOREIGN KEY (CustomerFK) REFERENCES dimCustomer(CustomerSK),
    CONSTRAINT fk_Store FOREIGN KEY (StoreFK) REFERENCES dimStore(StoreSK),
    CONSTRAINT fk_Employee FOREIGN KEY (EmployeeFK) REFERENCES dimEmployee(EmployeeSK),
    CONSTRAINT fk_Date FOREIGN KEY (Date_ID) REFERENCES dimDate(DateID),
    CONSTRAINT fk_Promotion FOREIGN KEY (PromotionFK) REFERENCES dimPromotion(PromotionSK),
    CONSTRAINT fk_Product FOREIGN KEY (ProductFK) REFERENCES dimProduct(ProductSK)
);