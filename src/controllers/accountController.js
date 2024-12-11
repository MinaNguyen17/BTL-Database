// controllers/AccountController.js

const AccountService = require("../models/accountModel");

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
