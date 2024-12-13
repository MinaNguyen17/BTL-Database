// controllers/ImportBillController.js

const ImportBillService = require("../models/importBillModel");

async function getAllImportBills(req, res) {
	try {
		const ImportBills = await ImportBillService.getAllImportBills();
		res.status(200).json(ImportBills); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getImportBillById(req, res) {
	const { id } = req.params;
	try {
		const ImportBill = await ImportBillService.getImportBillById(id);
		if (!ImportBill) {
			return res.status(404).json({ message: "ImportBill không tồn tại." });
		}
		res.status(200).json(ImportBill); // Trả về thông tin ImportBill
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy ImportBill.", error });
	}
}

async function addImportBill(req, res) {
	const { itemID, supplierID, importQuantity, importPrice, totalFee } = req.body;
	try {
		console.log("Hello");
		await ImportBillService.addImportBill(
			itemID,
			supplierID,
			importQuantity,
			importPrice,
			totalFee
		);
		res.status(201).json({
			message: "ImportBill đã được thêm thành công.",
		});
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm ImportBill.", error });
	}
}

async function updateImportBill(req, res) {
	const { id } = req.params;
	const { newState } = req.body;
	try {
		await ImportBillService.updateImportBill(id, newState);
		res.status(200).json({
			message: "ImportBill đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi cập nhật ImportBill.",
			error,
		});
	}
}

async function updateStockOnImport(req, res) {
	const { id } = req.params;
	try {
		await ImportBillService.updateStockOnImport(id);
		res.status(200).json({ message: "ImportBill đã được cập nhật thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật ImportBill.", error });
	}
}

module.exports = {
	getAllImportBills,
	getImportBillById,
	addImportBill,
	updateImportBill,
	updateStockOnImport,
};
