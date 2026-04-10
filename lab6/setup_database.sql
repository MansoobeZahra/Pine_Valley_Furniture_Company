-- ============================================================
-- PVFC DATABASE - Lab 06 (with RBAC Users table)
-- Original schema (explicit IDs, no IDENTITY)
-- ============================================================

USE PVFC;
GO

SET DATEFORMAT dmy;
SET ANSI_WARNINGS OFF;
GO

-- =========================
-- DROP TABLES (FK ORDER)
-- =========================
IF OBJECT_ID('dbo.Users','U') IS NOT NULL DROP TABLE dbo.Users;
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
-- RBAC USERS TABLE
-- =========================
CREATE TABLE Users (
    UserId INT IDENTITY PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    User_Password VARCHAR(50),
    User_Role VARCHAR(20)
);
GO

-- =========================
-- PVFC TABLES
-- =========================
CREATE TABLE CUSTOMER_t (
    Customer_Id      INT          NOT NULL,
    Customer_Name    VARCHAR(25),
    Customer_Address VARCHAR(30),
    Customer_City    VARCHAR(20),
    Customer_State   VARCHAR(2),
    Postal_Code      VARCHAR(10),
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_Id)
);

CREATE TABLE TERRITORY_t (
    Territory_Id   INT         NOT NULL,
    Territory_Name VARCHAR(50),
    CONSTRAINT TERRITORY_PK PRIMARY KEY (Territory_Id)
);

CREATE TABLE Does_Business_In_t (
    Customer_Id  INT NOT NULL,
    Territory_Id INT NOT NULL,
    CONSTRAINT Does_Business_In_PK  PRIMARY KEY (Customer_Id, Territory_Id),
    CONSTRAINT Does_Business_In_FK1 FOREIGN KEY (Customer_Id)  REFERENCES CUSTOMER_t(Customer_Id),
    CONSTRAINT Does_Business_In_FK2 FOREIGN KEY (Territory_Id) REFERENCES TERRITORY_t(Territory_Id)
);

CREATE TABLE EMPLOYEE_t (
    Employee_Id         VARCHAR(10) NOT NULL,
    Employee_Name       VARCHAR(25),
    Employee_Address    VARCHAR(30),
    Employee_BirthDate  DATE,
    Employee_City       VARCHAR(20),
    Employee_Date_Hired DATE,
    Employee_State      VARCHAR(2),
    Employee_Supervisor VARCHAR(10),
    Employee_Zip        VARCHAR(10),
    CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Employee_Id)
);

CREATE TABLE SKILL_t (
    Skill_Id          VARCHAR(12) NOT NULL,
    Skill_Description VARCHAR(30),
    CONSTRAINT SKILL_PK PRIMARY KEY (Skill_Id)
);

CREATE TABLE Employee_Skills_t (
    Employee_Id VARCHAR(10) NOT NULL,
    Skill_Id    VARCHAR(12) NOT NULL,
    CONSTRAINT Employee_Skills_PK  PRIMARY KEY (Employee_Id, Skill_Id),
    CONSTRAINT Employee_Skills_FK1 FOREIGN KEY (Employee_Id) REFERENCES EMPLOYEE_t(Employee_Id),
    CONSTRAINT Employee_Skills_FK2 FOREIGN KEY (Skill_Id)    REFERENCES SKILL_t(Skill_Id)
);

CREATE TABLE ORDER_t (
    Order_Id    INT  NOT NULL,
    Customer_Id INT,
    Order_Date  DATE,
    CONSTRAINT ORDER_PK  PRIMARY KEY (Order_Id),
    CONSTRAINT ORDER_FK1 FOREIGN KEY (Customer_Id) REFERENCES CUSTOMER_t(Customer_Id)
);

CREATE TABLE WORK_CENTER_t (
    Work_Center_Id       VARCHAR(12) NOT NULL,
    Work_Center_Location VARCHAR(30),
    CONSTRAINT WORK_CENTER_PK PRIMARY KEY (Work_Center_Id)
);

