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
    Username VARCHAR(100) NOT NULL UNIQUE,            -- Email, không được trùng lặp
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
    E_Num INT NOT NULL,
    Rate DECIMAL(5, 2) DEFAULT 1.00,
    CONSTRAINT CK_Shift_Type CHECK (Shift_Type IN ('1', '2', '3'))
);

-- CREATE WORK_ON
CREATE TABLE WORK_ON (
    Shift_ID INT FOREIGN KEY REFERENCES Shift(Shift_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    PRIMARY KEY (Shift_ID, ID_Card_Num),
    [Check] BIT DEFAULT 0
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
    [Name] VARCHAR(40) NOT NULL,
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
    [Name] VARCHAR(40) NOT NULL,
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
--------

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
    -- IMPORT_PRICE DECIMAL(10, 2),
    SELLING_PRICE DECIMAL(10, 2),
    SIZE VARCHAR(10),
    COLOR VARCHAR(10),
    STOCK INT,
    PRODUCT_ID INT,
    CONSTRAINT Fk_Item_Product FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID)
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
    CONSTRAINT FK_Of_Group_Voucher FOREIGN KEY (Voucher_ID) REFERENCES VOUCHER(Voucher_ID),
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
    IMPORT_PRICE DECIMAL(10, 2),
    CONSTRAINT Fk_Import_Import_Bill FOREIGN KEY (IMPORT_ID) REFERENCES IMPORT_BILL(IMPORT_ID),
    CONSTRAINT Fk_Import_Item FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    CONSTRAINT Fk_Import_Supplier FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIER(SUPPLIER_ID),
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
    RETURN_PRICE DECIMAL(10, 2),
    CONSTRAINT Fk_Return_Item_Return_Bill FOREIGN KEY (RETURN_ID) REFERENCES RETURN_BILL(RETURN_ID),
    CONSTRAINT Fk_Return_Item_Item FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    CONSTRAINT Fk_Return_Item_Suplier FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIER(SUPPLIER_ID),
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
    ID_CARD_NUM VARCHAR(12),
    ACTUAL_QUANTITY INT,
    CONSTRAINT Fk_Reconcile_Reconciliation_Form FOREIGN KEY (CHECK_ID) REFERENCES RECONCILIATION_FORM(CHECK_ID),
    CONSTRAINT FK_Reconcile_Item FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID),
    CONSTRAINT Fk_Warehouse_Employee_ID FOREIGN KEY (ID_CARD_NUM) REFERENCES WAREHOUSE_EMPLOYEE(ID_Card_Num),
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
    CONSTRAINT Fk_Combine_Product FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID),
    CONSTRAINT Fk_Combine_Product_Set FOREIGN KEY (SET_ID) REFERENCES PRODUCT_SET(SET_ID),
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
ADD CONSTRAINT fk_incharge_of_vs_sales_employee FOREIGN KEY (ID_Card_Num) REFERENCES SALES_EMPLOYEE(ID_Card_Num)

GO

-- CREATE PREPARE
CREATE TABLE PREPARE (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE PREPARE
ADD CONSTRAINT fk_prepare_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE PREPARE
ADD CONSTRAINT fk_prepare_vs_packaging_employee FOREIGN KEY (ID_Card_Num) REFERENCES PACKAGING_EMPLOYEE(ID_Card_Num)

GO

-- CREATE GET_FEEDBACK
CREATE TABLE GET_FEEDBACK (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE GET_FEEDBACK
ADD CONSTRAINT fk_get_feedback_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE GET_FEEDBACK
ADD CONSTRAINT fk_get_feedback_vs_customer_service_employee FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMERSERVICE_EMPLOYEE(ID_Card_Num)

GO

-- CREATE HANDLE
CREATE TABLE HANDLE (
    Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_customer_service_employee FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMERSERVICE_EMPLOYEE(ID_Card_Num)

GO