-- ============================================================
-- COMPLETE PVFC DATABASE (AUTO-INCREMENT VERSION)
-- ============================================================

-- =========================
-- DROP TABLES (FK ORDER)
-- =========================
IF OBJECT_ID('dbo.Works_In_t','U') IS NOT NULL DROP TABLE dbo.Works_In_t;
IF OBJECT_ID('dbo.Uses_t','U') IS NOT NULL DROP TABLE dbo.Uses_t;
IF OBJECT_ID('dbo.SUPPLIES_t','U') IS NOT NULL DROP TABLE dbo.SUPPLIES_t;
IF OBJECT_ID('dbo.VENDOR_t','U') IS NOT NULL DROP TABLE dbo.VENDOR_t;
IF OBJECT_ID('dbo.SALESPERSON_t','U') IS NOT NULL DROP TABLE dbo.SALESPERSON_t;
IF OBJECT_ID('dbo.RAW_MATERIAL_t','U') IS NOT NULL DROP TABLE dbo.RAW_MATERIAL_t;
IF OBJECT_ID('dbo.Order_line_t','U') IS NOT NULL DROP TABLE dbo.Order_line_t;
IF OBJECT_ID('dbo.Produced_In_t','U') IS NOT NULL DROP TABLE dbo.Produced_In_t;
IF OBJECT_ID('dbo.PRODUCT_t','U') IS NOT NULL DROP TABLE dbo.PRODUCT_t;
IF OBJECT_ID('dbo.PRODUCT_LINE_t','U') IS NOT NULL DROP TABLE dbo.PRODUCT_LINE_t;
IF OBJECT_ID('dbo.WORK_CENTER_t','U') IS NOT NULL DROP TABLE dbo.WORK_CENTER_t;
IF OBJECT_ID('dbo.ORDER_t','U') IS NOT NULL DROP TABLE dbo.ORDER_t;
IF OBJECT_ID('dbo.Employee_Skills_t','U') IS NOT NULL DROP TABLE dbo.Employee_Skills_t;
IF OBJECT_ID('dbo.SKILL_t','U') IS NOT NULL DROP TABLE dbo.SKILL_t;
IF OBJECT_ID('dbo.EMPLOYEE_t','U') IS NOT NULL DROP TABLE dbo.EMPLOYEE_t;
IF OBJECT_ID('dbo.Does_Business_In_t','U') IS NOT NULL DROP TABLE dbo.Does_Business_In_t;
IF OBJECT_ID('dbo.TERRITORY_t','U') IS NOT NULL DROP TABLE dbo.TERRITORY_t;
IF OBJECT_ID('dbo.CUSTOMER_t','U') IS NOT NULL DROP TABLE dbo.CUSTOMER_t;
GO

-- =========================
-- TABLES
-- =========================

CREATE TABLE CUSTOMER_t(
    Customer_Id INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Name VARCHAR(255),
    Customer_Address VARCHAR(255),
    Customer_City VARCHAR(255),
    Customer_State VARCHAR(2),
    Postal_Code VARCHAR(10)
);

CREATE TABLE TERRITORY_t(
    Territory_Id INT IDENTITY(1,1) PRIMARY KEY,
    Territory_Name VARCHAR(255)
);

CREATE TABLE Does_Business_In_t(
    Customer_Id INT REFERENCES CUSTOMER_t(Customer_Id),
    Territory_Id INT REFERENCES TERRITORY_t(Territory_Id),
    PRIMARY KEY(Customer_Id,Territory_Id)
);

CREATE TABLE EMPLOYEE_t(
    Employee_Id VARCHAR(10) PRIMARY KEY,
    Employee_Name VARCHAR(255),
    Employee_Address VARCHAR(255),
    Employee_BirthDate DATE,
    Employee_City VARCHAR(255),
    Employee_Date_Hired DATE,
    Employee_State VARCHAR(2),
    Employee_Supervisor VARCHAR(10),
    Employee_Zip VARCHAR(10)
);

CREATE TABLE SKILL_t(
    Skill_Id VARCHAR(12) PRIMARY KEY,
    Skill_Description VARCHAR(255)
);

CREATE TABLE Employee_Skills_t(
    Employee_Id VARCHAR(10) REFERENCES EMPLOYEE_t(Employee_Id),
    Skill_Id VARCHAR(12) REFERENCES SKILL_t(Skill_Id),
    PRIMARY KEY(Employee_Id,Skill_Id)
);

CREATE TABLE ORDER_t(
    Order_Id INT IDENTITY(1001,1) PRIMARY KEY,
    Customer_Id INT REFERENCES CUSTOMER_t(Customer_Id),
    Order_Date DATE
);

CREATE TABLE WORK_CENTER_t(
    Work_Center_Id VARCHAR(12) PRIMARY KEY,
    Work_Center_Location VARCHAR(255)
);

CREATE TABLE PRODUCT_LINE_t(
    Product_Line_Id INT IDENTITY(1,1) PRIMARY KEY,
    Product_Line_Name VARCHAR(255)
);

CREATE TABLE PRODUCT_t(
    Product_Id INT IDENTITY(1,1) PRIMARY KEY,
    Product_Line_Id INT REFERENCES PRODUCT_LINE_t(Product_Line_Id),
    Product_Description VARCHAR(255),
    Product_Finish VARCHAR(255),
    Standard_Price DECIMAL(10,2)
);

