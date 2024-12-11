const express = require("express");
const ShiftController = require("../controllers/shiftController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/all", ShiftController.getAllShifts);
router.get("/:shiftId", ShiftController.getShiftById);
router.post("/", ShiftController.addShift);
router.put("/", ShiftController.updateShift);
module.exports = router;
