// controllers/ReturnBillController.js

const ReturnBillService = require("../models/returnBillModel");

async function getAllReturnBills(req, res) {
	try {
		const ReturnBills = await ReturnBillService.getAllReturnBills();
		res.status(200).json(ReturnBills); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getReturnBillById(req, res) {
	const { id } = req.params;
	try {
		const ReturnBill = await ReturnBillService.getReturnBillById(id);
		if (!ReturnBill) {
			return res.status(404).json({ message: "ReturnBill không tồn tại." });
		}
		res.status(200).json(ReturnBill); // Trả về thông tin ReturnBill
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy ReturnBill.", error });
	}
}

async function addReturnBill(req, res) {
	const { reason, returnFee, itemID, supplierID, returnQuantity, returnPrice } =
		req.body;
	try {
		await ReturnBillService.addReturnBill(
			reason,
			returnFee,
			itemID,
			supplierID,
			returnQuantity,
			returnPrice
		);
		res.status(201).json({
			message: "ReturnBill đã được thêm thành công.",
		});
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm ReturnBill.", error });
	}
}

async function updateReturnBill(req, res) {
	const { id } = req.params;
	const { name, email } = req.body;
	try {
		await ReturnBillService.updateReturnBill(id, name, email);
		res.status(200).json({
			message: "ReturnBill đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi cập nhật ReturnBill.",
			error,
		});
	}
}

async function deleteReturnBill(req, res) {
	const { id } = req.params;
	try {
		await ReturnBillService.deleteReturnBill(id);
		res.status(200).json({ message: "ReturnBill đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa ReturnBill.", error });
	}
}

module.exports = {
	getAllReturnBills,
	getReturnBillById,
	addReturnBill,
	updateReturnBill,
	deleteReturnBill,
};
