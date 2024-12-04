BEGIN TRANSACTION;

-- ALTER TABLE CUSTOMER
-- DROP CONSTRAINT  FK_Customer_Customer_Group;
-- DROP TABLE CUSTOMER_GROUP;
-- GO
-- DROP TABLE CUSTOMER;
-- GO




-- Bảng CUSTOMER_GROUP
CREATE TABLE CUSTOMER_GROUP (
    Group_Name NVARCHAR(50) PRIMARY KEY,
    Requirement NVARCHAR(255),
    Group_Note NVARCHAR(255)
);


-- Bảng CUSTOMER
CREATE TABLE CUSTOMER (
    ID_Card_Num CHAR(12) PRIMARY KEY,
    Customer_ID INT IDENTITY(1,1) UNIQUE NOT NULL,
    Group_Name NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Customer_Customer_Group FOREIGN KEY (Group_Name) REFERENCES CUSTOMER_GROUP(Group_Name) ON DELETE CASCADE,
    -- CONSTRAINT FK_Customer_Person FOREIGN KEY (ID_Card_Num) REFERENCES PERSON(ID_Card_Num)
);


-- Bảng RECEIVER_INFO
CREATE TABLE RECEIVER_INFO (
    ID_Card_Num CHAR(12) NOT NULL UNIQUE,
    Customer_ID INT NOT NULL UNIQUE,
    
    Housenum NVARCHAR(50),
    Street NVARCHAR(100),
    District NVARCHAR(100),
    City NVARCHAR(100),
    
    [Name] NVARCHAR(100),
    Phone NVARCHAR(15) CHECK (LEN(Phone) <= 10),

    PRIMARY KEY (ID_Card_Num, Customer_ID, Housenum, Street, District, City),
    CONSTRAINT FK_Receiver_Info_Customer FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMER(ID_Card_Num) ON DELETE CASCADE,
);

-- Bảng OF_GROUP
CREATE TABLE OF_GROUP (
    Voucher_ID INT NOT NULL UNIQUE,
    Group_Name NVARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (Voucher_ID, Group_Name),
    -- CONSTRAINT FK_Of_Group_Voucher FOREIGN KEY (Voucher_ID) REFERENCES Voucher(Voucher_ID),
    CONSTRAINT FK_Of_Group_Customer_Group FOREIGN KEY (Group_Name) REFERENCES CUSTOMER_GROUP(Group_Name)
);

-- Bảng PLACE
CREATE TABLE PLACE (
    Order_ID INT NOT NULL UNIQUE,
    ID_Card_Num CHAR(12) NOT NULL UNIQUE,

    Customer_ID INT NOT NULL UNIQUE,
    Housenum NVARCHAR(50),
    Street NVARCHAR(100),
    District NVARCHAR(100),
    City NVARCHAR(100),

    PRIMARY KEY (Order_ID, ID_Card_Num),
    CONSTRAINT FK_Place_Receiver_Info FOREIGN KEY (ID_Card_Num, Customer_ID, Housenum, Street, District, City) REFERENCES RECEIVER_INFO(ID_Card_Num, Customer_ID, Housenum, Street, District, City),
    CONSTRAINT FK_Place_Customer FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMER(ID_Card_Num) ON DELETE CASCADE,
    -- CONSTRAINT FK_Place_Order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID),
);

-- Bảng REVENUE_REPORT_BY_ITEM
CREATE TABLE REVENUE_REPORT_BY_ITEM (
    Item_Revenue_Report_ID INT PRIMARY KEY IDENTITY(1,1),
    Report_Type NVARCHAR(50) NOT NULL,
    Total_Revenue DECIMAL(18,3) NOT NULL,
    -- Created_Date DATE DEFAULT GETDATE()
    [Day] INT CHECK ([Day] BETWEEN 1 AND 31), -- Ngày trong tháng (1 đến 31)
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12), -- Tháng (1 đến 12)
    [Year] INT
);

-- Bảng INVENTORY_REPORT
CREATE TABLE INVENTORY_REPORT (
    Inventory_Report_ID INT PRIMARY KEY IDENTITY(1,1),
    Report_Type NVARCHAR(50) NOT NULL,
    Inventory_Value INT NOT NULL CHECK (Inventory_Value >= 0),
    -- Created_Date DATE DEFAULT GETDATE()
    [Day] INT CHECK ([Day] BETWEEN 1 AND 31), -- Ngày trong tháng (1 đến 31)
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12), -- Tháng (1 đến 12)
    [Year] INT
);

-- Bảng Summarize
CREATE TABLE Summarize (
    Item_Revenue_Report_ID INT NOT NULL UNIQUE,
    Order_ID INT NOT NULL UNIQUE,
    Quantity INT NOT NULL CHECK (Quantity >= 0),

    PRIMARY KEY (Item_Revenue_Report_ID, Order_ID),
    CONSTRAINT FK_Summarize_Revenue_Report_By_Item FOREIGN KEY (Item_Revenue_Report_ID) REFERENCES REVENUE_REPORT_BY_ITEM(Item_Revenue_Report_ID),
    -- CONSTRAINT FK_Summarize_Order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)
);
-- Bảng Contain
CREATE TABLE Contain (
    Inventory_Report_ID INT NOT NULL,
    Item_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),

    PRIMARY KEY (Inventory_Report_ID, Item_ID),
    CONSTRAINT FK_Contain_Inventory_Report FOREIGN KEY (Inventory_Report_ID) REFERENCES INVENTORY_REPORT(Inventory_Report_ID),
    -- CONSTRAINT FK_Contain_Item FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID)
);





