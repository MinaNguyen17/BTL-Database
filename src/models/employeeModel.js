const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function getAllEmployees() {
  try {
    const pool = await getDBConnection();
    const result = await pool.request().execute("dbo.GetAllEmployees"); // Gọi procedure
    return result.recordset; // Trả về danh sách nhân viên
  } catch (error) {
    console.error("Lỗi khi lấy danh sách nhân viên:", error);
    throw error;
  }
}

async function getEmployeeById(employeeId) {
  try {
    const pool = await getDBConnection();
    const result = await pool
      .request()
      .input("id", sql.Char(12), employeeId) // Chuyển tham số ID_Card_Num
      .execute("dbo.GetEmployeeById"); // Gọi procedure
    return result.recordset[0]; // Trả về thông tin nhân viên đầu tiên (nếu có)
  } catch (error) {
    console.error("Lỗi khi lấy thông tin nhân viên:", error);
    throw error;
  }
}

async function createEmployee(
  ID_Card_Num,
  Fname,
  Lname,
  DOB,
  Sex,
  Position,
  Wage
) {
  const pool = await getDBConnection();
  try {
    // Gọi stored procedure 'CreateEmployee' với các tham số đã được chuẩn bị
    await pool
      .request()
      .input("ID_Card_Num", sql.Char(12), ID_Card_Num)
      .input("Fname", sql.NVarChar(20), Fname)
      .input("Lname", sql.NVarChar(40), Lname)
      .input("DOB", sql.Date, DOB)
      .input("Sex", sql.Bit, Sex)
      .input("Position", sql.VarChar(30), Position)
      .input("Wage", sql.Int, Wage)
      .execute("dbo.CreateEmployee"); // Gọi stored procedure
  } catch (error) {
    console.error("Lỗi khi thêm nhân viên:", error);
    throw error; // Ném lỗi ra ngoài để controller có thể xử lý
  }
}

async function updateEmployee(idCardNum, newPosition, newWage) {
  const pool = await getDBConnection();

  // Kiểm tra kiểu dữ liệu và đảm bảo tham số được truyền đúng
  await pool
    .request()
    .input("ID_Card_Num", sql.Char(12), idCardNum) // ID_Card_Num là CHAR(12)
    .input("New_Position", sql.VarChar(30), newPosition || null) // Vị trí mới, có thể NULL
    .input("New_Wage", sql.Int, newWage || null) // Mức lương mới, có thể NULL
    .execute("dbo.UpdateEmployeeInfo"); // Gọi stored procedure UpdateEmployeeInfo
}

async function deleteEmployee(id) {
  const pool = await getDBConnection();
  await pool.request().input("id", sql.Int, id).execute("dbo.DeleteEmployee"); // Gọi stored procedure để xóa Employee
}

module.exports = {
  getAllEmployees,
  getEmployeeById,
  createEmployee,
  updateEmployee,
  deleteEmployee,
};
