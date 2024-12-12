const express = require("express");
const EmployeeController = require("../controllers/employeeController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/all", EmployeeController.getAllEmployees);
router.get("/salary/:idCardNum", EmployeeController.viewEmployeeSalary);
router.get("/:employeeId", EmployeeController.getEmployeeById);
router.post("/", EmployeeController.addEmployee);
router.put("/", EmployeeController.updateEmployee);
module.exports = router;
