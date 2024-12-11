// controllers/ProductController.js

const ProductService = require("../models/productModel");

async function getAllProducts(req, res) {
	try {
		const Products = await ProductService.getAllProducts();
		res.status(200).json(Products); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getProductById(req, res) {
	const { id } = req.params;
	try {
		const Product = await ProductService.getProductById(id);
		if (!Product) {
			return res.status(404).json({ message: "Product không tồn tại." });
		}
		res.status(200).json(Product); // Trả về thông tin Product
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy Product.", error });
	}
}

async function addProduct(req, res) {
	const { name, brand, style_tag, season, category, description } = req.body;
	try {
		await ProductService.addProduct(
			name,
			brand,
			style_tag,
			season,
			category,
			description
		);
		res.status(201).json({ message: "Product đã được thêm thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm Product.", error });
	}
}

async function updateProduct(req, res) {
	const { id } = req.params;
	const { name, brand, style_tag, season, category, description } = req.body;
	try {
		await ProductService.updateProduct(
			id,
			name,
			brand,
			style_tag,
			season,
			category,
			description
		);
		res.status(200).json({
			message: "Product đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật Product.", error });
	}
}

async function deleteProduct(req, res) {
	const { id } = req.params;
	try {
		await ProductService.deleteProduct(id);
		res.status(200).json({ message: "Product đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Product.", error });
	}
}

module.exports = {
	getAllProducts,
	getProductById,
	addProduct,
	updateProduct,
	deleteProduct,
};
