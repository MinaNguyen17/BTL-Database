const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addProduct(name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.AddProduct"); // Gọi stored procedure để thêm Product
}

async function deleteProduct(id) {
	const pool = await getDBConnection();
	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteProduct"); // Gọi stored procedure để xóa Product
}

async function updateProduct(id, name, email) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("id", sql.Int, id)
		.input("name", sql.NVarChar, name)
		.input("email", sql.NVarChar, email)
		.execute("dbo.UpdateProduct"); // Gọi stored procedure để sửa Product
}

async function getAllProducts() {
	const pool = await getDBConnection();
	const result = await pool.request().execute("dbo.GetAllProducts"); // Gọi stored procedure để lấy tất cả Products
	return result.recordset; // Trả về danh sách tất cả Products
}

async function getProductById(id) {
	const pool = await getDBConnection();
	const result = await pool
		.request()
		.input("id", sql.Int, id)
		.execute("dbo.GetProductById"); // Gọi stored procedure để lấy một Product theo Id
	return result.recordset[0]; // Trả về Product đầu tiên (nếu có)
}
module.exports = {
	getAllProducts,
	getProductById,
	addProduct,
	updateProduct,
	deleteProduct,
};
