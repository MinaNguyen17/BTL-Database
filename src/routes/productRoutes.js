const express = require("express");
const productController = require("../controllers/productController.js");
const router = express.Router();

router.get("/get-products", productController.getAllProducts);
router.get("/get-product/:id", productController.getProductById);
router.post("/create-product", productController.addProduct);
router.post("/update-product/:id", productController.updateProduct);

module.exports = router;
