const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addReturnBill(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddReturnBill"); // Gọi stored procedure để thêm ReturnBill
}

async function deleteReturnBill(id) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.DeleteReturnBill"); // Gọi stored procedure để xóa ReturnBill
}

async function updateReturnBill(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateReturnBill"); // Gọi stored procedure để sửa ReturnBill
}

async function getAllReturnBills() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllReturnBills"); // Gọi stored procedure để lấy tất cả ReturnBills
	return result.recordset; // Trả về danh sách tất cả ReturnBills
}

async function getReturnBillById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetReturnBillById"); // Gọi stored procedure để lấy một ReturnBill theo Id
	return result.recordset[0]; // Trả về ReturnBill đầu tiên (nếu có)
}

module.exports = {
	getAllReturnBills,
	getReturnBillById,
	addReturnBill,
	updateReturnBill,
	deleteReturnBill,
};
