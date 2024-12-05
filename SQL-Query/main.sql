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
-----------------------------------------TRIGGER------------------------------------------------
GO
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

-- DROP TRIGGER add_Work_on
GO
CREATE TRIGGER add_Work_on
ON WORK_ON
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Bắt đầu giao dịch
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Kiểm tra tổng số bản ghi trong inserted
        IF (SELECT COUNT(*) FROM inserted) > 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Không thể chèn nhiều bản ghi vào WORK_ON cùng lúc. Vui lòng chèn từng bản ghi một.', 16, 1);
            RETURN;
        END

        -- Biến để lưu thông tin kiểm tra
        DECLARE @ShiftID INT;
        DECLARE @ID_Card_Num CHAR(12);
        DECLARE @MaxPeople INT;
        DECLARE @CurrentPeople INT;

        -- Lấy giá trị từ bảng inserted (bản ghi muốn chèn)
        SELECT @ShiftID = Shift_ID, @ID_Card_Num = ID_Card_Num
        FROM inserted;

        -- Khóa dữ liệu của ca đang xét để tránh giao dịch đồng thời
        SELECT @MaxPeople = E_Num
        FROM SHIFT WITH (UPDLOCK, HOLDLOCK)
        WHERE Shift_ID = @ShiftID;

        -- Lấy số lượng người hiện tại trong ca
        SELECT @CurrentPeople = COUNT(*)
        FROM WORK_ON WITH (UPDLOCK, HOLDLOCK)
        WHERE Shift_ID = @ShiftID;

        -- Kiểm tra nếu số lượng đã đủ
        IF @CurrentPeople >= @MaxPeople
        BEGIN
            RAISERROR ('Nhân viên %s không thể đăng ký. Số người trong ca đã đạt giới hạn.', 16, 1, @ID_Card_Num);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Nếu chưa đủ người, thực hiện chèn
        INSERT INTO WORK_ON (Shift_ID, ID_Card_Num)
        SELECT Shift_ID, ID_Card_Num
        FROM inserted;

        -- Kết thúc giao dịch
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi và hủy giao dịch
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO

----------------------------------------PROCEDURE-----------------------------------------------

GO
----------------------------------------INSERT VALUE--------------------------------------------

-- 24 EMPLOYEE
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
-- SELECT * FROM Person;

INSERT INTO Account (ID_Card_Num, Username, Password, Role, Status)
VALUES
('123456789012', 'NguyenMinhHoa012', 'hashed_password1', 'Admin', 'Active'),
('987654321098', 'TranVanBinh098', 'hashed_password2', 'Admin', 'Active'),
('222222221111', 'NguyenVanMinh111', 'hashed_password3', 'Admin', 'Active'),
('332211445577', 'TranThiSau577', 'hashed_password4', 'Employee', 'Active'),
('555555555555', 'LeThiHanh555', 'hashed_password5', 'Employee', 'Active'),
('666666666666', 'PhamVanPhuc666', 'hashed_password6', 'Employee', 'Active'),
('777777777777', 'NguyenThiDao777', 'hashed_password7', 'Employee', 'Active'),
('888888888888', 'DoHoangAnh888', 'hashed_password8', 'Employee', 'Active'),
('999999999999', 'TranThiHong999', 'hashed_password9', 'Employee', 'Active'),
('112233445566', 'NguyenVanTam566', 'hashed_password10', 'Employee', 'Active'),
('223344556677', 'PhamMinhLong677', 'hashed_password11', 'Employee', 'Active'),
('334455667788', 'LeHoangLinh788', 'hashed_password12', 'Employee', 'Active'),
('445566778899', 'NguyenThiTrang899', 'hashed_password13', 'Employee', 'Active'),
('556677889900', 'TranVanHoa900', 'hashed_password14', 'Employee', 'Active'),
('667788990011', 'PhamThiMy011', 'hashed_password15', 'Employee', 'Active'),
('778899001122', 'DoVanHung122', 'hashed_password16', 'Employee', 'Active'),
('889900112233', 'NguyenThiLan233', 'hashed_password17', 'Employee', 'Active'),
('990011223344', 'LeVanDung344', 'hashed_password18', 'Employee', 'Active'),
('110022334455', 'TranHoangNam455', 'hashed_password19', 'Employee', 'Active'),
('120033445566', 'PhamThiHue566', 'hashed_password20', 'Employee', 'Active'),
('130044556677', 'NguyenVanHieu677', 'hashed_password21', 'Employee', 'Active'),
('140055667788', 'TranMinhQuang788', 'hashed_password22', 'Employee', 'Active'),
('150066778899', 'LeThiKim899', 'hashed_password23', 'Employee', 'Active'),
('160077889900', 'PhamVanCuong900', 'hashed_password24', 'Employee', 'Active');
-- SELECT p.ID_Card_Num, p.Fname, p.Lname, a.Username, a.Password
-- FROM Person p
-- JOIN Account a ON p.ID_Card_Num = a.ID_Card_Num;

INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
VALUES
('123456789012', 'Senior', 35000),  -- Admin -> Senior
('987654321098', 'Senior', 30000),  -- Admin -> Senior
('222222221111', 'Senior', 35000),  -- Admin -> Senior
('332211445577', 'Senior', 30000), 
('555555555555', 'Junior', 25000), 
('666666666666', 'Junior', 25000),
('777777777777', 'Junior', 25000), 
('888888888888', 'Senior', 35000), 
('999999999999', 'Junior', 25000), 
('112233445566', 'Senior', 30000), 
('223344556677', 'Junior', 25000), 
('334455667788', 'Junior', 25000), 
('445566778899', 'Senior', 35000), 
('556677889900', 'Junior', 25000), 
('667788990011', 'Senior', 30000), 
('778899001122', 'Junior', 25000), 
('889900112233', 'Junior', 25000), 
('990011223344', 'Senior', 30000), 
('110022334455', 'Senior', 35000), 
('120033445566', 'Junior', 25000), 
('130044556677', 'Junior', 25000), 
('140055667788', 'Senior', 30000), 
('150066778899', 'Junior', 25000), 
('160077889900', 'Senior', 35000);

-- SELECT * FROM Employee;

INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('123456789012', '2024-01-01', '2024-06-30'), 
('987654321098', '2024-01-01', '2024-12-31'), 
('222222221111', '2024-02-01', '2024-08-31'), 
('332211445577', '2024-03-01', '2024-09-30'),
('123456789012', '2022-01-01', '2023-06-30'), 
('332211445577', '2020-03-01', '2021-12-30');

-- SELECT * FROM Working_Period;

INSERT INTO Shift (Shift_Type, [Date], Rate, E_Num)
VALUES 
('1', '2024-12-05', 1, 2),
('2', '2024-12-05', 1, 2),
('3', '2024-12-05', 1.25, 4),
('1', '2024-12-06', 1, 2),
('2', '2024-12-06', 1, 2),
('3', '2024-12-06', 1.25, 3),
('1', '2024-12-07', 1.25, 2),
('2', '2024-12-07', 1.25, 2),
('3', '2024-12-07', 1.5, 4);

-- SELECT * FROM Shift;

-- DELETE FROM WORK_ON;

INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (1, '123456789012'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (1, '987654321098'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (2, '222222221111');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (2, '332211445577'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '555555555555');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '666666666666');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '777777777777'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (4, '999999999999');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (4, '112233445566'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (5, '223344556677');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (5, '334455667788'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (6, '445566778899'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (7, '889900112233'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (8, '130044556677'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (9, '150066778899');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (9, '160077889900');

-- KHONG CHEN CUNG LUC DUOC
-- INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES 
-- (5, '223344556677'),
-- (5, '332211445577'),
-- (5, '555555555555'); 

-- SELECT * FROM WORK_ON;
GO

-- Insert 5 employees into SALES_EMPLOYEE
INSERT INTO SALES_EMPLOYEE (ID_Card_Num)
VALUES
('123456789012'),
('987654321098'),
('222222221111'),
('332211445577'),
('555555555555');

-- SELECT * FROM SALES_EMPLOYEE S JOIN EMPLOYEE E ON S.ID_Card_Num = E.ID_Card_Num;

INSERT INTO SUPERVISE (Supervisor_ID, Supervisee_ID)
VALUES
('123456789012', '222222221111'),
('123456789012', '987654321098'),
('123456789012', '332211445577'),
('222222221111', '555555555555');

-- Insert 5 employees into PACKAGING_EMPLOYEE
INSERT INTO PACKAGING_EMPLOYEE (ID_Card_Num)
VALUES
('666666666666'),
('777777777777'),
('888888888888'),
('999999999999'),
('112233445566');

SELECT * FROM PACKAGING_EMPLOYEE;

-- Insert 5 employees into CUSTOMERSERVICE_EMPLOYEE
INSERT INTO CUSTOMERSERVICE_EMPLOYEE (ID_Card_Num)
VALUES
('223344556677'),
('334455667788'),
('445566778899'),
('556677889900'),
('667788990011');

SELECT * FROM CUSTOMERSERVICE_EMPLOYEE;

-- Insert 5 employees into ACCOUNTING_EMPLOYEE
INSERT INTO ACCOUNTING_EMPLOYEE (ID_Card_Num)
VALUES
('778899001122'),
('889900112233'),
('990011223344'),
('110022334455'),
('120033445566');

SELECT * FROM ACCOUNTING_EMPLOYEE;

-- Insert 4 employees into WAREHOUSE_EMPLOYEE
INSERT INTO WAREHOUSE_EMPLOYEE (ID_Card_Num)
VALUES
('130044556677'),
('140055667788'),
('150066778899'),
('160077889900');

SELECT * FROM WAREHOUSE_EMPLOYEE;

INSERT INTO EXPENSE_TYPE ([Name]) VALUES
('Inventory Purchase'),
('Rent'),
('Salaries'),
('Utilities'),
('Marketing');

INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID) VALUES
('Purchase of Winter Collection', '2024-12-01', 10000000, 'Fashion Supplier', 1),
('Store Rent for December', '2024-12-01', 25000000, 'Landlord', 2),
('Salary Payment for December', '2024-12-01', 20000000, 'Employee', 3),
('Electricity Bill', '2024-12-02', 1000000, 'Electricity Provider', 4),
('Facebook Ads Campaign', '2024-12-02', 5000000, 'Ad Agency', 5);

SELECT * FROM EXPENSE_RECEIPT R JOIN EXPENSE_TYPE T ON R.Expense_Type_ID = T.Expense_Type_ID

INSERT INTO INCOME_TYPE ([Name]) VALUES
('Sales Revenue'),
('Inventory Returns');

-- Insert 5 sample records into INCOME_RECEIPT (Income related to the fashion store)
INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID) VALUES
('Sale of Order', '2024-12-01', 2000000, 'Customer A', 1),
('Return of Faulty Shoes', '2024-12-02', 1000000, 'Supplier B', 2),
('Return of Faulty Dresses', '2024-12-02', 10000000, 'Supplier G', 2),
('Sale of Order', '2024-11-11', 5000000, 'Customer X', 1);



-------

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



----------------------------------------DELETE--------------------------------------------
<<<<<<< HEAD
-- Drop các bảng chứa các ràng buộc khóa ngoại trước
ALTER TABLE HANDLE DROP CONSTRAINT fk_handle_vs_customer_service_employee;
ALTER TABLE HANDLE DROP CONSTRAINT fk_handle_vs_order;
ALTER TABLE GET_FEEDBACK DROP CONSTRAINT fk_get_feedback_vs_customer_service_employee;
ALTER TABLE GET_FEEDBACK DROP CONSTRAINT fk_get_feedback_vs_order;
ALTER TABLE PREPARE DROP CONSTRAINT fk_prepare_vs_packaging_employee;
ALTER TABLE PREPARE DROP CONSTRAINT fk_prepare_vs_order;
ALTER TABLE INCHARGE_OF DROP CONSTRAINT fk_incharge_of_vs_sales_employee;
ALTER TABLE INCHARGE_OF DROP CONSTRAINT fk_incharge_of_vs_order;
ALTER TABLE INCLUDE_ITEM DROP CONSTRAINT fk_include_item_vs_item;
ALTER TABLE INCLUDE_ITEM DROP CONSTRAINT fk_include_item_vs_order;
ALTER TABLE VOUCHER_VALID_PERIOD DROP CONSTRAINT fk_voucher_valid_period_vs_voucher;
ALTER TABLE RECONCILE DROP CONSTRAINT fk_reconcile_vs_item;
ALTER TABLE RECONCILE DROP CONSTRAINT fk_reconcile_vs_check;
ALTER TABLE RECONCILE DROP CONSTRAINT fk_reconcile_vs_employee;
ALTER TABLE MANAGE_INCOME DROP CONSTRAINT fk_manage_income_vs_income_receipt;
ALTER TABLE MANAGE_INCOME DROP CONSTRAINT fk_manage_income_vs_profit_and_loss_statement;
ALTER TABLE MANAGE_EXPENSE DROP CONSTRAINT fk_manage_expense_vs_profit_and_loss_statement;
ALTER TABLE MANAGE_EXPENSE DROP CONSTRAINT fk_manage_expense_vs_expense_receipt;
ALTER TABLE SUPERVISE DROP CONSTRAINT fk_supervise_vs_supervisor;
ALTER TABLE SUPERVISE DROP CONSTRAINT fk_supervise_vs_supervisee;
ALTER TABLE SALARY DROP CONSTRAINT fk_salary_vs_employee;
ALTER TABLE WORK_ON DROP CONSTRAINT fk_work_on_vs_employee;
ALTER TABLE WORK_ON DROP CONSTRAINT fk_work_on_vs_shift;
ALTER TABLE SHIFT DROP CONSTRAINT fk_shift_vs_employee;
ALTER TABLE EMPLOYEE DROP CONSTRAINT fk_employee_vs_person;
ALTER TABLE ACCOUNT DROP CONSTRAINT fk_account_vs_person;
ALTER TABLE RETURN_ORDER DROP CONSTRAINT fk_return_order_vs_order;
ALTER TABLE DELIVERY_INFO DROP CONSTRAINT fk_delivery_info_vs_order;
ALTER TABLE APPLY_VOUCHER DROP CONSTRAINT fk_apply_voucher_vs_voucher;
ALTER TABLE APPLY_VOUCHER DROP CONSTRAINT fk_apply_voucher_vs_order;
ALTER TABLE PLACE DROP CONSTRAINT fk_place_vs_order;
ALTER TABLE PLACE DROP CONSTRAINT fk_place_vs_customer;
ALTER TABLE PLACE DROP CONSTRAINT fk_place_vs_receiver_info;
ALTER TABLE OF_GROUP DROP CONSTRAINT fk_of_group_vs_customer_group;
ALTER TABLE OF_GROUP DROP CONSTRAINT fk_of_group_vs_voucher;
ALTER TABLE CUSTOMER DROP CONSTRAINT fk_customer_vs_person;
ALTER TABLE CUSTOMER DROP CONSTRAINT fk_customer_vs_customer_group;
ALTER TABLE RECEIVER_INFO DROP CONSTRAINT fk_receiver_info_vs_customer;
ALTER TABLE RECEIVER_INFO DROP CONSTRAINT fk_receiver_info_vs_customer_group;
ALTER TABLE CUSTOMER_GROUP DROP CONSTRAINT fk_customer_group_vs_customer;
=======
DROP SEQUENCE EmpID_Sequence
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
>>>>>>> b6d3887e6079c26f661126fac8c2a28521b38056

-- Drop tất cả các bảng
DROP TABLE IF EXISTS HANDLE;
DROP TABLE IF EXISTS GET_FEEDBACK;
DROP TABLE IF EXISTS PREPARE;
DROP TABLE IF EXISTS INCHARGE_OF;
DROP TABLE IF EXISTS INCLUDE_ITEM;
DROP TABLE IF EXISTS VOUCHER_VALID_PERIOD;
DROP TABLE IF EXISTS RECONCILE;
DROP TABLE IF EXISTS MANAGE_INCOME;
DROP TABLE IF EXISTS MANAGE_EXPENSE;
DROP TABLE IF EXISTS SUPERVISE;
DROP TABLE IF EXISTS SALARY;
DROP TABLE IF EXISTS WORK_ON;
DROP TABLE IF EXISTS SHIFT;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS ACCOUNT;
DROP TABLE IF EXISTS RETURN_ORDER;
DROP TABLE IF EXISTS DELIVERY_INFO;
DROP TABLE IF EXISTS APPLY_VOUCHER;
DROP TABLE IF EXISTS PLACE;
DROP TABLE IF EXISTS OF_GROUP;
DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS RECEIVER_INFO;
DROP TABLE IF EXISTS CUSTOMER_GROUP;
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS PRODUCT_SET;
DROP TABLE IF EXISTS COMBINE;
DROP TABLE IF EXISTS REVENUE_REPORT_BY_ITEM;
DROP TABLE IF EXISTS INVENTORY_REPORT;
DROP TABLE IF EXISTS SUPPLIER;
DROP TABLE IF EXISTS EXPENSE_RECEIPT;
DROP TABLE IF EXISTS INCOME_RECEIPT;
DROP TABLE IF EXISTS EXPENSE_TYPE;
DROP TABLE IF EXISTS INCOME_TYPE;
DROP TABLE IF EXISTS ADD_EXPENSE;
DROP TABLE IF EXISTS ADD_INCOME;
DROP TABLE IF EXISTS PROFIT_AND_LOSS_STATEMENT;
DROP TABLE IF EXISTS IMPORT_BILL;
DROP TABLE IF EXISTS IMPORT;
DROP TABLE IF EXISTS RETURN_BILL;
DROP TABLE IF EXISTS RETURN_ITEM;
DROP TABLE IF EXISTS RECONCILIATION_FORM;
DROP TABLE IF EXISTS VOUCHER;
DROP TABLE IF EXISTS WORKING_PERIOD;
DROP TABLE IF EXISTS SALES_EMPLOYEE;
DROP TABLE IF EXISTS PACKAGING_EMPLOYEE;
DROP TABLE IF EXISTS CUSTOMERSERVICE_EMPLOYEE;
DROP TABLE IF EXISTS ACCOUNTING_EMPLOYEE;
DROP TABLE IF EXISTS WAREHOUSE_EMPLOYEE;
DROP TABLE IF EXISTS PERSON;
DROP TABLE IF EXISTS [ORDER];
DROP TABLE IF EXISTS CONTAIN;
DROP TABLE IF EXISTS SUMMARIZE;

-- Drop các sequences
DROP SEQUENCE IF EXISTS EmpID_Sequence;

