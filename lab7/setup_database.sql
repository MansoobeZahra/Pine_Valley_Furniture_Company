-- ============================================================
-- LAB 07 – PVFC Database with Customer Segmentation Data
-- Run in SSMS against PVFC database
-- ============================================================
USE PVFC;
GO

-- Drop tables in order (FK first)
IF OBJECT_ID('Order_line_t','U') IS NOT NULL DROP TABLE Order_line_t;
IF OBJECT_ID('ORDER_t','U')      IS NOT NULL DROP TABLE ORDER_t;
IF OBJECT_ID('PRODUCT_t','U')    IS NOT NULL DROP TABLE PRODUCT_t;
IF OBJECT_ID('PRODUCT_LINE_t','U') IS NOT NULL DROP TABLE PRODUCT_LINE_t;
IF OBJECT_ID('CUSTOMER_t','U')   IS NOT NULL DROP TABLE CUSTOMER_t;
IF OBJECT_ID('Users','U')        IS NOT NULL DROP TABLE Users;
GO

-- ── USERS (RBAC) ────────────────────────────────────────────
CREATE TABLE Users (
    UserId        INT IDENTITY PRIMARY KEY,
    Username      VARCHAR(50) UNIQUE,
    User_Password VARCHAR(50),
    User_Role     VARCHAR(20)
);
INSERT INTO Users (Username, User_Password, User_Role) VALUES
('admin','123','admin'),
('umer','123','user'),
('sara','123','user'),
('john','123','user');

-- ── PRODUCT LINE ─────────────────────────────────────────────
CREATE TABLE PRODUCT_LINE_t (
    Product_Line_Id   INT NOT NULL,
    Product_Line_Name VARCHAR(50),
    CONSTRAINT PRODUCT_LINE_PK PRIMARY KEY (Product_Line_Id)
);
INSERT INTO PRODUCT_LINE_t VALUES (1,'Living Room'),(2,'Dining Room'),(3,'Bedroom');

-- ── CUSTOMERS (25 records) ───────────────────────────────────
CREATE TABLE CUSTOMER_t (
    Customer_Id      INT NOT NULL,
    Customer_Name    VARCHAR(25),
    Customer_Address VARCHAR(30),
    Customer_City    VARCHAR(20),
    Customer_State   VARCHAR(2),
    Postal_Code      VARCHAR(10),
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_Id)
);
INSERT INTO CUSTOMER_t VALUES
(1,'Ali Hassan','123 Oak St','New York','NY','10001'),
(2,'Sara Khan','456 Pine Ave','Los Angeles','CA','90001'),
(3,'John Smith','789 Elm Rd','Chicago','IL','60601'),
(4,'Emily Davis','321 Maple Dr','Houston','TX','77001'),
(5,'Michael Brown','654 Cedar Ln','Phoenix','AZ','85001'),
(6,'Fatima Malik','987 Birch Blvd','Philadelphia','PA','19101'),
(7,'David Wilson','147 Walnut St','San Antonio','TX','78201'),
(8,'Aisha Raza','258 Spruce Way','San Diego','CA','92101'),
(9,'James Taylor','369 Poplar Ave','Dallas','TX','75201'),
(10,'Linda Thomas','741 Ash Ct','San Jose','CA','95101'),
(11,'Robert Martin','852 Hickory Pl','Austin','TX','78701'),
(12,'Patricia Garcia','963 Willow Rd','Jacksonville','FL','32099'),
(13,'William Martinez','159 Chestnut St','Fort Worth','TX','76101'),
(14,'Barbara Anderson','357 Magnolia Blvd','Columbus','OH','43085'),
(15,'Charles Jackson','486 Sycamore Dr','Charlotte','NC','28201'),
(16,'Susan White','624 Dogwood Ln','Indianapolis','IN','46201'),
(17,'Joseph Harris','735 Palmetto Way','San Francisco','CA','94101'),
(18,'Karen Thompson','816 Sequoia Ave','Seattle','WA','98101'),
(19,'Thomas Moore','927 Redbud Ct','Denver','CO','80201'),
(20,'Margaret Lewis','638 Juniper Rd','Nashville','TN','37201'),
(21,'Christopher Clark','549 Cypress Blvd','Oklahoma City','OK','73101'),
(22,'Dorothy Rodriguez','461 Aspen Pl','El Paso','TX','79901'),
(23,'Daniel Lewis','372 Fir Way','Boston','MA','02101'),
(24,'Jessica Lee','283 Holly Ave','Louisville','KY','40201'),
(25,'Ryan Walker','194 Pecan St','Portland','OR','97201');

