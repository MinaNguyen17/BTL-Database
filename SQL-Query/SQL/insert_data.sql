----------------------------------------INSERT VALUE--------------------------------------------

-- 24 EMPLOYEE
INSERT INTO Person (ID_Card_Num, Fname, Lname, DOB)
VALUES
('123456789012', 'Nguyen Minh', 'Hoa', '1990-05-10'),
('987654321098', 'Tran Van', 'Binh', '1985-12-25'),
('222222221111', 'Nguyen Van', 'Minh', '1990-03-10'),
('332211445577', 'Tran Thi', 'Sau', '1985-11-14'),
('555555555555', 'Le Thi', 'Hanh', '1992-07-22'),
('666666666666', 'Pham Van', 'Phuc', '1987-04-18'),
('777777777777', 'Nguyen Thi', 'Dao', '1995-01-02'),
('888888888888', 'Do Hoang', 'Anh', '1989-09-15'),
('999999999999', 'Tran Thi', 'Hong', '1993-12-30'),
('112233445566', 'Nguyen Van', 'Tam', '1986-06-10'),
('223344556677', 'Pham Minh', 'Long', '1991-03-11'),
('334455667788', 'Le Hoang', 'Linh', '1988-08-19'),
('445566778899', 'Nguyen Thi', 'Trang', '1994-05-20'),
('556677889900', 'Tran Van', 'Hoa', '1983-11-22'),
('667788990011', 'Pham Thi', 'My', '1992-10-10'),
('778899001122', 'Do Van', 'Hung', '1987-12-15'),
('889900112233', 'Nguyen Thi', 'Lan', '1990-04-28'),
('990011223344', 'Le Van', 'Dung', '1995-07-07'),
('110022334455', 'Tran Hoang', 'Nam', '1986-01-30'),
('120033445566', 'Pham Thi', 'Hue', '1992-03-25'),
('130044556677', 'Nguyen Van', 'Hieu', '1990-08-18'),
('140055667788', 'Tran Minh', 'Quang', '1985-11-02'),
('150066778899', 'Le Thi', 'Kim', '1993-09-13'),
('160077889900', 'Pham Van', 'Cuong', '1994-02-24');
-- SELECT * FROM Person;

INSERT INTO Account (ID_Card_Num, Username, Password, Role, Status)
VALUES
('123456789012', 'NguyenMinhHoa012', 'hashed_password1', 'Admin', 'Active'),
('987654321098', 'TranVanBinh098', 'hashed_password2', 'Admin', 'Active'),
('222222221111', 'NguyenVanMinh111', 'hashed_password3', 'Admin', 'Active'),
('332211445577', 'TranThiSau577', 'hashed_password4', 'Employee', 'Active'),
('555555555555', 'LeThiHanh555', 'hashed_password5', 'Employee', 'Active'),
('666666666666', 'PhamVanPhuc666', 'hashed_password6', 'Employee', 'Active'),
('777777777777', 'NguyenThiDao777', 'hashed_password7', 'Employee', 'Active'),
('888888888888', 'DoHoangAnh888', 'hashed_password8', 'Employee', 'Active'),
('999999999999', 'TranThiHong999', 'hashed_password9', 'Employee', 'Active'),
('112233445566', 'NguyenVanTam566', 'hashed_password10', 'Employee', 'Active'),
('223344556677', 'PhamMinhLong677', 'hashed_password11', 'Employee', 'Active'),
('334455667788', 'LeHoangLinh788', 'hashed_password12', 'Employee', 'Active'),
('445566778899', 'NguyenThiTrang899', 'hashed_password13', 'Employee', 'Active'),
('556677889900', 'TranVanHoa900', 'hashed_password14', 'Employee', 'Active'),
('667788990011', 'PhamThiMy011', 'hashed_password15', 'Employee', 'Active'),
('778899001122', 'DoVanHung122', 'hashed_password16', 'Employee', 'Active'),
('889900112233', 'NguyenThiLan233', 'hashed_password17', 'Employee', 'Active'),
('990011223344', 'LeVanDung344', 'hashed_password18', 'Employee', 'Active'),
('110022334455', 'TranHoangNam455', 'hashed_password19', 'Employee', 'Active'),
('120033445566', 'PhamThiHue566', 'hashed_password20', 'Employee', 'Active'),
('130044556677', 'NguyenVanHieu677', 'hashed_password21', 'Employee', 'Active'),
('140055667788', 'TranMinhQuang788', 'hashed_password22', 'Employee', 'Active'),
('150066778899', 'LeThiKim899', 'hashed_password23', 'Employee', 'Active'),
('160077889900', 'PhamVanCuong900', 'hashed_password24', 'Employee', 'Active');
-- SELECT p.ID_Card_Num, p.Fname, p.Lname, a.Username, a.Password
-- FROM Person p
-- JOIN Account a ON p.ID_Card_Num = a.ID_Card_Num;