CREATE TABLE PRODUCT_LINE_t (
    Product_Line_Id   INT         NOT NULL,
    Product_Line_Name VARCHAR(50),
    CONSTRAINT PRODUCT_LINE_PK PRIMARY KEY (Product_Line_Id)
);

CREATE TABLE PRODUCT_t (
    Product_Id          INT         NOT NULL,
    Product_Line_Id     INT,
    Product_Description VARCHAR(50),
    Product_Finish      VARCHAR(20),
    Standard_Price      DECIMAL(6,2),
    CONSTRAINT PRODUCT_PK  PRIMARY KEY (Product_Id),
    CONSTRAINT PRODUCT_FK1 FOREIGN KEY (Product_Line_Id) REFERENCES PRODUCT_LINE_t(Product_Line_Id)
);

CREATE TABLE Produced_In_t (
    Product_Id     INT         NOT NULL,
    Work_Center_Id VARCHAR(12) NOT NULL,
    CONSTRAINT Produced_In_PK  PRIMARY KEY (Product_Id, Work_Center_Id),
    CONSTRAINT Produced_In_FK1 FOREIGN KEY (Product_Id)     REFERENCES PRODUCT_t(Product_Id),
    CONSTRAINT Produced_In_FK2 FOREIGN KEY (Work_Center_Id) REFERENCES WORK_CENTER_t(Work_Center_Id)
);

CREATE TABLE Order_line_t (
    Order_Id         INT NOT NULL,
    Product_Id       INT NOT NULL,
    Ordered_Quantity INT,
    CONSTRAINT Order_line_PK  PRIMARY KEY (Order_Id, Product_Id),
    CONSTRAINT Order_line_FK1 FOREIGN KEY (Order_Id)   REFERENCES ORDER_t(Order_Id),
    CONSTRAINT Order_line_FK2 FOREIGN KEY (Product_Id) REFERENCES PRODUCT_t(Product_Id)
);

CREATE TABLE RAW_MATERIAL_t (
    Material_Id     VARCHAR(12) NOT NULL,
    Material_Name   VARCHAR(30),
    Standard_Cost   DECIMAL(6,2),
    Unit_Of_Measure VARCHAR(10),
    CONSTRAINT RAW_MATERIAL_PK PRIMARY KEY (Material_Id)
);

CREATE TABLE SALESPERSON_t (
    SalesPerson_Id    INT         NOT NULL,
    SalesPerson_Name  VARCHAR(25),
    SalesPerson_phone VARCHAR(50),
    SalesPerson_Fax   VARCHAR(50),
    Territory_Id      INT,
    CONSTRAINT SALESPERSON_PK  PRIMARY KEY (SalesPerson_Id),
    CONSTRAINT SALESPERSON_FK1 FOREIGN KEY (Territory_Id) REFERENCES TERRITORY_t(Territory_Id)
);

CREATE TABLE VENDOR_t (
    Vendor_Id      INT         NOT NULL,
    Vendor_Name    VARCHAR(25),
    Vendor_Address VARCHAR(30),
    Vendor_City    VARCHAR(20),
    Vendor_Contact VARCHAR(50),
    Vendor_Fax     VARCHAR(10),
    Vendor_Phone   VARCHAR(10),
    Vendor_State   VARCHAR(2),
    Vendor_Tax_Id  VARCHAR(50),
    Vendor_Zipcode VARCHAR(50),
    CONSTRAINT VENDOR_PK PRIMARY KEY (Vendor_Id)
);

CREATE TABLE SUPPLIES_t (
    Vendor_Id         INT         NOT NULL,
    Material_Id       VARCHAR(12) NOT NULL,
    Supply_Unit_Price DECIMAL(6,2),
    CONSTRAINT SUPPLIES_PK  PRIMARY KEY (Vendor_Id, Material_Id),
    CONSTRAINT SUPPLIES_FK1 FOREIGN KEY (Material_Id) REFERENCES RAW_MATERIAL_t(Material_Id),
    CONSTRAINT SUPPLIES_FK2 FOREIGN KEY (Vendor_Id)   REFERENCES VENDOR_t(Vendor_Id)
);