CREATE TABLE Produced_In_t(
    Product_Id INT REFERENCES PRODUCT_t(Product_Id),
    Work_Center_Id VARCHAR(12) REFERENCES WORK_CENTER_t(Work_Center_Id),
    PRIMARY KEY(Product_Id,Work_Center_Id)
);

CREATE TABLE Order_line_t(
    Order_Id INT REFERENCES ORDER_t(Order_Id),
    Product_Id INT REFERENCES PRODUCT_t(Product_Id),
    Ordered_Quantity INT,
    PRIMARY KEY(Order_Id,Product_Id)
);

CREATE TABLE RAW_MATERIAL_t(
    Material_Id VARCHAR(12) PRIMARY KEY,
    Material_Name VARCHAR(255),
    Standard_Cost DECIMAL(6,2),
    Unit_Of_Measure VARCHAR(10)
);

CREATE TABLE SALESPERSON_t(
    SalesPerson_Id INT IDENTITY(1,1) PRIMARY KEY,
    SalesPerson_Name VARCHAR(255),
    SalesPerson_phone VARCHAR(50),
    SalesPerson_Fax VARCHAR(50),
    Territory_Id INT REFERENCES TERRITORY_t(Territory_Id)
);

CREATE TABLE VENDOR_t(
    Vendor_Id INT IDENTITY(1,1) PRIMARY KEY,
    Vendor_Name VARCHAR(255),
    Vendor_Address VARCHAR(255),
    Vendor_City VARCHAR(255),
    Vendor_Contact VARCHAR(50),
    Vendor_Fax VARCHAR(10),
    Vendor_Phone VARCHAR(10),
    Vendor_State VARCHAR(2),
    Vendor_Tax_Id VARCHAR(50),
    Vendor_Zipcode VARCHAR(50)
);

CREATE TABLE SUPPLIES_t(
    Vendor_Id INT REFERENCES VENDOR_t(Vendor_Id),
    Material_Id VARCHAR(12) REFERENCES RAW_MATERIAL_t(Material_Id),
    Supply_Unit_Price DECIMAL(6,2),
    PRIMARY KEY(Vendor_Id,Material_Id)
);

CREATE TABLE Uses_t(
    Goes_into_Quantity INT,
    Material_Id VARCHAR(12) REFERENCES RAW_MATERIAL_t(Material_Id),
    Product_Id INT REFERENCES PRODUCT_t(Product_Id),
    PRIMARY KEY(Product_Id,Material_Id)
);

CREATE TABLE Works_In_t(
    Employee_Id VARCHAR(10) REFERENCES EMPLOYEE_t(Employee_Id),
    Work_Center_Id VARCHAR(12) REFERENCES WORK_CENTER_t(Work_Center_Id),
    PRIMARY KEY(Employee_Id,Work_Center_Id)
);
GO

-- =========================
-- INSERT DATA
-- =========================

INSERT INTO CUSTOMER_t
(Customer_Name,Customer_Address,Customer_City,Customer_State,Postal_Code)
VALUES
('Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','32601-2871'),
('Value Furniture','15145 S.W. 17th St.','Plano','TX','75094-7743'),
('Home Furnishings','1900 Allard Ave.','Albany','NY','12209-1125');

INSERT INTO TERRITORY_t (Territory_Name)
VALUES ('SouthEast'),('SouthWest'),('NorthEast'),('NorthWest'),('Central');

INSERT INTO Does_Business_In_t VALUES
(1,1),(1,2),(2,2),(3,3);

INSERT INTO EMPLOYEE_t VALUES
('123-44-345','Jim Jason','2134 Hilltop Rd',NULL,'','1999-06-12','TN','454-56-768',''),
('454-56-768','Robert Lewis','17834 Deerfield Ln',NULL,'Nashville','1999-01-01','TN','','');

INSERT INTO SKILL_t VALUES
('BS12','12in Band Saw'),
('QC1','Quality Control'),
('RT1','Router');

INSERT INTO Employee_Skills_t VALUES
('123-44-345','BS12'),
('123-44-345','RT1');

INSERT INTO PRODUCT_LINE_t (Product_Line_Name)
VALUES ('Cherry Tree'),('Scandinavia'),('Country Look');

INSERT INTO PRODUCT_t
(Product_Description,Product_Finish,Standard_Price,Product_Line_Id)
VALUES
('End Table','Cherry',175,1),
('Coffee Table','Natural Ash',200,2);

INSERT INTO ORDER_t (Order_Date,Customer_Id)
VALUES ('2008-10-21',1),
       ('2008-10-21',2);

INSERT INTO Order_line_t VALUES
(1001,1,2),
(1001,2,2);

INSERT INTO WORK_CENTER_t VALUES
('SM1','Main Saw Mill'),
('WR1','Warehouse and Receiving');

INSERT INTO Works_In_t VALUES
('123-44-345','SM1');

INSERT INTO SALESPERSON_t
(SalesPerson_Name,SalesPerson_phone,SalesPerson_Fax,Territory_Id)
VALUES
('Doug Henny','8134445555','',1),
('Robert Lewis','8139264006','',2);

GO

PRINT 'PVFC Database with AUTO-INCREMENT IDs created successfully.';
GO
