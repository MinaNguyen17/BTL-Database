const express = require("express");
const ShiftController = require("../controllers/shiftController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/all", ShiftController.getAllShifts);
router.get("/:shiftId", ShiftController.getShiftById);
router.get("/view/:idCardNum", ShiftController.viewEmployeeShifts);
router.post("/checkin", ShiftController.checkIn);
router.post("/assign", ShiftController.autoAssignShifts);
router.post("/remove", ShiftController.removeEmployeeFromShift);
router.post("/add", ShiftController.registerEmployeeToShift);
router.post("/", ShiftController.addShift);
router.put("/", ShiftController.updateShift);
module.exports = router;
