const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addSupplier(SUPPLIER_NAME, SUPPLIER_EMAIL, SUPPLIER_PHONE, ADDRESS) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("SUPPLIER_NAME", sql.VarChar(30), SUPPLIER_NAME)
		.input("SUPPLIER_EMAIL", sql.VarChar(30), SUPPLIER_EMAIL)
		.input("SUPPLIER_PHONE", sql.VarChar(20), SUPPLIER_PHONE)
		.input("ADDRESS", sql.VarChar(100), ADDRESS)
		.execute("dbo.AddSupplier"); // Gọi stored procedure để thêm Supplier
}

async function deleteSupplier(SUPPLIER_ID) {
	const pool = await getDBConnection();
	await pool.request().input("SUPPLIER_ID", sql.Int, SUPPLIER_ID).execute("dbo.DeleteSupplier"); // Gọi stored procedure để xóa Supplier
}

async function updateSupplier(SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_EMAIL, SUPPLIER_PHONE, ADDRESS) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("SUPPLIER_ID", sql.Int, SUPPLIER_ID)
		.input("SUPPLIER_NAME", sql.VarChar(30), SUPPLIER_NAME)
		.input("SUPPLIER_EMAIL", sql.VarChar(30), SUPPLIER_EMAIL)
		.input("SUPPLIER_PHONE", sql.VarChar(20), SUPPLIER_PHONE)
		.input("ADDRESS", sql.VarChar(100), ADDRESS)
		.execute("dbo.UpdateSupplier"); // Gọi stored procedure để sửa Supplier
}

async function getAllSuppliers() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllSuppliers"); // Gọi stored procedure để lấy tất cả Suppliers
	return result.recordset; // Trả về danh sách tất cả Suppliers
}

async function getSupplierById(SUPPLIER_ID) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("SUPPLIER_ID", sql.Int, SUPPLIER_ID)
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
