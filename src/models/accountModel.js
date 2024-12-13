const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");
const bcrypt = require("bcrypt");

const addAccount = async (idCardNum, role) => {
	try {
		const pool = await getDBConnection();

		const account = await pool
			.request()
			.input("ID_Card_Num", sql.Char(12), idCardNum)
			.input("Role", sql.Char(20), role)
			.execute("CreateAccount");

		const { Username } = account.recordset[0];

		// Hash the password
		const hashedPassword = await bcrypt.hash(Username, 10);

		// Update the password with the hashed version
		await pool
			.request()
			.input("Username", sql.VarChar(100), Username)
			.input("NewPassword", sql.VarChar(255), hashedPassword)
			.execute("UpdateAccount");

		return { username: Username, role };
	} catch (error) {
		throw new Error(error.message || "Lỗi khi tạo và hash mật khẩu.");
	}
};

// async function updateAccount(id, role, status) {
// 	const pool = await getDBConnection();
// 	await pool
// 		.request()
// 		.input("Account_ID", sql.Int, id)
// 		.input("Role", sql.Char(20), role)
// 		.input("Status", sql.VarChar(20), status)
// 		.execute("dbo.updateAccount"); // Gọi stored procedure để xóa Account
// }

async function changePassword(username, password) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("Username", sql.VarChar(100), username)
		.input("NewPassword", sql.VarChar(255), password)
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
		.input("AccountID", sql.Int, id)
		.execute("dbo.GetAccountById"); // Gọi stored procedure để lấy một Account theo Id
	return result.recordset[0]; // Trả về Account đầu tiên (nếu có)
}

async function getAccountByUsername(username) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("Username", sql.VarChar(100), username)
		.execute("dbo.GetAccountByUsername"); // Gọi stored procedure để lấy một Account theo Id
	return result.recordset[0]; // Trả về Account đầu tiên (nếu có)
}

module.exports = {
	getAllAccounts,
	getAccountById,
	addAccount,
	changePassword,
	// updateAccount,
	getAccountByUsername,
};
