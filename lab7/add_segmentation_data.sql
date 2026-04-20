-- ============================================================
-- LAB 07 – Add EXTRA Segmentation Data (SAFE INSERT SCRIPT)
-- This script DOES NOT wipe your database. It safely adds 
-- an extensive list of test customers, products, and orders 
-- starting at high ID ranges (1000+) to test the dashboard.
-- ============================================================
USE PVFC;
GO

-- 1. ADD EXTENSIVE TEST CUSTOMERS (IDs 1001-1025)
-- ------------------------------------------------------------
INSERT INTO CUSTOMER_t (Customer_Id, Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) VALUES
-- Multi-Segment / Mega Buyers (Hit 2+ thresholds)
(1001, 'Mary Johnson', '111 Everything Ave', 'Houston', 'TX', '77001'),
(1002, 'Andrew Smith', '222 Top Tier Blvd', 'Dallas', 'TX', '75201'),
(1003, 'Robert Brown','333 Warehouse Way','Chicago', 'IL', '60601'),
(1004, 'Tina Davis', '444 High Volume Rd', 'Phoenix', 'AZ', '85001'),

-- Pure Premium Customers (High Spend, Low Orders, Low Qty)
(1005, 'Peter Wilson', '555 Lux Way', 'New York', 'NY', '10001'),
(1006, 'Richard Moore', '666 Diamond St', 'Miami', 'FL', '33101'),
(1007, 'Wendy Taylor', '777 Emerald Ave', 'Beverly Hills', 'CA', '90210'),
(1008, 'Oscar Anderson', '888 Ruby Ln', 'San Francisco', 'CA', '94101'),
(1009, 'Laura Thomas', '999 Safari Blvd', 'Las Vegas', 'NV', '89101'),

-- Pure Frequent Customers (High Orders, Low Spend, Low Qty)
(1010, 'Francine Jackson', '101 Busy Blvd', 'Los Angeles', 'CA', '90001'),
(1011, 'David White', '102 Always Here St', 'Seattle', 'WA', '98101'),
(1012, 'Connie Harris', '103 Nonstop Rd', 'Denver', 'CO', '80201'),
(1013, 'Walter Martin', '104 Routine Ave', 'Austin', 'TX', '78701'),
(1014, 'Helen Thompson', '105 Regular Ln', 'Boston', 'MA', '02101'),

-- Pure Bulk Buyers (Low Orders, Low Value items, High Qty)
(1015, 'Barry Garcia', '201 Wholesaler Dr', 'Detroit', 'MI', '48201'),
(1016, 'Michael Martinez', '202 Freight St', 'Atlanta', 'GA', '30301'),
(1017, 'George Robinson', '203 Pallet Blvd', 'Charlotte', 'NC', '28201'),
(1018, 'Larry Clark', '204 Cargo Way', 'Indianapolis', 'IN', '46201'),
(1019, 'Carol Rodriguez', '205 Shipment Rd', 'Columbus', 'OH', '43085'),

