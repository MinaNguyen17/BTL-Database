const express = require("express");
const ImportBillController = require("../controllers/importBillController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route
router.get("/get/:id", auth.authenticateToken, ImportBillController.getImportBillById);
router.get("/all", auth.authenticateToken, ImportBillController.getAllImportBills);
router.post("/create", auth.authenticateToken, ImportBillController.addImportBill);
router.post("/update/:id", auth.authenticateToken, ImportBillController.updateImportBill);
router.post(
	"/updateStock/:id",
	auth.authenticateToken,
	ImportBillController.updateStockOnImport
);
module.exports = router;
