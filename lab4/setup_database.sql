USE PVFC;
GO

-------------------------------------------------
-- SESSION SETTINGS (REQUIRED – NOT CODE CHANGE)
-------------------------------------------------
SET DATEFORMAT dmy;
SET ANSI_WARNINGS OFF;
GO

-------------------------------------------------
-- CHECK DATABASE
-------------------------------------------------
SELECT DB_NAME();
SELECT name FROM sys.databases;
GO

-------------------------------------------------
-- CREATE TABLES (DEPENDENCY-SAFE ORDER)
-------------------------------------------------

CREATE TABLE CUSTOMER_t (
    Customer_Id INT NOT NULL IDENTITY(1,1),
    Customer_Name VARCHAR(255),
    Customer_Address VARCHAR(255),
    Customer_City VARCHAR(255),
    Customer_State VARCHAR(2),
    Postal_Code VARCHAR(10),
    PRIMARY KEY (Customer_Id)
);

CREATE TABLE TERRITORY_t (
    Territory_Id INT NOT NULL IDENTITY(1,1),
    Territory_Name VARCHAR(255),
    PRIMARY KEY (Territory_Id)
);

CREATE TABLE EMPLOYEE_t (
    Employee_Id VARCHAR(10) NOT NULL,
    Employee_Name VARCHAR(255),
    Employee_Address VARCHAR(255),
    Employee_BirthDate DATE,
    Employee_City VARCHAR(255),
    Employee_Date_Hired DATE,
    Employee_State VARCHAR(2),
    Employee_Supervisor VARCHAR(10),
    Employee_Zip VARCHAR(10),
    PRIMARY KEY (Employee_Id)
);

CREATE TABLE SKILL_t (
    Skill_Id VARCHAR(12) NOT NULL,
    Skill_Description VARCHAR(255),
    PRIMARY KEY (Skill_Id)
);

CREATE TABLE WORK_CENTER_t (
    Work_Center_Id VARCHAR(12) NOT NULL,
    Work_Center_Location VARCHAR(255),
    PRIMARY KEY (Work_Center_Id)
);

CREATE TABLE RAW_MATERIAL_t (
    Material_Id VARCHAR(12) NOT NULL,
    Material_Name VARCHAR(255),
    Standard_Cost DECIMAL(6,2),
    Unit_Of_Measure VARCHAR(10),
    PRIMARY KEY (Material_Id)
);

CREATE TABLE VENDOR_t (
    Vendor_Id INT NOT NULL IDENTITY(1,1),
    Vendor_Name VARCHAR(255),
    Vendor_Address VARCHAR(255),
    Vendor_City VARCHAR(255),
    Vendor_Contact VARCHAR(50),
    Vendor_Fax VARCHAR(10),
    Vendor_Phone VARCHAR(10),
    Vendor_State VARCHAR(2),
    Vendor_Tax_Id VARCHAR(50),
    Vendor_Zipcode VARCHAR(50),
    PRIMARY KEY (Vendor_Id)
);

CREATE TABLE PRODUCT_LINE_t (
    Product_Line_Id INT NOT NULL IDENTITY(1,1),
    Product_Line_Name VARCHAR(255),
    PRIMARY KEY (Product_Line_Id)
);

CREATE TABLE PRODUCT_t (
    Product_Id INT NOT NULL IDENTITY(1,1),
    Product_Line_Id INT,
    Product_Description VARCHAR(255),
    Product_Finish VARCHAR(255),
    Standard_Price DECIMAL(10,2),
    PRIMARY KEY (Product_Id),
    FOREIGN KEY (Product_Line_Id) REFERENCES PRODUCT_LINE_t(Product_Line_Id)
);

CREATE TABLE ORDER_t (
    Order_Id INT NOT NULL IDENTITY(1,1),
    Customer_Id INT,
    Order_Date DATE,
    PRIMARY KEY (Order_Id),
    FOREIGN KEY (Customer_Id) REFERENCES CUSTOMER_t(Customer_Id)
);

