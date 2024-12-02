use db;

BEGIN TRANSACTION

-- CREATE PERSON 
CREATE TABLE Person (
    ID_Card_Num CHAR(12) PRIMARY KEY,
    Fname NVARCHAR(20) NOT NULL,
    Lname NVARCHAR(40) NOT NULL,
    DOB DATE NOT NULL,
    CONSTRAINT CK_Age CHECK (DATEADD(YEAR, 18, DOB) <= GETDATE())
);

-- TEST PERSON

INSERT INTO Person (ID_Card_Num, Fname, Lname, DOB)
VALUES
('123456789012', 'Nguyen Minh', 'Hoa', '1990-05-10'),
('987654321098', 'Tran Van', 'Binh', '1985-12-25');

SELECT * FROM Person;

-- CREATE ACCOUNT
CREATE TABLE Account (
    Account_ID INT IDENTITY(1,1) PRIMARY KEY,        -- Khóa chính, tự động tăng từ 1
    ID_Card_Num CHAR(12) UNIQUE NOT NULL, 
    Email VARCHAR(100) NOT NULL UNIQUE,            -- Email, không được trùng lặp
    [Password] VARCHAR(255) NOT NULL,                -- Mật khẩu
    [Role] CHAR(20) NOT NULL,                     -- Vai trò
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Active',  -- Trạng thái, mặc định là Active
    CONSTRAINT CK_Role CHECK (Role IN ('Employee', 'Admin', 'Customer')), -- Ràng buộc Role
    CONSTRAINT CK_Status CHECK (Status IN ('Active', 'Inactive')),
    CONSTRAINT FK_Account_Person FOREIGN KEY (ID_Card_Num) REFERENCES Person(ID_Card_Num)
);

-- TEST ACCOUNT

INSERT INTO Account (ID_Card_Num, Email, Password, Role, Status)
VALUES 
('123456789012','employee1@example.com', 'hashed_password1', 'Employee', 'Active'),
('987654321098','admin@example.com', 'hashed_password2', 'Admin', 'Active');

-- Thử thêm acc thứ 2 cho cùng 1 người
INSERT INTO Account (ID_Card_Num, Email, Password, Role, Status)
VALUES 
('123456789012','customer1@example.com', 'hashed_password3', 'Customer', 'Inactive');

SELECT * FROM Account;

DELETE FROM Account
WHERE Account_ID = 1;

INSERT INTO Account (ID_Card_Num,Email, Password, Role, Status)
VALUES 
('111111111111','employee4@example.com', 'hashed_password14', 'Employee', 'Active');

ROLLBACK

--