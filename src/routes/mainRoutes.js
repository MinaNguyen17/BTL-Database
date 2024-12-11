const express = require("express");
const EmployeeRoutes = require("./employeeRoutes.js");
const router = express.Router();

// Employee routes
router.use("/employee", EmployeeRoutes);
module.exports = router;
