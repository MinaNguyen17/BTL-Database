const express = require("express");
const cors = require('cors');
const AccountController = require("../controllers/accountController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route lấy danh sách users
router.get(
	"/all",
	auth.authenticateToken,
	auth.isAdmin,
	AccountController.getAllAccounts
);
router.post("/changePassword", auth.authenticateToken, AccountController.changePassword);


router.options('/login', cors()); // Enable preflight requests for this route
router.post("/login", AccountController.login);
router.post(
	"/create",
	auth.authenticateToken,
	auth.isAdmin,
	AccountController.addAccount
);
router.get(
	"/get/:id",
	auth.authenticateToken,
	auth.isAdmin,
	AccountController.getAccountById
);

module.exports = router;
