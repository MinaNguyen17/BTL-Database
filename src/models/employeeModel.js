const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addEmployee(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddEmployee"); // Gọi stored procedure để thêm Employee
}

async function deleteEmployee(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteEmployee"); // Gọi stored procedure để xóa Employee
}

async function updateEmployee(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateEmployee"); // Gọi stored procedure để sửa Employee
}

async function getAllEmployees() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllEmployees"); // Gọi stored procedure để lấy tất cả Employees
	return result.recordset; // Trả về danh sách tất cả Employees
}

async function getEmployeeById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetEmployeeById"); // Gọi stored procedure để lấy một Employee theo Id
	return result.recordset[0]; // Trả về Employee đầu tiên (nếu có)
}

module.exports = {
	getAllEmployees,
	getEmployeeById,
	addEmployee,
	updateEmployee,
	deleteEmployee,
};