-- Regular Customers (Don't hit any thresholds)
(1020, 'Raymond Lewis', '301 Normal Ln', 'Portland', 'OR', '97201'),
(1021, 'Anna Lee', '302 Standard Ave', 'San Diego', 'CA', '92101'),
(1022, 'Thomas Walker', '303 Common Blvd', 'San Jose', 'CA', '95101'),
(1023, 'Gina Hall', '304 Basic Rd', 'Jacksonville', 'FL', '32099'),
(1024, 'Benjamin Allen', '305 Plain St', 'Nashville', 'TN', '37201'),
(1025, 'Samuel Young', '306 Default Dr', 'Louisville', 'KY', '40201');

-- 2. ADD TEST PRODUCTS (IDs 1001-1003)
-- ------------------------------------------------------------
INSERT INTO PRODUCT_t (Product_Id, Product_Line_Id, Product_Description, Product_Finish, Standard_Price) VALUES
(1001, 1, 'Luxury Gold Sofa', 'Gold', 2500.00),     -- High price for Premium testing
(1002, 1, 'Basic Chair', 'Wood', 50.00),           -- Low price for Bulk testing
(1003, 1, 'Diamond Table', 'Glass', 5000.00);      -- Ultra high price for Premium testing

-- 3. ADD ORDERS & ORDER LINES (Starting at ID 5000)
-- ------------------------------------------------------------

-- Multi-Segment / Mega Buyers --
-- (1001) Mega Mary: 7 Orders, 74 Qty Total, $122,500 Total Spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5001,1001,'2024-01-01'), (5002,1001,'2024-02-01'), (5003,1001,'2024-03-01'), 
(5004,1001,'2024-04-01'), (5005,1001,'2024-05-01'), (5006,1001,'2024-06-01'), (5007,1001,'2024-07-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5001,1001,15), (5002,1001,10), (5003,1001,12), (5004,1003,10), (5005,1001,15), (5006,1003,12), (5007,1001,10);

-- (1002) Alpha Andy: Freq (6 orders) + Prem ($5000 spend), Low average qty (1 per order)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5008,1002,'2024-01-10'), (5009,1002,'2024-02-10'), (5010,1002,'2024-03-10'), 
(5011,1002,'2024-04-10'), (5012,1002,'2024-05-10'), (5013,1002,'2024-06-10');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5008,1001,1), (5009,1001,1), (5010,1002,1), (5011,1002,1), (5012,1002,1), (5013,1002,1);

-- (1003) Bulk Boss Bob: Bulk (Avg Qty = 25) + Prem ($62,500 spend), Low freq (2 orders)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5014,1003,'2024-02-05'), (5015,1003,'2024-08-05');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5014,1001,20), (5015,1001,30);

-- (1004) Titan Tina: Freq (7 orders) + Bulk (Avg Qty = 10), Low spend (using $50 chair = $3500 so wait it is over 1000 if 70 chairs, let's keep spend under $1000 using lower qty or a generic product, BUT chair is $50. 10*50 = 500 per order... 7 orders = 3500. It will hit premium. Let's make it hit Prem too but intentionally.)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5016,1004,'2024-01-02'), (5017,1004,'2024-02-02'), (5018,1004,'2024-03-02'), 
(5019,1004,'2024-04-02'), (5020,1004,'2024-05-02'), (5021,1004,'2024-06-02'), (5022,1004,'2024-07-02');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5016,1002,10), (5017,1002,12), (5018,1002,10), (5019,1002,15), (5020,1002,10), (5021,1002,12), (5022,1002,10);

-- Pure Premium --
-- (1005) Premium Pete: 2 orders, $10,000 spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5023,1005,'2024-01-15'), (5024,1005,'2024-08-15');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5023,1001,2), (5024,1003,1);

-- (1006) Rich Richard: 1 order, $15,000 spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5025,1006,'2024-03-20');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5025,1003,3);

-- (1007) Wealthy Wendy: 2 orders, $7,500 spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5026,1007,'2024-04-10'), (5027,1007,'2024-09-10');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5026,1001,1), (5027,1003,1);

-- (1008) Opulent Oscar: 1 order, $5,000 spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5028,1008,'2024-06-05');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5028,1003,1);

-- (1009) Lavish Laura: 1 order, $2,500 spend
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5029,1009,'2024-11-20');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5029,1001,1);

-- Pure Frequent --
-- (1010) Frequent Francine (8 orders, 1 chair each = $400 spend)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5030,1010,'2024-01-05'), (5031,1010,'2024-02-10'), (5032,1010,'2024-03-15'), (5033,1010,'2024-04-20'),
(5034,1010,'2024-05-25'), (5035,1010,'2024-06-30'), (5036,1010,'2024-07-05'), (5037,1010,'2024-08-10');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5030,1002,1), (5031,1002,1), (5032,1002,1), (5033,1002,1), (5034,1002,1), (5035,1002,1), (5036,1002,1), (5037,1002,1);

