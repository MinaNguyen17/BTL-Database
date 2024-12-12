const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addImportBill(itemID, supplierID, importQuantity, importPrice, totalFee) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("ItemID", sql.Int, itemID)
		.input("SupplierID", sql.Int, supplierID)
		.input("ImportQuantity", sql.Int, importQuantity)
		.input("ImportPrice", sql.Decimal(10, 2), importPrice)
		.input("TotalFee", sql.Decimal(10, 2), totalFee)
		.execute("dbo.ImportItemDetails"); // Gọi stored procedure để thêm ImportBill
	console.log("Hello2");
}

async function deleteImportBill(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteImportBill"); // Gọi stored procedure để xóa ImportBill
}

async function updateImportBill(id, newState) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("ImportID", sql.Int, id)
		.input("NewState", sql.VarChar(30), newState)
		.execute("dbo.UpdateImportBillState"); // Gọi stored procedure để sửa ImportBill
}

async function updateStockOnImport(id) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("Import_ID", sql.Int, id)
		.execute("dbo.UpdateStockOnImport"); // Gọi stored procedure để sửa ImportBill
}

async function getAllImportBills() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllImportBills"); // Gọi stored procedure để lấy tất cả ImportBills
	return result.recordset; // Trả về danh sách tất cả ImportBills
}

async function getImportBillById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("ImportID", sql.Int, id)
		.execute("dbo.GetImportBillById"); // Gọi stored procedure để lấy một ImportBill theo Id
	return result.recordset[0]; // Trả về ImportBill đầu tiên (nếu có)
}

module.exports = {
	getAllImportBills,
	getImportBillById,
	addImportBill,
	updateImportBill,
	deleteImportBill,
	updateStockOnImport,
};
