-- Kiểm tra và xóa database cũ nếu có
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'db')
BEGIN
    DROP DATABASE db;
END;

-- Tạo database mới
CREATE DATABASE db;
GO

-- Sử dụng database mới
USE db;
GO
