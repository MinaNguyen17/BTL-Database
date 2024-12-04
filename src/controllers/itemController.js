// controllers/ItemController.js

const ItemService = require("../models/itemModel");

async function getAllItems(req, res) {
	try {
		const Items = await ItemService.getAllItems();
		res.status(200).json(Items); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getItemById(req, res) {
	const { id } = req.params;
	try {
		const Item = await ItemService.getItemById(id);
		if (!Item) {
			return res.status(404).json({ message: "Item không tồn tại." });
		}
		res.status(200).json(Item); // Trả về thông tin Item
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy Item.", error });
	}
}

async function addItem(req, res) {
	const { name, email } = req.body;
	try {
		await ItemService.addItem(name, email);
		res.status(201).json({ message: "Item đã được thêm thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm Item.", error });
	}
}

async function updateItem(req, res) {
	const { id } = req.params;
	const { name, email } = req.body;
	try {
		await ItemService.updateItem(id, name, email);
		res.status(200).json({ message: "Item đã được cập nhật thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật Item.", error });
	}
}

async function deleteItem(req, res) {
	const { id } = req.params;
	try {
		await ItemService.deleteItem(id);
		res.status(200).json({ message: "Item đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Item.", error });
	}
}

module.exports = {
	getAllItems,
	getItemById,
	addItem,
	updateItem,
	deleteItem,
};
