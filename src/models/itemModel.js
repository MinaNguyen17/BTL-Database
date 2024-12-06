const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addItem(sellingPrice, size, color, stock, productId) {
    try {
        // Lấy kết nối tới DB
        const pool = await getDBConnection();
        const result = await pool
            .request() // Tạo request mới
            .input("SellingPrice", sql.Decimal(10, 2), sellingPrice)
            .input("Size", sql.VarChar(10), size)
            .input("Color", sql.VarChar(10), color)
            .input("Stock", sql.Int, stock)
            .input("ProductID", sql.Int, productId)
            .execute("AddItem"); // Thực thi stored procedure 'AddItem'

        console.log('Đã thêm Item', result);
        return result; 
    } catch (err) {
        console.error('Error adding item:', err);
        throw err; // Ném lỗi nếu có lỗi xảy ra
    }
}

// Ví dụ sử dụng hàm addItem
// addItem('T-shirt', 200000, 'M', 'Red', 100, 1)
//     .then(result => {
//         console.log('Item added:', result);
//     })
//     .catch(error => {
//         console.error('Error:', error);
//     });

// async function deleteItem(id) {
// 	const pool = await getDBConnection();
// 	await pool.request().input("id", sql.Int, id).execute("dbo.DeleteItem"); // Gọi stored procedure để xóa Item
// }

async function updateItem(itemId, sellingPrice, size, color, stock, productId) {
    const pool = await getDBConnection();
    try {
        await pool
            .request()
            .input("ItemId", sql.Int, itemId) // ID của Item cần cập nhật
            .input("SellingPrice", sql.Decimal(10, 2), sellingPrice) // Giá bán mới
            .input("Size", sql.VarChar(10), size) // Kích thước mới
            .input("Color", sql.VarChar(10), color) // Màu sắc mới
            .input("Stock", sql.Int, stock) // Số lượng mới
            .input("ProductId", sql.Int, productId) // ID sản phẩm liên quan
            .execute("UpdateItem"); // Stored Procedure cập nhật Item
        console.log(`Successfully updated Item with ID ${itemId}`);
    } catch (error) {
        console.error("Error updating Item:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}


async function getAllItems() {
    const pool = await getDBConnection();
    try {
        const result = await pool.request().execute("dbo.GetAllItems"); // Gọi stored procedure lấy tất cả Items
        return result.recordset; // Trả về danh sách Items
    } catch (error) {
        console.error("Error fetching all Items:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}

async function getItemById(id) {
    const pool = await getDBConnection();
    try {
        const result = await pool
            .request()
            .input("ItemId", sql.Int, id) // ID của Item cần lấy
            .execute("dbo.GetItemById"); // Stored Procedure lấy thông tin Item
        if (result.recordset.length > 0) {
            return result.recordset[0]; // Trả về Item đầu tiên (nếu có)
        } else {
            throw new Error(`Item with ID ${id} not found.`);
        }
    } catch (error) {
        console.error("Error fetching Item by ID:", error);
        throw error; // Throw lỗi để xử lý ở cấp trên
    }
}


module.exports = {
	getAllItems,
	getItemById,
	addItem,
	updateItem,
};
