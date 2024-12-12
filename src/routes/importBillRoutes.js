const express = require("express");
const ImportBillController = require("../controllers/importBillController.js");
const router = express.Router();

// Route
router.get("/get/:id", ImportBillController.getImportBillById);
router.get("/all", ImportBillController.getAllImportBills);
router.post("/create", ImportBillController.addImportBill);
router.post("/update/:id", ImportBillController.updateImportBill);
router.post("/updateStock/:id", ImportBillController.updateImportBill);
module.exports = router;
