-- ===========================================
-- Bắt đầu quá trình tạo cơ sở dữ liệu
-- ===========================================

-- Tạo database
:r .\create_database.sql
GO

-- Tạo các bảng
:r .\create_tables.sql
GO

-- Tạo trigger
:r .\create_trigger.sql
GO

-- Tạo stored procedure và function
:r .\create_procedure_function.sql
GO

-- Chèn dữ liệu vào các bảng
:r .\insert_data.sql
GO

-- ===========================================
-- Nếu cần xóa các đối tượng, bỏ comment dưới đây
-- ===========================================

-- Xóa các đối tượng (comment lại nếu không cần)
-- :r .\drop_objects.sql
-- GO
