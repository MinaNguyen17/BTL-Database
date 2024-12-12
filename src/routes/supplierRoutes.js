const express = require("express");
const SupplierController = require("../controllers/supplierController.js");
const router = express.Router();

// Route
router.get("/all", SupplierController.getAllSuppliers);
module.exports = router;
