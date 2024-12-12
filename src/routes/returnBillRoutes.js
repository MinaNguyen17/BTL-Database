const express = require("express");
const ReturnBillController = require("../controllers/returnBillController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route
router.get("/get/:id", auth.authenticateToken, ReturnBillController.getReturnBillById);
router.get("/all", auth.authenticateToken, ReturnBillController.getAllReturnBills);
router.post("/create", auth.authenticateToken, ReturnBillController.addReturnBill);
module.exports = router;
