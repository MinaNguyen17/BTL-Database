DROP TABLE IF EXISTS HANDLE;
DROP TABLE IF EXISTS GET_FEEDBACK;
DROP TABLE IF EXISTS PREPARE;
DROP TABLE IF EXISTS INCHARGE_OF;
DROP TABLE IF EXISTS INCLUDE_ITEM;
DROP TABLE IF EXISTS VOUCHER_VALID_PERIOD;
DROP TABLE IF EXISTS COMBINE;
DROP TABLE IF EXISTS PRODUCT_SET;
DROP TABLE IF EXISTS RECONCILE;
DROP TABLE IF EXISTS RECONCILIATION_FORM;
DROP TABLE IF EXISTS RETURN_ITEM;
DROP TABLE IF EXISTS RETURN_BILL;
DROP TABLE IF EXISTS IMPORT;
DROP TABLE IF EXISTS IMPORT_BILL;
DROP TABLE IF EXISTS INVENTORY_REPORT;
DROP TABLE IF EXISTS REVENUE_REPORT_BY_ITEM;
DROP TABLE IF EXISTS SUMMARIZE;
DROP TABLE IF EXISTS PLACE;
DROP TABLE IF EXISTS OF_GROUP;
DROP TABLE IF EXISTS RECEIVER_INFO;
DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS CUSTOMER_GROUP;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS SUPPLIER;
DROP TABLE IF EXISTS EXPENSE_TYPE;
DROP TABLE IF EXISTS EXPENSE_RECEIPT;
DROP TABLE IF EXISTS INCOME_TYPE;
DROP TABLE IF EXISTS INCOME_RECEIPT;
DROP TABLE IF EXISTS MANAGE_EXPENSE;
DROP TABLE IF EXISTS MANAGE_INCOME;
DROP TABLE IF EXISTS PROFIT_AND_LOSS_STATEMENT;
DROP TABLE IF EXISTS APPLY_VOUCHER;
DROP TABLE IF EXISTS RETURN_ORDER;
DROP TABLE IF EXISTS DELIVERY_INFO;
DROP TABLE IF EXISTS [ORDER];
DROP TABLE IF EXISTS SALARY;
DROP TABLE IF EXISTS WORK_ON;
DROP TABLE IF EXISTS SHIFT;
DROP TABLE IF EXISTS WORKING_PERIOD;
DROP TABLE IF EXISTS SUPERVISE;
DROP TABLE IF EXISTS SALES_EMPLOYEE;
DROP TABLE IF EXISTS PACKAGING_EMPLOYEE;
DROP TABLE IF EXISTS CUSTOMERSERVICE_EMPLOYEE;
DROP TABLE IF EXISTS ACCOUNTING_EMPLOYEE;
DROP TABLE IF EXISTS WAREHOUSE_EMPLOYEE;
DROP TABLE IF EXISTS EXPENSE_TYPE;
DROP TABLE IF EXISTS PERSON;
DROP TABLE IF EXISTS ACCOUNT;
DROP TABLE IF EXISTS EMPLOYEE;

-- Drop các sequence nếu có
DROP SEQUENCE IF EXISTS EmpID_Sequence;

SELECT table_name 
FROM information_schema.tables 
WHERE table_type = 'BASE TABLE' AND table_schema = 'dbo';

-- Xóa Proceduce

DROP PROCEDURE dbo.GetAllItems, dbo.GetItemById, AddItem, UpdateItem, GetAllReturnBills, AddReturnBill, GetReturnBillById, GetAllImportBills, GetImportBillById, UpdateImportBillState, ImportItemDetails, UpdateStockOnImport;
