----------------------------------------PROCEDURE & FUNCTION------------------------------------
CREATE FUNCTION GenerateVoucherCode()
RETURNS CHAR(5)
AS
BEGIN
    RETURN 'V' + RIGHT(CAST((ABS(CHECKSUM(NEWID())) % 10000) AS VARCHAR(4)), 4);
END;


----- Stored Procedure cho Item
GO
CREATE PROCEDURE AddItem
    @SellingPrice DECIMAL(10, 2),
    @Size VARCHAR(10),
    @Color VARCHAR(10),
    @Stock INT,
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
        VALUES (@SellingPrice, @Size, @Color, @Stock, @ProductID);
    END
    ELSE
    BEGIN
        -- Nếu ProductID không tồn tại, trả về thông báo lỗi
         RAISERROR ('Product không tồn tại.', 16, 1);
    END
END;

---Procedure UpdateItem
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
            THROW 50001, 'Item not found with the provided ID.', 1;
        END

        -- Kiểm tra xem Product có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE PRODUCT_ID = @ProductId)
        BEGIN
            THROW 50002, 'Product not found with the provided ID.', 1;
        END

        -- Cập nhật Item
        UPDATE ITEM
        SET 
            SELLING_PRICE = @SellingPrice,
            SIZE = @Size,
            COLOR = @Color,
            STOCK = @Stock,
            PRODUCT_ID = @ProductId
        WHERE ITEM_ID = @ItemId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Nếu xảy ra lỗi, rollback transaction và trả lỗi ra ngoài
        ROLLBACK TRANSACTION;
        THROW;
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




--Stored Procedure cho Import
GO
CREATE PROCEDURE ImportItemDetails
    @ItemID INT, 
    @SupplierID INT, 
    @ImportQuantity INT, 
    @ImportPrice DECIMAL(10, 2),
    @TotalFee DECIMAL(10, 2) -- Tổng phí lớn hơn ImportQuantity * ImportPrice (vì có thêm phí vận chuyển)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm bản ghi vào IMPORT_BILL
        DECLARE @NewImportID INT;
        INSERT INTO IMPORT_BILL (IMPORT_STATE, TOTAL_FEE)
        VALUES ('Pending', @TotalFee);

        -- Lấy ID của Import vừa thêm
        SET @NewImportID = SCOPE_IDENTITY();

        -- Kiểm tra ItemID và SupplierID có tồn tại hay không
        IF NOT EXISTS (SELECT 1 FROM ITEM WHERE ITEM_ID = @ItemID)
        BEGIN
            THROW 50001, 'Item không tồn tại.', 1;
        END

        IF NOT EXISTS (SELECT 1 FROM SUPPLIER WHERE SUPPLIER_ID = @SupplierID)
        BEGIN
            THROW 50002, 'Supplier không tồn tại.', 1;
        END


        --Thêm bản ghi vào bảng IMPORT (chi tiết nhập hàng)
        INSERT INTO IMPORT (IMPORT_ID, ITEM_ID, SUPPLIER_ID, IMPORT_QUANTITY, IMPORT_PRICE)
        VALUES (@NewImportID, @ItemID, @SupplierID, @ImportQuantity, @ImportPrice);

        -- Cập nhật Stock trong bảng ITEM
        -- UPDATE ITEM
        -- SET STOCK = STOCK + @ImportQuantity
        -- WHERE ITEM_ID = @ItemID;



        -------------CHƯA XỬ LÝ CÁC CHI PHÍ -----------------



        -- Hoàn tất transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi, rollback transaction
        ROLLBACK TRANSACTION;

        -- Hiển thị lỗi
        THROW;
    END CATCH;
END;
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
            THROW 60001, 'ImportID không tồn tại.', 1;
        END
    END TRY
    BEGIN CATCH
        -- Hiển thị lỗi
        THROW;
    END CATCH;
END;


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
        INSERT INTO RETURN_BILL (REASON, REFUND_FEE)
        VALUES (@Reason, @RefundFee);

        -- Lấy ID của Return Bill vừa thêm
        SET @NewReturnID = SCOPE_IDENTITY();

        -- 2. Kiểm tra ItemID và SupplierID có tồn tại hay không
        IF NOT EXISTS (SELECT 1 FROM ITEM WHERE ITEM_ID = @ItemID)
        BEGIN
            THROW 50001, 'Item not found with the provided ID.', 1;
        END
        IF NOT EXISTS (SELECT 1 FROM SUPPLIER WHERE SUPPLIER_ID = @SupplierID)
        BEGIN
            THROW 50002, 'Supplier not found with the provided ID.', 1;
        END

        -- 3. Kiểm tra ReturnQuantity > 0
        IF @ReturnQuantity <= 0
        BEGIN
            THROW 50003, 'ReturnQuantity must be greater than 0.', 1;
        END

        -- 4. Thêm bản ghi vào RETURN_ITEM
        INSERT INTO RETURN_ITEM (RETURN_ID, ITEM_ID, SUPPLIER_ID, RETURN_QUANTITY, RETURN_PRICE)
        VALUES (@NewReturnID, @ItemID, @SupplierID, @ReturnQuantity, @ReturnPrice);

        -- 5. Cập nhật lại Stock trong bảng ITEM
        -- UPDATE ITEM
        -- SET STOCK = STOCK - @ReturnQuantity
        -- WHERE ITEM_ID = @ItemID;


        -------------CHƯA XỬ LÝ CÁC CHI PHÍ -----------------

        -- Hoàn tất transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback nếu có lỗi
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

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


-- Xóa Proceduce

DROP PROCEDURE dbo.GetAllItems, dbo.GetItemById, AddItem, UpdateItem, GetAllReturnBills, AddReturnBill, GetReturnBillById, GetAllImportBills, GetImportBillById, UpdateImportBillState, ImportItemDetails, UpdateStockOnImport;
