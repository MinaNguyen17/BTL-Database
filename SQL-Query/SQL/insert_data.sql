----------------------------------------INSERT VALUE--------------------------------------------
USE db;
-- 24 EMPLOYEE


INSERT INTO Person (ID_Card_Num, Fname, Lname, DOB, Sex)
VALUES
('079304008477', 'Nguyen Minh', 'Hoa', '1990-05-10', 1),
('079203478901', 'Tran Van', 'Binh', '1985-12-25', 0),
('071201789032', 'Nguyen Van', 'Minh', '1990-03-10', 0),
('082303567891', 'Tran Thi', 'Sau', '1985-11-14', 1),
('043202456981', 'Le Thi', 'Hanh', '1992-07-22', 1),
('013201357468', 'Pham Van', 'Phuc', '1987-04-18', 0),
('039203246789', 'Nguyen Thi', 'Dao', '1995-01-02', 1),
('062201345987', 'Do Hoang', 'Anh', '1989-09-15', 0),
('025301987643', 'Tran Thi', 'Hong', '1993-12-30', 1),
('012201320456', 'Nguyen Van', 'Tam', '1986-06-10', 0),
('036302145769', 'Pham Minh', 'Long', '1991-03-11', 0),
('011201987654', 'Le Hoang', 'Linh', '1988-08-19', 1),
('061303543210', 'Nguyen Thi', 'Trang', '1994-05-20', 1),
('079201345678', 'Tran Van', 'Hoa', '1983-11-22', 0),
('048203987654', 'Pham Thi', 'My', '1992-10-10', 1),
('073203567890', 'Do Van', 'Hung', '1987-12-15', 0),
('031202765489', 'Nguyen Thi', 'Lan', '1990-04-28', 1),
('083303246897', 'Le Van', 'Dung', '1995-07-07', 0),
('082201874356', 'Tran Hoang', 'Nam', '1986-01-30', 0),
('043201098765', 'Pham Thi', 'Hue', '1992-03-25', 1),
('071201876543', 'Nguyen Van', 'Hieu', '1990-08-18', 0),
('053201574839', 'Tran Minh', 'Quang', '1985-11-02', 0),
('022201578903', 'Le Thi', 'Kim', '1993-09-13', 1),
('051202345678', 'Pham Van', 'Cuong', '1994-02-24', 0);
-- SELECT * FROM Person;

-- SDT
-- Thêm số điện thoại cho Nguyen Minh Hoa
INSERT INTO PHONE_NUM (ID_Card_Num, Phone_Num)
VALUES 
('079304008477', '0912345678'),
('079304008477', '0987654321'),
('079203478901', '0931122334'), 
('079203478901', '0974433221'),
('071201789032', '0922334455'),
('082303567891', '0945566778'),
('043202456981', '0967788990'); 

-- SELECT * FROM PHONE_NUM

-- delete from account
INSERT INTO ACCOUNT (ID_Card_Num, Username, [Password], [Role], [Status])
VALUES
('079304008477', 'NguyenMinhHoa477', 'hashed_password1', 'Admin', 'Active'),
('079203478901', 'TranVanBinh901', 'hashed_password2', 'Admin', 'Active'),
('071201789032', 'NguyenVanMinh032', 'hashed_password3', 'Admin', 'Active'),
('082303567891', 'TranThiSau891', 'hashed_password4', 'Employee', 'Active'),
('043202456981', 'LeThiHanh981', 'hashed_password5', 'Employee', 'Active'),
('013201357468', 'PhamVanPhuc468', 'hashed_password6', 'Employee', 'Active'),
('039203246789', 'NguyenThiDao789', 'hashed_password7', 'Employee', 'Active'),
('062201345987', 'DoHoangAnh987', 'hashed_password8', 'Employee', 'Active'),
('025301987643', 'TranThiHong643', 'hashed_password9', 'Employee', 'Active'),
('012201320456', 'NguyenVanTam456', 'hashed_password10', 'Employee', 'Active'),
('036302145769', 'PhamMinhLong769', 'hashed_password11', 'Employee', 'Active'),
('011201987654', 'LeHoangLinh654', 'hashed_password12', 'Employee', 'Active'),
('061303543210', 'NguyenThiTrang210', 'hashed_password13', 'Employee', 'Active'),
('079201345678', 'TranVanHoa678', 'hashed_password14', 'Employee', 'Active'),
('048203987654', 'PhamThiMy654', 'hashed_password15', 'Employee', 'Active'),
('073203567890', 'DoVanHung890', 'hashed_password16', 'Employee', 'Active'),
('031202765489', 'NguyenThiLan489', 'hashed_password17', 'Employee', 'Active'),
('083303246897', 'LeVanDung897', 'hashed_password18', 'Employee', 'Active'),
('082201874356', 'TranHoangNam356', 'hashed_password19', 'Employee', 'Active'),
('043201098765', 'PhamThiHue765', 'hashed_password20', 'Employee', 'Active'),
('071201876543', 'NguyenVanHieu543', 'hashed_password21', 'Employee', 'Active'),
('053201574839', 'TranMinhQuang839', 'hashed_password22', 'Employee', 'Active'),
('022201578903', 'LeThiKim903', 'hashed_password23', 'Employee', 'Active'),
('051202345678', 'PhamVanCuong678', 'hashed_password24', 'Employee', 'Active');


