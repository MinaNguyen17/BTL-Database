const express = require("express");
const EmployeeRoutes = require("./employeeRoutes.js");
const ShiftRoutes = require("./shiftRoutes.js");
const AccountRoutes = require("./accountRoutes.js");
const router = express.Router();

// Employee routes
router.use("/employee", EmployeeRoutes);
router.use("/shift", ShiftRoutes);
router.use("/account", AccountRoutes);
module.exports = router;
