const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addReturnBill(reason, refundFee, itemId, supplierId, returnQuantity, returnPrice) {
    const pool = await getDBConnection();
    await pool
        .request()
        .input("Reason", sql.Text, reason)
        .input("RefundFee", sql.Decimal(10, 2), refundFee)
        .input("ItemID", sql.Int, itemId)
        .input("SupplierID", sql.Int, supplierId)
        .input("ReturnQuantity", sql.Int, returnQuantity)
        .input("ReturnPrice", sql.Decimal(10, 2), returnPrice)
        .execute("dbo.AddReturnBill"); // Gọi stored procedure để thêm ReturnBill
}


// async function deleteReturnBill(id) {
// 	const pool = await getDBConnection();
// 	await pool
// 		.request()
// 		.input("id", sql.Int, id)
// 		.execute("dbo.DeleteReturnBill"); // Gọi stored procedure để xóa ReturnBill
// }

// async function updateReturnBill(id, name, email) {
// 	const pool = await getDBConnection();
// 	await pool
// 		.request()
// 		.input("id", sql.Int, id)
// 		.input("name", sql.NVarChar, name)
// 		.input("email", sql.NVarChar, email)
// 		.execute("dbo.UpdateReturnBill"); // Gọi stored procedure để sửa ReturnBill
// }

async function getAllReturnBills() {
    const pool = await getDBConnection();
    const result = await pool.request().execute("dbo.GetAllReturnBills"); 
    return result.recordset; 
}


async function getReturnBillById(returnId) {
    const pool = await getDBConnection();
    const result = await pool
        .request()
        .input("ReturnID", sql.Int, returnId)
        .execute("dbo.GetReturnBillById"); 
    return result.recordset[0]; 
}


module.exports = {
	getAllReturnBills,
	getReturnBillById,
	addReturnBill,
};
