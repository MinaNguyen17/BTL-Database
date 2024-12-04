// controllers/SupplierController.js

const SupplierService = require("../models/supplierModel");

async function getAllSuppliers(req, res) {
	try {
		const Suppliers = await SupplierService.getAllSuppliers();
		res.status(200).json(Suppliers); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getSupplierById(req, res) {
	const { id } = req.params;
	try {
		const Supplier = await SupplierService.getSupplierById(id);
		if (!Supplier) {
			return res.status(404).json({ message: "Supplier không tồn tại." });
		}
		res.status(200).json(Supplier); // Trả về thông tin Supplier
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy Supplier.", error });
	}
}

async function addSupplier(req, res) {
	const { name, email } = req.body;
	try {
		await SupplierService.addSupplier(name, email);
		res.status(201).json({ message: "Supplier đã được thêm thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm Supplier.", error });
	}
}

async function updateSupplier(req, res) {
	const { id } = req.params;
	const { name, email } = req.body;
	try {
		await SupplierService.updateSupplier(id, name, email);
		res.status(200).json({
			message: "Supplier đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật Supplier.", error });
	}
}

async function deleteSupplier(req, res) {
	const { id } = req.params;
	try {
		await SupplierService.deleteSupplier(id);
		res.status(200).json({ message: "Supplier đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Supplier.", error });
	}
}

module.exports = {
	getAllSuppliers,
	getSupplierById,
	addSupplier,
	updateSupplier,
	deleteSupplier,
};