CREATE TABLE Does_Business_In_t (
    Customer_Id INT NOT NULL,
    Territory_Id INT NOT NULL,
    PRIMARY KEY (Customer_Id, Territory_Id),
    FOREIGN KEY (Customer_Id) REFERENCES CUSTOMER_t(Customer_Id),
    FOREIGN KEY (Territory_Id) REFERENCES TERRITORY_t(Territory_Id)
);

CREATE TABLE Employee_Skills_t (
    Employee_Id VARCHAR(10) NOT NULL,
    Skill_Id VARCHAR(12) NOT NULL,
    PRIMARY KEY (Employee_Id, Skill_Id),
    FOREIGN KEY (Employee_Id) REFERENCES EMPLOYEE_t(Employee_Id),
    FOREIGN KEY (Skill_Id) REFERENCES SKILL_t(Skill_Id)
);

CREATE TABLE SALESPERSON_t (
    SalesPerson_Id INT NOT NULL IDENTITY(1,1),
    SalesPerson_Name VARCHAR(255),
    SalesPerson_phone VARCHAR(50),
    SalesPerson_Fax VARCHAR(50),
    Territory_Id INT,
    PRIMARY KEY (SalesPerson_Id),
    FOREIGN KEY (Territory_Id) REFERENCES TERRITORY_t(Territory_Id)
);

CREATE TABLE SUPPLIES_t (
    Vendor_Id INT NOT NULL,
    Material_Id VARCHAR(12) NOT NULL,
    Supply_Unit_Price DECIMAL(6,2),
    PRIMARY KEY (Vendor_Id, Material_Id),
    FOREIGN KEY (Material_Id) REFERENCES RAW_MATERIAL_t(Material_Id),
    FOREIGN KEY (Vendor_Id) REFERENCES VENDOR_t(Vendor_Id)
);

CREATE TABLE Produced_In_t (
    Product_Id INT NOT NULL,
    Work_Center_Id VARCHAR(12) NOT NULL,
    PRIMARY KEY (Product_Id, Work_Center_Id),
    FOREIGN KEY (Product_Id) REFERENCES PRODUCT_t(Product_Id),
    FOREIGN KEY (Work_Center_Id) REFERENCES WORK_CENTER_t(Work_Center_Id)
);

CREATE TABLE Uses_t (
    Goes_into_Quantity INT,
    Material_Id VARCHAR(12) NOT NULL,
    Product_Id INT NOT NULL,
    PRIMARY KEY (Product_Id, Material_Id),
    FOREIGN KEY (Product_Id) REFERENCES PRODUCT_t(Product_Id),
    FOREIGN KEY (Material_Id) REFERENCES RAW_MATERIAL_t(Material_Id)
);

CREATE TABLE Works_In_t (
    Employee_Id VARCHAR(10) NOT NULL,
    Work_Center_Id VARCHAR(12) NOT NULL,
    PRIMARY KEY (Employee_Id, Work_Center_Id),
    FOREIGN KEY (Employee_Id) REFERENCES EMPLOYEE_t(Employee_Id),
    FOREIGN KEY (Work_Center_Id) REFERENCES WORK_CENTER_t(Work_Center_Id)
);

CREATE TABLE Order_line_t (
    Order_Id INT NOT NULL,
    Product_Id INT NOT NULL,
    Ordered_Quantity INT,
    PRIMARY KEY (Order_Id, Product_Id),
    FOREIGN KEY (Order_Id) REFERENCES ORDER_t(Order_Id),
    FOREIGN KEY (Product_Id) REFERENCES PRODUCT_t(Product_Id)
);

-------------------------------------------------
-- INSERT DATA (DEPENDENCY-SAFE ORDER)
-------------------------------------------------