-- SELECT p.ID_Card_Num, p.Fname, p.Lname, a.Username, a.Password
-- FROM Person p
-- JOIN Account a ON p.ID_Card_Num = a.ID_Card_Num;


-- DELETE FROM EMPLOYEE

SELECT ID_Card_Num 
FROM EMPLOYEE 
WHERE ID_Card_Num NOT IN (SELECT ID_Card_Num FROM PERSON);

INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
VALUES
('079304008477', 'Senior', 35000),  -- Admin -> Senior
('079203478901', 'Senior', 30000),  -- Admin -> Senior
('071201789032', 'Senior', 35000),  -- Admin -> Senior
('082303567891', 'Senior', 30000), 
('043202456981', 'Junior', 25000), 
('013201357468', 'Junior', 25000),
('039203246789', 'Junior', 25000), 
('062201345987', 'Senior', 35000), 
('025301987643', 'Junior', 25000), 
('012201320456', 'Senior', 30000), 
('036302145769', 'Junior', 25000), 
('011201987654', 'Junior', 25000), 
('061303543210', 'Senior', 35000), 
('079201345678', 'Junior', 25000), 
('048203987654', 'Senior', 30000), 
('073203567890', 'Junior', 25000), 
('031202765489', 'Junior', 25000), 
('083303246897', 'Senior', 30000), 
('082201874356', 'Senior', 35000), 
('043201098765', 'Junior', 25000), 
('071201876543', 'Junior', 25000), 
('053201574839', 'Senior', 30000), 
('022201578903', 'Junior', 25000), 
('051202345678', 'Senior', 35000);

-- SELECT * FROM Employee;

INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('079304008477', '2024-01-01', '2024-06-30'), 
('079203478901', '2024-01-01', '2024-12-31'), 
('071201789032 ', '2024-02-01', '2024-08-31'), 
('082303567891', '2024-03-01', '2024-09-30'),
('079304008477', '2022-01-01', '2023-06-30'), 
('082303567891', '2020-03-01', '2021-12-30');

-- SELECT * FROM Working_Period;

INSERT INTO Shift (Shift_Type, [Date], Rate, E_Num)
VALUES 
('1', '2024-12-05', 1, 2),
('2', '2024-12-05', 1, 2),
('3', '2024-12-05', 1.25, 4),
('1', '2024-12-06', 1, 2),
('2', '2024-12-06', 1, 2),
('3', '2024-12-06', 1.25, 3),
('1', '2024-12-07', 1.25, 2),
('2', '2024-12-07', 1.25, 2),
('3', '2024-12-07', 1.5, 4);

-- SELECT * FROM Shift;

-- DELETE FROM WORK_ON;
EXEC RegisterShift @Shift_ID = 1, @ID_Card_Num = '079304008477'; 
EXEC RegisterShift @Shift_ID = 1, @ID_Card_Num = '079203478901'; 
EXEC RegisterShift @Shift_ID = 2, @ID_Card_Num = '071201789032';
EXEC RegisterShift @Shift_ID = 2, @ID_Card_Num = '082303567891'; 
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '043202456981';
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '013201357468';
EXEC RegisterShift @Shift_ID = 3, @ID_Card_Num = '039203246789'; 
EXEC RegisterShift @Shift_ID = 4, @ID_Card_Num = '025301987643';
EXEC RegisterShift @Shift_ID = 4, @ID_Card_Num = '012201320456'; 
EXEC RegisterShift @Shift_ID = 5, @ID_Card_Num = '036302145769';
EXEC RegisterShift @Shift_ID = 5, @ID_Card_Num = '011201987654'; 
EXEC RegisterShift @Shift_ID = 6, @ID_Card_Num = '061303543210'; 
EXEC RegisterShift @Shift_ID = 7, @ID_Card_Num = '031202765489'; 
EXEC RegisterShift @Shift_ID = 8, @ID_Card_Num = '071201876543'; 
EXEC RegisterShift @Shift_ID = 9, @ID_Card_Num = '079304008477';
EXEC RegisterShift @Shift_ID = 9, @ID_Card_Num = '051202345678';

