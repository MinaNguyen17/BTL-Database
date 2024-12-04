const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addItem(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddItem"); // Gọi stored procedure để thêm Item
}

async function deleteItem(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteItem"); // Gọi stored procedure để xóa Item
}

async function updateItem(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateItem"); // Gọi stored procedure để sửa Item
}

async function getAllItems() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllItems"); // Gọi stored procedure để lấy tất cả Items
	return result.recordset; // Trả về danh sách tất cả Items
}

async function getItemById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetItemById"); // Gọi stored procedure để lấy một Item theo Id
	return result.recordset[0]; // Trả về Item đầu tiên (nếu có)
}

module.exports = {
	getAllItems,
	getItemById,
	addItem,
	updateItem,
	deleteItem,
};
