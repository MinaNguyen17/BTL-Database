// controllers/ShiftController.js

const ShiftService = require("../models/shiftModel");

async function getAllShifts(req, res) {
	try {
		const Shifts = await ShiftService.getAllShifts();
		res.status(200).json(Shifts); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getShiftById(req, res) {
	const { id } = req.params;
	try {
		const Shift = await ShiftService.getShiftById(id);
		if (!Shift) {
			return res.status(404).json({ message: "Shift không tồn tại." });
		}
		res.status(200).json(Shift); // Trả về thông tin Shift
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy Shift.", error });
	}
}

async function addShift(req, res) {
	const { name, email } = req.body;
	try {
		await ShiftService.addShift(name, email);
		res.status(201).json({ message: "Shift đã được thêm thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm Shift.", error });
	}
}

async function updateShift(req, res) {
	const { id } = req.params;
	const { name, email } = req.body;
	try {
		await ShiftService.updateShift(id, name, email);
		res.status(200).json({ message: "Shift đã được cập nhật thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật Shift.", error });
	}
}

async function deleteShift(req, res) {
	const { id } = req.params;
	try {
		await ShiftService.deleteShift(id);
		res.status(200).json({ message: "Shift đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Shift.", error });
	}
}

module.exports = {
	getAllShifts,
	getShiftById,
	addShift,
	updateShift,
	deleteShift,
};