SELECT * FROM WORK_ON;

-- TÍNH LƯƠNG
DECLARE @Shift_ID INT, @ID_Card_Num CHAR(12);

DECLARE work_cursor CURSOR FOR
SELECT Shift_ID, ID_Card_Num FROM WORK_ON WHERE [Check] = 0;

OPEN work_cursor;

FETCH NEXT FROM work_cursor INTO @Shift_ID, @ID_Card_Num;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Gọi thủ tục CheckIn cho mỗi bản ghi
    EXEC CheckInAndUpdateSalary @Shift_ID, @ID_Card_Num;

    FETCH NEXT FROM work_cursor INTO @Shift_ID, @ID_Card_Num;
END

CLOSE work_cursor;
DEALLOCATE work_cursor;

SELECT E.ID_Card_Num, E.Wage, 
       S.[Month], S.[Year], SH.Rate, S.Amount
FROM EMPLOYEE E
JOIN SALARY S ON E.ID_Card_Num = S.ID_Card_Num
JOIN WORK_ON WO ON E.ID_Card_Num = WO.ID_Card_Num
JOIN SHIFT SH ON WO.Shift_ID = SH.Shift_ID
ORDER BY E.ID_Card_Num, SH.[Date], S.[Month], S.[Year];


-- KHONG CHEN CUNG LUC DUOC
-- INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES 
-- (5, '036302145769'),
-- (5, '082303567891'),
-- (5, '043202456981'); 

-- SELECT * FROM WORK_ON;
GO

-- Insert 5 employees into SALES_EMPLOYEE
INSERT INTO SALES_EMPLOYEE (ID_Card_Num)
VALUES
('079304008477'),
('079203478901'),
('071201789032'),
('082303567891'),
('043202456981');

-- SELECT * FROM SALES_EMPLOYEE S JOIN EMPLOYEE E ON S.ID_Card_Num = E.ID_Card_Num;

INSERT INTO SUPERVISE (Supervisor_ID, Supervisee_ID)
VALUES
('079304008477', '071201789032'),
('079304008477', '079203478901'),
('079304008477', '082303567891'),
('071201789032', '043202456981');

-- Insert 5 employees into PACKAGING_EMPLOYEE
INSERT INTO PACKAGING_EMPLOYEE (ID_Card_Num)
VALUES
('013201357468'),
('039203246789'),
('062201345987'),
('025301987643'),
('012201320456');

SELECT * FROM PACKAGING_EMPLOYEE;

-- Insert 5 employees into CUSTOMERSERVICE_EMPLOYEE
INSERT INTO CUSTOMERSERVICE_EMPLOYEE (ID_Card_Num)
VALUES
('036302145769'),
('011201987654'),
('061303543210'),
('079201345678'),
('048203987654');

SELECT * FROM CUSTOMERSERVICE_EMPLOYEE;

-- Insert 5 employees into ACCOUNTING_EMPLOYEE
INSERT INTO ACCOUNTING_EMPLOYEE (ID_Card_Num)
VALUES
('073203567890'),
('031202765489'),
('083303246897'),
('082201874356'),
('043201098765');

SELECT * FROM ACCOUNTING_EMPLOYEE;

-- Insert 4 employees into WAREHOUSE_EMPLOYEE
INSERT INTO WAREHOUSE_EMPLOYEE (ID_Card_Num)
VALUES
('071201876543'),
('053201574839'),
('022201578903'),
('051202345678');

SELECT * FROM WAREHOUSE_EMPLOYEE;

INSERT INTO EXPENSE_TYPE ([Name]) VALUES
('Inventory Purchase'),
('Rent'),
('Salaries'),
('Utilities'),
('Marketing'),
('Refund');

-- delete from EXPENSE_RECEIPT
INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID) VALUES
('Store Rent for December', '2024-12-01', 25000000, 'Landlord', 2),
('Electricity Bill', '2024-12-02', 1000000, 'Electricity Provider', 4),
('Wifi Bill', '2024-12-03', 350000, 'FPT', 4),
('Facebook Ads Campaign', '2024-12-02', 5000000, 'Ad Agency', 5);

SELECT * FROM EXPENSE_RECEIPT R JOIN EXPENSE_TYPE T ON R.Expense_Type_ID = T.Expense_Type_ID

