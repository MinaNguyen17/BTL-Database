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
    Voucher_Status VARCHAR(20) DEFAULT 'Not activated',
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
    Sex BIT NOT NULL, -- 0: nam, 1: nữ
    CONSTRAINT CK_Age CHECK (DATEADD(YEAR, 18, DOB) <= GETDATE())
);

-- CREATE PHONE_NUM
CREATE TABLE PHONE_NUM (
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES PERSON(ID_Card_Num),
    Phone_Num CHAR(10),
    PRIMARY KEY (ID_Card_Num, Phone_Num)
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
    [Day] INT,
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12),
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
    Phone NVARCHAR(15),  -- Điều chỉnh lại, không cần CHECK LEN(Phone) <= 10 nếu số điện thoại dài hơn

    PRIMARY KEY (ID_Card_Num, Customer_ID, Housenum, Street, District, City),
    CONSTRAINT FK_Receiver_Info_Customer FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMER(ID_Card_Num) ON DELETE CASCADE
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
    Order_ID INT NOT NULL,
    ID_Card_Num CHAR(12) NOT NULL,
    Customer_ID INT NOT NULL,
    Housenum NVARCHAR(50),
    Street NVARCHAR(100),
    District NVARCHAR(100),
    City NVARCHAR(100),
    
    PRIMARY KEY (Order_ID, ID_Card_Num),
    CONSTRAINT FK_Place_Receiver_Info FOREIGN KEY (ID_Card_Num, Customer_ID, Housenum, Street, District, City) 
        REFERENCES RECEIVER_INFO(ID_Card_Num, Customer_ID, Housenum, Street, District, City),
    CONSTRAINT FK_Place_Customer FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMER(ID_Card_Num) ON DELETE CASCADE,
    CONSTRAINT FK_Place_Order FOREIGN KEY (Order_ID) REFERENCES [ORDER](Order_ID)
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
    ID_CARD_NUM CHAR(12),
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
    Return_Order_ID INT PRIMARY KEY,
    ID_Card_Num CHAR(12)
)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_return_order FOREIGN KEY (Return_Order_ID) REFERENCES RETURN_ORDER(Return_Order_ID)

ALTER TABLE HANDLE
ADD CONSTRAINT fk_handle_vs_customer_service_employee FOREIGN KEY (ID_Card_Num) REFERENCES CUSTOMERSERVICE_EMPLOYEE(ID_Card_Num)

GO

-- ADD EMPLOYEE ID
GO
CREATE TRIGGER add_CreateEmpID
ON EMPLOYEE
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO EMPLOYEE (ID_Card_Num, Employee_ID, Position, Wage)
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
--- Cập nhật Stock của  Item sau khi Cân bằng
GO
CREATE TRIGGER trg_UpdateStockOnReconciliation
ON RECONCILE
AFTER INSERT
AS
BEGIN
    UPDATE ITEM
    SET STOCK = r.ACTUAL_QUANTITY
    FROM ITEM i
    INNER JOIN INSERTED r ON i.ITEM_ID = r.ITEM_ID;

    PRINT 'Cập nhật Stock sau khi Cân bằng';
END;


-- Cập nhật Stock cho Order
GO
CREATE TRIGGER trg_UpdateStockOnOrder
ON INCLUDE_ITEM
AFTER INSERT
AS
BEGIN
    -- Kiểm tra nếu Count vượt quá Stock
    IF EXISTS (
        SELECT 1
        FROM ITEM i
        INNER JOIN INSERTED oi ON i.ITEM_ID = oi.ITEM_ID
        WHERE oi.Count > i.STOCK
    )
    BEGIN
        PRINT 'Không đủ số lượng trong kho';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật Stock
    UPDATE ITEM
    SET STOCK = STOCK - oi.Count
    FROM ITEM i
    INNER JOIN INSERTED oi ON i.ITEM_ID = oi.ITEM_ID;

    PRINT 'Cập nhật Stock khi có đơn hàng';
END;


----------------------------------------PROCEDURE & FUNCTION------------------------------------

GO
CREATE PROCEDURE InsertVoucher
    @VoucherName NVARCHAR(100),
    @VoucherStatus NVARCHAR(20),
    @DiscountPercentage INT,
    @MaxDiscountAmount INT,
    @VoucherStartDate DATE,  -- Ngày bắt đầu của voucher
    @VoucherEndDate DATE     -- Ngày kết thúc của voucher
AS
BEGIN
    DECLARE @VoucherCode CHAR(5);
    DECLARE @VoucherID INT;
    DECLARE @MaxVoucherCode INT;

    -- Lấy mã voucher lớn nhất hiện tại trong bảng VOUCHER, nếu không có thì gán giá trị mặc định là 0
    SELECT @MaxVoucherCode = ISNULL(MAX(CAST(SUBSTRING(Voucher_Code, 2, 4) AS INT)), 0)
    FROM VOUCHER;

    -- Tạo mã voucher mới bằng cách cộng thêm 1 vào mã voucher hiện tại
    SET @VoucherCode = 'V' + RIGHT('0000' + CAST(@MaxVoucherCode + 1 AS VARCHAR(4)), 4);

    -- Thêm voucher vào bảng VOUCHER
    INSERT INTO VOUCHER (Voucher_Code, Voucher_Name, Voucher_Status, Discount_Percentage, Max_Discount_Amount)
    VALUES (@VoucherCode, @VoucherName, @VoucherStatus, @DiscountPercentage, @MaxDiscountAmount);

    -- Lấy Voucher_ID của voucher vừa thêm vào
    SET @VoucherID = SCOPE_IDENTITY();

    -- Thêm dữ liệu vào bảng VOUCHER_VALID_PERIOD
    INSERT INTO VOUCHER_VALID_PERIOD (Voucher_ID, Voucher_Start_Date, Voucher_End_Date)
    VALUES (@VoucherID, @VoucherStartDate, @VoucherEndDate);

    PRINT 'Voucher đã được thêm với mã: ' + @VoucherCode + ' và thời gian hiệu lực từ ' + CAST(@VoucherStartDate AS NVARCHAR) + ' đến ' + CAST(@VoucherEndDate AS NVARCHAR);
END;
GO



GO
-- PRODUCT
CREATE PROCEDURE AddProduct
    @PRODUCT_NAME VARCHAR(30),
    @BRAND VARCHAR(30),
    @STYLE_TAG VARCHAR(30),
    @SEASON VARCHAR(30),
    @CATEGORY VARCHAR(30),
    @DESCRIPTION TEXT
AS
BEGIN
    -- Insert the product
    INSERT INTO PRODUCT (PRODUCT_NAME, BRAND, STYLE_TAG, SEASON, CATEGORY, DESCRIPTION)
    VALUES (@PRODUCT_NAME, @BRAND, @STYLE_TAG, @SEASON, @CATEGORY, @DESCRIPTION);

    -- Return the created product
    SELECT * 
    FROM PRODUCT
    WHERE PRODUCT_ID = SCOPE_IDENTITY();
END
GO

-- DROP PROCEDURE AddProduct
GO

CREATE PROCEDURE UpdateProduct
    @PRODUCT_ID INT,
    @PRODUCT_NAME VARCHAR(30),
    @BRAND VARCHAR(30),
    @STYLE_TAG VARCHAR(30),
    @SEASON VARCHAR(30),
    @CATEGORY VARCHAR(30),
    @DESCRIPTION TEXT
AS
BEGIN
    UPDATE PRODUCT
    SET 
        PRODUCT_NAME = @PRODUCT_NAME,
        BRAND = @BRAND,
        STYLE_TAG = @STYLE_TAG,
        SEASON = @SEASON,
        CATEGORY = @CATEGORY,
        [DESCRIPTION] = @DESCRIPTION
    WHERE PRODUCT_ID = @PRODUCT_ID
END
GO

CREATE PROCEDURE GetProductById
    @ProductID INT
AS
BEGIN
    SELECT * FROM PRODUCT WHERE PRODUCT_ID = @ProductID;
END
GO

CREATE PROCEDURE GetAllProducts
AS
BEGIN
    SELECT * FROM PRODUCT;
END
GO


-- ACCOUNT
GO
CREATE OR ALTER PROCEDURE dbo.CreateAccount
    @ID_Card_Num CHAR(12),
    @Role CHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra ID_Card_Num có tồn tại trong bảng Person
        IF NOT EXISTS (
            SELECT 1 
            FROM Person
            WHERE ID_Card_Num = @ID_Card_Num
        )
        BEGIN
            THROW 50001, 'ID_Card_Num không tồn tại trong bảng Person.', 1;
        END;

        -- Lấy thông tin FName và LName từ Person
        DECLARE @LName NVARCHAR(50);
        DECLARE @FName NVARCHAR(50);
        SELECT @LName = LName, @FName = FName 
        FROM Person
        WHERE ID_Card_Num = @ID_Card_Num;

        -- Tạo Username
        DECLARE @Username NVARCHAR(100);
        SET @Username = REPLACE(@LName, ' ', '') + @FName + RIGHT(@ID_Card_Num, 3);

        -- Kiểm tra trùng lặp Username
        IF EXISTS (
            SELECT 1
            FROM ACCOUNT
            WHERE Username = @Username
        )
        BEGIN
            THROW 50002, 'Username đã tồn tại.', 1;
        END;

        -- Tạo Password mặc định giống Username
        DECLARE @Password NVARCHAR(255);
        SET @Password = @Username;

        -- Thêm tài khoản vào bảng ACCOUNT
        INSERT INTO ACCOUNT (ID_Card_Num, Username, Password, Role)
        VALUES (@ID_Card_Num, @Username, @Password, @Role);

        -- Trả về Username và Role
        SELECT Username, Role FROM ACCOUNT WHERE Username = @Username;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;



-- UPDATE ACCOUNT
GO
CREATE OR ALTER PROCEDURE UpdateAccount
    @Username VARCHAR(100),
    @NewPassword VARCHAR(255)
AS
BEGIN
    UPDATE ACCOUNT
    SET [Password] = @NewPassword
    WHERE Username = @Username;
END
GO

-- GET ACCOUNT
CREATE PROCEDURE GetAllAccounts
AS
BEGIN
    SELECT * FROM ACCOUNT;
END
GO

CREATE PROCEDURE GetAccountById
    @AccountID INT
AS
BEGIN
    SELECT * FROM ACCOUNT WHERE Account_ID = @AccountID;
END
GO

CREATE PROCEDURE GetAccountByUsername
    @Username VARCHAR(100)
AS
BEGIN
    SELECT * FROM ACCOUNT WHERE Username = @Username;
END
GO


GO 

-- CHECK IN AND UPDATE SALARY
-- DROP PROCEDURE CheckInAndUpdateSalary
GO
CREATE PROCEDURE CheckInAndUpdateSalary
    @Shift_ID INT,
    @ID_Card_Num CHAR(12)
