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
drop procedure RegisterShift
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
