const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addItem(sellingPrice, size, color, productID) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("SellingPrice", sql.Decimal(10, 2), sellingPrice)
		.input("Size", sql.VarChar(10), size)
		.input("Color", sql.VarChar(10), color)
		.input("ProductID", sql.Int, productID)
		.execute("dbo.AddItem"); // Gọi stored procedure để thêm Item
}

async function deleteItem(id) {
	// const pool = await getDBConnection();
	// await pool.request().input("id", sql.Int, id).execute("dbo.DeleteItem"); // Gọi stored procedure để xóa Item
	console.log("Not implement");
}

async function updateItem(id, sellingPrice, size, color, stock, productID) {
	const pool = await getDBConnection();
	await pool
		.request()
		.input("ItemId", sql.Int, id)
		.input("SellingPrice", sql.Decimal(10, 2), sellingPrice)
		.input("Size", sql.VarChar(10), size)
		.input("Color", sql.VarChar(10), color)
		.input("Stock", sql.Int, stock)
		.input("ProductID", sql.Int, productID)
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
		.input("ItemId", sql.Int, id)
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
