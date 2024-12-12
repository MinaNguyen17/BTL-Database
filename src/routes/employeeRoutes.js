const express = require("express");
const EmployeeController = require("../controllers/employeeController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route
router.get(
	"/all",
	auth.authenticateToken,
	auth.isAdmin,
	EmployeeController.getAllEmployees
);
router.get(
	"/salary/:idCardNum",
	auth.authenticateToken,
	EmployeeController.viewEmployeeSalary
);
router.get(
	"/:employeeId",
	auth.authenticateToken,
	auth.isAdmin,
	EmployeeController.getEmployeeById
);
router.post("/", auth.authenticateToken, auth.isAdmin, EmployeeController.addEmployee);
router.put("/", auth.authenticateToken, auth.isAdmin, EmployeeController.updateEmployee);
module.exports = router;
