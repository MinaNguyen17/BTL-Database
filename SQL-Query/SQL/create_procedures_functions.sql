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
CREATE OR ALTER PROCEDURE ChangePassword
    @Username VARCHAR(100),
    @NewPassword VARCHAR(255)
AS
BEGIN
    UPDATE ACCOUNT
    SET [Password] = @NewPassword
    WHERE Username = @Username;
END
GO

GO
CREATE OR ALTER PROCEDURE UpdateAccount
    @Account_ID INT,
    @Role CHAR(20),
    @Status NVARCHAR(20)
AS
BEGIN
    UPDATE ACCOUNT
    SET [Role] = @Role,
        [Status] = @Status
    WHERE Account_ID = @Account_ID;
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

        -- Cập nhật Stock trong bảng ITEM
        UPDATE ITEM
        SET STOCK = STOCK + @ImportQuantity
        WHERE ITEM_ID = @ItemID;

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





