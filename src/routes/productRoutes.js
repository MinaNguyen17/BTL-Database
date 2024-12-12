const express = require("express");
const ProductController = require("../controllers/productController.js");
const router = express.Router();
const auth = require("../middleware/authenticate.js");

// Route lấy danh sách users
router.get("/get/:id", auth.authenticateToken, ProductController.getProductById);
router.get("/all", auth.authenticateToken, ProductController.getAllProducts);
router.post("/create", auth.authenticateToken, ProductController.addProduct);
router.post("/update/:id", auth.authenticateToken, ProductController.updateProduct);
module.exports = router;
