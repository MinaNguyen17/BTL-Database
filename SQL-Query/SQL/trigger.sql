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
