// controllers/AccountController.js

const AccountService = require("../models/accountModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const addAccount = async (req, res) => {
	const { ID_Card_Num, Role } = req.body;

	if (!ID_Card_Num || !Role) {
		return res
			.status(400)
			.json({ message: "Vui lòng cung cấp ID_Card_Num và Role." });
	}

	try {
		const account = await AccountService.addAccount(ID_Card_Num, Role);
		res.status(201).json({
			message: "Tài khoản đã được tạo và mật khẩu đã được hash thành công.",
			account,
		});
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi tạo tài khoản.",
			error: error.message,
		});
	}
};

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

async function changePassword(req, res) {
	// Lấy thông tin user từ token (đã được gán vào req.user trong middleware authenticateToken)
	const { username } = req.user; // Lấy username từ token (req.user chứa thông tin đã xác thực từ token)
	const { password } = req.body; // Mật khẩu mới sẽ được gửi từ client qua req.body

	try {
		// Kiểm tra xem user có quyền cập nhật tài khoản của chính mình không
		const account = await AccountService.getAccountByUsername(username);
		if (!account) {
			return res.status(404).json({ message: "Account not found" });
		}

		// Cập nhật tài khoản
		// Bạn có thể mã hóa lại mật khẩu nếu cần thiết, ví dụ sử dụng bcrypt:
		const hashedPassword = await bcrypt.hash(password, 10); // 10 là số vòng băm

		// Gọi service để cập nhật tài khoản trong DB
		await AccountService.changePassword(username, hashedPassword);

		res.status(200).json({
			message: "Account đã được cập nhật thành công.",
		});
	} catch (error) {
		res.status(500).json({
			message: "Lỗi khi cập nhật Account.",
			error: error.message,
		});
	}
}

async function updateAccount(req, res) {
	const { id, role, status } = req.params;
	try {
		await AccountService.updateAccount(id, role, status);
		res.status(200).json({ message: "Account đã được xóa thành công." });
	} catch (error) {
		res.status(500).json({ message: "Lỗi khi xóa Account.", error });
	}
}

const SECRET_KEY = process.env.SECRET_KEY;
async function login(req, res) {
	const { username, password } = req.body;

	try {
		// Lấy tài khoản từ database theo username
		const account = await AccountService.getAccountByUsername(username);
		if (!account) {
			return res.status(404).json({ message: "Account not found" });
		}

		// Kiểm tra mật khẩu
		const isPasswordValid = await bcrypt.compare(password, account.Password);
		if (!isPasswordValid) {
			return res.status(401).json({ message: "Invalid credentials" });
		}

		// Kiểm tra trạng thái tài khoản
		if (account.Status !== "Active") {
			return res.status(403).json({ message: "Account is not active" });
		}

		// Tạo JWT token (bao gồm thông tin như Account_ID, Role, Status)
		const token = jwt.sign(
			{
				accountId: account.Account_ID,
				username: account.Username,
				ID_Card_Num: account.ID_Card_Num,
				role: account.Role.trim(), // Xóa khoảng trắng nếu có
				status: account.Status.trim(), // Xóa khoảng trắng nếu có
			},
			SECRET_KEY,
			{ expiresIn: "1h" }
		);

		// Trả về token cho client
		res.json({ message: "Login successful", token });
	} catch (error) {
		res.status(500).json({ message: "Internal server error", error: error.message });
	}
}

module.exports = {
	getAllAccounts,
	getAccountById,
	addAccount,
	changePassword,
	updateAccount,
	login,
};
