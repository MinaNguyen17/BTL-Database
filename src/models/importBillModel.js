const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addImportBill(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddImportBill"); // Gọi stored procedure để thêm ImportBill
}

async function deleteImportBill(id) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.DeleteImportBill"); // Gọi stored procedure để xóa ImportBill
}

async function updateImportBill(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateImportBill"); // Gọi stored procedure để sửa ImportBill
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
		.input("id", sql.Int, id)
		.execute("dbo.GetImportBillById"); // Gọi stored procedure để lấy một ImportBill theo Id
	return result.recordset[0]; // Trả về ImportBill đầu tiên (nếu có)
}

module.exports = {
	getAllImportBills,
	getImportBillById,
	addImportBill,
	updateImportBill,
	deleteImportBill,
};