-- CUSTOMER
SET IDENTITY_INSERT CUSTOMER_t ON;
INSERT INTO CUSTOMER_t (Customer_Id, Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) VALUES
(1,'Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','32601-2871'),
(2,'Value Furniture','15145 S.W. 17th St.','Plano','TX','75094-7743'),
(3,'Home Furnishings','1900 Allard Ave.','Albany','NY','12209-1125'),
(4,'Eastern Furniture','1925 Beltline Rd.','Carteret','NJ','07008-3188'),
(5,'Impressions','5585 Westcott Ct.','Sacramento','CA','94206-4056'),
(6,'Furniture Gallery','325 Flatiron Dr.','Boulder','CO','80514-4432'),
(7,'Period Furniture','394 Rainbow Dr.','Seattle','WA','97954-5589'),
(8,'Calfornia Classics','816 Peach Rd.','Santa Clara','CA','96915-7754'),
(9,'M and H Casual Furniture','3709 First Street','Clearwater','FL','34620-2314'),
(10,'Seminole Interiors','2400 Rocky Point Dr.','Seminole','FL','34646-4423'),
(11,'American Euro Lifestyles','2424 Missouri Ave N.','Prospect Park','NJ','07508-5621'),
(12,'Battle Creek Furniture','345 Capitol Ave. SW','Battle Creek','MI','49015-3401'),
(13,'Heritage Furnishings','66789 College Ave.','Carlisle','PA','17013-8834'),
(14,'Kaneohe Homes','112 Kiowai St.','Kaneohe','HI','96744-2537'),
(15,'Mountain Scenes','4132 Main Street','Ogden','UT','84403-4432');
SET IDENTITY_INSERT CUSTOMER_t OFF;

-- TERRITORY
SET IDENTITY_INSERT TERRITORY_t ON;
INSERT INTO TERRITORY_t (Territory_Id, Territory_Name) VALUES
(1,'SouthEast'),(2,'SouthWest'),(3,'NorthEast'),(4,'NorthWest'),(5,'Central');
SET IDENTITY_INSERT TERRITORY_t OFF;

-- PRODUCT LINE
SET IDENTITY_INSERT PRODUCT_LINE_t ON;
INSERT INTO PRODUCT_LINE_t (Product_Line_Id, Product_Line_Name) VALUES
(1,'Cherry Tree'),(2,'Scandinavia'),(3,'Country Look');
SET IDENTITY_INSERT PRODUCT_LINE_t OFF;

-- PRODUCT
SET IDENTITY_INSERT PRODUCT_t ON;
INSERT INTO PRODUCT_t (Product_Id, Product_Line_Id, Product_Description, Product_Finish, Standard_Price) VALUES
(1,1,'End Table','Cherry',175),
(2,2,'Coffee Table','Natural Ash',200),
(3,2,'Computer Desk','Natural Ash',375),
(4,3,'Entertainment Center','Natural Maple',650),
(5,1,'Writers Desk','Cherry',325),
(6,2,'8-Drawer Desk','White Ash',750),
(7,2,'Dining Table','Natural Ash',800),
(8,3,'Computer Desk','Walnut',250);
SET IDENTITY_INSERT PRODUCT_t OFF;

-- ORDER
SET IDENTITY_INSERT ORDER_t ON;
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(1001,1,'21/Oct/08'),(1002,8,'21/Oct/08'),(1003,15,'22/Oct/08'),
(1004,5,'22/Oct/08'),(1005,3,'24/Oct/08'),(1006,2,'24/Oct/08'),
(1007,11,'27/Oct/08'),(1008,12,'30/Oct/08'),(1009,4,'05/Nov/08'),
(1010,1,'05/Nov/08');
SET IDENTITY_INSERT ORDER_t OFF;

-- ORDER LINE
INSERT INTO Order_line_t VALUES
(1001,1,2),(1001,2,2),(1001,4,1),(1002,3,5),(1003,3,3),
(1004,6,2),(1004,8,2),(1005,4,3),(1006,4,1),(1006,5,2),
(1006,7,2),(1007,1,3),(1007,2,2),(1008,3,3),(1008,8,3),
(1009,4,2),(1009,7,3),(1010,8,10);

-------------------------------------------------
-- USERS TABLE FOR LOGIN SYSTEM
-------------------------------------------------

-------------------------------------------------
-- FINAL CHECKS
-------------------------------------------------
SELECT * FROM CUSTOMER_t;
SELECT * FROM ORDER_t;
SELECT * FROM Order_line_t;
SELECT * FROM PRODUCT_t;
