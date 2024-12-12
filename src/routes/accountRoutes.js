const express = require("express");
const AccountController = require("../controllers/accountController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route lấy danh sách users
router.get("/all", AccountController.getAllAccounts);
router.post("/changePassword", auth.authenticateToken, AccountController.changePassword);
router.post("/login", AccountController.login);
router.post("/create", AccountController.addAccount);
router.get("/get/:id", AccountController.getAccountById);
router.post(
	"/update/:id",
	auth.authenticateToken,
	auth.isAdmin,
	AccountController.updateAccount
);

module.exports = router;
