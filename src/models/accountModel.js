const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addAccount(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddAccount"); // Gọi stored procedure để thêm Account
}

async function deleteAccount(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteAccount"); // Gọi stored procedure để xóa Account
}

async function updateAccount(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateAccount"); // Gọi stored procedure để sửa Account
}

async function getAllAccounts() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllAccounts"); // Gọi stored procedure để lấy tất cả Accounts
	return result.recordset; // Trả về danh sách tất cả Accounts
}

async function getAccountById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetAccountById"); // Gọi stored procedure để lấy một Account theo Id
	return result.recordset[0]; // Trả về Account đầu tiên (nếu có)
}

module.exports = {
	getAllAccounts,
	getAccountById,
	addAccount,
	updateAccount,
	deleteAccount,
};
