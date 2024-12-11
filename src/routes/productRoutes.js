const express = require("express");
const ProductController = require("../controllers/productController.js");
const router = express.Router();

// Route lấy danh sách users
router.get("/get/:id", ProductController.getProductById);
router.get("/all", ProductController.getAllProducts);
router.post("/create", ProductController.addProduct);
router.post("/update/:id", ProductController.updateProduct);
module.exports = router;
