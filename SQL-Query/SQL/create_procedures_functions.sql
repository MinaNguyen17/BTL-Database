----------------------------------------PROCEDURE & FUNCTION------------------------------------
CREATE FUNCTION GenerateVoucherCode()
RETURNS CHAR(5)
AS
BEGIN
    RETURN 'V' + RIGHT(CAST((ABS(CHECKSUM(NEWID())) % 10000) AS VARCHAR(4)), 4);
END;

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
    INSERT INTO PRODUCT(PRODUCT_NAME, BRAND, STYLE_TAG, SEASON, CATEGORY, DESCRIPTION)
    VALUES(@PRODUCT_NAME, @BRAND, @STYLE_TAG, @SEASON, @CATEGORY, @DESCRIPTION)
END
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
CREATE PROCEDURE AddAccount
    @ID_Card_Num CHAR(12),
    @Username VARCHAR(100),
    @Password VARCHAR(255),
    @Role VARCHAR(20)
AS
BEGIN
    INSERT INTO ACCOUNT (ID_Card_Num, Username, [Password], [Role])
    VALUES (@ID_Card_Num, @Username, @Password, @Role);
END
GO

CREATE PROCEDURE GetAccountById
    @AccountID INT
AS
BEGIN
    SELECT * FROM ACCOUNT WHERE Account_ID = @AccountID;
END
GO

CREATE PROCEDURE GetAllAccounts
AS
BEGIN
    SELECT * FROM ACCOUNT;
END
GO


CREATE PROCEDURE UpdateAccount
    @AccountID INT,
    @NewPassword VARCHAR(255)
AS
BEGIN
    UPDATE ACCOUNT
    SET [Password] = @NewPassword
    WHERE Account_ID = @AccountID;
END
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
-- drop procedure RegisterShift
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
                RAISERROR ('Employee already exists for this ID Card Number.', 16, 1);
                ROLLBACK TRANSACTION;
            END
                -- Thêm nhân viên vào bảng EMPLOYEE
            INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
            VALUES (@ID_Card_Num, @Position, @Wage);
            COMMIT TRANSACTION;
            PRINT 'Employee created successfully.';
        END
        ELSE
        BEGIN
            RAISERROR ('Person already exists for this ID Card Number.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
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





CREATE OR ALTER PROCEDURE  dbo.AddShift
    @Shift_Type CHAR(1),
    @Date DATE,
    @E_Num INT,
    @Rate DECIMAL(5, 2)
AS
BEGIN
    INSERT INTO SHIFT(Shift_Type, [Date], E_Num, Rate)
    VALUES(@Shift_Type, @Date, @E_Num, @Rate)
END;
GO
EXEC dbo.AddShift '1', '2024-12-05', 234, 999;
SELECT * FROM SHIFT;
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



CREATE OR ALTER PROCEDURE  dbo.GetShiftById
    @Shift_ID INT
AS
BEGIN
    SELECT * FROM SHIFT
    WHERE Shift_ID = @Shift_ID; 
END;
GO
EXEC dbo.GetShiftById 31;
GO

CREATE OR ALTER PROCEDURE  dbo.GetAllShifts
AS
BEGIN
    SELECT * FROM SHIFT; 
END;
GO
EXEC dbo.GetAllShifts;
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
EXEC dbo.AddSupplier 'Routine', 'contact@routine.vn', '0901234567', '77 Nguyen Trai, District 1, Ho Chi Minh City';
EXEC dbo.AddSupplier 'Hnoss',  'info@hnoss.vn', '0912345678', '88 Dong Khoi, District 1, Ho Chi Minh City';
EXEC dbo.AddSupplier 'Coolmate', 'support@coolmate.me', '0923456789', '100 Cach Mang Thang 8, District 3, Ho Chi Minh City';
SELECT * FROM SUPPLIER;
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







