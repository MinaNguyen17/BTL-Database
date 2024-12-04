const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addShift(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddShift"); // Gọi stored procedure để thêm Shift
}

async function deleteShift(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteShift"); // Gọi stored procedure để xóa Shift
}

async function updateShift(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateShift"); // Gọi stored procedure để sửa Shift
}

async function getAllShifts() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllShifts"); // Gọi stored procedure để lấy tất cả Shifts
	return result.recordset; // Trả về danh sách tất cả Shifts
}

async function getShiftById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetShiftById"); // Gọi stored procedure để lấy một Shift theo Id
	return result.recordset[0]; // Trả về Shift đầu tiên (nếu có)
}

module.exports = {
	getAllShifts,
	getShiftById,
	addShift,
	updateShift,
	deleteShift,
};