AS
BEGIN
    -- Cập nhật trường Check trong bảng WORK_ON thành 1 (chấm công)
    UPDATE WORK_ON
    SET [Check] = 1
    WHERE Shift_ID = @Shift_ID AND ID_Card_Num = @ID_Card_Num;

    -- Tính toán lương cho tháng của shift đó và cộng vào bảng SALARY
    DECLARE @Month INT;
    DECLARE @Year INT;
    DECLARE @Wage INT;
    DECLARE @Rate DECIMAL(5, 2);

    -- Lấy thông tin tháng và năm từ shift
    SELECT @Month = MONTH([Date]), @Year = YEAR([Date])
    FROM SHIFT
    WHERE Shift_ID = @Shift_ID;

    -- Lấy thông tin Wage và Rate từ bảng Employee và Shift
    SELECT @Wage = Wage, @Rate = Rate
    FROM EMPLOYEE E, WORK_ON W, SHIFT S
    WHERE E.ID_Card_Num = W.ID_Card_Num AND W.Shift_ID = S.Shift_ID AND E.ID_Card_Num = @ID_Card_Num AND S.Shift_ID = @Shift_ID;

    -- Cập nhật lương của nhân viên trong tháng và năm tương ứng
    IF EXISTS (SELECT 1 FROM SALARY WHERE ID_Card_Num = @ID_Card_Num AND [Month] = @Month AND [Year] = @Year)
    BEGIN
        -- Nếu đã có lương cho tháng này, cộng thêm lương vào Amount
        UPDATE SALARY
        SET Amount = Amount + (@Wage * @Rate)
        WHERE ID_Card_Num = @ID_Card_Num AND [Month] = @Month AND [Year] = @Year;
    END
    ELSE
    BEGIN
        -- Nếu chưa có lương cho tháng này, tạo mới bản ghi lương
        INSERT INTO SALARY (ID_Card_Num, [Month], [Year], Amount)
        VALUES (@ID_Card_Num, @Month, @Year, @Wage * @Rate);
    END
END;

-- ĐĂNG KÝ CA
GO
CREATE PROCEDURE RegisterShift
    @Shift_ID INT,
    @ID_Card_Num CHAR(12)
AS
BEGIN
    -- Bắt đầu giao dịch
    BEGIN TRANSACTION;

    -- Tạo một ứng dụng lock để tránh việc tranh chấp dữ liệu
    DECLARE @LockResult INT;
    DECLARE @Resource NVARCHAR(255);

    -- Tạo giá trị cho @Resource
    SET @Resource = 'ShiftLock_' + CAST(@Shift_ID AS VARCHAR(10));

    EXEC @LockResult = sp_getapplock 
        @Resource,
        @LockMode = 'Exclusive', 
        @LockOwner = 'Transaction', 
        @LockTimeout = 10000;

    -- Kiểm tra kết quả lock
    IF @LockResult < 0
    BEGIN
        PRINT 'Không thể lấy khóa, vui lòng thử lại.';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Kiểm tra số lượng nhân viên đã đăng ký trong ca hiện tại
    DECLARE @EmployeeCount INT;
    DECLARE @MaxCount INT;

    SELECT @EmployeeCount = COUNT(*) 
    FROM WORK_ON 
    WHERE Shift_ID = @Shift_ID;

    SELECT @MaxCount 
    FROM SHIFT
    WHERE Shift_ID = @Shift_ID

    -- Giả sử ca làm việc có số lượng tối đa là 2 (thay đổi theo ENUM của bạn)
    IF @EmployeeCount >= @MaxCount
    BEGIN
        PRINT 'This shift is full. Cannot register!';
        ROLLBACK TRANSACTION;
        EXEC sp_releaseapplock @Resource;
        RETURN;
    END

    -- Thêm nhân viên vào ca làm việc
    INSERT INTO WORK_ON (Shift_ID, ID_Card_Num)
    VALUES (@Shift_ID, @ID_Card_Num);

    -- Giải phóng lock
    EXEC sp_releaseapplock @Resource;

    -- Kết thúc giao dịch
    COMMIT TRANSACTION;
END;

SELECT * FROM SHIFT
-- XÓA NHÂN VIÊN KHỎI CA
GO
CREATE OR ALTER PROCEDURE dbo.RemoveEmployeeFromShift
    @Shift_ID INT,
    @ID_Card_Num CHAR(12)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra Shift_ID có tồn tại trong bảng Shift không
        IF NOT EXISTS (
            SELECT 1 
            FROM Shift
            WHERE Shift_ID = @Shift_ID
        )
        BEGIN
            THROW 50001, 'Shift_ID không tồn tại.', 1;
        END;

        -- Kiểm tra ID_Card_Num có tồn tại trong bảng EMPLOYEE không
        IF NOT EXISTS (
            SELECT 1 
            FROM EMPLOYEE
            WHERE ID_Card_Num = @ID_Card_Num
        )
        BEGIN
            THROW 50002, 'ID_Card_Num không tồn tại.', 1;
        END;

        -- Kiểm tra nhân viên có đang làm trong ca đó không
        IF NOT EXISTS (
            SELECT 1 
            FROM WORK_ON
            WHERE Shift_ID = @Shift_ID AND ID_Card_Num = @ID_Card_Num
        )
        BEGIN
            THROW 50003, 'Nhân viên không làm việc trong ca này.', 1;
        END;

        -- Xóa nhân viên khỏi ca làm việc
        DELETE FROM WORK_ON
        WHERE Shift_ID = @Shift_ID AND ID_Card_Num = @ID_Card_Num;

        -- Xác nhận giao dịch
        COMMIT TRANSACTION;

        PRINT 'Nhân viên đã được xóa khỏi ca làm việc thành công.';
    END TRY
    BEGIN CATCH
        -- Hủy giao dịch nếu có lỗi
        ROLLBACK TRANSACTION;

        -- Trả về lỗi chi tiết
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(), 
            @ErrorSeverity = ERROR_SEVERITY(), 
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO


-- TÍNH TỔNG LƯƠNG VÀ TẠO PHIẾU CHI
-- DROP PROCEDURE dbo.InsertTotalSalaryReceipt
GO

CREATE PROCEDURE InsertTotalSalaryReceipt
    @Month INT,
    @Year INT
AS
BEGIN
    DECLARE @TotalSalary INT;
    DECLARE @ExpenseName NVARCHAR(40) = CONCAT('Total Salary for ', @Month, '/', @Year);

    -- Kiểm tra dữ liệu đã tồn tại chưa
    IF NOT EXISTS (
        SELECT 1
        FROM EXPENSE_RECEIPT
        WHERE Expense_Type_ID = 3 -- Loại chi phí là lương
          AND FORMAT([Date], 'MM/yyyy') = FORMAT(DATEFROMPARTS(@Year, @Month, 1), 'MM/yyyy')
    )
    BEGIN
        -- Tính tổng lương trực tiếp từ bảng SALARY
        SELECT @TotalSalary = SUM(Amount)
        FROM SALARY
        WHERE [Month] = @Month AND [Year] = @Year;

        -- Chèn dữ liệu nếu tổng lương > 0
        IF @TotalSalary > 0
        BEGIN
            INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID)
            VALUES (@ExpenseName, GETDATE(), @TotalSalary, 'All Employees', 3);

            PRINT 'Expense receipt created successfully.';
        END
        ELSE
        BEGIN
            PRINT 'No salaries found for the specified month and year.';
        END;
    END
    ELSE
    BEGIN
        PRINT 'An expense receipt for this month and year already exists.';
    END;
END;

-- Sắp xếp nhân viên vào ca

GO
CREATE PROCEDURE AssignShiftsForNextWeek
AS
BEGIN
    SET NOCOUNT ON;

    -- Xác định ngày bắt đầu và kết thúc của tuần tiếp theo
    DECLARE @StartOfNextWeek DATE, @EndOfNextWeek DATE;
    SET @StartOfNextWeek = DATEADD(DAY, 8 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)); -- Ngày đầu tuần tiếp theo
    SET @EndOfNextWeek = DATEADD(DAY, 14 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE));  -- Ngày cuối tuần tiếp theo

    -- 1. Tìm các ca thiếu người trong tuần tiếp theo
    DECLARE @InsufficientShifts TABLE (Shift_ID INT, E_Num INT, Current_Employee_Count INT);
    INSERT INTO @InsufficientShifts
    SELECT 
        S.Shift_ID,
        S.E_Num,
        COUNT(WO.ID_Card_Num) AS Current_Employee_Count
    FROM SHIFT S
    LEFT JOIN WORK_ON WO ON S.Shift_ID = WO.Shift_ID
    WHERE S.[Date] BETWEEN @StartOfNextWeek AND @EndOfNextWeek
    GROUP BY S.Shift_ID, S.E_Num
    HAVING COUNT(WO.ID_Card_Num) < S.E_Num;

    -- 2. Tìm các nhân viên chưa đủ số ca đăng ký trong tuần tiếp theo
    DECLARE @EmployeesWithInsufficientShifts TABLE (ID_Card_Num CHAR(12), Shifts_Worked INT);
    INSERT INTO @EmployeesWithInsufficientShifts
    SELECT 
    E.ID_Card_Num,
    ISNULL(COUNT(WO.Shift_ID), 0) AS Shifts_Worked
    FROM EMPLOYEE E
    LEFT JOIN WORK_ON WO ON E.ID_Card_Num = WO.ID_Card_Num
    LEFT JOIN SHIFT S ON WO.Shift_ID = S.Shift_ID AND S.[Date] BETWEEN @StartOfNextWeek AND @EndOfNextWeek
    GROUP BY E.ID_Card_Num
    HAVING ISNULL(COUNT(WO.Shift_ID), 0) < 5;  -- Yêu cầu tối thiểu 5 ca/tuần

    -- 3. Phân bổ nhân viên vào các ca thiếu
    DECLARE @RowNum INT = 1;
    DECLARE @ShiftID INT;
    DECLARE @ID_Card_Num CHAR(12);
    DECLARE @MaxPeople INT;
    DECLARE @CurrentPeople INT;

    -- Lặp qua danh sách nhân viên chưa đủ số ca
    DECLARE @EmployeeCursor CURSOR;
    SET @EmployeeCursor = CURSOR FOR
    SELECT ID_Card_Num FROM @EmployeesWithInsufficientShifts;

    OPEN @EmployeeCursor;
    FETCH NEXT FROM @EmployeeCursor INTO @ID_Card_Num;

    -- Lặp qua các nhân viên chưa đủ số ca
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tìm ca thiếu người tiếp theo mà nhân viên có thể được phân bổ vào
        DECLARE @Assigned INT = 0;
        DECLARE @ShiftCursor CURSOR;
        SET @ShiftCursor = CURSOR FOR
        SELECT Shift_ID
        FROM @InsufficientShifts
        WHERE Current_Employee_Count < E_Num
        ORDER BY Shift_ID;

        OPEN @ShiftCursor;
        FETCH NEXT FROM @ShiftCursor INTO @ShiftID;

        -- Lặp qua các ca thiếu và phân bổ nhân viên
        WHILE @@FETCH_STATUS = 0 AND @Assigned = 0
        BEGIN
            -- Kiểm tra nếu ca có đủ người
            SELECT @MaxPeople = E_Num
            FROM SHIFT
            WHERE Shift_ID = @ShiftID;

            SELECT @CurrentPeople = COUNT(*)
            FROM WORK_ON
            WHERE Shift_ID = @ShiftID;

            IF @CurrentPeople < @MaxPeople
            BEGIN
                -- Kiểm tra nếu nhân viên chưa được phân bổ vào ca này
                IF NOT EXISTS (SELECT 1 FROM WORK_ON WHERE Shift_ID = @ShiftID AND ID_Card_Num = @ID_Card_Num)
                BEGIN
                    -- Chèn nhân viên vào ca
                    INSERT INTO WORK_ON (Shift_ID, ID_Card_Num)
                    VALUES (@ShiftID, @ID_Card_Num);

                    -- Cập nhật số ca đã phân bổ cho nhân viên
                    UPDATE @EmployeesWithInsufficientShifts
                    SET Shifts_Worked = Shifts_Worked + 1
                    WHERE ID_Card_Num = @ID_Card_Num;

                    SET @Assigned = 1; -- Đã phân bổ xong
                END
            END

            FETCH NEXT FROM @ShiftCursor INTO @ShiftID;
        END

        CLOSE @ShiftCursor;
        DEALLOCATE @ShiftCursor;

        -- Tiến đến nhân viên tiếp theo
        FETCH NEXT FROM @EmployeeCursor INTO @ID_Card_Num;
    END

    CLOSE @EmployeeCursor;
    DEALLOCATE @EmployeeCursor;

