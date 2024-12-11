// controllers/EmployeeController.js

const EmployeeService = require("../models/employeeModel");

async function getAllEmployees(req, res) {
  try {
    const Employees = await EmployeeService.getAllEmployees();
    res.status(200).json(Employees); // Trả về danh sách người dùng
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi lấy tất cả người dùng.",
      error,
    });
  }
}

async function getEmployeeById(req, res) {
  const { employeeId } = req.params;
  try {
    const Employee = await EmployeeService.getEmployeeById(employeeId);
    if (!Employee) {
      return res.status(404).json({ message: "Employee không tồn tại." });
    }
    res.status(200).json(Employee); // Trả về thông tin Employee
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi lấy Employee.", error });
  }
}

async function addEmployee(req, res) {
  const { ID_Card_Num, Fname, Lname, DOB, Sex, Position, Wage } = req.body;

  // Kiểm tra tất cả các tham số đầu vào
  if (!ID_Card_Num || !Fname || !Lname || !DOB || !Position || !Wage) {
    return res.status(400).json({
      message: "Thiếu tham số bắt buộc.",
    });
  }

  try {
    await EmployeeService.createEmployee(
      ID_Card_Num,
      Fname,
      Lname,
      DOB,
      Sex,
      Position,
      Wage
    );
    res.status(201).json({
      message: "Employee đã được thêm thành công.",
    });
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi thêm Employee.",
      error: error.message,
    });
  }
}

async function updateEmployee(req, res) {
  const { ID_Card_Num, New_Position, New_Wage } = req.body;
  try {
    await EmployeeService.updateEmployee(ID_Card_Num, New_Position, New_Wage);
    res.status(200).json({
      message: "Employee đã được cập nhật thành công.",
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi cập nhật Employee.", error });
  }
}

async function deleteEmployee(req, res) {
  const { id } = req.params;
  try {
    await EmployeeService.deleteEmployee(id);
    res.status(200).json({ message: "Employee đã được xóa thành công." });
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi xóa Employee.", error });
  }
}

module.exports = {
  getAllEmployees,
  getEmployeeById,
  addEmployee,
  updateEmployee,
  deleteEmployee,
};
