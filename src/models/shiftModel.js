const { getDBConnection } = require("../config/database.js");
const sql = require("mssql");

async function addShift(shiftType, date, employeeNum, rate) {
  const pool = await getDBConnection(); // Kết nối tới DB
  const result = await pool
    .request()
    .input("Shift_Type", sql.Char, shiftType)
    .input("Date", sql.Date, date)
    .input("E_Num", sql.Int, employeeNum)
    .input("Rate", sql.Decimal, rate)
    .execute("CreateShift"); // Gọi stored procedure

  // Trả về kết quả của record vừa được tạo
  return result.recordset[0]; // Lấy bản ghi đầu tiên (vì chỉ có một bản ghi được trả về)
}

async function deleteShift(Shift_ID) {
  const pool = await getDBConnection();
  await pool
    .request()
    .input("Shift_ID", sql.Int, Shift_ID)
    .execute("dbo.DeleteShift"); // Gọi stored procedure để xóa Shift
}

async function updateShift(shiftId, eNum, rate) {
  const pool = await getDBConnection();
  await pool
    .request()
    .input("Shift_ID", sql.Int, shiftId)
    .input("New_E_Num", sql.Int, eNum || null)
    .input("New_Rate", sql.Decimal(5, 2), rate || null)
    .execute("UpdateShiftInfo");
}

async function getAllShifts() {
  const pool = await getDBConnection();
  const result = await pool.request().execute("dbo.GetAllShifts"); // Gọi stored procedure để lấy tất cả Shifts
  return result.recordset; // Trả về danh sách tất cả Shifts
}

async function getShiftById(Shift_ID) {
  const pool = await getDBConnection();
  const result = await pool
    .request()
    .input("Shift_ID", sql.Int, Shift_ID)
    .execute("dbo.GetShiftById"); // Gọi stored procedure để lấy một Shift theo Id
  return result.recordset[0]; // Trả về Shift đầu tiên (nếu có)
}

async function GetEmployeesOfShift(Shift_ID) {
  const pool = await getDBConnection();
  const employeesResult = await pool
    .request()
    .input("Shift_ID", sql.Int, Shift_ID)
    .execute("GetEmployeesOfShift");
  return employeesResult.recordset;
}

async function removeEmployeeFromShift(shiftId, idCardNum) {
  const pool = await getDBConnection();
  try {
    const result = await pool
      .request()
      .input("Shift_ID", sql.Int, shiftId)
      .input("ID_Card_Num", sql.Char(12), idCardNum)
      .execute("dbo.RemoveEmployeeFromShift");
    return {
      success: true,
      message: "Nhân viên đã được xóa khỏi ca làm việc thành công.",
    };
  } catch (error) {
    return {
      success: false,
      message: error.originalError.info.message || "Lỗi không xác định.",
    };
  }
}

async function registerEmployeeToShift(shiftId, idCardNum) {
  const pool = await getDBConnection();
  try {
    const result = await pool
      .request()
      .input("Shift_ID", sql.Int, shiftId)
      .input("ID_Card_Num", sql.Char(12), idCardNum)
      .execute("dbo.RegisterShift");
    return {
      success: true,
      message: "Nhân viên đã được thêm vào ca làm việc thành công.",
    };
  } catch (error) {
    return {
      success: false,
      message: error.originalError?.info?.message || "Lỗi không xác định.",
    };
  }
}

module.exports = {
  getAllShifts,
  getShiftById,
  addShift,
  updateShift,
  deleteShift,
  GetEmployeesOfShift,
  removeEmployeeFromShift,
  registerEmployeeToShift,
};
