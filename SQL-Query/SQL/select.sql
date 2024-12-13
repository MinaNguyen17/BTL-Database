DECLARE @tableName NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);

-- Lấy tên các bảng
DECLARE table_cursor CURSOR FOR
SELECT name
FROM sys.tables
WHERE type = 'U';

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @tableName;

-- Vòng lặp để truy vấn dữ liệu từng bảng
WHILE @@FETCH_STATUS = 0
BEGIN
    -- In tên bảng vào kết quả
    PRINT '--- Dữ liệu từ bảng: ' + @tableName;

    -- Truy vấn dữ liệu từ bảng
    SET @sql = 'SELECT ''' + @tableName + ''' AS TableName, * FROM ' + QUOTENAME(@tableName);
    EXEC sp_executesql @sql;

    FETCH NEXT FROM table_cursor INTO @tableName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

SELECT * FROM INCHARGE_OF
SELECT * FROM PREPARE
SELECT * FROM GET_FEEDBACK
SELECT * FROM HANDLE
