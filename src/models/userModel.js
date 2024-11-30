const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

// Hàm lấy tất cả users
async function getAllUsers() {
	const pool = getDBConnection();
	const result = await pool.request().query("SELECT * FROM Users");
	return result.recordset;
}

// Hàm thêm user
async function addUser(name, email) {
	const pool = getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.query("INSERT INTO Users (Name, Email) VALUES (@name, @email)");
}

module.exports = {
	getAllUsers,
	addUser,
};
