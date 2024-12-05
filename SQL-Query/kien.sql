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
    
    Fname NVARCHAR(20) NOT NULL,
    Lname NVARCHAR(40) NOT NULL,
    Phone NVARCHAR(15) CHECK (LEN(Phone) <= 10),

    PRIMARY KEY (ID_Card_Num, Customer_ID, Housenum, Street, District, City),
    CONSTRAINT FK_Receiver_Info_Customer FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMER(ID_Card_Num) ON DELETE CASCADE,
);

-- Bảng OF_GROUP
CREATE TABLE OF_GROUP (
    Voucher_ID INT NOT NULL UNIQUE,
    Group_Name NVARCHAR(50) NOT NULL,
    PRIMARY KEY (Voucher_ID, Group_Name),
    -- CONSTRAINT FK_Of_Group_Voucher FOREIGN KEY (Voucher_ID) REFERENCES VOUCHER(Voucher_ID),
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
('223344556677', 'Platinum'),
('334455667788', 'Diamond'),
('445566778899', 'Silver'),
('556677889900', 'Gold'),
('667788990011', 'Platinum'),
('778899001122', 'Diamond'),
('889900112233', 'Member');

-- Kiểm tra dữ liệu bảng CUSTOMER
SELECT * FROM CUSTOMER;

-- Dữ liệu cho bảng REVENUE_REPORT_BY_ITEM
INSERT INTO REVENUE_REPORT_BY_ITEM (Report_Type, Total_Revenue, [Day], [Month], [Year])
VALUES 
('Daily', 15000.50, 1, 12, 2024),
('Daily', 10500.75, 7, 12, 2024),
('Daily', 20000.00, 15, 12, 2024),
('Monthly', 500000.00, NULL, 12, 2024),
('Monthly', 150000.25, NULL, 6, 2024),
('Monthly', 10000000.50, NULL, 10, 2024),
('Yearly', 750000000.00, NULL, NULL, 2023),
('Yearly', 100000000.00, NULL, NULL, 2024),
('Yearly', 500000000.00, NULL, NULL, 2022),
('Monthly', 120000.75, NULL, 8, 2024);

-- Kiểm tra dữ liệu bảng REVENUE_REPORT_BY_ITEM
SELECT * FROM REVENUE_REPORT_BY_ITEM;

-- Dữ liệu cho bảng INVENTORY_REPORT
INSERT INTO INVENTORY_REPORT (Report_Type, Inventory_Value, [Day], [Month], [Year])
VALUES 
('Daily', 250, 1, 12, 2024),
('Daily', 175, 7, 12, 2024),
('Daily', 75, 15, 12, 2024),
('Monthly', 3000, NULL, 3, 2024),
('Monthly', 5000, NULL, 5, 2024),
('Monthly', 2600, NULL, 7, 2024),
('Yearly', 12400, NULL, NULL, 2022),
('Yearly', 12000, NULL, NULL, 2023),
('Yearly', 19700, NULL, NULL, 2024),
('Monthly', 1500, NULL, 11, 2024);

-- Kiểm tra dữ liệu bảng INVENTORY_REPORT
SELECT * FROM INVENTORY_REPORT;

-- Dữ liệu cho bảng RECEIVER_INFO
INSERT INTO RECEIVER_INFO (ID_Card_Num, Customer_ID, Housenum, Street, District, City, Lname, Fname, Phone)
VALUES
('123456789012', 1, '12B', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi', 'Nguyen Van', 'Hoa', '0123456789'),
('987654321098', 2, '45C', 'Le Duan', 'Dong Da', 'Ha Noi', 'Tran Van', 'Binh', '0987654321'),
('112233445566', 3, '78A', 'Tran Phu', 'Ha Dong', 'Ha Noi', 'Nguyen Van', 'Tam', '0912345678'),
('223344556677', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi', 'Pham Minh', 'Long', '0945678912'),
('334455667788', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi', 'Le Hoang', 'Linh', '0934567890'),
('445566778899', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi', 'Nguyen Thi', 'Trang', '0923456781'),
('556677889900', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi', 'Tran Van', 'Hoa', '0912345679'),
('667788990011', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi', 'Pham Thi', 'My', '0901234567'),
('778899001122', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi', 'Do Van', 'Hung', '0987654322'),
('889900112233', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi', 'Nguyen Thi', 'Lan', '0945678923');

-- Kiểm tra dữ liệu bảng RECEIVER_INFO
SELECT * FROM RECEIVER_INFO;

-- Dữ liệu cho bảng Of_Group
INSERT INTO Of_Group (Voucher_ID, Group_Name)
VALUES 
(1, 'Member'),
(2, 'Silver'),
(3, 'Member'),
(4, 'Platinum'),
(5, 'Diamond'),
(6, 'Member'),
(7, 'Silver'),
(8, 'Silver'),
(9, 'Platinum'),
(10, 'Diamond');

-- Kiểm tra dữ liệu bảng Of_Group
SELECT * FROM Of_Group;

-- -- Dữ liệu cho bảng Place
-- INSERT INTO Place (Order_ID, ID_Card_Num, Customer_ID, HouseNum, Street, District, City)
-- VALUES 
-- (101, '123456789012', 1, '12A', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi'),
-- (102, '987654321098', 2, '45B', 'Le Duan', 'Dong Da', 'Ha Noi'),
-- (103, '112233445566', 3, '78C', 'Tran Phu', 'Ha Dong', 'Ha Noi'),
-- (104, '223344556677', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi'),
-- (105, '334455667788', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi'),
-- (106, '445566778899', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi'),
-- (107, '556677889900', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi'),
-- (108, '667788990011', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi'),
-- (109, '778899001122', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi'),
-- (110, '889900112233', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi');

-- -- Kiểm tra dữ liệu bảng Place
-- SELECT * FROM Place;

-- -- Dữ liệu cho bảng Summarize
-- INSERT INTO Summarize (Item_Revenue_Report_ID, Order_ID, Quantity)
-- VALUES
-- (1, 101, 5),
-- (2, 102, 10),
-- (3, 103, 15),
-- (4, 104, 20),
-- (5, 105, 25),
-- (6, 106, 30),
-- (7, 107, 35),
-- (8, 108, 40),
-- (9, 109, 45),
-- (10, 110, 50);

-- -- Kiểm tra dữ liệu bảng Summarize
-- SELECT * FROM Summarize;

-- -- Dữ liệu cho bảng Contain
-- INSERT INTO Contain (Inventory_Report_ID, Item_ID, Quantity)
-- VALUES
-- (1, 1001, 50),
-- (2, 1002, 100),
-- (3, 1003, 150),
-- (4, 1004, 200),
-- (5, 1005, 250),
-- (6, 1006, 300),
-- (7, 1007, 350),
-- (8, 1008, 400),
-- (9, 1009, 450),
-- (10, 1010, 500);

-- -- Kiểm tra dữ liệu bảng Contain
-- SELECT * FROM Contain;



-- Rollback để hoàn tác
ROLLBACK;