CREATE TABLE Uses_t (
    Goes_into_Quantity INT,
    Material_Id        VARCHAR(12) NOT NULL,
    Product_Id         INT         NOT NULL,
    CONSTRAINT Uses_PK  PRIMARY KEY (Product_Id, Material_Id),
    CONSTRAINT Uses_FK1 FOREIGN KEY (Product_Id)  REFERENCES PRODUCT_t(Product_Id),
    CONSTRAINT Uses_FK2 FOREIGN KEY (Material_Id) REFERENCES RAW_MATERIAL_t(Material_Id)
);

CREATE TABLE Works_In_t (
    Employee_Id    VARCHAR(10) NOT NULL,
    Work_Center_Id VARCHAR(12) NOT NULL,
    CONSTRAINT Works_In_PK  PRIMARY KEY (Employee_Id, Work_Center_Id),
    CONSTRAINT Works_In_FK1 FOREIGN KEY (Employee_Id)    REFERENCES EMPLOYEE_t(Employee_Id),
    CONSTRAINT Works_In_FK2 FOREIGN KEY (Work_Center_Id) REFERENCES WORK_CENTER_t(Work_Center_Id)
);
GO

-- =========================
-- INSERT DATA
-- =========================

-- USERS (RBAC)
INSERT INTO Users (Username, User_Password, User_Role) VALUES
('admin', '123', 'admin'),
('umer',  '123', 'user');

-- CUSTOMERS
INSERT INTO CUSTOMER_t VALUES (1,'Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','32601-2871');
INSERT INTO CUSTOMER_t VALUES (2,'Value Furniture','15145 S.W. 17th St.','Plano','TX','75094-7743');
INSERT INTO CUSTOMER_t VALUES (3,'Home Furnishings','1900 Allard Ave.','Albany','NY','12209-1125');
INSERT INTO CUSTOMER_t VALUES (4,'Eastern Furniture','1925 Beltline Rd.','Carteret','NJ','07008-3188');
INSERT INTO CUSTOMER_t VALUES (5,'Impressions','5585 Westcott Ct.','Sacramento','CA','94206-4056');
INSERT INTO CUSTOMER_t VALUES (6,'Furniture Gallery','325 Flatiron Dr.','Boulder','CO','80514-4432');
INSERT INTO CUSTOMER_t VALUES (7,'Period Furniture','394 Rainbow Dr.','Seattle','WA','97954-5589');
INSERT INTO CUSTOMER_t VALUES (8,'Calfornia Classics','816 Peach Rd.','Santa Clara','CA','96915-7754');
INSERT INTO CUSTOMER_t VALUES (9,'M and H Casual Furniture','3709 First Street','Clearwater','FL','34620-2314');
INSERT INTO CUSTOMER_t VALUES (10,'Seminole Interiors','2400 Rocky Point Dr.','Seminole','FL','34646-4423');
INSERT INTO CUSTOMER_t VALUES (11,'American Euro Lifestyles','2424 Missouri Ave N.','Prospect Park','NJ','07508-5621');
INSERT INTO CUSTOMER_t VALUES (12,'Battle Creek Furniture','345 Capitol Ave. SW','Battle Creek','MI','49015-3401');
INSERT INTO CUSTOMER_t VALUES (13,'Heritage Furnishings','66789 College Ave.','Carlisle','PA','17013-8834');
INSERT INTO CUSTOMER_t VALUES (14,'Kaneohe Homes','112 Kiowai St.','Kaneohe','HI','96744-2537');
INSERT INTO CUSTOMER_t VALUES (15,'Mountain Scenes','4132 Main Street','Ogden','UT','84403-4432');

-- TERRITORIES
INSERT INTO TERRITORY_t VALUES (1,'SouthEast'),(2,'SouthWest'),(3,'NorthEast'),(4,'NorthWest'),(5,'Central');

-- DOES BUSINESS IN
INSERT INTO Does_Business_In_t VALUES (1,1),(1,2),(2,2),(3,3),(4,3),(5,2),(6,5);