-- ── PRODUCTS (15 records – wide price range) ─────────────────
CREATE TABLE PRODUCT_t (
    Product_Id          INT NOT NULL,
    Product_Line_Id     INT,
    Product_Description VARCHAR(50),
    Product_Finish      VARCHAR(20),
    Standard_Price      DECIMAL(10,2),
    CONSTRAINT PRODUCT_PK PRIMARY KEY (Product_Id),
    CONSTRAINT PRODUCT_FK FOREIGN KEY (Product_Line_Id) REFERENCES PRODUCT_LINE_t(Product_Line_Id)
);
INSERT INTO PRODUCT_t VALUES
(1, 1,'End Table',          'Cherry',   175.00),
(2, 1,'Coffee Table',       'Natural Ash',250.00),
(3, 1,'Entertainment Center','Natural Ash',650.00),
(4, 1,'Sofa',               'Fabric',  1200.00),
(5, 1,'Loveseat',           'Leather',  850.00),
(6, 1,'Recliner',           'Fabric',   550.00),
(7, 2,'Dining Table',       'Natural Ash',800.00),
(8, 2,'Dining Chair',       'Cherry',   150.00),
(9, 2,'China Cabinet',      'Natural Ash',950.00),
(10,2,'Bar Stool',          'Oak',      120.00),
(11,3,'8-Drawer Dresser',   'White Ash',500.00),
(12,3,'Bookcase',           'Cherry',   750.00),
(13,3,'Bed Frame Queen',    'Natural Ash',425.00),
(14,3,'Wardrobe',           'White Ash',920.00),
(15,3,'Night Stand',        'Cherry',   185.00);

-- ── ORDERS (70 records) ──────────────────────────────────────
CREATE TABLE ORDER_t (
    Order_Id    INT NOT NULL,
    Customer_Id INT,
    Order_Date  DATE,
    CONSTRAINT ORDER_PK PRIMARY KEY (Order_Id),
    CONSTRAINT ORDER_FK FOREIGN KEY (Customer_Id) REFERENCES CUSTOMER_t(Customer_Id)
);

-- Customer 1 (Ali Hassan) – FREQUENT (8 orders) + PREMIUM (expensive items)
INSERT INTO ORDER_t VALUES
(1001,1,'2024-01-10'),(1002,1,'2024-02-14'),(1003,1,'2024-04-20'),
(1004,1,'2024-06-15'),(1005,1,'2024-08-22'),(1006,1,'2024-10-05'),
(1007,1,'2024-11-30'),(1008,1,'2025-01-18');

-- Customer 2 (Sara Khan) – FREQUENT (10 orders) + BULK BUYER (high qty)
INSERT INTO ORDER_t VALUES
(1009,2,'2024-01-05'),(1010,2,'2024-02-20'),(1011,2,'2024-03-15'),
(1012,2,'2024-04-10'),(1013,2,'2024-05-25'),(1014,2,'2024-06-30'),
(1015,2,'2024-08-14'),(1016,2,'2024-09-21'),(1017,2,'2024-11-08'),
(1018,2,'2025-01-02');

-- Customer 3 (John Smith) – FREQUENT (9 orders) + PREMIUM + BULK
INSERT INTO ORDER_t VALUES
(1019,3,'2024-01-22'),(1020,3,'2024-03-08'),(1021,3,'2024-04-17'),
(1022,3,'2024-06-01'),(1023,3,'2024-07-19'),(1024,3,'2024-09-03'),
(1025,3,'2024-10-28'),(1026,3,'2024-12-05'),(1027,3,'2025-02-10');

-- Customer 4 (Emily Davis) – FREQUENT (7 orders)
INSERT INTO ORDER_t VALUES
(1028,4,'2024-02-11'),(1029,4,'2024-04-05'),(1030,4,'2024-06-20'),
(1031,4,'2024-08-09'),(1032,4,'2024-09-24'),(1033,4,'2024-11-15'),
(1034,4,'2025-01-08');

-- Customer 5 (Michael Brown) – FREQUENT (6 orders)
INSERT INTO ORDER_t VALUES
(1035,5,'2024-03-12'),(1036,5,'2024-05-28'),(1037,5,'2024-07-07'),
(1038,5,'2024-09-16'),(1039,5,'2024-11-02'),(1040,5,'2025-02-01');

-- Customer 6 (Fatima Malik) – PREMIUM (expensive products, 3 orders)
INSERT INTO ORDER_t VALUES
(1041,6,'2024-02-28'),(1042,6,'2024-07-15'),(1043,6,'2024-12-20');

-- Customer 7 (David Wilson) – PREMIUM (3 orders, high value)
INSERT INTO ORDER_t VALUES
(1044,7,'2024-03-05'),(1045,7,'2024-08-19'),(1046,7,'2024-12-01');

-- Customer 8 (Aisha Raza) – PREMIUM (4 orders)
INSERT INTO ORDER_t VALUES
(1047,8,'2024-01-30'),(1048,8,'2024-05-12'),(1049,8,'2024-09-08'),
(1050,8,'2025-01-25');

