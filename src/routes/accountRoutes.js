const express = require("express");
const AccountController = require("../controllers/accountController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/create", AccountController.addAccount);

module.exports = router;
