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
('987654321098', 'Tran Van', 'Binh', '1985-12-25'),
('222222221111', 'Nguyen Van', 'Minh', '1990-03-10'),
('332211445577', 'Tran Thi', 'Sau', '1985-11-14');

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

-- CREATE EMPLOYEE
CREATE SEQUENCE EmpID_Sequence
START WITH 1
INCREMENT BY 1;

CREATE TABLE Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Person(ID_Card_Num),
    Employee_ID CHAR(8) UNIQUE,
    Position VARCHAR(30) NOT NULL,
    Wage INT NOT NULL,
);


-- TRIGGER thêm EMPLOYEE_ID
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

GO
INSERT INTO Employee (ID_Card_Num, Position, Wage)
VALUES
('123456789012', 'Sale', 25000),
('987654321098', 'Manager', 50000),
('222222221111', 'Tele', 25000),
('332211445577', 'Package', 50000);

SELECT * FROM Employee;

-- CREATE WORKING_PERIOD
CREATE TABLE Working_Period (
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    [Start_Date] DATE NOT NULL,
    End_Date DATE NOT NULL,
    PRIMARY KEY (ID_Card_Num, Start_Date, End_Date)
);

-- TEST WORKING_PERIOD
INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('123456789012', '2024-01-01', '2024-06-30'), -- Sale
('987654321098', '2024-01-01', '2024-12-31'), -- Manager
('222222221111', '2024-02-01', '2024-08-31'), -- Tele
('332211445577', '2024-03-01', '2024-09-30'), -- Package
('123456789012', '2022-01-01', '2023-06-30'), -- Sale
('332211445577', '2020-03-01', '2021-12-30'); -- Package

SELECT * FROM Working_Period;

BEGIN TRANSACTION;
-- CREATE SHIFT
CREATE TABLE Shift (
    Shift_ID INT IDENTITY(1,1) PRIMARY KEY,
    Shift_Type CHAR(1) NOT NULL,
    [Date] DATE NOT NULL,
    Rate DECIMAL(5, 2) DEFAULT 1.00,
    CONSTRAINT CK_Shift_Type CHECK (Shift_Type IN ('1', '2', '3'))
);

-- TEST SHIFT
INSERT INTO Shift (Shift_Type, [Date], Rate)
VALUES 
('1', '2024-12-05', 1),
('2', '2024-12-05', 1),
('3', '2024-12-05', 1.25),
('1', '2024-12-06', 1),
('2', '2024-12-06', 1),
('3', '2024-12-06', 1.25),
('1', '2024-12-07', 1.25),
('2', '2024-12-07', 1.25),
('3', '2024-12-07', 1.5);

SELECT * FROM Shift;

-- CREATE WORK_ON
CREATE TABLE Work_On (
    Shift_ID INT FOREIGN KEY REFERENCES Shift(Shift_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    PRIMARY KEY (Shift_ID, ID_Card_Num)
);

-- CREATE SALARY
CREATE TABLE Salary (
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12),
    [Year] INT,
    Amount INT NOT NULL,
    PRIMARY KEY (ID_Card_Num, [Month], [Year])
);

-- CREATE SUPERVISE
CREATE TABLE Supervise (
    Supervisee_ID CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num),
    Supervisor_ID CHAR(12) FOREIGN KEY REFERENCES Employee(ID_Card_Num),
);

-- CREATE TYPES OF EMPLOYEE
CREATE TABLE Sales_Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE Packaging_Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE CustomerService_Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE Accounting_Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

CREATE TABLE Warehouse_Employee (
    ID_Card_Num CHAR(12) PRIMARY KEY FOREIGN KEY REFERENCES Employee(ID_Card_Num)
);

-- CREATE EXPENSE_TYPE
CREATE TABLE Expense_Type (
    Expense_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE
);

-- CREATE EXPENSE_RECEIPT
CREATE TABLE Expense_Receipt (
    Expense_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE,
    [Date] DATE NOT NULL,
    Amount INT NOT NULL,
    Payee_Name VARCHAR(40) NOT NULL,
    Expense_Type_ID INT FOREIGN KEY REFERENCES Expense_Type(Expense_Type_ID)
);

-- CREATE INCOME_TYPE
CREATE TABLE Income_Type (
    Income_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE
);

-- CREATE INCOME_RECEIPT
CREATE TABLE Income_Receipt (
    Income_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(40) NOT NULL UNIQUE,
    [Date] DATE NOT NULL,
    Amount INT NOT NULL,
    Payer_Name VARCHAR(40) NOT NULL,
    Income_Type_ID INT FOREIGN KEY REFERENCES Income_Type(Income_Type_ID)
);

-- CREATE ADD_EXPENSE
CREATE TABLE Add_Expense (
    Expense_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Expense_Receipt(Expense_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Accounting_Employee(ID_Card_Num)
);

-- CREATE ADD_INCOME
CREATE TABLE Add_Income (
    Income_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Income_Receipt(Income_ID),
    ID_Card_Num CHAR(12) FOREIGN KEY REFERENCES Accounting_Employee(ID_Card_Num)
);

-- CREATE PROFIT AND LOSS STATEMENT
CREATE TABLE Profit_And_Loss_Statement (
    Profit_And_Loss_ID INT IDENTITY(1,1) PRIMARY KEY,
    Report_Type VARCHAR(5) CHECK (Report_Type IN ('Day','Month','Year')),
    Expense INT NOT NULL,
    Revenue INT NOT NULL,
    Gross_Profit INT NOT NULL,
    [Day] INT NOT NULL,
    [Month] INT CHECK ([Month] BETWEEN 1 AND 12) NOT NULL,
    [Year] INT NOT NULL
);

-- CREATE MANAGE_EXPENSE
CREATE TABLE Manage_Expense (
    Expense_ID INT FOREIGN KEY REFERENCES Expense_Receipt(Expense_ID),
    Profit_And_Loss_ID INT FOREIGN KEY REFERENCES Profit_And_Loss_Statement(Profit_And_Loss_ID),
    PRIMARY KEY(Expense_ID, Profit_And_Loss_ID)
);

-- CREATE MANAGE_EXPENSE
CREATE TABLE Manage_Income (
    Income_ID INT FOREIGN KEY REFERENCES Income_Receipt(Income_ID),
    Profit_And_Loss_ID INT FOREIGN KEY REFERENCES Profit_And_Loss_Statement(Profit_And_Loss_ID),
    PRIMARY KEY(Income_ID, Profit_And_Loss_ID)
);

ROLLBACK;


DROP TABLE Expense_Receipt;
DROP TABLE Income_Receipt;
DROP TABLE Expense_Type;
DROP TABLE Income_Type;