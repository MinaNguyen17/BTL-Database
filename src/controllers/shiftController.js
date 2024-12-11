// controllers/ShiftController.js

const ShiftService = require("../models/shiftModel");

async function getAllShifts(req, res) {
  try {
    const Shifts = await ShiftService.getAllShifts();
    res.status(200).json(Shifts); // Trả về danh sách người dùng
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi lấy tất cả shift.",
      error,
    });
  }
}

async function getShiftById(req, res) {
  const { shiftId } = req.params;

  try {
    const shift = await ShiftService.getShiftById(shiftId);

    // Kiểm tra xem có shift với ID này không
    if (!shift) {
      return res.status(404).json({ message: "Shift not found." });
    }

    // lấy danh sách nhân viên làm việc trong ca này
    const employees = await ShiftService.GetEmployeesOfShift(shiftId); // Danh sách nhân viên

    // Trả về thông tin ca làm việc và danh sách nhân viên
    res.status(200).json({
      shift: shift,
      employees: employees, // Trả về danh sách nhân viên
    });
  } catch (error) {
    // Xử lý lỗi
    console.error(error);
    res.status(500).json({ message: "Error retrieving shift data", error });
  }
}

async function addShift(req, res) {
  const { Shift_Type, S_Date, E_Num, Rate } = req.body;

  // Kiểm tra đầu vào
  if (!Shift_Type || !S_Date || !E_Num) {
    return res.status(400).json({
      message: "Thiếu tham số bắt buộc (Shift_Type, Date, E_Num).",
    });
  }

  const currentDate = new Date();
  const shiftDate = new Date(S_Date);

  if (shiftDate <= currentDate) {
    return res.status(400).json({
      message: "Ngày shift phải sau ít nhất 1 ngày kể từ ngày hiện tại.",
    });
  }

  try {
    // Gọi hàm addShift trong ShiftService để thêm shift
    const shift = await ShiftService.addShift(Shift_Type, S_Date, E_Num, Rate);

    // Trả về thông tin của shift vừa được thêm
    res.status(201).json({
      message: "Shift đã được thêm thành công.",
      shift: shift,
    });
  } catch (error) {
    // Xử lý lỗi nếu có
    res.status(500).json({
      message: "Lỗi khi thêm Shift.",
      error: error.message || error,
    });
  }
}

async function updateShift(req, res) {
  const { Shift_ID, E_Num, Rate } = req.body;

  try {
    // Gọi service để cập nhật thông tin ca làm việc
    if (!Shift_ID) {
      return res.status(400).json({
        message: "Thiếu tham số bắt buộc (Shift_ID).",
      });
    }
    await ShiftService.updateShift(Shift_ID, E_Num, Rate);

    res.status(200).json({ message: "Shift updated successfully." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error updating shift.", error });
  }
}

async function removeEmployeeFromShift(req, res) {
  const { Shift_ID, ID_Card_Num } = req.body;
  try {
    const response = await ShiftService.removeEmployeeFromShift(
      Shift_ID,
      ID_Card_Num
    );
    if (response.success) {
      res.status(200).json({ message: response.message });
    } else {
      res.status(400).json({ message: response.message });
    }
  } catch (error) {
    res.status(500).json({
      message: "Lỗi server khi xóa nhân viên khỏi ca làm việc.",
      error,
    });
  }
}

async function registerEmployeeToShift(req, res) {
  const { Shift_ID, ID_Card_Num } = req.body;

  if (!Shift_ID || !ID_Card_Num) {
    return res
      .status(400)
      .json({ message: "Thiếu Shift_ID hoặc ID_Card_Num." });
  }

  try {
    const response = await ShiftService.registerEmployeeToShift(
      Shift_ID,
      ID_Card_Num
    );
    if (response.success) {
      res.status(200).json({ message: response.message });
    } else {
      res.status(400).json({ message: response.message });
    }
  } catch (error) {
    res.status(500).json({
      message: "Lỗi server khi thêm nhân viên vào ca làm việc.",
      error: error.message,
    });
  }
}

module.exports = {
  getAllShifts,
  getShiftById,
  addShift,
  updateShift,
  removeEmployeeFromShift,
  registerEmployeeToShift,
};
