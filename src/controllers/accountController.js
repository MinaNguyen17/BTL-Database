// controllers/AccountController.js

const AccountService = require("../models/accountModel");

async function getAllAccounts(req, res) {
	try {
		const Accounts = await AccountService.getAllAccounts();
		res.status(200).json(Accounts); // Trả về danh sách người dùng
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi lấy tất cả người dùng.",
			error,
		});
	}
}

async function getAccountById(req, res) {
	const { id } = req.params;
	try {
		const Account = await AccountService.getAccountById(id);
		if (!Account) {
			return res.status(404).json({ message: "Account không tồn tại." });
		}
		res.status(200).json(Account); // Trả về thông tin Account
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi lấy Account.", error });
	}
}

async function addAccount(req, res) {
	const { name, email } = req.body;
	try {
		await AccountService.addAccount(name, email);
		res.status(201).json({ message: "Account đã được thêm thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi thêm Account.", error });
	}
}

async function updateAccount(req, res) {
	const { id } = req.params;
	const { name, email } = req.body;
	try {
		await AccountService.updateAccount(id, name, email);
		res.status(200).json({
			message: "Account đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi cập nhật Account.", error });
	}
}

async function deleteAccount(req, res) {
	const { id } = req.params;
	try {
		await AccountService.deleteAccount(id);
		res.status(200).json({ message: "Account đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Account.", error });
	}
}

module.exports = {
	getAllAccounts,
	getAccountById,
	addAccount,
	updateAccount,
	deleteAccount,
};
