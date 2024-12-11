const express = require("express");
const ItemController = require("../controllers/itemController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/get/:id", ItemController.getItemById);
router.get("/all", ItemController.getAllItems);
router.post("/create", ItemController.addItem);
router.post("/update/:id", ItemController.updateItem);
module.exports = router;
