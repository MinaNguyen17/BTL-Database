const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addProduct(name, brand, style_tag, season, category, description) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("PRODUCT_NAME", sql.VarChar(30), name)
		.input("BRAND", sql.VarChar(30), brand)
		.input("STYLE_TAG", sql.VarChar(30), style_tag)
		.input("SEASON", sql.VarChar(30), season)
		.input("CATEGORY", sql.VarChar(30), category)
		.input("DESCRIPTION", sql.Text, description)
		.execute("dbo.AddProduct"); // Gọi stored procedure để thêm Product
}

async function deleteProduct(id) {
	// const pool = await getDBConnection();
	// await pool.request().input("id", sql.Int, id).execute("dbo.DeleteProduct"); // Gọi stored procedure để xóa Product
	console.log("Not Implement");
}

async function updateProduct(id, name, brand, style_tag, season, category, description) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("PRODUCT_ID", sql.Int, id)
		.input("PRODUCT_NAME", sql.VarChar(30), name)
		.input("BRAND", sql.VarChar(30), brand)
		.input("STYLE_TAG", sql.VarChar(30), style_tag)
		.input("SEASON", sql.VarChar(30), season)
		.input("CATEGORY", sql.VarChar(30), category)
		.input("DESCRIPTION", sql.Text, description)
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
		.input("ProductID", sql.Int, id)
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
