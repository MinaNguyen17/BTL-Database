const express = require("express");
const EmployeeRoutes = require("./employeeRoutes.js");
const ShiftRoutes = require("./shiftRoutes.js");
const ProductRoutes = require("./productRoutes.js");
const ItemRoutes = require("./itemRoutes.js");
const router = express.Router();

// Employee routes
router.use("/employee", EmployeeRoutes);
router.use("/shift", ShiftRoutes);
router.use("/product", ProductRoutes);
router.use("/item", ItemRoutes);
module.exports = router;