-- Customer 9 (James Taylor) – PREMIUM (single large order)
INSERT INTO ORDER_t VALUES
(1051,9,'2024-06-10');

-- Customer 10 (Linda Thomas) – BULK BUYER (4 orders, high qty)
INSERT INTO ORDER_t VALUES
(1052,10,'2024-02-18'),(1053,10,'2024-05-30'),(1054,10,'2024-09-11'),
(1055,10,'2024-12-22');

-- Customer 11 (Robert Martin) – BULK BUYER (3 orders, very high qty)
INSERT INTO ORDER_t VALUES
(1056,11,'2024-03-20'),(1057,11,'2024-07-28'),(1058,11,'2024-11-14');

-- Customer 12 (Patricia Garcia) – BULK BUYER (4 orders)
INSERT INTO ORDER_t VALUES
(1059,12,'2024-01-15'),(1060,12,'2024-04-22'),(1061,12,'2024-08-05'),
(1062,12,'2024-12-10');

-- Customers 13-20 – Regular customers (1-3 orders each)
INSERT INTO ORDER_t VALUES
(1063,13,'2024-05-10'),(1064,13,'2024-10-18'),
(1065,14,'2024-03-25'),(1066,14,'2024-09-14'),
(1067,15,'2024-06-08'),(1068,15,'2024-11-20'),
(1069,16,'2024-04-14'),
(1070,17,'2024-07-22'),
(1071,18,'2024-08-30'),
(1072,19,'2024-10-06'),
(1073,20,'2024-02-07'),(1074,20,'2024-11-25'),
(1075,21,'2024-05-19'),
(1076,22,'2024-09-02'),
(1077,23,'2024-03-11'),(1078,23,'2024-08-16'),
(1079,24,'2024-07-04'),
(1080,25,'2024-12-01');

-- ── ORDER LINES ───────────────────────────────────────────────
CREATE TABLE Order_line_t (
    Order_Id         INT NOT NULL,
    Product_Id       INT NOT NULL,
    Ordered_Quantity INT,
    CONSTRAINT OL_PK PRIMARY KEY (Order_Id, Product_Id),
    CONSTRAINT OL_FK1 FOREIGN KEY (Order_Id)   REFERENCES ORDER_t(Order_Id),
    CONSTRAINT OL_FK2 FOREIGN KEY (Product_Id) REFERENCES PRODUCT_t(Product_Id)
);

-- Customer 1 orders (expensive items, moderate qty → PREMIUM)
INSERT INTO Order_line_t VALUES
(1001,4,1),(1001,5,1),        -- Sofa + Loveseat = 2050
(1002,3,1),(1002,6,1),        -- Ent Center + Recliner = 1200
(1003,7,1),(1003,8,4),        -- Dining set = 1400
(1004,12,1),(1004,14,1),      -- Bookcase + Wardrobe = 1670
(1005,4,1),(1005,2,1),        -- Sofa + Coffee = 1450
(1006,9,1),(1006,11,1),       -- Cabinet + Dresser = 1450
(1007,13,2),(1007,15,2),      -- Beds + Stands = 1220
(1008,5,1),(1008,6,1);        -- Loveseat + Recliner = 1400

-- Customer 2 orders (high quantity → BULK + FREQUENT)
INSERT INTO Order_line_t VALUES
(1009,8,12),(1009,10,15),     -- Chairs + Stools (bulk!)
(1010,1,8),(1010,15,10),      -- End tables + Stands
(1011,8,20),                   -- 20 dining chairs!
(1012,10,18),(1012,8,8),      -- Stools + Chairs
(1013,1,10),(1013,2,5),       -- End + Coffee tables
(1014,15,14),(1014,10,12),    -- Stands + Stools
(1015,8,16),(1015,1,6),       -- Chairs + End tables
(1016,10,20),(1016,15,8),     -- Stools + Stands
(1017,8,10),(1017,1,8),       -- Chairs + End tables
(1018,10,14),(1018,8,12);     -- Stools + Chairs

-- Customer 3 orders (FREQUENT + PREMIUM + BULK)
INSERT INTO Order_line_t VALUES
(1019,4,1),(1019,5,1),        -- Sofa + Loveseat
(1020,7,1),(1020,8,6),        -- Dining table + 6 chairs
(1021,9,1),(1021,11,1),       -- Cabinet + Dresser
(1022,12,2),(1022,13,2),      -- Bookcases + Beds
(1023,3,1),(1023,6,2),        -- Ent Center + Recliners
(1024,14,1),(1024,4,1),       -- Wardrobe + Sofa
(1025,7,1),(1025,8,8),        -- Dining set + 8 chairs (bulk)
(1026,5,2),(1026,12,1),       -- Loveseats + Bookcase
(1027,9,1),(1027,14,1);       -- Cabinet + Wardrobe