INSERT INTO INCOME_TYPE ([Name]) VALUES
('Sales Revenue'),
('Inventory Returns'),
('Additional Services Revenue'),
('Compensation');

-- Insert 5 sample records into INCOME_RECEIPT (Income related to the fashion store)
-- DELETE FROM INCOME_RECEIPT
INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID) VALUES
('Lateness penalty', '2024-12-01', 100000, 'Tran Van Binh', 4),
('Damage compensation', '2024-12-06', 500000, 'Pham Thi My', 4),
('Express shipping fee', '2024-12-02', 80000, 'Ho Ba Kien', 3),
('Tips', '2024-11-07', 150000, 'Pham Thanh An', 3);

-- TÍNH LƯƠNG THÁNG
EXEC InsertTotalSalaryReceipt @Month = 12, @Year = 2024;
SELECT * FROM EXPENSE_RECEIPT

-- DỮ LIỆU ADD EXPENSE/ INCOME
SELECT * FROM Accounting_Employee
SELECT * FROM INCOME_RECEIPT
SELECT * FROM EXPENSE_RECEIPT

INSERT INTO ADD_EXPENSE (Expense_ID, ID_Card_Num) VALUES
('6','031202765489'),
('7','083303246897'),
('8','082201874356'),
('9','073203567890'),
('12','043201098765');

INSERT INTO ADD_INCOME (Income_ID, ID_Card_Num) VALUES
('5','031202765489'),
('6','083303246897'),
('7','082201874356'),
('8','073203567890');

-- SELECT E.ID_Card_Num, I.NAME, T.NAME
-- FROM EMPLOYEE E, ADD_INCOME, INCOME_RECEIPT I, INCOME_TYPE T
-- WHERE E.ID_CARD_NUM = ADD_INCOME.ID_CARD_NUM AND ADD_INCOME.Income_ID = I.Income_ID
-- AND I.INCOME_TYPE_ID = T.INCOME_TYPE_ID;

EXEC CreateDailyProfitAndLossReport @Day = 01, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 02, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 03, @Month = 12, @Year = 2024
EXEC CreateDailyProfitAndLossReport @Day = 04, @Month = 12, @Year = 2024

EXEC CreateMonthlyProfitAndLossReport @Month = 12, @Year = 2024
EXEC CreateYearlyProfitAndLossReport @Year = 2024

SELECT * FROM PROFIT_AND_LOSS_STATEMENT
-------

-- Dữ liệu cho bảng CUSTOMER_GROUP
INSERT INTO CUSTOMER_GROUP (Group_Name, Requirement, Group_Note)
VALUES 
('Member', 'Below 3000 points', 'Standard customers'),
('Silver', '3000+ points', 'Intermediate benefits'),
('Gold', '5000+ points', 'Priority benefits'),
('Platinum', '10000+ points', 'Premium benefits'),
('Diamond', '20000+ points', 'VIP benefits');

-- Kiểm tra dữ liệu bảng CUSTOMER_GROUP
SELECT * FROM CUSTOMER_GROUP;

-- Dữ liệu cho bảng CUSTOMER
INSERT INTO CUSTOMER (ID_Card_Num, Group_Name)
VALUES 
('079304008477', 'Member'),
('079203478901', 'Silver'),
('012201320456', 'Gold'),
('036302145769', 'Platinum'),
('011201987654', 'Diamond'),
('061303543210', 'Silver'),
('079201345678', 'Gold'),
('048203987654', 'Platinum'),
('073203567890', 'Diamond'),
('031202765489', 'Member');

-- Kiểm tra dữ liệu bảng CUSTOMER
SELECT * FROM CUSTOMER;

-- Dữ liệu cho bảng REVENUE_REPORT_BY_ITEM
INSERT INTO REVENUE_REPORT_BY_ITEM (Report_Type, Total_Revenue, [Day], [Month], [Year])
VALUES 
('Daily', 15000.50, 1, 12, 2024),
('Daily', 10500.75, 7, 12, 2024),
('Daily', 20000.00, 15, 12, 2024),
('Monthly', 500000.00, NULL, 12, 2024),
('Monthly', 150000.25, NULL, 6, 2024),
('Monthly', 10000000.50, NULL, 10, 2024),
('Yearly', 750000000.00, NULL, NULL, 2023),
('Yearly', 100000000.00, NULL, NULL, 2024),
('Yearly', 500000000.00, NULL, NULL, 2022),
('Monthly', 120000.75, NULL, 8, 2024);

-- Kiểm tra dữ liệu bảng REVENUE_REPORT_BY_ITEM
SELECT * FROM REVENUE_REPORT_BY_ITEM;

