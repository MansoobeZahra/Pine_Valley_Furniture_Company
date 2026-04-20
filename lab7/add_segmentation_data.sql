-- ============================================================
-- LAB 07 – Add Segmentation Data (SAFE INSERT SCRIPT)
-- This script DOES NOT wipe your database. It safely adds 
-- new test customers, products, and orders starting at 
-- high ID ranges (1000+) to avoid primary key conflicts.
-- ============================================================
USE PVFC;
GO

-- 1. ADD TEST CUSTOMERS (Starting at ID 1000)
-- ------------------------------------------------------------
INSERT INTO CUSTOMER_t (Customer_Id, Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) VALUES
(1001, 'Premium Pete', '123 Lux Way', 'New York', 'NY', '10001'),
(1002, 'Frequent Francine', '456 Busy Blvd', 'Los Angeles', 'CA', '90001'),
(1003, 'Bulk Barry', '789 Warehouse Rd', 'Chicago', 'IL', '60601'),
(1004, 'Mega Mary (All 3)', '321 Everything Ave', 'Houston', 'TX', '77001'),
(1005, 'Regular Ray', '654 Normal Ln', 'Phoenix', 'AZ', '85001');

-- 2. ADD TEST PRODUCTS (Starting at ID 1000)
-- ------------------------------------------------------------
-- We assume Product_Line_Id 1, 2, or 3 exists from previous labs.
INSERT INTO PRODUCT_t (Product_Id, Product_Line_Id, Product_Description, Product_Finish, Standard_Price) VALUES
(1001, 1, 'Luxury Gold Sofa', 'Gold', 2500.00),
(1002, 1, 'Basic Chair', 'Wood', 50.00),
(1003, 1, 'Diamond Table', 'Glass', 5000.00);

-- 3. ADD ORDERS (Starting at ID 5000)
-- ------------------------------------------------------------
-- Customer 1001: Premium Pete (Spends a lot, few orders)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5001, 1001, '2024-01-10'),
(5002, 1001, '2024-02-15');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5001, 1001, 2), -- 2 Luxury Sofas = $5000
(5002, 1003, 1); -- 1 Diamond Table = $5000

-- Customer 1002: Frequent Francine (Many small orders)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5003, 1002, '2024-01-05'), (5004, 1002, '2024-02-10'),
(5005, 1002, '2024-03-15'), (5006, 1002, '2024-04-20'),
(5007, 1002, '2024-05-25'), (5008, 1002, '2024-06-30'),
(5009, 1002, '2024-07-05'), (5010, 1002, '2024-08-10');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5003, 1002, 1), (5004, 1002, 1),
(5005, 1002, 1), (5006, 1002, 1),
(5007, 1002, 1), (5008, 1002, 1),
(5009, 1002, 1), (5010, 1002, 1); -- 8 orders, 1 chair each

-- Customer 1003: Bulk Barry (High quantity per order)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5011, 1003, '2024-03-01'),
(5012, 1003, '2024-06-01');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5011, 1002, 40), -- 40 Basic chairs!
(5012, 1002, 35); -- 35 Basic chairs!

-- Customer 1004: Mega Mary (Frequent, Bulk, Premium)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5013, 1004, '2024-01-01'), (5014, 1004, '2024-02-01'),
(5015, 1004, '2024-03-01'), (5016, 1004, '2024-04-01'),
(5017, 1004, '2024-05-01'), (5018, 1004, '2024-06-01'),
(5019, 1004, '2024-07-01');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5013, 1001, 15), (5014, 1001, 10),
(5015, 1001, 12), (5016, 1003, 10),
(5017, 1001, 15), (5018, 1003, 12),
(5019, 1001, 10);

-- Customer 1005: Regular Ray (Doesn't hit any thresholds)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES
(5020, 1005, '2024-05-15');

INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES
(5020, 1002, 2); -- 2 basic chairs

GO
PRINT 'Segmentation test data safely added!'