-- Customer 4 orders (FREQUENT, moderate value)
INSERT INTO Order_line_t VALUES
(1028,2,1),(1028,1,2),
(1029,6,1),(1029,15,1),
(1030,13,1),(1030,11,1),
(1031,8,4),(1031,10,2),
(1032,2,2),(1032,1,1),
(1033,7,1),(1033,8,4),
(1034,11,1),(1034,15,2);

-- Customer 5 orders (FREQUENT, moderate value)
INSERT INTO Order_line_t VALUES
(1035,3,1),(1035,1,1),
(1036,13,1),(1036,15,2),
(1037,6,1),(1037,11,1),
(1038,12,1),(1038,2,1),
(1039,7,1),(1039,8,2),
(1040,5,1),(1040,6,1);

-- Customer 6 (PREMIUM - expensive items)
INSERT INTO Order_line_t VALUES
(1041,4,2),(1041,5,1),        -- 2 Sofas + Loveseat = 3250
(1042,9,1),(1042,7,1),(1042,14,1), -- Cabinet+Table+Wardrobe=2670
(1043,12,2),(1043,3,1),(1043,4,1); -- Bookcases+EntCtr+Sofa=3800

-- Customer 7 (PREMIUM)
INSERT INTO Order_line_t VALUES
(1044,4,3),(1044,5,2),        -- 3 Sofas + 2 Loveseats = 5300
(1045,9,2),(1045,7,1),        -- 2 Cabinets + Table = 2700
(1046,14,2),(1046,12,1);      -- 2 Wardrobes + Bookcase = 2590

-- Customer 8 (PREMIUM)
INSERT INTO Order_line_t VALUES
(1047,4,1),(1047,9,1),(1047,5,1), -- Sofa+Cabinet+Loveseat=3000
(1048,7,1),(1048,14,1),           -- Table+Wardrobe=1720
(1049,12,2),(1049,3,1),           -- Bookcases+EntCtr=2150
(1050,4,1),(1050,5,1),(1050,6,1); -- Sofa+Loveseat+Recliner=2600

-- Customer 9 (PREMIUM – single massive order)
INSERT INTO Order_line_t VALUES
(1051,4,5),(1051,5,3),(1051,7,2),(1051,9,2); -- 5 Sofas+3 Loveseats+Tables = 12050

-- Customer 10 (BULK BUYER)
INSERT INTO Order_line_t VALUES
(1052,8,25),(1052,10,20),     -- 25 chairs + 20 stools
(1053,1,15),(1053,15,18),     -- End tables + stands
(1054,8,30),(1054,10,15),     -- 30 chairs!
(1055,1,12),(1055,15,20);     -- End tables + stands

-- Customer 11 (BULK BUYER – very high qty)
INSERT INTO Order_line_t VALUES
(1056,8,40),(1056,10,30),     -- 40 chairs!! 30 stools
(1057,1,20),(1057,2,15),      -- End + Coffee tables
(1058,8,35),(1058,10,25);     -- Bulk chairs + stools

-- Customer 12 (BULK BUYER)
INSERT INTO Order_line_t VALUES
(1059,10,18),(1059,8,14),
(1060,1,10),(1060,15,12),
(1061,8,20),(1061,10,16),
(1062,15,14),(1062,1,11);

-- Regular customers – 1-2 orders
INSERT INTO Order_line_t VALUES
(1063,1,1),(1063,2,1),  (1064,13,1),(1064,15,1),
(1065,6,1),(1065,11,1), (1066,2,1),(1066,8,2),
(1067,3,1),             (1068,11,1),(1068,15,1),
(1069,7,1),(1069,8,4),
(1070,13,1),(1070,15,1),
(1071,12,1),(1071,2,1),
(1072,6,1),(1072,1,2),
(1073,1,1),(1073,15,1), (1074,11,1),(1074,13,1),
(1075,8,3),(1075,10,2),
(1076,2,1),(1076,1,1),
(1077,13,1),(1077,15,2),(1078,6,1),(1078,11,1),
(1079,3,1),(1079,2,1),
(1080,14,1),(1080,12,1);

-- ============================================================
-- SEGMENTATION QUERIES (for reference / testing)
-- ============================================================
-- Premium Customer (Total Spend > $1000)
-- SELECT c.Customer_Name, SUM(ol.Ordered_Quantity * p.Standard_Price) AS TotalSpend ...
-- Frequent Customer (Orders > 5)
-- SELECT c.Customer_Name, COUNT(DISTINCT o.Order_Id) AS OrderCount ...
-- Bulk Buyer (Avg qty per order line > 5)
-- SELECT c.Customer_Name, AVG(CAST(ol.Ordered_Quantity AS DECIMAL)) AS AvgQty ...
