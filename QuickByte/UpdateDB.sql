-- QuickByte Food Delivery App - Unified Clean Schema
CREATE DATABASE FoodserviceDB;
GO
USE FoodserviceDB;
GO

-- ==========================================
-- 1. STAKEHOLDER TABLES (Entity Tables)
-- ==========================================

-- 1. STAKEHOLDER TABLES (Entity Tables)
-- Customers
CREATE TABLE Customer_QB (
    CustomerID INT IDENTITY(2001,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(20),
    Region NVARCHAR(50), -- Karachi, Lahore, Islamabad, Rawalpindi
    Segment NVARCHAR(50) DEFAULT 'Regular',
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Restaurants
CREATE TABLE Restaurant_QB (
    RestaurantID INT IDENTITY(3001,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Street NVARCHAR(100),
    City NVARCHAR(50),
    Region NVARCHAR(50), -- Karachi, Lahore, Islamabad, Rawalpindi
    ContactNumber NVARCHAR(20),
    Segment NVARCHAR(50) DEFAULT 'Standard',
    IsActive BIT DEFAULT 1, -- Admin can disable
    LastRevenueReset DATETIME DEFAULT GETDATE()
);

-- Riders
CREATE TABLE Rider_QB (
    RiderID INT IDENTITY(5001,1) PRIMARY KEY,
    Name NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    Availability BIT DEFAULT 1,
    IsActive BIT DEFAULT 1, -- Admin can disable
    Region NVARCHAR(50), -- Karachi, Lahore, Islamabad, Rawalpindi
    Segment NVARCHAR(50) DEFAULT 'Standard',
    LastRevenueReset DATETIME DEFAULT GETDATE()
);

-- Platform Managers (Internal Admins)
CREATE TABLE PlatformManager_QB (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Department NVARCHAR(50),
    Segment NVARCHAR(50) DEFAULT 'Standard'
);

-- ==========================================
-- 2. CENTRALIZED USER MANAGEMENT (RBAC)
-- ==========================================

CREATE TABLE Users_QB (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL, -- 'Customer', 'RestaurantManager', 'Rider', 'PlatformManager'
    ReferenceID INT NULL,
    Region NVARCHAR(50) -- User's default region
);

-- ==========================================
-- 3. OPERATIONAL TABLES
-- ==========================================

-- Menu Items
CREATE TABLE MenuItem_QB (
    ItemID INT IDENTITY(4001,1) PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name NVARCHAR(100),
    Description NVARCHAR(255),
    Price DECIMAL(10,2),
    Available BIT DEFAULT 1,
    CONSTRAINT FK_MenuItem_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant_QB(RestaurantID)
);

-- Orders
CREATE TABLE Order_QB (
    OrderID INT IDENTITY(6001,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    RiderID INT NULL, -- Can be assigned later
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT 'Pending', -- Pending, Assigned, Picked Up, Delivered, Confirmed
    Region NVARCHAR(50), -- Order region
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES Customer_QB(CustomerID),
    CONSTRAINT FK_Order_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant_QB(RestaurantID),
    CONSTRAINT FK_Order_Rider FOREIGN KEY (RiderID) REFERENCES Rider_QB(RiderID)
);

-- Order Items
CREATE TABLE OrderItem_QB (
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT,
    PRIMARY KEY (OrderID, ItemID),
    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (OrderID) REFERENCES Order_QB(OrderID),
    CONSTRAINT FK_OrderItem_MenuItem FOREIGN KEY (ItemID) REFERENCES MenuItem_QB(ItemID)
);

-- Payments
CREATE TABLE Payment_QB (
    PaymentID INT IDENTITY(7001,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    Method NVARCHAR(30),
    Amount DECIMAL(10,2),
    PaymentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT 'Pending',
    CONSTRAINT FK_Payment_Order FOREIGN KEY (OrderID) REFERENCES Order_QB(OrderID)
);

-- ==========================================
-- 4. LOGGING & AUDIT
-- ==========================================

CREATE TABLE CustomerAuditLog_QB (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    Email NVARCHAR(100),
    DeletedAt DATETIME DEFAULT GETDATE()
);

GO

-- ==========================================
-- 5. TRIGGERS (Automated Business Rules)
-- ==========================================

-- Auto-update Rider Availability
CREATE TRIGGER trg_UpdateRiderAvailability
ON Order_QB
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        -- Release rider only when customer confirms delivery
        UPDATE Rider_QB
        SET Availability = 1
        FROM Rider_QB r
        JOIN inserted i ON r.RiderID = i.RiderID
        WHERE i.Status = 'Confirmed';
    END
END;
GO

-- Log Deleted Customers
CREATE TRIGGER trg_LogCustomerDeletion
ON Customer_QB
AFTER DELETE
AS
BEGIN
    INSERT INTO CustomerAuditLog_QB (CustomerID, Email)
    SELECT CustomerID, Email
    FROM deleted;
END;
GO

-- ==========================================
-- 6. FEEDBACK SYSTEM
-- ==========================================

CREATE TABLE Feedback_QB (
    FeedbackID INT IDENTITY(8001,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    TargetType NVARCHAR(20) NOT NULL, -- 'Rider' or 'Restaurant'
    TargetID INT NOT NULL,           -- RiderID or RestaurantID
    ReviewerRole NVARCHAR(20) NOT NULL, -- 'Customer' or 'RestaurantManager'
    ReviewerID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_Order FOREIGN KEY (OrderID) REFERENCES Order_QB(OrderID)
);

GO

-- ==========================================
-- 7. LIVE SAMPLE DATA & USERS (UPDATED)
-- ==========================================

-- Populate Platform Managers
INSERT INTO PlatformManager_QB (FullName, Department, Segment) VALUES ('Main Admin', 'Operations', 'SuperAdmin');
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) VALUES ('admin@quickbyte.com', 'Admin@123', 'PlatformManager', 1, 'Islamabad');

-- Populate Restaurants
INSERT INTO Restaurant_QB (Name, Street, City, Region, ContactNumber, IsActive) VALUES 
('Pizza Palace','Main Road','Islamabad','Islamabad','0511111111', 1),
('Lahore Grill','Mall Road','Lahore','Lahore','0421111111', 1),
('Karachi Spice','Clifton','Karachi','Karachi','0211111111', 1),
('Rawal Roasters','Saddar','Rawalpindi','Rawalpindi','0512222222', 1);

INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) 
SELECT LOWER(REPLACE(Name, ' ', '')) + '@quickbyte.com', 'Rest@123', 'RestaurantManager', RestaurantID, Region FROM Restaurant_QB;

-- Populate Riders
INSERT INTO Rider_QB (Name, ContactNumber, Availability, Region, IsActive) VALUES 
('Ahmed','03450000001',1, 'Islamabad', 1), 
('Bilal','03450000002',1, 'Lahore', 1),
('Zain','03450000003',1, 'Karachi', 1),
('Usman','03450000004',1, 'Rawalpindi', 1);

INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) 
SELECT LOWER(Name) + '@rider.com', 'Rider@123', 'Rider', RiderID, Region FROM Rider_QB;

-- Populate Customers
INSERT INTO Customer_QB (FirstName, LastName, Email, PhoneNumber, Region) VALUES 
('Ali','Raza','ali@example.com','03001111111', 'Islamabad'), 
('Sara','Khan','sara@example.com','03002222222', 'Lahore'),
('Hamza','Sheikh','hamza@example.com','03003333333', 'Karachi'),
('Fatima','Zahra','fatima@example.com','03004444444', 'Rawalpindi');

INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) 
SELECT Email, 'Customer@123', 'Customer', CustomerID, Region FROM Customer_QB;

-- Populate Menu
INSERT INTO MenuItem_QB (RestaurantID, Name, Description, Price, Available) VALUES 
(3001, 'Pepperoni Pizza', 'Large pepperoni pizza', 1200, 1),
(3001, 'Garlic Bread', '4 pieces cheesy garlic bread', 450, 1),
(3002, 'Chicken Karahi', 'Spicy chicken karahi', 1500, 1),
(3002, 'Naan', 'Freshly baked tandoori naan', 50, 1),
(3003, 'Sindhi Biryani', 'Authentic Sindhi biryani', 800, 1),
(3003, 'Shami Kabab', 'Pack of 2 beef shami kababs', 300, 1),
(3004, 'Chargha', 'Full tandoori chargha', 1800, 1);

-- Populate Orders to trigger segments (Premium/Regular)
-- Ali (Islamabad) - Premium Customer (Many orders)
INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, Region) VALUES (2001, 3001, 5001, 'Confirmed', 'Islamabad');
INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (6001, 4001, 2);
INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (6001, 'Cash', 2400, 'Paid');

INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, Region) VALUES (2001, 3001, 5001, 'Confirmed', 'Islamabad');
INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (6002, 4002, 5);
INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (6002, 'Online', 2250, 'Paid');

