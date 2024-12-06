const express = require("express");
const { getUsers, createUser } = require("../controllers/productController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/get-users", getUsers);

// Route thêm user mới
router.post("/create-user", createUser);

module.exports = router;
