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


-- Cập nhật Stock cho Item sau khi nhập kho hoàn tất
GO
CREATE TRIGGER trg_UpdateStockOnImportConfirm
ON IMPORT_BILL
AFTER UPDATE
AS
BEGIN
    -- Bắt đầu Transaction
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Cập nhật Stock của Item
        UPDATE ITEM
        SET STOCK = STOCK + imp.IMPORT_QUANTITY
        FROM ITEM i
        JOIN IMPORT imp ON i.ITEM_ID = imp.ITEM_ID
        JOIN INSERTED ins ON imp.IMPORT_ID = ins.IMPORT_ID
        WHERE ins.IMPORT_STATE = 'Confirmed' 
          AND NOT EXISTS (
              SELECT 1 FROM DELETED d WHERE d.IMPORT_ID = ins.IMPORT_ID AND d.IMPORT_STATE = 'Confirmed'
          );

        PRINT 'Cập nhật Stock sau khi Hoàn thành Nhập Kho'

        -- Commit transaction nếu không có lỗi
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction nếu có lỗi
        ROLLBACK TRANSACTION;

        -- Hiển thị lỗi
        THROW;
    END CATCH;
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

-- Cập nhật Stock sau khi nhập kho rồi trả hàng
GO
CREATE TRIGGER trg_UpdateStockOnReturn
ON RETURN_ITEM
AFTER INSERT
AS
BEGIN
    -- Kiểm tra nếu Return_Quantity lớn hơn Stock
    IF EXISTS (
        SELECT 1
        FROM ITEM i
        INNER JOIN INSERTED ri ON i.ITEM_ID = ri.ITEM_ID
        WHERE ri.RETURN_QUANTITY > i.STOCK
    )
    BEGIN
        PRINT 'Return quantity vượt quá stock';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật Stock
    UPDATE ITEM
    SET STOCK = STOCK - ri.RETURN_QUANTITY
    FROM ITEM i
    INNER JOIN INSERTED ri ON i.ITEM_ID = ri.ITEM_ID;

    PRINT 'Cập nhật Stock sau khi trả hàng cho nhà cung cấp';
END;

-- Xóa trigger trg_UpdateStockOnReconciliation
DROP TRIGGER trg_UpdateStockOnReconciliation;

-- Xóa trigger trg_UpdateStockOnImportConfirm
DROP TRIGGER trg_UpdateStockOnImportConfirm;

-- Xóa trigger trg_UpdateStockOnOrder
DROP TRIGGER trg_UpdateStockOnOrder;

-- Xóa trigger trg_UpdateStockOnReturn
DROP TRIGGER trg_UpdateStockOnReturn;
