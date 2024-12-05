--------------------------------------------CREATE----------------------------------------------
-- CREATE ORDER
CREATE TABLE [ORDER](
    Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Order_Date DATE DEFAULT GETDATE(),
    Discount INT DEFAULT 0,
    Payment_Method VARCHAR(10) DEFAULT 'Cash',
    Shipping_Fee INT DEFAULT 0,
    Order_Status VARCHAR(10) DEFAULT 'Preparing',
    Total_Item_Amount INT DEFAULT 0,
    Customer_Notes VARCHAR(255)
);

GO

--CREATE VOUCHER
CREATE TABLE VOUCHER(
    Voucher_ID INT IDENTITY(1,1) PRIMARY KEY,
    Voucher_Code CHAR(5) UNIQUE NOT NULL,
    Voucher_Name VARCHAR(50) DEFAULT 'Voucher',
    Voucher_Status VARCHAR(10) DEFAULT 'Not activated',
    Discount_Percentage INT DEFAULT 0,
    Max_Discount_Amount INT DEFAULT 0
);

GO

--CREATE DELIVERY_INFO
CREATE TABLE DELIVERY_INFO(
    Shipping_Code INT IDENTITY(1,1) PRIMARY KEY,
    Shipping_Provider VARCHAR(50) DEFAULT '',
    Pick_up_Date DATE DEFAULT GETDATE(),
    Expected_Delivery_Date DATE DEFAULT DATEADD(DAY, 10, GETDATE()),
    Order_ID INT,
)
GO

ALTER TABLE DELIVERY_INFO
ADD CONSTRAINT fk_delivery_info_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

GO

--CREATE RETURN_ORDER
CREATE TABLE RETURN_ORDER(
    Return_Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Reason VARCHAR(255) DEFAULT 'ERROR',
    Return_Description VARCHAR(255) DEFAULT '',
    Return_Status VARCHAR(50) DEFAULT 'Under consideration',
    Order_ID INT
)

GO

ALTER TABLE RETURN_ORDER
ADD CONSTRAINT fk_return_order_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

GO

-- CREATE APPLY_VOUCHER
CREATE TABLE APPLY_VOUCHER(
    Voucher_ID INT PRIMARY KEY,
    Order_ID INT
)

ALTER TABLE APPLY_VOUCHER 
ADD CONSTRAINT fk_apply_voucher_vs_voucher FOREIGN KEY (Voucher_ID) REFERENCES VOUCHER(Voucher_ID)

ALTER TABLE APPLY_VOUCHER 
ADD CONSTRAINT fk_apply_voucher_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

GO

-- CREATE PERSON 
CREATE TABLE PERSON (
    ID_Card_Num CHAR(12) PRIMARY KEY,
    Fname NVARCHAR(20) NOT NULL,
    Lname NVARCHAR(40) NOT NULL,
    DOB DATE NOT NULL,
    CONSTRAINT CK_Age CHECK (DATEADD(YEAR, 18, DOB) <= GETDATE())
);

-- CREATE ACCOUNT
CREATE TABLE ACCOUNT (
    Account_ID INT IDENTITY(1,1) PRIMARY KEY,        -- Khóa chính, tự động tăng từ 1
    ID_Card_Num CHAR(12) UNIQUE NOT NULL, 
    Email VARCHAR(100) NOT NULL UNIQUE,            -- Email, không được trùng lặp
    [Password] VARCHAR(255) NOT NULL,                -- Mật khẩu
    [Role] CHAR(20) NOT NULL,                     -- Vai trò
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Active',  -- Trạng thái, mặc định là Active
    CONSTRAINT CK_Role CHECK (Role IN ('Employee', 'Admin', 'Customer')), -- Ràng buộc Role
    CONSTRAINT CK_Status CHECK (Status IN ('Active', 'Inactive')),
    CONSTRAINT FK_Account_Person FOREIGN KEY (ID_Card_Num) REFERENCES Person(ID_Card_Num)
);

-- CREATE EMPLOYEE
CREATE SEQUENCE EmpID_Sequence
START WITH 1
INCREMENT BY 1;

CREATE TABLE EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Person(ID_Card_Num),
    Employee_ID CHAR(8) UNIQUE,
    Position VARCHAR(30) NOT NULL,
    Wage INT NOT NULL,
);

-- CREATE WORKING_PERIOD
CREATE TABLE WORKING_PERIOD (
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    [Start_Date] DATE NOT NULL,
    End_Date DATE NOT NULL,
    PRIMARY KEY (ID_Card_Num, Start_Date, End_Date)
);