-- EMPLOYEES
INSERT INTO EMPLOYEE_t VALUES ('123-44-345','Jim Jason','2134 Hilltop Rd',NULL,'','TN','454-56-768','','12/Jun/99');
INSERT INTO EMPLOYEE_t VALUES ('454-56-768','Robert Lewis','17834 Deerfield Ln',NULL,'Nashville','TN','','','01/Jan/99');

-- SKILLS
INSERT INTO SKILL_t VALUES ('BS12','12in Band Saw'),('QC1','Quality Control'),('RT1','Router'),
('S)1','Sander-Orbital'),('SB1','Sander-Belt'),('TS10','10in Table Saw'),
('TS12','12in Table Saw'),('UC1','Upholstery Cutter'),('US1','Upholstery Sewer'),('UT1','Upholstery Tacker');

-- EMPLOYEE SKILLS
INSERT INTO Employee_Skills_t VALUES ('123-44-345','BS12'),('123-44-345','RT1'),('454-56-768','BS12');

-- PRODUCT LINES
INSERT INTO PRODUCT_LINE_t VALUES (1,'Cherry Tree'),(2,'Scandinavia'),(3,'Country Look');

-- PRODUCTS
INSERT INTO PRODUCT_t VALUES (1,1,'End Table','Cherry',175);
INSERT INTO PRODUCT_t VALUES (2,2,'Coffee Table','Natural Ash',200);
INSERT INTO PRODUCT_t VALUES (3,2,'Computer Desk','Natural Ash',375);
INSERT INTO PRODUCT_t VALUES (4,3,'Entertainment Center','Natural Maple',650);
INSERT INTO PRODUCT_t VALUES (5,1,'Writers Desk','Cherry',325);
INSERT INTO PRODUCT_t VALUES (6,2,'8-Drawer Desk','White Ash',750);
INSERT INTO PRODUCT_t VALUES (7,2,'Dining Table','Natural Ash',800);
INSERT INTO PRODUCT_t VALUES (8,3,'Computer Desk','Walnut',250);

-- ORDERS
INSERT INTO ORDER_t VALUES (1001,1,'21/Oct/08'),(1002,8,'21/Oct/08'),(1003,15,'22/Oct/08'),
(1004,5,'22/Oct/08'),(1005,3,'24/Oct/08'),(1006,2,'24/Oct/08'),
(1007,11,'27/Oct/08'),(1008,12,'30/Oct/08'),(1009,4,'05/Nov/08'),(1010,1,'05/Nov/08');

-- ORDER LINES
INSERT INTO Order_line_t VALUES (1001,1,2),(1001,2,2),(1001,4,1),(1002,3,5),(1003,3,3),
(1004,6,2),(1004,8,2),(1005,4,3),(1006,4,1),(1006,5,2),(1006,7,2),
(1007,1,3),(1007,2,2),(1008,3,3),(1008,8,3),(1009,4,2),(1009,7,3),(1010,8,10);

-- WORK CENTERS
INSERT INTO WORK_CENTER_t VALUES ('SM1','Main Saw Mill'),('WR1','Warehouse and Receiving');

-- WORKS IN
INSERT INTO Works_In_t VALUES ('123-44-345','SM1');

-- SALESPERSONS
INSERT INTO SALESPERSON_t VALUES (1,'Doug Henny','8134445555','',1);
INSERT INTO SALESPERSON_t VALUES (2,'Robert Lewis','8139264006','',2);
INSERT INTO SALESPERSON_t VALUES (3,'William Strong','5053821212','',3);
INSERT INTO SALESPERSON_t VALUES (4,'Julie Dawson','4355346677','',4);
INSERT INTO SALESPERSON_t VALUES (5,'Jacob Winslow','2238973498','',5);
GO

PRINT 'Lab 06 PVFC Database created successfully.';

-- QUICK VERIFY
SELECT * FROM Users;
SELECT * FROM CUSTOMER_t;
SELECT * FROM PRODUCT_t;
GO
