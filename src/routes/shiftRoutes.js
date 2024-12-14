const express = require("express");
const ShiftController = require("../controllers/shiftController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route lấy danh sách users
router.get("/all", auth.authenticateToken, ShiftController.getAllShifts);
router.get(
	"/view/:idCardNum",
	auth.authenticateToken,
	ShiftController.viewEmployeeShifts
);
router.post("/checkin", auth.authenticateToken, ShiftController.checkIn);
router.post(
	"/assign",
	auth.authenticateToken,
	auth.isAdmin,
	ShiftController.autoAssignShifts
);
router.post("/remove", auth.authenticateToken, ShiftController.removeEmployeeFromShift);
router.post("/add", auth.authenticateToken, ShiftController.registerEmployeeToShift);
router.get("/:shiftId", auth.authenticateToken, ShiftController.getShiftById);
router.post("/", auth.authenticateToken,auth.isAdmin, ShiftController.addShift);
router.put("/", auth.authenticateToken, auth.isAdmin, ShiftController.updateShift);
module.exports = router;
