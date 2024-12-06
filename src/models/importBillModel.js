const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

// async function addImportBill(name, email) {
// 	const pool = await getDBConnection();
// 	await pool
// 		.request()
// 		.input("name", sql.NVarChar, name)
// 		.input("email", sql.NVarChar, email)
// 		.execute("dbo.AddImportBill"); // Gọi stored procedure để thêm ImportBill
// }

async function addImportBill(itemID, supplierID, importQuantity, importPrice, totalFee){
    try {
        // Kết nối đến cơ sở dữ liệu
        const pool = await getDBConnection();

        // Gọi stored procedure ImportItemDetails
        await pool
            .request()
            .input('ItemID', sql.Int, itemID) // Truyền ID của item
            .input('SupplierID', sql.Int, supplierID) // Truyền ID của nhà cung cấp
            .input('ImportQuantity', sql.Int, importQuantity) // Truyền số lượng nhập
            .input('ImportPrice', sql.Decimal(10, 2), importPrice) // Truyền giá nhập
            .input('TotalFee', sql.Decimal(10, 2), totalFee) // Truyền tổng phí nhập hàng
            .execute('ImportItemDetails'); // Gọi stored procedure

        console.log(`Item ${itemID} imported successfully with quantity: ${importQuantity}`);
    } catch (err) {
        console.error('Error importing item details:', err);
    }
}

// async function deleteImportBill(id) {
// 	const pool = await getDBConnection();
// 	await pool
// 		.request()
// 		.input("id", sql.Int, id)
// 		.execute("dbo.DeleteImportBill"); // Gọi stored procedure để xóa ImportBill
// }

async function updateImportBill(id, status) {
    const pool = await getDBConnection();
    try {
        await pool
            .request()
            .input("ImportID", sql.Int, id) // ID của Import Bill cần cập nhật
            .input("NewState", sql.NVarChar, status) // Trạng thái mới (e.g., 'Confirmed')
            .execute("UpdateImportBillState"); // Stored Procedure cập nhật trạng thái
        console.log(`Successfully updated Import Bill with ID ${id} to status: ${status}`);
    } catch (error) {
        console.error("Error updating Import Bill:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}
//
//await updateImportBill(1, 'Confirmed');



async function getAllImportBills() {
    const pool = await getDBConnection();
    try {
        const result = await pool.request().execute("GetAllImportBills"); // Gọi stored procedure
        return result.recordset; // Trả về danh sách Import Bills
    } catch (error) {
        console.error("Error fetching all Import Bills:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}

// const bills = await getAllImportBills();
// console.log(bills);



async function getImportBillById(id) {
    const pool = await getDBConnection();
    try {
        const result = await pool
            .request()
            .input("ImportID", sql.Int, id) // Truyền tham số @ImportID cho stored procedure
            .execute("dbo.GetImportBillById"); // Stored Procedure để lấy thông tin Import Bill
        if (result.recordset.length > 0) {
            return result.recordset[0]; // Trả về Import Bill đầu tiên (nếu có)
        } else {
            throw new Error(`Import Bill with ID ${id} not found.`);
        }
    } catch (error) {
        console.error("Error fetching Import Bill by ID:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}

// const bill = await getImportBillById(1);
// console.log(bill);



module.exports = {
	getAllImportBills,
	getImportBillById,
	addImportBill,
	updateImportBill,
};
