const { getAllUsers, addUser } = require("../models/userModel");

// Lấy danh sách tất cả users
async function getUsers(req, res) {
	try {
		const users = await getAllUsers();
		res.status(200).json(users);
	} catch (err) {
		console.error(err);
		res.status(500).send("Error retrieving users");
	}
}

// Thêm user mới
async function createUser(req, res) {
	try {
		const { name, email } = req.body;
		if (!name || !email) {
			return res.status(400).send("Name and email are required");
		}
		await addUser(name, email);
		res.status(201).send("User added successfully");
	} catch (err) {
		console.error(err);
		res.status(500).send("Error creating user");
	}
}

module.exports = {
	getUsers,
	createUser,
};
