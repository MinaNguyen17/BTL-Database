const express = require("express");
const itemController = require("../controllers/itemController.js");
const router = express.Router();

router.get("/get-items", productController.getAllProducts);
router.get("/get-item/:id", productController.getProductById);
router.post("/create-item", productController.addProduct);
router.post("/update-item/:id", productController.updateProduct);

module.exports = router;
