-- Drop all foreign key constraints
DECLARE @sql1 NVARCHAR(MAX) = '';
SELECT @sql1 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql1;

-- Drop all check constraints, unique constraints, and primary key constraints
DECLARE @sql1_1 NVARCHAR(MAX) = '';
SELECT @sql1_1 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.check_constraints;
EXEC sp_executesql @sql1_1;

DECLARE @sql1_2 NVARCHAR(MAX) = '';
SELECT @sql1_2 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.key_constraints
WHERE type IN ('PK', 'UQ'); -- Drop Primary Keys and Unique Constraints
EXEC sp_executesql @sql1_2;

-- Drop all sequences
DECLARE @sql2_1 NVARCHAR(MAX) = '';
SELECT @sql2_1 += 'DROP SEQUENCE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.sequences;
EXEC sp_executesql @sql2_1;

-- Drop all tables
DECLARE @sql2 NVARCHAR(MAX) = '';
SELECT @sql2 += 'DROP TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.tables;
EXEC sp_executesql @sql2;

-- Optionally, drop other database objects if needed (e.g., views, stored procedures, functions)

-- Drop all views
DECLARE @sql3 NVARCHAR(MAX) = '';
SELECT @sql3 += 'DROP VIEW ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.views;
EXEC sp_executesql @sql3;

-- Drop all stored procedures
DECLARE @sql4 NVARCHAR(MAX) = '';
SELECT @sql4 += 'DROP PROCEDURE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.objects
WHERE type = 'P';
EXEC sp_executesql @sql4;

-- Drop all functions
DECLARE @sql5 NVARCHAR(MAX) = '';
SELECT @sql5 += 'DROP FUNCTION ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF');
EXEC sp_executesql @sql5;

-- -- Drop all types
-- DROP TYPE dbo.ItemListType;