INSERT INTO EMPLOYEE (ID_Card_Num, Position, Wage)
VALUES
('123456789012', 'Senior', 35000),  -- Admin -> Senior
('987654321098', 'Senior', 30000),  -- Admin -> Senior
('222222221111', 'Senior', 35000),  -- Admin -> Senior
('332211445577', 'Senior', 30000), 
('555555555555', 'Junior', 25000), 
('666666666666', 'Junior', 25000),
('777777777777', 'Junior', 25000), 
('888888888888', 'Senior', 35000), 
('999999999999', 'Junior', 25000), 
('112233445566', 'Senior', 30000), 
('223344556677', 'Junior', 25000), 
('334455667788', 'Junior', 25000), 
('445566778899', 'Senior', 35000), 
('556677889900', 'Junior', 25000), 
('667788990011', 'Senior', 30000), 
('778899001122', 'Junior', 25000), 
('889900112233', 'Junior', 25000), 
('990011223344', 'Senior', 30000), 
('110022334455', 'Senior', 35000), 
('120033445566', 'Junior', 25000), 
('130044556677', 'Junior', 25000), 
('140055667788', 'Senior', 30000), 
('150066778899', 'Junior', 25000), 
('160077889900', 'Senior', 35000);

-- SELECT * FROM Employee;

INSERT INTO Working_Period (ID_Card_Num, Start_Date, End_Date)
VALUES 
('123456789012', '2024-01-01', '2024-06-30'), 
('987654321098', '2024-01-01', '2024-12-31'), 
('222222221111', '2024-02-01', '2024-08-31'), 
('332211445577', '2024-03-01', '2024-09-30'),
('123456789012', '2022-01-01', '2023-06-30'), 
('332211445577', '2020-03-01', '2021-12-30');

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

INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (1, '123456789012'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (1, '987654321098'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (2, '222222221111');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (2, '332211445577'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '555555555555');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '666666666666');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (3, '777777777777'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (4, '999999999999');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (4, '112233445566'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (5, '223344556677');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (5, '334455667788'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (6, '445566778899'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (7, '889900112233'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (8, '130044556677'); 
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (9, '150066778899');
INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES (9, '160077889900');

-- KHONG CHEN CUNG LUC DUOC
-- INSERT INTO WORK_ON (Shift_ID, ID_Card_Num) VALUES 
-- (5, '223344556677'),
-- (5, '332211445577'),
-- (5, '555555555555'); 

-- SELECT * FROM WORK_ON;
GO

-- Insert 5 employees into SALES_EMPLOYEE
INSERT INTO SALES_EMPLOYEE (ID_Card_Num)
VALUES
('123456789012'),
('987654321098'),
('222222221111'),
('332211445577'),
('555555555555');

-- SELECT * FROM SALES_EMPLOYEE S JOIN EMPLOYEE E ON S.ID_Card_Num = E.ID_Card_Num;

INSERT INTO SUPERVISE (Supervisor_ID, Supervisee_ID)
VALUES
('123456789012', '222222221111'),
('123456789012', '987654321098'),
('123456789012', '332211445577'),
('222222221111', '555555555555');

-- Insert 5 employees into PACKAGING_EMPLOYEE
INSERT INTO PACKAGING_EMPLOYEE (ID_Card_Num)
VALUES
('666666666666'),
('777777777777'),
('888888888888'),
('999999999999'),
('112233445566');

SELECT * FROM PACKAGING_EMPLOYEE;

-- Insert 5 employees into CUSTOMERSERVICE_EMPLOYEE
INSERT INTO CUSTOMERSERVICE_EMPLOYEE (ID_Card_Num)
VALUES
('223344556677'),
('334455667788'),
('445566778899'),
('556677889900'),
('667788990011');

SELECT * FROM CUSTOMERSERVICE_EMPLOYEE;

-- Insert 5 employees into ACCOUNTING_EMPLOYEE
INSERT INTO ACCOUNTING_EMPLOYEE (ID_Card_Num)
VALUES
('778899001122'),
('889900112233'),
('990011223344'),
('110022334455'),
('120033445566');

SELECT * FROM ACCOUNTING_EMPLOYEE;

-- Insert 4 employees into WAREHOUSE_EMPLOYEE
INSERT INTO WAREHOUSE_EMPLOYEE (ID_Card_Num)
VALUES
('130044556677'),
('140055667788'),
('150066778899'),
('160077889900');

SELECT * FROM WAREHOUSE_EMPLOYEE;

INSERT INTO EXPENSE_TYPE ([Name]) VALUES
('Inventory Purchase'),
('Rent'),
('Salaries'),
('Utilities'),
('Marketing');

INSERT INTO EXPENSE_RECEIPT ([Name], [Date], Amount, Payee_Name, Expense_Type_ID) VALUES
('Purchase of Winter Collection', '2024-12-01', 10000000, 'Fashion Supplier', 1),
('Store Rent for December', '2024-12-01', 25000000, 'Landlord', 2),
('Salary Payment for December', '2024-12-01', 20000000, 'Employee', 3),
('Electricity Bill', '2024-12-02', 1000000, 'Electricity Provider', 4),
('Facebook Ads Campaign', '2024-12-02', 5000000, 'Ad Agency', 5);

SELECT * FROM EXPENSE_RECEIPT R JOIN EXPENSE_TYPE T ON R.Expense_Type_ID = T.Expense_Type_ID

INSERT INTO INCOME_TYPE ([Name]) VALUES
('Sales Revenue'),
('Inventory Returns');

-- Insert 5 sample records into INCOME_RECEIPT (Income related to the fashion store)
INSERT INTO INCOME_RECEIPT ([Name], [Date], Amount, Payer_Name, Income_Type_ID) VALUES
('Sale of Order', '2024-12-01', 2000000, 'Customer A', 1),
('Return of Faulty Shoes', '2024-12-02', 1000000, 'Supplier B', 2),
('Return of Faulty Dresses', '2024-12-02', 10000000, 'Supplier G', 2),
('Sale of Order', '2024-11-11', 5000000, 'Customer X', 1);



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
('123456789012', 'Member'),
('987654321098', 'Silver'),
('112233445566', 'Gold'),
('223344556677', 'Platinum'),
('334455667788', 'Diamond'),
('445566778899', 'Silver'),
('556677889900', 'Gold'),
('667788990011', 'Platinum'),
('778899001122', 'Diamond'),
('889900112233', 'Member');

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
('123456789012', 1, '12B', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi', 'Nguyen Van', 'Hoa', '0123456789'),
('987654321098', 2, '45C', 'Le Duan', 'Dong Da', 'Ha Noi', 'Tran Van', 'Binh', '0987654321'),
('112233445566', 3, '78A', 'Tran Phu', 'Ha Dong', 'Ha Noi', 'Nguyen Van', 'Tam', '0912345678'),
('223344556677', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi', 'Pham Minh', 'Long', '0945678912'),
('334455667788', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi', 'Le Hoang', 'Linh', '0934567890'),
('445566778899', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi', 'Nguyen Thi', 'Trang', '0923456781'),
('556677889900', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi', 'Tran Van', 'Hoa', '0912345679'),
('667788990011', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi', 'Pham Thi', 'My', '0901234567'),
('778899001122', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi', 'Do Van', 'Hung', '0987654322'),
('889900112233', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi', 'Nguyen Thi', 'Lan', '0945678923');

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
-- (101, '123456789012', 1, '12A', 'Nguyen Trai', 'Thanh Xuan', 'Ha Noi'),
-- (102, '987654321098', 2, '45B', 'Le Duan', 'Dong Da', 'Ha Noi'),
-- (103, '112233445566', 3, '78C', 'Tran Phu', 'Ha Dong', 'Ha Noi'),
-- (104, '223344556677', 4, '32D', 'Pham Van Dong', 'Cau Giay', 'Ha Noi'),
-- (105, '334455667788', 5, '89E', 'Hoang Hoa Tham', 'Ba Dinh', 'Ha Noi'),
-- (106, '445566778899', 6, '123A', 'Kim Ma', 'Ba Dinh', 'Ha Noi'),
-- (107, '556677889900', 7, '456B', 'Ho Tung Mau', 'Nam Tu Liem', 'Ha Noi'),
-- (108, '667788990011', 8, '789C', 'Trung Kinh', 'Cau Giay', 'Ha Noi'),
-- (109, '778899001122', 9, '321D', 'Le Hong Phong', 'Ha Dong', 'Ha Noi'),
-- (110, '889900112233', 10, '654E', 'Giai Phong', 'Hoang Mai', 'Ha Noi');

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
INSERT INTO [ORDER] (Discount, Payment_Method, Shipping_Fee, Order_Status, Total_Item_Amount, Customer_Notes)
VALUES 
(10, 'Cash', 20, 'Shipped', 3, 'Please deliver in the morning'),
(15, 'Card', 25, 'Preparing', 5, 'Fragile item, handle with care'),
(5, 'Online', 15, 'Completed', 2, NULL),
(20, 'Cash', 10, 'Cancelled', 0, 'Out of stock'),
(0, 'Online', 5, 'Preparing', 1, NULL),
(30, 'Card', 35, 'Shipped', 6, 'Gift wrap required'),
(0, 'Online', 0, 'Completed', 4, 'Deliver to reception'),
(25, 'Cash', 20, 'Shipped', 7, 'Urgent delivery needed'),
(10, 'Online', 10, 'Completed', 5, NULL),
(15, 'Card', 30, 'Cancelled', 0, 'Address not found');


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

INSERT INTO RETURN_ORDER (Reason, Return_Description, Return_Status, Order_ID)
VALUES
('Damaged item', 'Item arrived broken', 'Approved', 1),
('Wrong item', 'Received a different product', 'Under consideration', 2),
('Change of mind', '', 'Rejected', 3),
('Late delivery', '', 'Approved', 4);

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
(3, 4), -- Voucher ID 3 được áp dụng cho Order ID 4
(5, 6), -- Voucher ID 5 được áp dụng cho Order ID 6
(7, 8), -- Voucher ID 7 được áp dụng cho Order ID 8
(9, 10); -- Voucher ID 9 được áp dụng cho Order ID 10

-- Giả định ITEM và ORDER đã có dữ liệu.
INSERT INTO INCLUDE_ITEM (Order_ID, Item_ID, Count)
VALUES
(1, 101, 2), -- Order 1 bao gồm 2 Item có ID 101
(1, 102, 1), -- Order 1 bao gồm 1 Item có ID 102
(2, 103, 5), -- Order 2 bao gồm 5 Item có ID 103
(3, 101, 3), -- Order 3 bao gồm 3 Item có ID 101
(4, 104, 4); -- Order 4 bao gồm 4 Item có ID 104
