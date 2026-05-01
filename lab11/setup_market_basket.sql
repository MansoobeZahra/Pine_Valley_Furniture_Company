
-- Market Basket Analysis Setup for Lab 11
USE PVFC;
GO

-- Clear existing test orders if any
DELETE FROM Order_line_t WHERE Order_Id > 2000;
DELETE FROM ORDER_t WHERE Order_Id > 2000;

-- 1. Create some orders that pair products
-- We use Product_Id from 1 to 15 (based on setup_database.sql)
-- 1: End Table
-- 2: Coffee Table
-- 3: Entertainment Center
-- 7: Dining Table
-- 8: Dining Chair

-- Order 2001: Dining Table (7) and Dining Chair (8) - Common Pair
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (2001, 1, '2025-05-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2001, 7, 1);
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2001, 8, 4);

-- Order 2002: Dining Table (7) and Dining Chair (8)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (2002, 2, '2025-05-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2002, 7, 1);
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2002, 8, 6);

-- Order 2003: End Table (1) and Coffee Table (2)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (2003, 3, '2025-05-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2003, 1, 2);
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2003, 2, 1);

-- Order 2004: End Table (1) and Coffee Table (2)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (2004, 4, '2025-05-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2004, 1, 1);
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2004, 2, 1);

-- Order 2005: Bed Frame (13) and Night Stand (15)
INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (2005, 5, '2025-05-01');
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2005, 13, 1);
INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (2005, 15, 2);

GO

-- Verify query
-- Customers who bought Dining Table (7) also bought...
SELECT p2.Product_Id, p2.Product_Description, COUNT(*) AS Frequency
FROM Order_line_t l1
JOIN Order_line_t l2 ON l1.Order_Id = l2.Order_Id AND l1.Product_Id <> l2.Product_Id
JOIN PRODUCT_t p2 ON l2.Product_Id = p2.Product_Id
WHERE l1.Product_Id = 7
GROUP BY p2.Product_Id, p2.Product_Description
ORDER BY Frequency DESC;