-- CREATE SHIFT
CREATE TABLE SHIFT (
    Shift_ID INT IDENTITY(1,1) PRIMARY KEY,
    Shift_Type CHAR(1) NOT NULL,
    [Date] DATE NOT NULL,
    Rate DECIMAL(5, 2) DEFAULT 1.00,
    CONSTRAINT CK_Shift_Type CHECK (Shift_Type IN ('1', '2', '3'))
);

-- CREATE WORK_ON
CREATE TABLE WORK_ON (
    Shift_ID INT FOREIGN KEY REFERENCES Shift(Shift_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    PRIMARY KEY (Shift_ID, ID_Card_Num)
);

-- CREATE SALARY
CREATE TABLE SALARY (
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12),
    [Year] INT,
    Amount INT NOT NULL,
    PRIMARY KEY (ID_Card_Num, [Month], [Year])
);

-- CREATE SUPERVISE
CREATE TABLE SUPERVISE (
    Supervisee_ID CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    Supervisor_ID CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
);

-- CREATE TYPES OF EMPLOYEE
CREATE TABLE SALES_EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE PACKAGING_EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE CUSTOMERSERVICE_EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE ACCOUNTING_EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE WAREHOUSE_EMPLOYEE (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

-- CREATE EXPENSE_TYPE
CREATE TABLE EXPENSE_TYPE (
    Expense_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE
);

-- CREATE EXPENSE_RECEIPT
CREATE TABLE EXPENSE_RECEIPT (
    Expense_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE,
    [Date] DATE NOT NULL,
    Amount INT NOT NULL,
    Payee_Name VARCHAR(40) NOT NULL,
    Expense_Type_ID INT FOREIGN KEY REFERENCES Expense_Type(Expense_Type_ID)
);

-- CREATE INCOME_TYPE
CREATE TABLE INCOME_TYPE (
    Income_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE
);

-- CREATE INCOME_RECEIPT
CREATE TABLE INCOME_RECEIPT (
    Income_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE,
    [Date] DATE NOT NULL,
    Amount INT NOT NULL,
    Payer_Name VARCHAR(40) NOT NULL,
    Income_Type_ID INT FOREIGN KEY REFERENCES Income_Type(Income_Type_ID)
);

-- CREATE ADD_EXPENSE
CREATE TABLE ADD_EXPENSE (
    Expense_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Expense_Receipt(Expense_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Accounting_Employee(ID_Card_Num)
);

-- CREATE ADD_INCOME
CREATE TABLE ADD_INCOME (
    Income_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Income_Receipt(Income_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Accounting_Employee(ID_Card_Num)
);

-- CREATE PROFIT AND LOSS STATEMENT
CREATE TABLE PROFIT_AND_LOSS_STATEMENT (
    Profit_And_Loss_ID INT IDENTITY(1,1) PRIMARY KEY,
    Report_Type VARCHAR(5) CHECK (Report_Type IN ('Day','Month','Year')),
    Expense INT NOT NULL,
    Revenue INT NOT NULL,
    Gross_Profit INT NOT NULL,
    [Day] INT NOT NULL,
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12) NOT NULL,
    [Year] INT NOT NULL
);

-- CREATE MANAGE_EXPENSE
CREATE TABLE MANAGE_EXPENSE (
    Expense_ID INT FOREIGN KEY REFERENCES Expense_Receipt(Expense_ID),
    Profit_And_Loss_ID INT FOREIGN KEY REFERENCES Profit_And_Loss_Statement(Profit_And_Loss_ID),
    PRIMARY KEY(Expense_ID, Profit_And_Loss_ID)
);

-- CREATE MANAGE_INCOME
CREATE TABLE MANAGE_INCOME (
    Income_ID INT FOREIGN KEY REFERENCES Income_Receipt(Income_ID),
    Profit_And_Loss_ID INT FOREIGN KEY REFERENCES Profit_And_Loss_Statement(Profit_And_Loss_ID),
    PRIMARY KEY(Income_ID, Profit_And_Loss_ID)
);

-- Bảng SUPPLIER
CREATE TABLE SUPPLIER (
    SUPPLIER_ID INT IDENTITY(1,1) PRIMARY KEY,
    SUPPLIER_NAME VARCHAR(30),
    SUPPLIER_EMAIL VARCHAR(30),
    SUPPLIER_PHONE VARCHAR(20),
    [ADDRESS] VARCHAR(100)
);

-- Bảng PRODUCT
CREATE TABLE PRODUCT (
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(30),
    BRAND VARCHAR(30),
    STYLE_TAG VARCHAR(30),
    SEASON VARCHAR(30),
    CATEGORY VARCHAR(30),
    [DESCRIPTION] TEXT
);

-- Bảng ITEM
CREATE TABLE ITEM (
    ITEM_ID INT IDENTITY(1,1) PRIMARY KEY,
    IMPORT_PRICE DECIMAL(10, 2),
    SELLING_PRICE DECIMAL(10, 2),
    SIZE VARCHAR(10),
    COLOR VARCHAR(10),
    STOCK INT,
    PRODUCT_ID INT,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID)
);


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
    CONSTRAINT FK_Customer_Person FOREIGN KEY (ID_Card_Num) REFERENCES PERSON(ID_Card_Num)
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
    CONSTRAINT FK_Of_Group_Voucher FOREIGN KEY (Voucher_ID) REFERENCES Voucher(Voucher_ID),
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
    CONSTRAINT FK_Place_Order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID),
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
    CONSTRAINT FK_Summarize_Order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)
);
-- Bảng Contain
CREATE TABLE Contain (
    Inventory_Report_ID INT NOT NULL,
    Item_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),

    PRIMARY KEY (Inventory_Report_ID, Item_ID),
    CONSTRAINT FK_Contain_Inventory_Report FOREIGN KEY (Inventory_Report_ID) REFERENCES INVENTORY_REPORT(Inventory_Report_ID),
    CONSTRAINT FK_Contain_Item FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID)
);