END;

GO
CREATE PROCEDURE ViewEmployeeShifts
    @ID_Card_Num CHAR(12)
AS
BEGIN
    SELECT 
        S.Shift_ID,
        S.Shift_Type,
        S.[Date],
        S.Rate,
        WO.[Check] AS IsCheckedIn,
        CASE 
            WHEN WO.[Check] = 1 THEN 'Checked In'
            ELSE 'Registered Only'
        END AS Status
    FROM WORK_ON WO
    JOIN SHIFT S ON WO.Shift_ID = S.Shift_ID
    WHERE WO.ID_Card_Num = @ID_Card_Num
    ORDER BY S.[Date], S.Shift_ID;
END;

-- EXEC ViewEmployeeShifts @ID_Card_Num = '079144005846'
SELECT * FROM WORK_ON

GO
CREATE PROCEDURE ViewEmployeeSalary
    @ID_Card_Num CHAR(12),
    @Month INT = NULL,
    @Year INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.ID_Card_Num,
        e.Employee_ID,
        e.Position,
        s.[Month],
        s.[Year],
        s.Amount
    FROM SALARY s
    JOIN EMPLOYEE e ON s.ID_Card_Num = e.ID_Card_Num
    WHERE s.ID_Card_Num = @ID_Card_Num
        AND (@Month IS NULL OR s.[Month] = @Month)
        AND (@Year IS NULL OR s.[Year] = @Year)
    ORDER BY s.[Year] DESC, s.[Month] DESC;
END;


-- TẠO BÁO CÁO LÃI LỖ THEO NGÀY
-- DROP PROCEDURE CreateDailyProfitAndLossReport
GO
CREATE PROCEDURE CreateDailyProfitAndLossReport
    @Day INT,
    @Month INT,
    @Year INT
AS
BEGIN
    DECLARE @Expense INT;
    DECLARE @Revenue INT;
    DECLARE @Gross_Profit INT;
    DECLARE @Profit_And_Loss_ID INT;

    -- Tính tổng chi phí từ EXPENSE_RECEIPT
    SELECT @Expense = SUM(Amount)
    FROM EXPENSE_RECEIPT
    WHERE DAY([Date]) = @Day AND MONTH([Date]) = @Month AND YEAR([Date]) = @Year;

    IF @Expense IS NULL 
    BEGIN
    SET @Expense = 0
    END

    -- Tính tổng doanh thu từ INCOME_RECEIPT
    SELECT @Revenue = SUM(Amount)
    FROM INCOME_RECEIPT
    WHERE DAY([Date]) = @Day AND MONTH([Date]) = @Month AND YEAR([Date]) = @Year;

    IF @Revenue IS NULL 
    BEGIN
    SET @Revenue = 0
    END
    -- Tính lãi gộp (Gross Profit)
    SET @Gross_Profit = @Revenue - @Expense;

    -- Tạo báo cáo lãi lỗ cho ngày
    INSERT INTO PROFIT_AND_LOSS_STATEMENT (Report_Type, Expense, Revenue, Gross_Profit, [Day], [Month], [Year])
    VALUES ('Day', @Expense, @Revenue, @Gross_Profit, @Day, @Month, @Year);

    -- Lấy ID báo cáo vừa tạo
    SET @Profit_And_Loss_ID = SCOPE_IDENTITY();

    -- Thêm mối quan hệ với chi phí (EXPENSE)
    INSERT INTO MANAGE_EXPENSE (Expense_ID, Profit_And_Loss_ID)
    SELECT Expense_ID, @Profit_And_Loss_ID
    FROM EXPENSE_RECEIPT
    WHERE DAY([Date]) = @Day AND MONTH([Date]) = @Month AND YEAR([Date]) = @Year;

    -- Thêm mối quan hệ với doanh thu (INCOME)
    INSERT INTO MANAGE_INCOME (Income_ID, Profit_And_Loss_ID)
    SELECT Income_ID, @Profit_And_Loss_ID
    FROM INCOME_RECEIPT
    WHERE DAY([Date]) = @Day AND MONTH([Date]) = @Month AND YEAR([Date]) = @Year;

    PRINT 'Daily Profit and Loss report created successfully with related expenses and incomes.';
END;

-- TÍNH BÁO CÁO LÃI LỖ THEO THÁNG
GO
CREATE PROCEDURE CreateMonthlyProfitAndLossReport
    @Month INT,
    @Year INT
AS
BEGIN
    DECLARE @Expense INT;
    DECLARE @Revenue INT;
    DECLARE @Gross_Profit INT;
    DECLARE @Profit_And_Loss_ID INT;

    -- Tính tổng chi phí từ các báo cáo ngày trong tháng
    SELECT @Expense = SUM(Expense)
    FROM PROFIT_AND_LOSS_STATEMENT
    WHERE [Month] = @Month AND [Year] = @Year AND Report_Type = 'Day';

    IF @Expense IS NULL 
    BEGIN
        SET @Expense = 0;
    END

    -- Tính tổng doanh thu từ các báo cáo ngày trong tháng
    SELECT @Revenue = SUM(Revenue)
    FROM PROFIT_AND_LOSS_STATEMENT
    WHERE [Month] = @Month AND [Year] = @Year AND Report_Type = 'Day';

    IF @Revenue IS NULL 
    BEGIN
        SET @Revenue = 0;
    END

    -- Tính lãi gộp
    SET @Gross_Profit = @Revenue - @Expense;

    -- Tạo báo cáo lãi lỗ cho tháng
    INSERT INTO PROFIT_AND_LOSS_STATEMENT (Report_Type, Expense, Revenue, Gross_Profit, [Month], [Year])
    VALUES ('Month', @Expense, @Revenue, @Gross_Profit, @Month, @Year);

    PRINT 'Monthly Profit and Loss report created successfully with related expenses and incomes.';
END;

-- TÍNH BÁO CÁO LÃI LỖ THEO NĂM
GO
CREATE PROCEDURE CreateYearlyProfitAndLossReport
    @Year INT
AS
BEGIN
    DECLARE @Expense INT;
    DECLARE @Revenue INT;
    DECLARE @Gross_Profit INT;
    DECLARE @Profit_And_Loss_ID INT;

    -- Tính tổng chi phí từ các báo cáo tháng trong năm
    SELECT @Expense = SUM(Expense)
    FROM PROFIT_AND_LOSS_STATEMENT
    WHERE [Year] = @Year AND Report_Type = 'Month';

    IF @Expense IS NULL 
    BEGIN
        SET @Expense = 0;
    END

    -- Tính tổng doanh thu từ các báo cáo tháng trong năm
    SELECT @Revenue = SUM(Revenue)
    FROM PROFIT_AND_LOSS_STATEMENT
    WHERE [Year] = @Year AND Report_Type = 'Month';

    IF @Revenue IS NULL 
    BEGIN
        SET @Revenue = 0;
    END

    -- Tính lãi gộp
    SET @Gross_Profit = @Revenue - @Expense;

    -- Tạo báo cáo lãi lỗ cho năm
    INSERT INTO PROFIT_AND_LOSS_STATEMENT (Report_Type, Expense, Revenue, Gross_Profit, [Year])
    VALUES ('Year', @Expense, @Revenue, @Gross_Profit, @Year);

    PRINT 'Yearly Profit and Loss report created successfully with related expenses and incomes.';
END;

