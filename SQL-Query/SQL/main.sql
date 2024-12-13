-- ===========================================
-- Bắt đầu quá trình tạo cơ sở dữ liệu
-- ===========================================

-- Tạo database
-- :r .\create_database.sql
-- GO

-- Tạo các bảng
:r "D:\Code\Nodejs\BTL-Database\SQL-Query\SQL\create_tables.sql"
GO

-- Tạo trigger
:r "D:\Code\Nodejs\BTL-Database\SQL-Query\SQL\trigger.sql"
GO

-- Tạo stored procedure và function
:r "D:\Code\Nodejs\BTL-Database\SQL-Query\SQL\create_procedures_functions.sql"
GO

-- Chèn dữ liệu vào các bảng
:r "D:\Code\Nodejs\BTL-Database\SQL-Query\SQL\insert_data.sql"
GO


-- ===========================================
-- Nếu cần xóa các đối tượng, bỏ comment dưới đây
-- ===========================================

-- Xóa các đối tượng (comment lại nếu không cần)
-- :r .\drop_objects.sql
-- GO