-- Bảng IMPORT_BILL
CREATE TABLE IMPORT_BILL (
    IMPORT_ID INT IDENTITY(1,1) PRIMARY KEY,
    IMPORT_STATE VARCHAR(30),
    TOTAL_FEE DECIMAL(10, 2)
);

-- Bảng IMPORT
CREATE TABLE IMPORT (
    IMPORT_ID INT,
    ITEM_ID INT,
    SUPPLIER_ID INT,
    IMPORT_QUANTITY INT,
    FOREIGN KEY (IMPORT_ID) REFERENCES IMPORT_BILL(IMPORT_ID),
    FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIER(SUPPLIER_ID),
    PRIMARY KEY (IMPORT_ID, ITEM_ID)
);

-- Bảng RETURN_BILL
CREATE TABLE RETURN_BILL (
    RETURN_ID INT IDENTITY(1,1) PRIMARY KEY,
    REASON TEXT,
    REFUND_FEE DECIMAL(10, 2)
);

-- Bảng RETURN_ITEM
CREATE TABLE RETURN_ITEM (
    RETURN_ID INT,
    ITEM_ID INT,
    SUPPLIER_ID INT,
    RETURN_QUANTITY INT,
    FOREIGN KEY (RETURN_ID) REFERENCES RETURN_BILL(RETURN_ID),
    FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIER(SUPPLIER_ID),
    PRIMARY KEY (RETURN_ID, ITEM_ID)
);

-- Bảng RECONCILIATION_FORM
CREATE TABLE RECONCILIATION_FORM (
    CHECK_ID INT IDENTITY(1,1) PRIMARY KEY,
    CHECKED_DATE DATE
);

-- Bảng RECONCILE
CREATE TABLE RECONCILE (
    CHECK_ID INT,
    ITEM_ID INT,
    ID_CARD_NUM VARCHAR(30),
    ACTUAL_QUANTITY INT,
    FOREIGN KEY (CHECK_ID) REFERENCES RECONCILIATION_FORM(CHECK_ID),
    FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    PRIMARY KEY (CHECK_ID, ITEM_ID)
);

-- Bảng PRODUCT_SET
CREATE TABLE PRODUCT_SET (
    SET_ID INT IDENTITY(1,1) PRIMARY KEY,
    NAME VARCHAR(100),
    STYLE VARCHAR(50)
);

-- Bảng COMBINE
CREATE TABLE COMBINE (
    PRODUCT_ID INT,
    SET_ID INT,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID),
    FOREIGN KEY (SET_ID) REFERENCES PRODUCT_SET(SET_ID),
    PRIMARY KEY (PRODUCT_ID, SET_ID)
);
GO

-- CREATE VOUCHER_VALID_PERIOD
CREATE TABLE VOUCHER_VALID_PERIOD (
    Voucher_ID INT,
    Voucher_Start_Date DATE NOT NULL,
    Voucher_End_Date DATE NOT NULL,
    PRIMARY KEY (Voucher_ID, Voucher_Start_Date, Voucher_End_Date)
)