-- Sara (Lahore) - Regular Customer
INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, Region) VALUES (2002, 3002, 5002, 'Confirmed', 'Lahore');
INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (6003, 4003, 1);
INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (6003, 'Cash', 1500, 'Paid');

-- Hamza (Karachi) - Premium Customer (High spend)
INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, Region) VALUES (2003, 3003, 5003, 'Confirmed', 'Karachi');
INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (6004, 4005, 10); -- 10 Biryanis = 8000 (Premium)
INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (6004, 'Online', 8000, 'Paid');

-- Sample Feedback
-- Customer Ali rates Restaurant Pizza Palace
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6001, 'Restaurant', 3001, 'Customer', 2001, 5, 'Best pizza in Islamabad!');

-- Customer Ali rates Rider Ahmed
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6001, 'Rider', 5001, 'Customer', 2001, 4, 'Fast delivery.');

-- Restaurant Palace rates Rider Ahmed
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6001, 'Rider', 5001, 'RestaurantManager', 3001, 5, 'Very professional rider.');

-- More Sample Feedback
-- Sara rates Savour Foods
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6003, 'Restaurant', 3002, 'Customer', 2002, 4, 'Great taste, but could be spicier.');

-- Hamza rates Student Biryani
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6004, 'Restaurant', 3003, 'Customer', 2003, 5, 'Authentic Karachi Biryani!');

-- Sara rates Rider Bilal
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6003, 'Rider', 5002, 'Customer', 2002, 3, 'Took a bit long to find the address.');

-- Hamza rates Rider Zain
INSERT INTO Feedback_QB (OrderID, TargetType, TargetID, ReviewerRole, ReviewerID, Rating, Comment)
VALUES (6004, 'Rider', 5003, 'Customer', 2003, 5, 'Super fast delivery in Karachi traffic!');

GO