-- Thêm dữ liệu mẫu
-- Dữ liệu cho bảng CUSTOMER_GROUP
INSERT INTO CUSTOMER_GROUP (Group_Name, Requirement, Group_Note)
VALUES 
('Member', 'Below 3000 points', 'Standard customers'),
('Silver', '3000+ points', 'Intermediate benefits'),
('Gold', '5000+ points', 'Priority benefits'),
('Platinum', '10000+ points', 'Premium benefits'),
('Diamond', '20000+ points', 'VIP benefits');

-- Kiểm tra dữ liệu bảng CUSTOMER_GROUP
SELECT * FROM CUSTOMER_GROUP;

-- Dữ liệu cho bảng CUSTOMER
INSERT INTO CUSTOMER (ID_Card_Num, Group_Name)
VALUES 
('123456789012', 'Member'),
('987654321098', 'Silver'),
('112233445566', 'Gold'),
('998877665544', 'Platinum'),
('556677889900', 'Diamond');

-- Kiểm tra dữ liệu bảng CUSTOMER
SELECT * FROM CUSTOMER;

-- Dữ liệu cho bảng REVENUE_REPORT_BY_ITEM
INSERT INTO REVENUE_REPORT_BY_ITEM (Report_Type, Total_Revenue, [Day], [Month], [Year])
VALUES 
('Daily', 150000.50, 1, 12, 2024),
('Daily', 1050000.75, 7, 12, 2024),
('Monthly', 5000000.00, NULL, 12, 2024),
('Monthly', 15000000.25, NULL, 6, 2024),
('Yearly', 75000000.00, NULL, NULL, 2023);

-- Kiểm tra dữ liệu bảng REVENUE_REPORT_BY_ITEM
SELECT * FROM REVENUE_REPORT_BY_ITEM;

-- Dữ liệu cho bảng INVENTORY_REPORT
INSERT INTO INVENTORY_REPORT (Report_Type, Inventory_Value, [Day], [Month], [Year])
VALUES 
('Daily', 250000.00, 1, 12, 2024),
('Daily', 1750000.75, 7, 12, 2024),
('Daily', 7500000.00, 15, 12, 2024),
('Monthly', 30000000.25, NULL, 3, 2024),
('Yearly', 100000000.00, NULL, NULL, 2022);

-- Kiểm tra dữ liệu bảng INVENTORY_REPORT
SELECT * FROM INVENTORY_REPORT;

-- Dữ liệu cho bảng RECEIVER_INFO
INSERT INTO RECEIVER_INFO (ID_Card_Num, Customer_ID, Housenum, Street, District, City, [Name], Phone)
VALUES
('123456789012', 1, '12A', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi', 'Nguyen Van A', '0123456789'),
('987654321098', 2, '45B', 'Le Duan', 'Dong Da', 'Ha Noi', 'Le Thi B', '0987654321'),
('112233445566', 3, '78C', 'Tran Phu', 'Ha Dong', 'Ha Noi', 'Pham Van C', '0912345678'),
('998877665544', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi', 'Tran Thi D', '0945678912'),
('556677889900', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi', 'Vu Van E', '0934567890');

-- Kiểm tra dữ liệu bảng RECEIVER_INFO
SELECT * FROM RECEIVER_INFO;

-- Dữ liệu cho bảng Of_Group
INSERT INTO Of_Group (Voucher_ID, Group_Name)
VALUES 
(1, 'Member'),
(2, 'Silver'),
(3, 'Gold'),
(4, 'Platinum'),
(5, 'Diamond');

-- Kiểm tra dữ liệu bảng Of_Group
SELECT * FROM Of_Group;

-- -- Dữ liệu cho bảng Place
-- INSERT INTO Place (Order_ID, ID_Card_Num, Customer_ID, HouseNum, Street, District, City)
-- VALUES 
-- (101, '123456789012', 1, '12A', 'Nguyen Trai', 'Thanh Xuan', 'Hanoi'),
-- (102, '987654321098', 2, '45B', 'Le Duan', 'Dong Da', 'Hanoi'),
-- (103, '112233445566', 3, '78C', 'Tran Phu', 'Ha Dong', 'Hanoi'),
-- (104, '998877665544', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Hanoi'),
-- (105, '556677889900', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Hanoi');

-- -- Kiểm tra dữ liệu bảng Place
-- SELECT * FROM Place;

-- -- Dữ liệu cho bảng Summarize
-- INSERT INTO Summarize (Item_Revenue_Report_ID, Order_ID, Quantity)
-- VALUES
-- (1, 101, 5),
-- (2, 102, 10),
-- (3, 103, 15),
-- (4, 104, 20),
-- (5, 105, 25);

-- -- Kiểm tra dữ liệu bảng Summarize
-- SELECT * FROM Summarize;

-- -- Dữ liệu cho bảng Contain
-- INSERT INTO Contain (Inventory_Report_ID, Item_ID, Quantity)
-- VALUES
-- (1, 1001, 50),
-- (2, 1002, 100),
-- (3, 1003, 150),
-- (4, 1004, 200),
-- (5, 1005, 250);

-- -- Kiểm tra dữ liệu bảng Contain
-- SELECT * FROM Contain;



-- Rollback để hoàn tác
ROLLBACK;