GO
ALTER TABLE VOUCHER_VALID_PERIOD
ADD CONSTRAINT fk_voucher_valid_period_vs_voucher FOREIGN KEY (Voucher_ID) REFERENCES VOUCHER(Voucher_ID)

GO

-- CREATE INCLUDE_ITEM
CREATE TABLE INCLUDE_ITEM (
    Order_ID INT,
    Item_ID INT,
    Count INT DEFAULT 0
    PRIMARY KEY (Order_ID, Item_ID)
)

ALTER TABLE INCLUDE_ITEM
ADD CONSTRAINT fk_include_item_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE INCLUDE_ITEM
ADD CONSTRAINT fk_include_item_vs_item FOREIGN KEY (Item_ID) REFERENCES ITEM(ITEM_ID)

GO
-- CREATE INCHARGE_OF
CREATE TABLE INCHARGE_OF (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE INCHARGE_OF
ADD CONSTRAINT fk_incharge_of_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE INCHARGE_OF
ADD CONSTRAINT fk_incharge_of_vs_sales_employee FOREIGN KEY (Item_ID) REFERENCES SALES_EMPLOYEE(ID_Card_Num)

GO

-- CREATE PREPARE
CREATE TABLE PREPARE (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE PREPARE
ADD CONSTRAINT fk_prepare_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE PREPARE
ADD CONSTRAINT fk_prepare_vs_packaging_employee FOREIGN KEY (Item_ID) REFERENCES PACKAGING_EMPLOYEE(ID_Card_Num)

GO

-- CREATE GET_FEEDBACK
CREATE TABLE GET_FEEDBACK (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE GET_FEEDBACK
ADD CONSTRAINT fk_get_feedback_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE GET_FEEDBACK
ADD CONSTRAINT fk_get_feedback_vs_customer_service_employee FOREIGN KEY (Item_ID) REFERENCES CUSTOMERSERVICE_EMPLOYEE(ID_Card_Num)

GO

-- CREATE HANDLE
CREATE TABLE HANDLE (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_customer_service_employee FOREIGN KEY (Item_ID) REFERENCES CUSTOMERSERVICE_EMPLOYEE(ID_Card_Num)

GO
-----------------------------------------TRIGGER------------------------------------------------
CREATE TRIGGER add_CreateEmpID
ON Employee
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Employee (ID_Card_Num, Employee_ID, Position, Wage)
    SELECT 
        i.ID_Card_Num,
        'EMP' + RIGHT('00000' + CAST(NEXT VALUE FOR EmpID_Sequence AS NVARCHAR), 5),
        i.Position,
        i.Wage
    FROM INSERTED i;
END;

GO

----------------------------------------PROCEDURE-----------------------------------------------

GO
----------------------------------------INSERT VALUE--------------------------------------------
INSERT INTO Person (ID_Card_Num, Fname, Lname, DOB)
VALUES
('123456789012', 'Nguyen Minh', 'Hoa', '1990-05-10'),
('987654321098', 'Tran Van', 'Binh', '1985-12-25'),
('222222221111', 'Nguyen Van', 'Minh', '1990-03-10'),
('332211445577', 'Tran Thi', 'Sau', '1985-11-14'),
('555555555555', 'Le Thi', 'Hanh', '1992-07-22'),
('666666666666', 'Pham Van', 'Phuc', '1987-04-18'),
('777777777777', 'Nguyen Thi', 'Dao', '1995-01-02'),
('888888888888', 'Do Hoang', 'Anh', '1989-09-15'),
('999999999999', 'Tran Thi', 'Hong', '1993-12-30'),
('112233445566', 'Nguyen Van', 'Tam', '1986-06-10'),
('223344556677', 'Pham Minh', 'Long', '1991-03-11'),
('334455667788', 'Le Hoang', 'Linh', '1988-08-19'),
('445566778899', 'Nguyen Thi', 'Trang', '1994-05-20'),
('556677889900', 'Tran Van', 'Hoa', '1983-11-22'),
('667788990011', 'Pham Thi', 'My', '1992-10-10'),
('778899001122', 'Do Van', 'Hung', '1987-12-15'),
('889900112233', 'Nguyen Thi', 'Lan', '1990-04-28'),
('990011223344', 'Le Van', 'Dung', '1995-07-07'),
('110022334455', 'Tran Hoang', 'Nam', '1986-01-30'),
('120033445566', 'Pham Thi', 'Hue', '1992-03-25'),
('130044556677', 'Nguyen Van', 'Hieu', '1990-08-18'),
('140055667788', 'Tran Minh', 'Quang', '1985-11-02'),
('150066778899', 'Le Thi', 'Kim', '1993-09-13'),
('160077889900', 'Pham Van', 'Cuong', '1994-02-24');


SELECT * FROM Person;

INSERT INTO Account (ID_Card_Num, Email, Password, Role, Status)
VALUES 
('123456789012','employee1@example.com', 'hashed_password1', 'Employee', 'Active'),
('987654321098','admin@example.com', 'hashed_password2', 'Admin', 'Active');

INSERT INTO Employee (ID_Card_Num, Position, Wage)
VALUES
('123456789012', 'Sale', 25000),
('987654321098', 'Manager', 50000),
('222222221111', 'Tele', 25000),
('332211445577', 'Package', 50000);

SELECT * FROM Employee;

INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('123456789012', '2024-01-01', '2024-06-30'), -- Sale
('987654321098', '2024-01-01', '2024-12-31'), -- Manager
('222222221111', '2024-02-01', '2024-08-31'), -- Tele
('332211445577', '2024-03-01', '2024-09-30'), -- Package
('123456789012', '2022-01-01', '2023-06-30'), -- Sale
('332211445577', '2020-03-01', '2021-12-30'); -- Package

SELECT * FROM Working_Period;

INSERT INTO Shift (Shift_Type, [Date], Rate)
VALUES 
('1', '2024-12-05', 1),
('2', '2024-12-05', 1),
('3', '2024-12-05', 1.25),
('1', '2024-12-06', 1),
('2', '2024-12-06', 1),
('3', '2024-12-06', 1.25),
('1', '2024-12-07', 1.25),
('2', '2024-12-07', 1.25),
('3', '2024-12-07', 1.5);

SELECT * FROM Shift;

GO



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



----------------------------------------DELETE--------------------------------------------
DROP TABLE GET_FEEDBACK
DROP TABLE HANDLE
DROP TABLE INCLUDE_ITEM
DROP TABLE PERSON
DROP TABLE INCHARGE_OF
DROP TABLE PREPARE
DROP TABLE VOUCHER_VALID_PERIOD
DROP TABLE Expense_Receipt;
DROP TABLE Income_Receipt;
DROP TABLE Expense_Type;
DROP TABLE Income_Type;
-- Xóa các bảng con trước
DROP TABLE IF EXISTS RECONCILE;
DROP TABLE IF EXISTS IMPORT;
DROP TABLE IF EXISTS RETURN_ITEM;
DROP TABLE IF EXISTS COMBINE;

-- Xóa các bảng cha
DROP TABLE IF EXISTS RECONCILIATION_FORM;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS PRODUCT_SET;
DROP TABLE IF EXISTS RETURN_BILL;
DROP TABLE IF EXISTS IMPORT_BILL;
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS SUPPLIER;

ALTER TABLE APPLY_VOUCHER DROP CONSTRAINT fk_apply_voucher_vs_voucher
ALTER TABLE APPLY_VOUCHER DROP CONSTRAINT fk_apply_voucher_vs_order
DROP TABLE APPLY_VOUCHER

ALTER TABLE RETURN_ORDER DROP CONSTRAINT fk_return_order_vs_order
DROP TABLE RETURN_ORDER

ALTER TABLE DELIVERY_INFO DROP CONSTRAINT fk_delivery_info_vs_order
DROP TABLE DELIVERY_INFO

DROP TABLE VOUCHER
DROP TABLE EMPLOYEE
DROP TABLE PERSON
DROP TABLE ACCOUNTING_EMPLOYEE
DROP TABLE SHIFT

DROP TABLE [ORDER]
DROP TABLE ACCOUNT
DROP TABLE ACCOUNTING_EMPLOYEE
DROP TABLE ADD_EXPENSE
DROP TABLE ADD_INCOME
DROP TABLE CUSTOMERSERVICE_EMPLOYEE
DROP TABLE EMPLOYEE
DROP TABLE EXPENSE_RECEIPT
DROP TABLE EXPENSE_TYPE
DROP TABLE INCOME_RECEIPT
DROP TABLE INCOME_TYPE
DROP TABLE MANAGE_EXPENSE
DROP TABLE MANAGE_INCOME
DROP TABLE PACKAGING_EMPLOYEE
DROP TABLE PERSON
DROP TABLE PROFIT_AND_LOSS_STATEMENT
DROP TABLE SALARY
DROP TABLE SALES_EMPLOYEE
DROP TABLE SHIFT
DROP TABLE SUPERVISE
DROP TABLE WAREHOUSE_EMPLOYEE
DROP TABLE WORKING_PERIOD
DROP TABLE WORK_ON
