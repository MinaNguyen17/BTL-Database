const express = require("express");
const ReturnBillController = require("../controllers/returnBillController.js");
const router = express.Router();

// Route
router.get("/get/:id", ReturnBillController.getReturnBillById);
router.get("/all", ReturnBillController.getAllReturnBills);
router.post("/create", ReturnBillController.addReturnBill);
module.exports = router;
