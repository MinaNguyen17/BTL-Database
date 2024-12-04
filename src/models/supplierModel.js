const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addSupplier(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddSupplier"); // Gọi stored procedure để thêm Supplier
}

async function deleteSupplier(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteSupplier"); // Gọi stored procedure để xóa Supplier
}

async function updateSupplier(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateSupplier"); // Gọi stored procedure để sửa Supplier
}

async function getAllSuppliers() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllSuppliers"); // Gọi stored procedure để lấy tất cả Suppliers
	return result.recordset; // Trả về danh sách tất cả Suppliers
}

async function getSupplierById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetSupplierById"); // Gọi stored procedure để lấy một Supplier theo Id
	return result.recordset[0]; // Trả về Supplier đầu tiên (nếu có)
}

module.exports = {
	getAllSuppliers,
	getSupplierById,
	addSupplier,
	updateSupplier,
	deleteSupplier,
};
