const express = require("express");
const ItemController = require("../controllers/itemController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route lấy danh sách users
router.get("/get/:id", auth.authenticateToken, ItemController.getItemById);
router.get("/all", auth.authenticateToken, ItemController.getAllItems);
router.post("/create", auth.authenticateToken, ItemController.addItem);
router.post("/update/:id", auth.authenticateToken, ItemController.updateItem);
module.exports = router;
