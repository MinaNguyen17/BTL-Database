const express = require("express");
const EmployeeRoutes = require("./employeeRoutes.js");
const ShiftRoutes = require("./shiftRoutes.js");
const ProductRoutes = require("./productRoutes.js");
const ItemRoutes = require("./itemRoutes.js");
const AccountRoutes = require("./accountRoutes.js");
const ReturnBillRoutes = require("./returnBillRoutes.js");
const SupplierRoutes = require("./supplierRoutes.js");
const ImportBillRoutes = require("./importBillRoutes.js");
const router = express.Router();

// Employee routes
router.use("/employee", EmployeeRoutes);
router.use("/shift", ShiftRoutes);
router.use("/product", ProductRoutes);
router.use("/item", ItemRoutes);
router.use("/account", AccountRoutes);
router.use("/returnBill", ReturnBillRoutes);
router.use("/supplier", SupplierRoutes);
router.use("/importBill", ImportBillRoutes);
module.exports = router;
