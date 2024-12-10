const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addShift(Shift_Type, Date, E_Num, Rate) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("Shift_Type", sql.Char(1), Shift_Type)
		.input("Date", sql.Date, Date)
		.input("E_Num", sql.Int, E_Num)
		.input("Rate", sql.Decimal(5,2), Rate)
		.execute("dbo.AddShift"); // Gọi stored procedure để thêm Shift
}

async function deleteShift(Shift_ID) {
	const pool = await getDBConnection();
	await pool.request().input("Shift_ID", sql.Int, Shift_ID).execute("dbo.DeleteShift"); // Gọi stored procedure để xóa Shift
}

async function updateShift(Shift_ID, Shift_Type, Date, E_Num, Rate) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("Shift_ID", sql.Int, Shift_ID)
		.input("Shift_Type", sql.Char(1), Shift_Type)
		.input("Date", sql.Date, Date)
		.input("E_Num", sql.Int, E_Num)
		.input("Rate", sql.Decimal(5,2), Rate)
		.execute("dbo.UpdateShift"); // Gọi stored procedure để sửa Shift
}

async function getAllShifts() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllShifts"); // Gọi stored procedure để lấy tất cả Shifts
	return result.recordset; // Trả về danh sách tất cả Shifts
}

async function getShiftById(Shift_ID) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("Shift_ID", sql.Int, Shift_ID)
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