-- Dữ liệu cho bảng INVENTORY_REPORT
INSERT INTO INVENTORY_REPORT (Report_Type, Inventory_Value, [Day], [Month], [Year])
VALUES 
('Daily', 250, 1, 12, 2024),
('Daily', 175, 7, 12, 2024),
('Daily', 75, 15, 12, 2024),
('Monthly', 3000, NULL, 3, 2024),
('Monthly', 5000, NULL, 5, 2024),
('Monthly', 2600, NULL, 7, 2024),
('Yearly', 12400, NULL, NULL, 2022),
('Yearly', 12000, NULL, NULL, 2023),
('Yearly', 19700, NULL, NULL, 2024),
('Monthly', 1500, NULL, 11, 2024);

-- Kiểm tra dữ liệu bảng INVENTORY_REPORT
SELECT * FROM INVENTORY_REPORT;

-- Dữ liệu cho bảng RECEIVER_INFO
INSERT INTO RECEIVER_INFO (ID_Card_Num, Customer_ID, Housenum, Street, District, City, Lname, Fname, Phone)
VALUES
('079304008477', 1, '12B', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi', 'Nguyen Van', 'Hoa', '0123456789'),
('079203478901', 2, '45C', 'Le Duan', 'Dong Da', 'Ha Noi', 'Tran Van', 'Binh', '0987654321'),
('012201320456', 3, '78A', 'Tran Phu', 'Ha Dong', 'Ha Noi', 'Nguyen Van', 'Tam', '0912345678'),
('036302145769', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi', 'Pham Minh', 'Long', '0945678912'),
('011201987654', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi', 'Le Hoang', 'Linh', '0934567890'),
('061303543210', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi', 'Nguyen Thi', 'Trang', '0923456781'),
('079201345678', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi', 'Tran Van', 'Hoa', '0912345679'),
('048203987654', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi', 'Pham Thi', 'My', '0901234567'),
('073203567890', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi', 'Do Van', 'Hung', '0987654322'),
('031202765489', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi', 'Nguyen Thi', 'Lan', '0945678923');

-- Kiểm tra dữ liệu bảng RECEIVER_INFO
SELECT * FROM RECEIVER_INFO;

-- Dữ liệu cho bảng Of_Group
INSERT INTO Of_Group (Voucher_ID, Group_Name)
VALUES 
(1, 'Member'),
(2, 'Silver'),
(3, 'Member'),
(4, 'Platinum'),
(5, 'Diamond'),
(6, 'Member'),
(7, 'Silver'),
(8, 'Silver'),
(9, 'Platinum'),
(10, 'Diamond');

-- Kiểm tra dữ liệu bảng Of_Group
SELECT * FROM Of_Group;

-- -- Dữ liệu cho bảng Place
-- INSERT INTO Place (Order_ID, ID_Card_Num, Customer_ID, HouseNum, Street, District, City)
-- VALUES 
-- (101, '079304008477', 1, '12A', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi'),
-- (102, '079203478901', 2, '45B', 'Le Duan', 'Dong Da', 'Ha Noi'),
-- (103, '012201320456', 3, '78C', 'Tran Phu', 'Ha Dong', 'Ha Noi'),
-- (104, '036302145769', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi'),
-- (105, '011201987654', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi'),
-- (106, '061303543210', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi'),
-- (107, '079201345678', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi'),
-- (108, '048203987654', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi'),
-- (109, '073203567890', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi'),
-- (110, '031202765489', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi');

-- -- Kiểm tra dữ liệu bảng Place
-- SELECT * FROM Place;

-- -- Dữ liệu cho bảng Summarize
-- INSERT INTO Summarize (Item_Revenue_Report_ID, Order_ID, Quantity)
-- VALUES
-- (1, 101, 5),
-- (2, 102, 10),
-- (3, 103, 15),
-- (4, 104, 20),
-- (5, 105, 25),
-- (6, 106, 30),
-- (7, 107, 35),
-- (8, 108, 40),
-- (9, 109, 45),
-- (10, 110, 50);

-- -- Kiểm tra dữ liệu bảng Summarize
-- SELECT * FROM Summarize;

-- -- Dữ liệu cho bảng Contain
-- INSERT INTO Contain (Inventory_Report_ID, Item_ID, Quantity)
-- VALUES
-- (1, 1001, 50),
-- (2, 1002, 100),
-- (3, 1003, 150),
-- (4, 1004, 200),
-- (5, 1005, 250),
-- (6, 1006, 300),
-- (7, 1007, 350),
-- (8, 1008, 400),
-- (9, 1009, 450),
-- (10, 1010, 500);

-- -- Kiểm tra dữ liệu bảng Contain
-- SELECT * FROM Contain;

-- Dữ liệu cho phần ORDER




INSERT INTO VOUCHER (Voucher_Code, Voucher_Name, Voucher_Status, Discount_Percentage, Max_Discount_Amount)
VALUES 
(dbo.GenerateVoucherCode(), 'Special Offer', 'Activated', 20, 300),
(dbo.GenerateVoucherCode(), 'Holiday Deal', 'Not activated', 15, 150),
(dbo.GenerateVoucherCode(), 'Flash Sale', 'Expired', 25, 250),
(dbo.GenerateVoucherCode(), 'Black Friday', 'Activated', 30, 500),
(dbo.GenerateVoucherCode(), 'New Year Gift', 'Not activated', 10, 100),
(dbo.GenerateVoucherCode(), 'Birthday Bonus', 'Activated', 20, 200),
(dbo.GenerateVoucherCode(), 'Loyalty Reward', 'Activated', 25, 300),
(dbo.GenerateVoucherCode(), 'Referral Code', 'Activated', 15, 150),
(dbo.GenerateVoucherCode(), 'Summer Sale', 'Expired', 40, 400),
(dbo.GenerateVoucherCode(), 'Clearance Offer', 'Not activated', 50, 500);

INSERT INTO DELIVERY_INFO (Shipping_Provider, Pick_up_Date, Expected_Delivery_Date, Order_ID)
VALUES
('FedEx', GETDATE(), DATEADD(DAY, 7, GETDATE()), 1),
('DHL', GETDATE(), DATEADD(DAY, 10, GETDATE()), 2),
('UPS', GETDATE(), DATEADD(DAY, 5, GETDATE()), 3),
('USPS', GETDATE(), DATEADD(DAY, 8, GETDATE()), 4),
('Aramex', GETDATE(), DATEADD(DAY, 10, GETDATE()), 5),
('BlueDart', GETDATE(), DATEADD(DAY, 12, GETDATE()), 6),
('TNT', GETDATE(), DATEADD(DAY, 6, GETDATE()), 7),
('FedEx', GETDATE(), DATEADD(DAY, 10, GETDATE()), 8),
('DHL', GETDATE(), DATEADD(DAY, 9, GETDATE()), 9),
('UPS', GETDATE(), DATEADD(DAY, 7, GETDATE()), 10);

-- INSERT INTO [ORDER] (Discount, Payment_Method, Shipping_Fee, Order_Status, Total_Item_Amount, Customer_Notes)
-- VALUES 
-- (10, 'Cash', 20, 'Shipped', 300, 'Please deliver in the morning'),
-- (15, 'Card', 25, 'Preparing', 500, 'Fragile item, handle with care'),
-- (5, 'Online', 15, 'Completed', 200, 'No special instructions'),
-- (20, 'Cash', 10, 'Canceled', 0, 'Out of stock, please refund'),
-- (0, 'Online', 5, 'Preparing', 100, 'No special instructions'),
-- (30, 'Card', 35, 'Shipped', 600, 'Gift wrap required, please include a note'),
-- (0, 'Online', 0, 'Completed', 400, 'Deliver to reception desk'),
-- (25, 'Cash', 20, 'Shipped', 700, 'Urgent delivery needed, please prioritize'),
-- (10, 'Online', 10, 'Completed', 500, 'No special instructions'),
-- (15, 'Card', 30, 'Canceled', 0, 'Address not found, please check details');

-- INSERT INTO RETURN_ORDER (Reason, Return_Description, Return_Status, Order_ID)
-- VALUES
-- ('Damaged item', 'Item arrived broken', 'Approved', 1),
-- ('Wrong item', 'Received a different product', 'Under consideration', 2),
-- ('Change of mind', '', 'Rejected', 3),
-- ('Late delivery', '', 'Approved', 4);

-- Thêm nhiều dữ liệu vào ORDER và INCOME_RECEIPT bằng thủ tục CreateOrderAndIncomeReceipt
EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 1500, 
    @ShippingFee = 100, 
    @Discount = 50, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 1', 
    @PayerName = N'Customer', 
    @IncomeTypeID = 1;

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 2000, 
    @ShippingFee = 150, 
    @Discount = 100, 
    @PaymentMethod = 'Cash', 
    @IncomeName = N'Payment for Order 2', 
    @PayerName = N'Customer B', 
    @IncomeTypeID = 1;

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 1200, 
    @ShippingFee = 80, 
    @Discount = 0, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 3', 
    @PayerName = N'Customer', 
    @IncomeTypeID = 1;

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 1500, 
    @ShippingFee = 100, 
    @Discount = 50, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 4', 
    @PayerName = N'Customer', 
    @IncomeTypeID = 1;

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 2000, 
    @ShippingFee = 150, 
    @Discount = 100, 
    @PaymentMethod = 'Cash', 
    @IncomeName = N'Payment for Order 5', 
    @PayerName = N'Customer B', 
    @IncomeTypeID = 1;

EXEC CreateOrderAndIncomeReceipt 
    @CustomerNotes = N'', 
    @TotalItemAmount = 1200, 
    @ShippingFee = 80, 
    @Discount = 0, 
    @PaymentMethod = 'Card', 
    @IncomeName = N'Payment for Order 6', 
    @PayerName = N'Customer', 
    @IncomeTypeID = 1;

-- Thêm nhiều dữ liệu vào RETURN_ORDER và EXPENSE_RECEIPT bằng thủ tục ReturnOrderAndCreateExpenseReceipt
EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 1, 
    @Reason = N'Damaged item', 
    @ReturnDescription = N'Item arrived broken', 
    @ExpenseName = N'Refund for Order 1', 
    @PayeeName = N'Customer', 
    @ExpenseTypeID = 6;

EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 2, 
    @Reason = N'Wrong item', 
    @ReturnDescription = N'Received a different product', 
    @ExpenseName = N'Refund for Order 2', 
    @PayeeName = N'Customer', 
    @ExpenseTypeID = 6;

EXEC ReturnOrderAndCreateExpenseReceipt 
    @OrderID = 3, 
    @Reason = N'Late delivery', 
    @ReturnDescription = N'', 
    @ExpenseName = N'Refund for Order 3', 
    @PayeeName = N'Customer', 
    @ExpenseTypeID = 6;


INSERT INTO VOUCHER_VALID_PERIOD (Voucher_ID, Voucher_Start_Date, Voucher_End_Date)
VALUES
(1, '2024-01-01', '2024-01-31'),
(2, '2024-02-01', '2024-02-28'),
(3, '2024-03-01', '2024-03-31'),
(4, '2024-04-01', '2024-04-30'),
(5, '2024-05-01', '2024-05-31'),
(6, '2024-06-01', '2024-06-30'),
(7, '2024-07-01', '2024-07-31'),
(8, '2024-08-01', '2024-08-31'),
(9, '2024-09-01', '2024-09-30'),
(10, '2024-10-01', '2024-10-31');

INSERT INTO APPLY_VOUCHER (Voucher_ID, Order_ID)
VALUES 
(1, 2), -- Voucher ID 1 được áp dụng cho Order ID 2
(3, 4),
(5, 6),
(7, 8),
(9, 10);

-- INSERT INTO INCLUDE_ITEM (Order_ID, Item_ID, Count)
-- VALUES
-- (1, 101, 2), -- Order 1 bao gồm 2 Item có ID 101
-- (1, 102, 1),
-- (2, 103, 5),
-- (3, 101, 3),
-- (4, 104, 4);

INSERT INTO INCHARGE_OF (Order_ID, ID_Card_Num)
VALUES
(1, '079304008477'), -- Sales Employee với ID Card phụ trách Order 1
(2, '079203478901'),
(3, '071201789032'),
(4, '082303567891'),
(5, '043202456981'); 

INSERT INTO PREPARE (Order_ID, ID_Card_Num)
VALUES
(1, '013201357468'), -- Packaging Employee với ID Card chuẩn bị Order 1
(2, '039203246789'),
(3, '062201345987'),
(4, '025301987643'),
(5, '012201320456');


INSERT INTO GET_FEEDBACK (Order_ID, ID_Card_Num)
VALUES
(1, '036302145769'), -- Customer Service Employee với ID Card nhận phản hồi cho Order 1
(2, '011201987654'),
(3, '061303543210'),
(4, '079201345678'), 
(5, '048203987654'); 

-- Dữ liệu insert supplier 
INSERT INTO SUPPLIER (SUPPLIER_NAME, SUPPLIER_EMAIL, SUPPLIER_PHONE, ADDRESS)
VALUES 
('Routine', 'contact@routine.vn', '0901234567', '77 Nguyen Trai, District 1, Ho Chi Minh City'),
('Hnoss', 'info@hnoss.vn', '0912345678', '88 Dong Khoi, District 1, Ho Chi Minh City'),
('Coolmate', 'support@coolmate.me', '0923456789', '100 Cach Mang Thang 8, District 3, Ho Chi Minh City'),
('Yody', 'hello@yody.vn', '0934567890', '20 Le Loi, Hai Chau District, Da Nang'),
('Canifa', 'sales@canifa.com', '0945678901', '50 Hang Bong, Hoan Kiem District, Hanoi'),
('Owen', 'contact@owen.vn', '0956789012', '25 Tran Hung Dao, District 5, Ho Chi Minh City'),
('Blue Exchange', 'info@blueexchange.vn', '0967890123', '15 Le Thanh Ton, District 1, Ho Chi Minh City'),
('Lime Orange', 'service@limeorange.vn', '0978901234', '99 Phan Dinh Phung, Phu Nhuan District, Ho Chi Minh City');

--Dữ liệu insert product
INSERT INTO PRODUCT (PRODUCT_NAME, BRAND, STYLE_TAG, SEASON, CATEGORY, DESCRIPTION)
VALUES
('Cotton T-Shirt', 'Routine', 'Casual', 'Summer', 'Clothing', 'Comfortable cotton t-shirt for everyday wear.'),
('Chiffon Dress', 'Hnoss', 'Elegant', 'Spring', 'Clothing', 'Lightweight chiffon dress for formal events.'),
('Polo Shirt', 'Coolmate', 'Classic', 'All Seasons', 'Clothing', 'Breathable polo shirt with modern fit.'),
('Jogger Pants', 'Yody', 'Sporty', 'Fall', 'Clothing', 'Stretchable jogger pants for active lifestyle.'),
('Jeans', 'Canifa', 'Denim', 'All Seasons', 'Clothing', 'Durable denim jeans with versatile styling.'),
('Business Shirt', 'Owen', 'Formal', 'Winter', 'Clothing', 'Elegant business shirt with wrinkle-resistant fabric.');


--Dữ liệu insert Item
INSERT INTO ITEM (SELLING_PRICE, SIZE, COLOR, STOCK, PRODUCT_ID)
VALUES
(199000, 'M', 'White', 150, 1),
(299000, 'S', 'Pink', 100, 2),
(250000, 'L', 'Black', 200, 3),
(350000, 'XL', 'Gray', 120, 4),
(500000, '32', 'Blue', 80, 5),
(400000, 'L', 'White', 50, 6);

--Dữ liệu product_set
INSERT INTO PRODUCT_SET (NAME, STYLE)
VALUES
('Summer Collection', 'Casual'),
('Winter Elegance', 'Formal'),
('Wind Breaker', 'Casual'),
('Sportwear Line', 'Sport');

--Dữ liệu combine
INSERT INTO COMBINE (PRODUCT_ID, SET_ID)
VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 3),
(6, 2);

--dữ liệu import_bill
INSERT INTO IMPORT_BILL (IMPORT_STATE, TOTAL_FEE)
VALUES
('Pending', 5000000),
('Completed', 10000000),
('Completed', 12000000),
('Completed', 1500000);

--dữ liệu import
INSERT INTO IMPORT (IMPORT_ID, ITEM_ID, SUPPLIER_ID, IMPORT_QUANTITY, IMPORT_PRICE)
VALUES
(1, 1, 1, 100, 180000),
(2, 2, 2, 50, 250000),
(2, 3, 3, 200, 230000),
(3, 4, 4, 120, 300000),
(3, 5, 5, 80, 450000),
(3, 6, 6, 50, 380000);

--dữ liệu return bill
INSERT INTO RETURN_BILL (REASON, REFUND_FEE)
VALUES
('Damaged during transport', 500000),
('Wrong item sent', 700000),
('Damaged during transport', 100000),
('Defective goods', 250000);

--dữ liệu return_item
INSERT INTO RETURN_ITEM (RETURN_ID, ITEM_ID, SUPPLIER_ID, RETURN_QUANTITY, RETURN_PRICE)
VALUES
(1, 1, 1, 5, 180000),
(2, 2, 2, 3, 250000), 
(3, 3, 3, 10, 100000), 
(4, 4, 4, 2, 125000); 


--dữ liệu reconcilation_form
INSERT INTO RECONCILIATION_FORM (CHECKED_DATE)
VALUES
('2024-01-01'),
('2024-01-15'),
('2024-02-01'),
('2024-02-15');

INSERT INTO RECONCILE (CHECK_ID, ITEM_ID, ID_CARD_NUM, ACTUAL_QUANTITY)
VALUES
(1, 1, '130044556677', 5),
(2, 2, '140055667788', 10),
(3, 3, '150066778899', 15),
(4, 4, '160077889900', 20);