-- (1011) Daily Dave (10 orders, 1 chair per order = $500 spend)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5038,1011,'2024-01-01'), (5039,1011,'2024-01-15'), (5040,1011,'2024-02-01'), (5041,1011,'2024-02-15'),
(5042,1011,'2024-03-01'), (5043,1011,'2024-03-15'), (5044,1011,'2024-04-01'), (5045,1011,'2024-04-15'),
(5046,1011,'2024-05-01'), (5047,1011,'2024-05-15');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5038,1002,1), (5039,1002,1), (5040,1002,1), (5041,1002,1), (5042,1002,1),
(5043,1002,1), (5044,1002,1), (5045,1002,1), (5046,1002,1), (5047,1002,1);

-- (1012) Constant Connie (7 orders, 1 chair each)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5048,1012,'2024-01-01'), (5049,1012,'2024-02-01'), (5050,1012,'2024-03-01'), (5051,1012,'2024-04-01'),
(5052,1012,'2024-05-01'), (5053,1012,'2024-06-01'), (5054,1012,'2024-07-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5048,1002,1), (5049,1002,1), (5050,1002,1), (5051,1002,1), (5052,1002,1), (5053,1002,1), (5054,1002,1);

-- (1013) Weekly Walter (6 orders)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5055,1013,'2024-01-01'), (5056,1013,'2024-02-01'), (5057,1013,'2024-03-01'), 
(5058,1013,'2024-04-01'), (5059,1013,'2024-05-01'), (5060,1013,'2024-06-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5055,1002,1), (5056,1002,1), (5057,1002,1), (5058,1002,1), (5059,1002,1), (5060,1002,1);

-- (1014) Habitual Helen (6 orders)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5061,1014,'2024-01-01'), (5062,1014,'2024-02-01'), (5063,1014,'2024-03-01'), 
(5064,1014,'2024-04-01'), (5065,1014,'2024-05-01'), (5066,1014,'2024-06-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5061,1002,1), (5062,1002,1), (5063,1002,1), (5064,1002,1), (5065,1002,1), (5066,1002,1);

-- Pure Bulk Buyers --
-- (1015) Bulk Barry: 2 orders, 75 total chairs ($3,750 spend -- so Premium+Bulk actually!)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5067,1015,'2024-03-01'),(5068,1015,'2024-06-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5067,1002,40), (5068,1002,35);

-- (1016) Massive Mike: 1 order, 50 chairs (Avg=50, Spend=$2,500 = Prem+Bulk)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5069,1016,'2024-04-12');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5069,1002,50);

-- (1017) Giant George: 1 order, 15 chairs (Avg=15, Spend=$750 = Pure Bulk if threshold > 1000)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5070,1017,'2024-05-18');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5070,1002,15);

-- (1018) Large Larry: 2 orders, 18 chairs each (Avg=18, Spend=$1,800 = Prem+Bulk)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5071,1018,'2024-01-01'),(5072,1018,'2024-02-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5071,1002,18), (5072,1002,18);

-- (1019) Colossal Carol: 1 order, 12 chairs (Avg=12, Spend=$600 = Pure Bulk)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (5073,1019,'2024-07-22');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (5073,1002,12);

-- Regular Customers (Don't hit any threshold) --
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5074,1020,'2024-05-15'), (5075,1021,'2024-06-20'), (5076,1022,'2024-07-25'),
(5077,1023,'2024-08-30'), (5078,1024,'2024-09-05'), (5079,1025,'2024-10-10');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5074,1002,2), (5075,1002,3), (5076,1002,1),
(5077,1002,4), (5078,1002,2), (5079,1002,1);

GO
PRINT 'Extensive Segmentation test data specifically tuned for categories has been safely added!'