-- HÀM TẠO EMPLOYEE
GO
CREATE PROCEDURE CreateEmployee
    @ID_Card_Num CHAR(12),
    @Fname NVARCHAR(20),
    @Lname NVARCHAR(40),
    @DOB DATE,
    @Sex BIT,
    @Position VARCHAR(30),
    @Wage INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Kiểm tra xem PERSON đã tồn tại chưa
        IF NOT EXISTS (SELECT 1 FROM PERSON WHERE ID_Card_Num = @ID_Card_Num)
        BEGIN
            -- Thêm người vào bảng PERSON
            INSERT INTO PERSON (ID_Card_Num, Fname, Lname, DOB, Sex)
            VALUES (@ID_Card_Num, @Fname, @Lname, @DOB, @Sex);
            
            -- Kiểm tra nếu EMPLOYEE đã tồn tại
            IF EXISTS (SELECT 1 FROM EMPLOYEE WHERE ID_Card_Num = @ID_Card_Num)
            BEGIN
                -- Ném lỗi khi nhân viên đã tồn tại
                RAISERROR ('Employee already exists for this ID Card Number.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;  -- Thoát thủ tục sau khi ném lỗi
            END

            -- Thêm nhân viên vào bảng EMPLOYEE
            INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
            VALUES (@ID_Card_Num, @Position, @Wage);
            COMMIT TRANSACTION;
            PRINT 'Employee created successfully.';
        END
        ELSE
        BEGIN
            -- Ném lỗi khi người đã tồn tại
            RAISERROR ('Person already exists for this ID Card Number.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Ghi lại lỗi nếu có và rollback transaction
        ROLLBACK TRANSACTION;
        -- Ném lại lỗi để Node.js có thể bắt
        THROW;  -- THROW sẽ ném lỗi từ SQL ra ngoài
    END CATCH;
END;
GO

-- EXEC CreateEmployee 
--     @ID_Card_Num = '079305009315',
--     @Fname = 'Nguyen Van Minh',
--     @Lname = 'Thanh',
--     @DOB = '1999-01-27',
--     @Sex = 0,
--     @Position = 'Senior',
--     @Wage = 60000;


-- HÀM CHỈNH THÔNG TIN EMPLOYEE

GO
CREATE PROCEDURE UpdateEmployeeInfo
    @ID_Card_Num CHAR(12),
    @New_Position VARCHAR(30) = NULL,
    @New_Wage INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra nếu nhân viên tồn tại
        IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE ID_Card_Num = @ID_Card_Num)
        BEGIN
            RAISERROR ('Employee not found for the given ID Card Number.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Cập nhật thông tin nhân viên
        UPDATE EMPLOYEE
        SET 
            Position = ISNULL(@New_Position, Position),  -- Giữ nguyên nếu không truyền giá trị mới
            Wage = ISNULL(@New_Wage, Wage)
        WHERE ID_Card_Num = @ID_Card_Num;

        COMMIT TRANSACTION;
        PRINT 'Employee information updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

-- EXEC UpdateEmployeeInfo @ID_Card_Num = '071201876543', @New_Position = 'Senior', @New_Wage = 32000;

-- Procedure: Lấy danh sách tất cả Employees
CREATE PROCEDURE dbo.GetAllEmployees
AS
BEGIN
    SELECT 
        e.ID_Card_Num,
        e.Employee_ID,
        e.Position,
        e.Wage,
        p.Fname,
        p.Lname,
        p.DOB,
        p.Sex
    FROM 
        EMPLOYEE e
    INNER JOIN 
        PERSON p ON e.ID_Card_Num = p.ID_Card_Num;
END;
GO

-- exec dbo.GetAllEmployees

-- Procedure: Lấy thông tin Employee theo ID
GO
CREATE PROCEDURE dbo.GetEmployeeById
    @id CHAR(12)
AS
BEGIN
    SELECT 
        e.ID_Card_Num,
        e.Employee_ID,
        e.Position,
        e.Wage,
        p.Fname,
        p.Lname,
        p.DOB,
        p.Sex
    FROM 
        EMPLOYEE e
    INNER JOIN 
        PERSON p ON e.ID_Card_Num = p.ID_Card_Num
    WHERE 
        e.ID_Card_Num = @id; 
END;
GO

-- TẠO SHIFT
GO
CREATE PROCEDURE CreateShift
    @Shift_Type CHAR(1),
    @Date DATE,
    @E_Num INT,
    @Rate DECIMAL(5, 2) = 1.00 -- Mặc định Rate là 1.00
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra xem đã có shift với loại ca và ngày này chưa
        IF EXISTS (SELECT 1 FROM SHIFT WHERE Shift_Type = @Shift_Type AND [Date] = @Date)
        BEGIN
            -- Nếu đã có shift, ném lỗi
            RAISERROR ('A shift already exists for this type and date.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Thêm dữ liệu vào bảng SHIFT
        INSERT INTO SHIFT (Shift_Type, [Date], E_Num, Rate)
        VALUES (@Shift_Type, @Date, @E_Num, @Rate);

        -- Lấy thông tin của shift vừa tạo và trả về nó
        SELECT 
            Shift_ID,
            Shift_Type,
            [Date],
            E_Num,
            Rate
        FROM SHIFT
        WHERE Shift_ID = SCOPE_IDENTITY();  -- SCOPE_IDENTITY() trả về ID của bản ghi vừa thêm

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Ném lỗi ra ngoài nếu có lỗi
        THROW;
    END CATCH
END;
GO



CREATE OR ALTER PROCEDURE  dbo.DeleteShift
    @Shift_ID INT
AS
BEGIN
    DELETE FROM SHIFT 
    WHERE Shift_ID = @Shift_ID; 
END;
GO
EXEC dbo.DeleteShift 32;
SELECT * FROM SHIFT;
GO



CREATE OR ALTER PROCEDURE  dbo.UpdateShift
    @Shift_ID INT,
    @Shift_Type CHAR(1),
    @Date DATE,
    @E_Num INT,
    @Rate DECIMAL(5, 2)
AS
BEGIN
    UPDATE SHIFT 
    SET
        Shift_Type = @Shift_Type,
        [Date] = @Date,
        E_Num = @E_Num,
        Rate = @Rate
    WHERE Shift_ID = @Shift_ID; 
END;
GO
EXEC dbo.UpdateShift 31, 2, '2024-12-03', 123, 789;
SELECT * FROM SHIFT;
GO

-- GET ALL SHIFT
GO
CREATE PROCEDURE GetAllShifts
AS
BEGIN
    SELECT * FROM SHIFT;
END;
GO

-- GET SHIFT BY ID
CREATE PROCEDURE GetShiftById
    @Shift_ID INT
AS
BEGIN
    SELECT 
        Shift_ID,
        Shift_Type,
        [Date],
        E_Num,
        Rate
    FROM SHIFT
    WHERE Shift_ID = @Shift_ID;
END;


-- GET EMPLOYEES OF A SHIFT
GO
CREATE OR ALTER PROCEDURE GetEmployeesOfShift
    @Shift_ID INT
AS
BEGIN
    SELECT 
        E.ID_Card_Num,
        E.Employee_ID,
        E.Position,
        E.Wage,
        P.Fname,
        P.Lname
    FROM WORK_ON W
    INNER JOIN EMPLOYEE E ON W.ID_Card_Num = E.ID_Card_Num
    INNER JOIN PERSON P ON E.ID_Card_Num = P.ID_Card_Num
    WHERE W.Shift_ID = @Shift_ID;
END;

-- UPDATE CA
GO
CREATE OR ALTER PROCEDURE UpdateShiftInfo
    @Shift_ID INT,                -- ID của ca cần cập nhật
    @New_E_Num INT = NULL,         -- Số nhân viên mới, có thể null nếu không thay đổi
    @New_Rate DECIMAL(5, 2) = NULL  -- Tỷ lệ mới, có thể null nếu không thay đổi
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra xem ca làm việc có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM SHIFT WHERE Shift_ID = @Shift_ID)
        BEGIN
            RAISERROR ('Shift not found for the given ID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Cập nhật thông tin của ca làm việc
        UPDATE SHIFT
        SET 
            E_Num = ISNULL(@New_E_Num, E_Num),  -- Giữ nguyên nếu không có giá trị mới
            Rate = ISNULL(@New_Rate, Rate)
        WHERE Shift_ID = @Shift_ID;

        COMMIT TRANSACTION;
        PRINT 'Shift information updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO

-- 

----------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE  dbo.AddSupplier
    @SUPPLIER_NAME VARCHAR(30),
    @SUPPLIER_EMAIL VARCHAR(30),
    @SUPPLIER_PHONE VARCHAR(20),
    @ADDRESS VARCHAR(100)
AS
BEGIN
    INSERT INTO SUPPLIER(SUPPLIER_NAME, SUPPLIER_EMAIL, SUPPLIER_PHONE, [ADDRESS])
    VALUES(@SUPPLIER_EMAIL, @SUPPLIER_EMAIL, @SUPPLIER_PHONE, @ADDRESS)
END;
GO


CREATE OR ALTER PROCEDURE  dbo.DeleteSupplier
    @SUPPLIER_ID INT
AS
BEGIN
    DELETE FROM SUPPLIER 
    WHERE SUPPLIER_ID = @SUPPLIER_ID; 
END;
GO
EXEC dbo.DeleteSupplier 1;
SELECT * FROM SUPPLIER;
GO



CREATE OR ALTER PROCEDURE  dbo.UpdateSupplier
    @SUPPLIER_ID INT,
    @SUPPLIER_NAME VARCHAR(30),
    @SUPPLIER_EMAIL VARCHAR(30),
    @SUPPLIER_PHONE VARCHAR(20),
    @ADDRESS VARCHAR(100)
AS
BEGIN
    UPDATE SUPPLIER 
    SET
        SUPPLIER_NAME = @SUPPLIER_NAME,
        SUPPLIER_EMAIL = @SUPPLIER_EMAIL,
        SUPPLIER_PHONE = @SUPPLIER_PHONE,
        [ADDRESS] = @ADDRESS
    WHERE SUPPLIER_ID = @SUPPLIER_ID; 
END;
GO
EXEC dbo.UpdateSupplier 3, 'Coolmate', 'support@coolmate.me', '0822314976', '100 Cach Mang Thang 8, District 3, Ho Chi Minh City';
SELECT * FROM SUPPLIER;
GO



CREATE OR ALTER PROCEDURE  dbo.GetSupplierById
    @SUPPLIER_ID INT
AS
BEGIN
    SELECT * FROM SUPPLIER
    WHERE SUPPLIER_ID = @SUPPLIER_ID; 
END;
GO
EXEC dbo.GetSupplierById 2;
GO

CREATE OR ALTER PROCEDURE  dbo.GetAllSuppliers
AS
BEGIN
    SELECT * FROM SUPPLIER; 
END;
GO
EXEC dbo.GetAllSuppliers;
GO


----- Stored Procedure cho Item
GO
CREATE PROCEDURE AddItem
    @SellingPrice DECIMAL(10, 2),
    @Size VARCHAR(10),
    @Color VARCHAR(10),
    @ProductID INT
AS
BEGIN
    -- chỉ đc thêm Item nếu Product có tồn tại
    IF EXISTS ( 
        SELECT 1
        FROM PRODUCT
        WHERE PRODUCT_ID = @ProductID
    )
    BEGIN
        -- Nếu tồn tại, thực hiện thêm ITEM vào bảng ITEM
        INSERT INTO ITEM (SELLING_PRICE, SIZE, COLOR, STOCK, PRODUCT_ID)
        VALUES (@SellingPrice, @Size, @Color, 0, @ProductID);
    END
    ELSE
    BEGIN
        -- Nếu ProductID không tồn tại, trả về thông báo lỗi
         RAISERROR ('Product không tồn tại.', 16, 1);
    END
END;

-- Cập nhật Item
GO
CREATE PROCEDURE UpdateItem
    @ItemId INT,
    @SellingPrice DECIMAL(10, 2),
    @Size VARCHAR(10),
    @Color VARCHAR(10),
    @Stock INT,
    @ProductId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra xem Item có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM ITEM WHERE ITEM_ID = @ItemId)
        BEGIN
            RAISERROR('Item not found with the provided ID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Kiểm tra xem Product có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE PRODUCT_ID = @ProductId)
        BEGIN
            RAISERROR('Product not found with the provided ID.', 16, 2);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Cập nhật Item
        UPDATE ITEM
        SET 
            SELLING_PRICE = @SellingPrice,
            SIZE = @Size,
            COLOR = @Color,
            STOCK = @Stock,
            PRODUCT_ID = @ProductId
        WHERE ITEM_ID = @ItemId;

        -- Hoàn tất giao dịch
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction nếu xảy ra lỗi
        ROLLBACK TRANSACTION;

        -- Báo lỗi chi tiết từ CATCH block
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;


GO
CREATE PROCEDURE dbo.GetAllItems
AS
BEGIN
    SELECT * FROM ITEM;
END;

GO
CREATE PROCEDURE dbo.GetItemById
    @ItemId INT
AS
BEGIN
    SELECT * FROM ITEM
    WHERE ITEM_ID = @ItemId;
END;

GO
CREATE PROCEDURE ImportItemDetails
    @ItemID INT, 
    @SupplierID INT, 
    @ImportQuantity INT, 
    @ImportPrice DECIMAL(10, 2),
    @TotalFee DECIMAL(10, 2) 
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm bản ghi vào IMPORT_BILL
        DECLARE @NewImportID INT;
        DECLARE @SupllierName VARCHAR(30);
        DECLARE @ExpectedFee DECIMAL(10, 2);
        DECLARE @ExpenseTypeID INT;
        DECLARE @ImportName VARCHAR(40); -- Khai báo biến
        SET @ImportName = CONCAT('Import Item: ', @ItemID);
        DECLARE @PayeeName VARCHAR(40);

        SET @ExpectedFee = @ImportQuantity * @ImportPrice;

        -- Kiểm tra tổng phí
        IF @TotalFee <= @ExpectedFee
        BEGIN
            RAISERROR('Tổng phí phải lớn hơn tổng tiền nhập hàng.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        SELECT @ExpenseTypeID = Expense_Type_ID
        FROM EXPENSE_TYPE
        WHERE [Name] = 'Inventory Purchase';

        INSERT INTO IMPORT_BILL (IMPORT_STATE, TOTAL_FEE)
        VALUES ('Pending', @TotalFee);

        -- Lấy ID của Import vừa thêm
        SET @NewImportID = SCOPE_IDENTITY();

        -- Kiểm tra ItemID và SupplierID có tồn tại hay không
        IF NOT EXISTS (SELECT 1 FROM ITEM WHERE ITEM_ID = @ItemID)
        BEGIN
            RAISERROR('Item không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM SUPPLIER WHERE SUPPLIER_ID = @SupplierID)
        BEGIN
            RAISERROR('Supplier không tồn tại.', 16, 2);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        SELECT @SupllierName = SUPPLIER_NAME
        FROM SUPPLIER 
        WHERE SUPPLIER_ID = @SupplierID;

        SET @PayeeName = CONCAT('Supplier: ', @SupllierName);

        -- Thêm bản ghi vào bảng IMPORT (chi tiết nhập hàng)
        INSERT INTO IMPORT (IMPORT_ID, ITEM_ID, SUPPLIER_ID, IMPORT_QUANTITY, IMPORT_PRICE)
        VALUES (@NewImportID, @ItemID, @SupplierID, @ImportQuantity, @ImportPrice);

        -- -- Cập nhật Stock trong bảng ITEM
        -- UPDATE ITEM
        -- SET STOCK = STOCK + @ImportQuantity
        -- WHERE ITEM_ID = @ItemID;

        -- Thêm bản ghi vào bảng EXPENSE_RECEIPT
        INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID)
        VALUES 
        (@ImportName, GETDATE(), @TotalFee, @PayeeName, @ExpenseTypeID);

        -- Hoàn tất transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi, rollback transaction
        ROLLBACK TRANSACTION;

        -- Hiển thị lỗi chi tiết
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO

GO


-- Cập nhật trạng thái của Import
GO
CREATE PROCEDURE UpdateImportBillState
    @ImportID INT,
    @NewState VARCHAR(30)
AS
BEGIN
    BEGIN TRY
        -- Cập nhật trạng thái
        UPDATE IMPORT_BILL
        SET IMPORT_STATE = @NewState
        WHERE IMPORT_ID = @ImportID;

        -- Kiểm tra nếu không tồn tại ImportID
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('ImportID không tồn tại.', 16, 1);
        END;
    END TRY
    BEGIN CATCH
        -- Hiển thị lỗi chi tiết
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO



GO
CREATE PROCEDURE GetAllImportBills
AS
BEGIN
    SELECT * FROM IMPORT_BILL;
END;

GO
CREATE PROCEDURE GetImportBillById
    @ImportID INT
AS
BEGIN
    SELECT * 
    FROM IMPORT_BILL
    WHERE IMPORT_ID = @ImportID;
END;


-- ---Cập nhật Stock của Item sau khi nhập kho
-- --Câu lệnh để gọi Procedure : EXEC UpdateStockOnImport @Import_ID = 1;
GO
CREATE PROCEDURE UpdateStockOnImport
    @Import_ID INT
AS
BEGIN
    -- Cập nhật Stock dựa trên Import
    UPDATE ITEM
    SET STOCK = STOCK + i.IMPORT_QUANTITY
    FROM ITEM it
    INNER JOIN IMPORT i ON it.ITEM_ID = i.ITEM_ID
    WHERE i.IMPORT_ID = @Import_ID;

    PRINT 'Cập nhật Stock sau khi nhập kho';
END;


--Proceduce trả nhập hàng
GO
CREATE PROCEDURE AddReturnBill
    @Reason TEXT,
    @RefundFee DECIMAL(10, 2),
    @ItemID INT,
    @SupplierID INT,
    @ReturnQuantity INT,
    @ReturnPrice DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Thêm bản ghi vào RETURN_BILL
        DECLARE @NewReturnID INT;
        DECLARE @SupplierName VARCHAR(30);
        DECLARE @IncomeTypeID INT;
        DECLARE @IncomeName VARCHAR(40);
        DECLARE @PayerName VARCHAR(40);
        
        -- Lấy tên Supplier
        SELECT @SupplierName = SUPPLIER_NAME
        FROM SUPPLIER
        WHERE SUPPLIER_ID = @SupplierID;

        -- Xác định Income_Type_ID cho "Inventory Returns"
        SELECT @IncomeTypeID = Income_Type_ID
        FROM INCOME_TYPE
        WHERE [Name] = 'Inventory Returns';

        -- Tạo tên và payer cho Income Receipt
        SET @IncomeName = CONCAT('Refund for Item: ', @ItemID);
        SET @PayerName = CONCAT('Supplier: ', @SupplierName);

        -- Thêm bản ghi vào RETURN_BILL
        INSERT INTO RETURN_BILL (REASON, REFUND_FEE)
        VALUES (@Reason, @RefundFee);

        -- Lấy ID của Return Bill vừa thêm
        SET @NewReturnID = SCOPE_IDENTITY();

        -- 2. Kiểm tra ItemID và SupplierID có tồn tại hay không
        IF NOT EXISTS (SELECT 1 FROM ITEM WHERE ITEM_ID = @ItemID)
        BEGIN
            RAISERROR('Item không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM SUPPLIER WHERE SUPPLIER_ID = @SupplierID)
        BEGIN
            RAISERROR('Supplier không tồn tại.', 16, 2);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 3. Kiểm tra ReturnQuantity > 0
        IF @ReturnQuantity <= 0
        BEGIN
            RAISERROR('ReturnQuantity phải lớn hơn 0.', 16, 3);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 4. Thêm bản ghi vào RETURN_ITEM
        INSERT INTO RETURN_ITEM (RETURN_ID, ITEM_ID, SUPPLIER_ID, RETURN_QUANTITY, RETURN_PRICE)
        VALUES (@NewReturnID, @ItemID, @SupplierID, @ReturnQuantity, @ReturnPrice);

        -- 5. Cập nhật lại Stock trong bảng ITEM
        UPDATE ITEM
        SET STOCK = STOCK - @ReturnQuantity
        WHERE ITEM_ID = @ItemID;

        -- 6. Thêm bản ghi vào INCOME_RECEIPT
        INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID)
        VALUES (@IncomeName, GETDATE(), @RefundFee, @PayerName, @IncomeTypeID);

        -- Hoàn tất transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback nếu có lỗi
        ROLLBACK TRANSACTION;

        -- Xử lý và ném lỗi ra ngoài
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO

GO


GO
CREATE PROCEDURE GetAllReturnBills
AS
BEGIN
    SELECT *
    FROM RETURN_BILL;
END;

GO
CREATE PROCEDURE GetReturnBillById
    @ReturnID INT
AS
BEGIN
    SELECT *
    FROM RETURN_BILL
    WHERE RETURN_ID = @ReturnID;
END;

--ORDER
GO
CREATE PROCEDURE CreateOrderAndIncomeReceipt
    @CustomerNotes NVARCHAR(255),
    @TotalItemAmount INT,
    @ShippingFee INT,
    @PaymentMethod VARCHAR(10),
    @IncomeName NVARCHAR(40),
    @PayerName NVARCHAR(40),
    @IncomeTypeID INT,
    @VoucherCode CHAR(5) = NULL -- Thêm tham số VoucherCode để nhận voucher
AS
BEGIN
    BEGIN TRY
        -- Bắt đầu transaction
        BEGIN TRANSACTION;

        -- Bước 1: Kiểm tra và áp dụng voucher nếu có
        DECLARE @VoucherDiscount INT = 0;
        DECLARE @MaxDiscountAmount INT = 0;
        DECLARE @VoucherID INT;

        IF @VoucherCode IS NOT NULL
        BEGIN
            -- Kiểm tra xem voucher code có hợp lệ không
            SELECT @VoucherID = Voucher_ID,
                   @VoucherDiscount = Discount_Percentage,
                   @MaxDiscountAmount = Max_Discount_Amount
            FROM VOUCHER
            WHERE Voucher_Code = @VoucherCode -- Sử dụng voucher code thay vì voucher name
              AND Voucher_Status = 'Activated';

            -- Nếu voucher hợp lệ, tính toán giá trị giảm giá
            IF @VoucherDiscount > 0
            BEGIN
                -- Áp dụng giảm giá tối đa
                DECLARE @CalculatedDiscount INT = (@TotalItemAmount * @VoucherDiscount) / 100;
                IF @CalculatedDiscount > @MaxDiscountAmount
                    SET @CalculatedDiscount = @MaxDiscountAmount;

                -- Áp dụng giảm giá từ voucher vào Discount
                SET @VoucherDiscount = @CalculatedDiscount;
            END
        END

        -- Nếu voucher không hợp lệ hoặc không có voucher thì không áp dụng giảm giá
        -- Bước 2: Tạo order mới với hoặc không có giảm giá
        DECLARE @OrderID INT;
        INSERT INTO [ORDER] (Order_Date, Discount, Payment_Method, Shipping_Fee, Total_Item_Amount, Customer_Notes)
        VALUES (GETDATE(), @VoucherDiscount, @PaymentMethod, @ShippingFee, @TotalItemAmount, @CustomerNotes);

        -- Lấy Order_ID của order vừa tạo
        SET @OrderID = SCOPE_IDENTITY();

        -- Bước 3: Tính toán tổng tiền (Revenue)
        DECLARE @TotalRevenue INT;
        SET @TotalRevenue = @TotalItemAmount + @ShippingFee - @VoucherDiscount;

        -- Bước 4: Thêm phiếu thu (Income Receipt)
        INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID)
        VALUES (@IncomeName, GETDATE(), @TotalRevenue, @PayerName, @IncomeTypeID);

        -- Bước 5: Nếu voucher có áp dụng, thêm dữ liệu vào bảng APPLY_VOUCHER
        IF @VoucherCode IS NOT NULL
        BEGIN
            INSERT INTO APPLY_VOUCHER (Voucher_ID, Order_ID)
            VALUES (@VoucherID, @OrderID);
        END

        -- Commit transaction
        COMMIT TRANSACTION;

        PRINT 'Order và Income Receipt đã được tạo thành công.' + 
              CASE WHEN @VoucherCode IS NOT NULL THEN ' Voucher đã được áp dụng.' ELSE '' END;

    END TRY
    BEGIN CATCH
        -- Nếu có lỗi, rollback transaction
        ROLLBACK TRANSACTION;
        PRINT 'Lỗi xảy ra: ' + ERROR_MESSAGE();
    END CATCH
END;


-- DROP PROCEDURE CreateOrderAndIncomeReceipt

GO
CREATE PROCEDURE ReturnOrderAndCreateExpenseReceipt
    @OrderID INT,
    @Reason NVARCHAR(255),
    @ReturnDescription NVARCHAR(255),
    @ExpenseName NVARCHAR(40),
    @PayeeName NVARCHAR(40),
    @ExpenseTypeID INT
AS
BEGIN
    BEGIN TRY
        -- Bắt đầu transaction
        BEGIN TRANSACTION;

        -- Bước 1: Xác minh đơn hàng tồn tại và chưa được trả lại
        IF NOT EXISTS (
            SELECT 1 
            FROM [ORDER] 
            WHERE Order_ID = @OrderID AND Order_Status <> 'Returned'
        )
        BEGIN
            THROW 50000, 'Đơn hàng không tồn tại hoặc đã được trả lại.', 1;
        END

        -- Bước 2: Lấy thông tin tổng số tiền của đơn hàng
        DECLARE @TotalRefundAmount INT;
        SELECT @TotalRefundAmount = (Total_Item_Amount + Shipping_Fee - Discount)
        FROM [ORDER]
        WHERE Order_ID = @OrderID;

        -- Kiểm tra tổng tiền hoàn trả có hợp lệ
        IF @TotalRefundAmount <= 0
        BEGIN
            THROW 50001, 'Số tiền hoàn trả không hợp lệ.', 1;
        END

        -- Bước 3: Cập nhật trạng thái đơn hàng
        UPDATE [ORDER]
        SET Order_Status = 'Returned'
        WHERE Order_ID = @OrderID;

        -- Bước 4: Tạo một bản ghi trong bảng RETURN_ORDER
        INSERT INTO RETURN_ORDER (Reason, Return_Description, Return_Status, Order_ID)
        VALUES (@Reason, @ReturnDescription, 'Approved', @OrderID);

        -- Bước 5: Tạo phiếu chi trong bảng EXPENSE_RECEIPT
        INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID)
        VALUES (@ExpenseName, GETDATE(), @TotalRefundAmount, @PayeeName, @ExpenseTypeID);

        -- Commit transaction
        COMMIT TRANSACTION;

        PRINT 'Đơn hàng đã được trả lại, phiếu hoàn trả và phiếu chi đã được tạo thành công.';
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi, rollback transaction
        ROLLBACK TRANSACTION;

        -- Hiển thị thông báo lỗi chi tiết
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(), 
               @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

----------------------------------------INSERT VALUE--------------------------------------------
-- 24 EMPLOYEE


INSERT INTO Person (ID_Card_Num, Lname, Fname, DOB, Sex)
VALUES
('079304008477', 'Nguyen Minh', 'Hoa', '1990-05-10', 1),
('079203478901', 'Tran Van', 'Binh', '1985-12-25', 0),
('071201789032', 'Nguyen Van', 'Minh', '1990-03-10', 0),
('082303567891', 'Tran Thi', 'Sau', '1985-11-14', 1),
('043202456981', 'Le Thi', 'Hanh', '1992-07-22', 1),
('013201357468', 'Pham Van', 'Phuc', '1987-04-18', 0),
('039203246789', 'Nguyen Thi', 'Dao', '1995-01-02', 1),
('062201345987', 'Do Hoang', 'Anh', '1989-09-15', 0),
('025301987643', 'Tran Thi', 'Hong', '1993-12-30', 1),
('012201320456', 'Nguyen Van', 'Tam', '1986-06-10', 0),
('036302145769', 'Pham Minh', 'Long', '1991-03-11', 0),
('011201987654', 'Le Hoang', 'Linh', '1988-08-19', 1),
('061303543210', 'Nguyen Thi', 'Trang', '1994-05-20', 1),
('079201345678', 'Tran Van', 'Hoa', '1983-11-22', 0),
('048203987654', 'Pham Thi', 'My', '1992-10-10', 1),
('073203567890', 'Do Van', 'Hung', '1987-12-15', 0),
('031202765489', 'Nguyen Thi', 'Lan', '1990-04-28', 1),
('083303246897', 'Le Van', 'Dung', '1995-07-07', 0),
('082201874356', 'Tran Hoang', 'Nam', '1986-01-30', 0),
('043201098765', 'Pham Thi', 'Hue', '1992-03-25', 1),
('071201876543', 'Nguyen Van', 'Hieu', '1990-08-18', 0),
('053201574839', 'Tran Minh', 'Quang', '1985-11-02', 0),
('022201578903', 'Le Thi', 'Kim', '1993-09-13', 1),
('051202345678', 'Pham Van', 'Cuong', '1994-02-24', 0);
-- SELECT * FROM Person;

-- SDT
-- Thêm số điện thoại cho Nguyen Minh Hoa
INSERT INTO PHONE_NUM (ID_Card_Num, Phone_Num)
VALUES 
('079304008477', '0912345678'),
('079304008477', '0987654321'),
('079203478901', '0931122334'), 
('079203478901', '0974433221'),
('071201789032', '0922334455'),
('082303567891', '0945566778'),
('043202456981', '0967788990'); 

-- SELECT * FROM PHONE_NUM

-- delete from account
INSERT INTO ACCOUNT (ID_Card_Num, Username, [Password], [Role], [Status])
VALUES
('079304008477', 'NguyenMinhHoa477', 'hashed_password1', 'Admin', 'Active'),
('079203478901', 'TranVanBinh901', 'hashed_password2', 'Admin', 'Active'),
('071201789032', 'NguyenVanMinh032', 'hashed_password3', 'Admin', 'Active'),
('082303567891', 'TranThiSau891', 'hashed_password4', 'Employee', 'Active'),
('043202456981', 'LeThiHanh981', 'hashed_password5', 'Employee', 'Active'),
('013201357468', 'PhamVanPhuc468', 'hashed_password6', 'Employee', 'Active'),
('039203246789', 'NguyenThiDao789', 'hashed_password7', 'Employee', 'Active'),
('062201345987', 'DoHoangAnh987', 'hashed_password8', 'Employee', 'Active'),
('025301987643', 'TranThiHong643', 'hashed_password9', 'Employee', 'Active'),
('012201320456', 'NguyenVanTam456', 'hashed_password10', 'Employee', 'Active'),
('036302145769', 'PhamMinhLong769', 'hashed_password11', 'Employee', 'Active'),
('011201987654', 'LeHoangLinh654', 'hashed_password12', 'Employee', 'Active'),
('061303543210', 'NguyenThiTrang210', 'hashed_password13', 'Employee', 'Active'),
('079201345678', 'TranVanHoa678', 'hashed_password14', 'Employee', 'Active'),
('048203987654', 'PhamThiMy654', 'hashed_password15', 'Employee', 'Active'),
('073203567890', 'DoVanHung890', 'hashed_password16', 'Employee', 'Active'),
('031202765489', 'NguyenThiLan489', 'hashed_password17', 'Employee', 'Active'),
('083303246897', 'LeVanDung897', 'hashed_password18', 'Employee', 'Active'),
('082201874356', 'TranHoangNam356', 'hashed_password19', 'Employee', 'Active'),
('043201098765', 'PhamThiHue765', 'hashed_password20', 'Employee', 'Active'),
('071201876543', 'NguyenVanHieu543', 'hashed_password21', 'Employee', 'Active'),
('053201574839', 'TranMinhQuang839', 'hashed_password22', 'Employee', 'Active'),
('022201578903', 'LeThiKim903', 'hashed_password23', 'Employee', 'Active'),
('051202345678', 'PhamVanCuong678', 'hashed_password24', 'Employee', 'Active');


-- SELECT p.ID_Card_Num, p.Fname, p.Lname, a.Username, a.Password
-- FROM Person p
-- JOIN Account a ON p.ID_Card_Num = a.ID_Card_Num;


-- DELETE FROM EMPLOYEE

-- SELECT ID_Card_Num 
-- FROM EMPLOYEE 
-- WHERE ID_Card_Num NOT IN (SELECT ID_Card_Num FROM PERSON);

INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
VALUES
('079304008477', 'Senior', 35000),  -- Admin -> Senior
('079203478901', 'Senior', 30000),  -- Admin -> Senior
('071201789032', 'Senior', 35000),  -- Admin -> Senior
('082303567891', 'Senior', 30000), 
('043202456981', 'Junior', 25000), 
('013201357468', 'Junior', 25000),
('039203246789', 'Junior', 25000), 
('062201345987', 'Senior', 35000), 
('025301987643', 'Junior', 25000), 
('012201320456', 'Senior', 30000), 
('036302145769', 'Junior', 25000), 
('011201987654', 'Junior', 25000), 
('061303543210', 'Senior', 35000), 
('079201345678', 'Junior', 25000), 
('048203987654', 'Senior', 30000), 
('073203567890', 'Junior', 25000), 
('031202765489', 'Junior', 25000), 
('083303246897', 'Senior', 30000), 
('082201874356', 'Senior', 35000), 
('043201098765', 'Junior', 25000), 
('071201876543', 'Junior', 25000), 
('053201574839', 'Senior', 30000), 
('022201578903', 'Junior', 25000), 
('051202345678', 'Senior', 35000);

-- SELECT * FROM Employee;

INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('079304008477', '2024-01-01', '2024-06-30'), 
('079203478901', '2024-01-01', '2024-12-31'), 
('071201789032 ', '2024-02-01', '2024-08-31'), 
('082303567891', '2024-03-01', '2024-09-30'),
('079304008477', '2022-01-01', '2023-06-30'), 
('082303567891', '2020-03-01', '2021-12-30');

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
EXEC RegisterShift @Shift_ID = 1, @ID_Card_Num = '079304008477'; 
EXEC RegisterShift @Shift_ID = 1, @ID_Card_Num = '079203478901'; 
EXEC RegisterShift @Shift_ID = 2, @ID_Card_Num = '071201789032';
EXEC RegisterShift @Shift_ID = 2, @ID_Card_Num = '082303567891'; 
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '043202456981';
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '013201357468';
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '039203246789'; 
EXEC RegisterShift @Shift_ID = 4, @ID_Card_Num = '025301987643';
EXEC RegisterShift @Shift_ID = 4, @ID_Card_Num = '012201320456'; 
EXEC RegisterShift @Shift_ID = 5, @ID_Card_Num = '036302145769';
EXEC RegisterShift @Shift_ID = 5, @ID_Card_Num = '011201987654'; 
EXEC RegisterShift @Shift_ID = 6, @ID_Card_Num = '061303543210'; 
EXEC RegisterShift @Shift_ID = 7, @ID_Card_Num = '031202765489'; 
EXEC RegisterShift @Shift_ID = 8, @ID_Card_Num = '071201876543'; 
EXEC RegisterShift @Shift_ID = 9, @ID_Card_Num = '079304008477';
EXEC RegisterShift @Shift_ID = 9, @ID_Card_Num = '051202345678';

SELECT * FROM WORK_ON;

-- TÍNH LƯƠNG
DECLARE @Shift_ID INT, @ID_Card_Num CHAR(12);

DECLARE work_cursor CURSOR FOR
SELECT Shift_ID, ID_Card_Num FROM WORK_ON WHERE [Check] = 0;

OPEN work_cursor;

FETCH NEXT FROM work_cursor INTO @Shift_ID, @ID_Card_Num;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Gọi thủ tục CheckIn cho mỗi bản ghi
    EXEC CheckInAndUpdateSalary @Shift_ID, @ID_Card_Num;

    FETCH NEXT FROM work_cursor INTO @Shift_ID, @ID_Card_Num;
END

CLOSE work_cursor;
DEALLOCATE work_cursor;

SELECT E.ID_Card_Num, E.Wage, 
       S.[Month], S.[Year], SH.Rate, S.Amount
FROM EMPLOYEE E
JOIN SALARY S ON E.ID_Card_Num = S.ID_Card_Num
JOIN WORK_ON WO ON E.ID_Card_Num = WO.ID_Card_Num
JOIN SHIFT SH ON WO.Shift_ID = SH.Shift_ID
ORDER BY E.ID_Card_Num, SH.[Date], S.[Month], S.[Year];


-- KHONG CHEN CUNG LUC DUOC
-- INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES 
-- (5, '036302145769'),
-- (5, '082303567891'),
-- (5, '043202456981'); 

-- SELECT * FROM WORK_ON;
GO

-- Insert 5 employees into SALES_EMPLOYEE
INSERT INTO SALES_EMPLOYEE (ID_Card_Num)
VALUES
('079304008477'),
('079203478901'),
('071201789032'),
('082303567891'),
('043202456981');

-- SELECT * FROM SALES_EMPLOYEE S JOIN EMPLOYEE E ON S.ID_Card_Num = E.ID_Card_Num;

INSERT INTO SUPERVISE (Supervisor_ID, Supervisee_ID)
VALUES
('079304008477', '071201789032'),
('079304008477', '079203478901'),
('079304008477', '082303567891'),
('071201789032', '043202456981');

-- Insert 5 employees into PACKAGING_EMPLOYEE
INSERT INTO PACKAGING_EMPLOYEE (ID_Card_Num)
VALUES
('013201357468'),
('039203246789'),
('062201345987'),
('025301987643'),
('012201320456');

SELECT * FROM PACKAGING_EMPLOYEE;

-- Insert 5 employees into CUSTOMERSERVICE_EMPLOYEE
INSERT INTO CUSTOMERSERVICE_EMPLOYEE (ID_Card_Num)
VALUES
('036302145769'),
('011201987654'),
('061303543210'),
('079201345678'),
('048203987654');

SELECT * FROM CUSTOMERSERVICE_EMPLOYEE;

-- Insert 5 employees into ACCOUNTING_EMPLOYEE
INSERT INTO ACCOUNTING_EMPLOYEE (ID_Card_Num)
VALUES
('073203567890'),
('031202765489'),
('083303246897'),
('082201874356'),
('043201098765');

SELECT * FROM ACCOUNTING_EMPLOYEE;

-- Insert 4 employees into WAREHOUSE_EMPLOYEE
INSERT INTO WAREHOUSE_EMPLOYEE (ID_Card_Num)
VALUES
('071201876543'),
('053201574839'),
('022201578903'),
('051202345678');

SELECT * FROM WAREHOUSE_EMPLOYEE;

INSERT INTO EXPENSE_TYPE ([Name]) VALUES
('Inventory Purchase'),
('Rent'),
('Salaries'),
('Utilities'),
('Marketing'),
('Refund');

GO
SELECT * FROM EXPENSE_TYPE;

-- -- delete from EXPENSE_RECEIPT
-- INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID) VALUES
-- ('Store Rent for December', '2024-12-01', 25000000, 'Landlord', 2),
-- ('Electricity Bill', '2024-12-02', 1000000, 'Electricity Provider', 4),
-- ('Wifi Bill', '2024-12-03', 350000, 'FPT', 4),
-- ('Facebook Ads Campaign', '2024-12-02', 5000000, 'Ad Agency', 5);


INSERT INTO INCOME_TYPE ([Name]) VALUES
('Sales Revenue'),
('Inventory Returns'),
('Additional Services Revenue'),
('Compensation');


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
('043201098765', 'Member'),
('071201876543', 'Silver'),
('053201574839', 'Gold'),
('022201578903', 'Platinum'),
('051202345678', 'Diamond');

-- Kiểm tra dữ liệu bảng CUSTOMER
SELECT * FROM CUSTOMER;

-- -- Dữ liệu cho bảng REVENUE_REPORT_BY_ITEM
-- INSERT INTO REVENUE_REPORT_BY_ITEM (Report_Type, Total_Revenue, [Day], [Month], [Year])
-- VALUES 
-- ('Daily', 15000.50, 1, 12, 2024),
-- ('Daily', 10500.75, 7, 12, 2024),
-- ('Daily', 20000.00, 15, 12, 2024),
-- ('Monthly', 500000.00, NULL, 12, 2024),
-- ('Monthly', 150000.25, NULL, 6, 2024),
-- ('Monthly', 10000000.50, NULL, 10, 2024),
-- ('Yearly', 750000000.00, NULL, NULL, 2023),
-- ('Yearly', 100000000.00, NULL, NULL, 2024),
-- ('Yearly', 500000000.00, NULL, NULL, 2022),
-- ('Monthly', 120000.75, NULL, 8, 2024);

-- Kiểm tra dữ liệu bảng REVENUE_REPORT_BY_ITEM
-- SELECT * FROM REVENUE_REPORT_BY_ITEM;

-- -- Dữ liệu cho bảng INVENTORY_REPORT
-- INSERT INTO INVENTORY_REPORT (Report_Type, Inventory_Value, [Day], [Month], [Year])
-- VALUES 
-- ('Daily', 250, 1, 12, 2024),
-- ('Daily', 175, 7, 12, 2024),
-- ('Daily', 75, 15, 12, 2024),
-- ('Monthly', 3000, NULL, 3, 2024),
-- ('Monthly', 5000, NULL, 5, 2024),
-- ('Monthly', 2600, NULL, 7, 2024),
-- ('Yearly', 12400, NULL, NULL, 2022),
-- ('Yearly', 12000, NULL, NULL, 2023),
-- ('Yearly', 19700, NULL, NULL, 2024),
-- ('Monthly', 1500, NULL, 11, 2024);

-- Kiểm tra dữ liệu bảng INVENTORY_REPORT
-- SELECT * FROM INVENTORY_REPORT;

-- Dữ liệu cho bảng RECEIVER_INFO
-- Dữ liệu cho bảng RECEIVER_INFO
INSERT INTO RECEIVER_INFO (ID_Card_Num, Customer_ID, Housenum, Street, District, City, Lname, Fname, Phone)
VALUES
('043201098765', 1, '12B', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi', 'Pham Thi', 'Hue', '0123456789'),
('071201876543', 2, '45C', 'Le Duan', 'Dong Da', 'Ha Noi', 'Nguyen Van', 'Hieu', '0987654321'),
('053201574839', 3, '78A', 'Tran Phu', 'Ha Dong', 'Ha Noi', 'Tran Minh', 'Quang', '0912345678'),
('022201578903', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi', 'Le Thi', 'Kim', '0945678912'),
('051202345678', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi', 'Pham Van', 'Cuong', '0934567890');

-- Kiểm tra dữ liệu bảng RECEIVER_INFO
SELECT * FROM RECEIVER_INFO;
SELECT * FROM PLACE

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

-- Dữ liệu cho phần ORDER


-- Trường hợp 1: Thêm voucher "Special Offer"
EXEC InsertVoucher 
    @VoucherName = 'Special Offer', 
    @VoucherStatus = 'Activated', 
    @DiscountPercentage = 20, 
    @MaxDiscountAmount = 300000,
    @VoucherStartDate = '2024-12-01',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2024-12-31';    -- Ngày kết thúc voucher

-- Trường hợp 2: Thêm voucher "Holiday Deal"
EXEC InsertVoucher 
    @VoucherName = 'Holiday Deal', 
    @VoucherStatus = 'Not activated', 
    @DiscountPercentage = 15, 
    @MaxDiscountAmount = 150000,
    @VoucherStartDate = '2024-12-10',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2025-01-10';    -- Ngày kết thúc voucher

-- Trường hợp 3: Thêm voucher "Flash Sale"
EXEC InsertVoucher 
    @VoucherName = 'Flash Sale', 
    @VoucherStatus = 'Expired', 
    @DiscountPercentage = 25, 
    @MaxDiscountAmount = 250000,
    @VoucherStartDate = '2024-11-15',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2024-11-30';    -- Ngày kết thúc voucher

-- Trường hợp 4: Thêm voucher "Black Friday"
EXEC InsertVoucher 
    @VoucherName = 'Black Friday', 
    @VoucherStatus = 'Expired', 
    @DiscountPercentage = 30, 
    @MaxDiscountAmount = 500000,
    @VoucherStartDate = '2024-11-28',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2024-11-29';    -- Ngày kết thúc voucher

-- Trường hợp 5: Thêm voucher "New Year Gift"
EXEC InsertVoucher 
    @VoucherName = 'New Year Gift', 
    @VoucherStatus = 'Not activated', 
    @DiscountPercentage = 10, 
    @MaxDiscountAmount = 100000,
    @VoucherStartDate = '2024-12-20',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2025-01-10';    -- Ngày kết thúc voucher

EXEC InsertVoucher 
    @VoucherName = 'SALE 12.12', 
    @VoucherStatus = 'Activated', 
    @DiscountPercentage = 15, 
    @MaxDiscountAmount = 150000,
    @VoucherStartDate = '2024-12-12',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2025-12-13';    -- Ngày kết thúc voucher

EXEC InsertVoucher 
    @VoucherName = 'SALE 12.12-2', 
    @VoucherStatus = 'Activated', 
    @DiscountPercentage = 15, 
    @MaxDiscountAmount = 150000,
    @VoucherStartDate = '2024-12-12',  -- Ngày bắt đầu voucher
    @VoucherEndDate = '2025-12-13';    -- Ngày kết thúc voucher


GO

-- Dữ liệu cho bảng Of_Group
INSERT INTO Of_Group (Voucher_ID, Group_Name)
VALUES 
(1, 'Member'),
(2, 'Silver'),
(3, 'Member'),
(4, 'Platinum'),
(5, 'Diamond'),
(6, 'Diamond'),
(7, 'Silver');

-- Kiểm tra dữ liệu bảng Of_Group
SELECT * FROM Of_Group;
SELECT * FROM VOUCHER
SELECT * FROM VOUCHER_VALID_PERIOD
-- DELETE FROM VOUCHER_VALID_PERIOD
-- DELETE FROM VOUCHER


-- Thêm nhiều dữ liệu vào ORDER và INCOME_RECEIPT bằng thủ tục CreateOrderAndIncomeReceipt
-- Thêm nhiều dữ liệu vào ORDER và INCOME_RECEIPT bằng thủ tục CreateOrderAndIncomeReceipt
EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 4980000, 
    @ShippingFee = 50000, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 1', 
    @PayerName = N'Pham Thi Hue', 
    @IncomeTypeID = 1,
    @VoucherCode = 'V0001';  -- Áp dụng voucher code

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 2500000, 
    @ShippingFee = 15000, 
    @PaymentMethod = 'Cash', 
    @IncomeName = N'Payment for Order 2', 
    @PayerName = N'Nguyen Van Hieu', 
    @IncomeTypeID = 1,
    @VoucherCode = 'V0007';  -- Áp dụng voucher code

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 3500000, 
    @ShippingFee = 80000, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 3', 
    @PayerName = N'Tran Minh Quang', 
    @IncomeTypeID = 1,
    @VoucherCode = NULL;  -- Không áp dụng voucher (discount = 0)

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 5000000, 
    @ShippingFee = 100000, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 4', 
    @PayerName = N'Le Thi Kim', 
    @IncomeTypeID = 1,
    @VoucherCode = NULL;  -- Áp dụng voucher code

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 200000, 
    @ShippingFee = 15000, 
    @PaymentMethod = 'Cash', 
    @IncomeName = N'Payment for Order 5', 
    @PayerName = N'Pham Van Cuong', 
    @IncomeTypeID = 1,
    @VoucherCode = 'V0006';  -- Áp dụng voucher code


-- Dữ liệu cho bảng PLACE
INSERT INTO PLACE (Order_ID, ID_Card_Num, Customer_ID, Housenum, Street, District, City)
VALUES 
(1, '043201098765', 1, '12B', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi'),
(2, '071201876543', 2, '45C', 'Le Duan', 'Dong Da', 'Ha Noi'),
(3, '053201574839', 3, '78A', 'Tran Phu', 'Ha Dong', 'Ha Noi'),
(4, '022201578903', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi'),
(5, '051202345678', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi');

-- Thêm nhiều dữ liệu vào RETURN_ORDER và EXPENSE_RECEIPT bằng thủ tục ReturnOrderAndCreateExpenseReceipt
EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 1, 
    @Reason = N'Damaged item', 
    @ReturnDescription = N'Item arrived broken', 
    @ExpenseName = N'Refund for Order 1', 
    @PayeeName = N'Pham Thi Hue', 
    @ExpenseTypeID = 6;

EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 2, 
    @Reason = N'Wrong item', 
    @ReturnDescription = N'Received a different product', 
    @ExpenseName = N'Refund for Order 2', 
    @PayeeName = N'Nguyen Van Hieu', 
    @ExpenseTypeID = 6;

EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 3, 
    @Reason = N'Late delivery', 
    @ReturnDescription = N'', 
    @ExpenseName = N'Refund for Order 3', 
    @PayeeName = N'Tran Minh Quang', 
    @ExpenseTypeID = 6;

-- SELECT * FROM [ORDER]
-- SELECT * FROM RETURN_ORDER
-- SELECT * FROM INCOME_RECEIPT
-- SELECT * FROM EXPENSE_RECEIPT
-- SELECT * FROM APPLY_VOUCHER
-- DELETE FROM APPLY_VOUCHER
-- DELETE FROM RETURN_ORDER
-- DELETE FROM [ORDER]
-- DELETE FROM INCOME_RECEIPT 
-- WHERE Income_ID >5
-- DELETE FROM EXPENSE_RECEIPT 
-- WHERE Expense_ID >5
INSERT INTO DELIVERY_INFO (Shipping_Provider, Pick_up_Date, Expected_Delivery_Date, Order_ID)
VALUES
('DHL', GETDATE(), DATEADD(DAY, 7, GETDATE()), 1),
('DHL', GETDATE(), DATEADD(DAY, 10, GETDATE()), 2),
('DHL', GETDATE(), DATEADD(DAY, 5, GETDATE()), 3),
('DHL', GETDATE(), DATEADD(DAY, 8, GETDATE()), 4),
('DHL', GETDATE(), DATEADD(DAY, 10, GETDATE()), 5);
SELECT * FROM DELIVERY_INFO

INSERT INTO INCHARGE_OF (Order_ID, ID_Card_Num)
VALUES
(1, '079304008477'), -- Sales Employee với ID Card phụ trách Order 1
(2, '079203478901'),
(3, '071201789032'),
(4, '082303567891'),
(5, '043202456981'); 

INSERT INTO PREPARE (Order_ID, ID_Card_Num)
VALUES
(1, '013201357468'), -- Packaging Employee với ID Card chuẩn bị Order 1
(2, '039203246789'),
(3, '062201345987'),
(4, '025301987643'),
(5, '012201320456');


INSERT INTO GET_FEEDBACK (Order_ID, ID_Card_Num)
VALUES
(1, '036302145769'), -- Customer Service Employee với ID Card nhận phản hồi cho Order 1
(2, '011201987654'),
(3, '061303543210'),
(4, '079201345678'), 
(5, '048203987654'); 

-- Dữ liệu insert supplier 
INSERT INTO SUPPLIER (SUPPLIER_NAME, SUPPLIER_EMAIL, SUPPLIER_PHONE, ADDRESS)
VALUES 
('Routine', 'contact@routine.vn', '0901234567', '77 Nguyen Trai, District 1, Ho Chi Minh City'),
('Hnoss', 'info@hnoss.vn', '0912345678', '88 Dong Khoi, District 1, Ho Chi Minh City'),
('Coolmate', 'support@coolmate.me', '0923456789', '100 Cach Mang Thang 8, District 3, Ho Chi Minh City'),
('Yody', 'hello@yody.vn', '0934567890', '20 Le Loi, Hai Chau District, Da Nang'),
('Canifa', 'sales@canifa.com', '0945678901', '50 Hang Bong, Hoan Kiem District, Hanoi'),
('Owen', 'contact@owen.vn', '0956789012', '25 Tran Hung Dao, District 5, Ho Chi Minh City'),
('Blue Exchange', 'info@blueexchange.vn', '0967890123', '15 Le Thanh Ton, District 1, Ho Chi Minh City'),
('Lime Orange', 'service@limeorange.vn', '0978901234', '99 Phan Dinh Phung, Phu Nhuan District, Ho Chi Minh City');

--Dữ liệu insert product
INSERT INTO PRODUCT (PRODUCT_NAME, BRAND, STYLE_TAG, SEASON, CATEGORY, DESCRIPTION)
VALUES
('Cotton T-Shirt', 'Routine', 'Casual', 'Summer', 'Clothing', 'Comfortable cotton t-shirt for everyday wear.'),
('Chiffon Dress', 'Hnoss', 'Elegant', 'Spring', 'Clothing', 'Lightweight chiffon dress for formal events.'),
('Polo Shirt', 'Coolmate', 'Classic', 'All Seasons', 'Clothing', 'Breathable polo shirt with modern fit.'),
('Jogger Pants', 'Yody', 'Sporty', 'Fall', 'Clothing', 'Stretchable jogger pants for active lifestyle.'),
('Jeans', 'Canifa', 'Denim', 'All Seasons', 'Clothing', 'Durable denim jeans with versatile styling.'),
('Business Shirt', 'Owen', 'Formal', 'Winter', 'Clothing', 'Elegant business shirt with wrinkle-resistant fabric.');


--Dữ liệu insert Item
INSERT INTO ITEM (SELLING_PRICE, SIZE, COLOR, STOCK, PRODUCT_ID)
VALUES
(199000, 'M', 'White', 150, 1),
(299000, 'S', 'Pink', 100, 2),
(250000, 'L', 'Black', 200, 3),
(350000, 'XL', 'Gray', 120, 4),
(500000, '32', 'Blue', 80, 5),
(400000, 'L', 'White', 50, 6);

-- INCLUDE_ITEM
INSERT INTO INCLUDE_ITEM (Order_ID, Item_ID, Count)
VALUES
(1, 1, 10), -- Order 1 bao gồm 2 Item có ID 101
(1, 2, 10),
(2, 3, 10),
(3, 4, 10),
(4, 5, 10),
(5, 5, 10);


--Dữ liệu product_set
INSERT INTO PRODUCT_SET (NAME, STYLE)
VALUES
('Summer Collection', 'Casual'),
('Winter Elegance', 'Formal'),
('Wind Breaker', 'Casual'),
('Sportwear Line', 'Sport');

--Dữ liệu combine
INSERT INTO COMBINE (PRODUCT_ID, SET_ID)
VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 3),
(6, 2);

--dữ liệu import_bill
INSERT INTO IMPORT_BILL (IMPORT_STATE, TOTAL_FEE)
VALUES
('Pending', 5000000),
('Completed', 10000000),
('Completed', 12000000),
('Completed', 1500000);


--dữ liệu import
INSERT INTO IMPORT (IMPORT_ID, ITEM_ID, SUPPLIER_ID, IMPORT_QUANTITY, IMPORT_PRICE)
VALUES
(1, 1, 1, 100, 180000),
(2, 2, 2, 50, 250000),
(2, 3, 3, 200, 230000),
(3, 4, 4, 120, 300000),
(3, 5, 5, 80, 450000),
(3, 6, 6, 50, 380000);

-- delete from EXPENSE_RECEIPT
INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID) VALUES
('Store Rent for December', '2024-12-01', 25000000, 'Landlord', 2),
('Electricity Bill', '2024-12-02', 1000000, 'Electricity Provider', 4),
('Wifi Bill', '2024-12-03', 350000, 'FPT', 4),
('Facebook Ads Campaign', '2024-12-02', 5000000, 'Ad Agency', 5),
('Purchase Item', '2024-12-04', 10000000, 'Routine', 1),
('Purchase Item', '2024-12-05', 12000000, 'Routine', 1),
('Purchase Item', '2024-12-04', 1500000, 'Routine', 1);

--dữ liệu return bill
INSERT INTO RETURN_BILL (REASON, REFUND_FEE)
VALUES
('Damaged during transport', 500000),
('Wrong item sent', 700000),
('Damaged during transport', 100000),
('Defective goods', 250000);

--dữ liệu return_item
INSERT INTO RETURN_ITEM (RETURN_ID, ITEM_ID, SUPPLIER_ID, RETURN_QUANTITY, RETURN_PRICE)
VALUES
(1, 1, 1, 5, 180000),
(2, 2, 2, 3, 250000), 
(3, 3, 3, 10, 100000), 
(4, 4, 4, 2, 125000); 

-- Insert 5 sample records into INCOME_RECEIPT (Income related to the fashion store)
-- DELETE FROM INCOME_RECEIPT
INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID) VALUES
('Lateness penalty', '2024-12-01', 100000, 'Tran Van Binh', 4),
('Damage compensation', '2024-12-06', 500000, 'Pham Thi My', 4),
('Express shipping fee', '2024-12-02', 80000, 'Ho Ba Kien', 3),
('Tips', '2024-11-07', 500000, 'Pham Thanh An', 3),
('Get Refund', '2024-12-11', 150000, 'Coolmate', 4),
('Get Refund', '2024-12-11', 700000, 'Coolmate', 4),
('Get Refund', '2024-12-11', 100000, 'Coolmate', 4),
('Get Refund', '2024-12-11', 250000, 'Coolmate', 4);


--dữ liệu reconcilation_form
INSERT INTO RECONCILIATION_FORM (CHECKED_DATE)
VALUES
('2024-01-01'),
('2024-01-15'),
('2024-02-01'),
('2024-02-15');

INSERT INTO RECONCILE (CHECK_ID, ITEM_ID, ID_CARD_NUM, ACTUAL_QUANTITY)
VALUES
(1, 1, '071201876543', 5),
(2, 2, '053201574839', 10),
(3, 3, '022201578903', 15),
(4, 4, '051202345678', 20);

INSERT INTO HANDLE (Return_Order_ID, ID_Card_Num)
VALUES
(1,'061303543210'),
(2,'011201987654'),
(3,'011201987654');

INSERT INTO ADD_EXPENSE (Expense_ID, ID_Card_Num) VALUES
('1','031202765489'),
('2','083303246897'),
('3','082201874356'),
('4','073203567890'),
('5','073203567890'),
('6','073203567890'),
('7','073203567890');

INSERT INTO ADD_INCOME (Income_ID, ID_Card_Num) VALUES
('1','031202765489'),
('2','083303246897'),
('3','082201874356'),
('4','073203567890'),
('5','031202765489'),
('6','083303246897'),
('7','082201874356'),
('8','073203567890');

SELECT * FROM EXPENSE_RECEIPT R JOIN EXPENSE_TYPE T ON R.Expense_Type_ID = T.Expense_Type_ID
-- TÍNH LƯƠNG THÁNG
EXEC InsertTotalSalaryReceipt @Month = 12, @Year = 2024;
SELECT * FROM EXPENSE_RECEIPT

-- DỮ LIỆU ADD EXPENSE/ INCOME
SELECT * FROM Accounting_Employee
SELECT * FROM INCOME_RECEIPT
SELECT * FROM EXPENSE_RECEIPT

-- SELECT E.ID_Card_Num, I.NAME, T.NAME
-- FROM EMPLOYEE E, ADD_INCOME, INCOME_RECEIPT I, INCOME_TYPE T
-- WHERE E.ID_CARD_NUM = ADD_INCOME.ID_CARD_NUM AND ADD_INCOME.Income_ID = I.Income_ID
-- AND I.INCOME_TYPE_ID = T.INCOME_TYPE_ID;

EXEC CreateDailyProfitAndLossReport @Day = 01, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 02, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 03, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 04, @Month = 12, @Year = 2024

EXEC CreateMonthlyProfitAndLossReport @Month = 12, @Year = 2024
EXEC CreateYearlyProfitAndLossReport @Year = 2024

SELECT * FROM PROFIT_AND_LOSS_STATEMENT