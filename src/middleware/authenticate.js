// Middleware to authenticate JWT token
const jwt = require("jsonwebtoken");
const SECRET_KEY = process.env.SECRET_KEY;

// Middleware authenticateToken
const authenticateToken = (req, res, next) => {
	// Lấy token từ header Authorization (Bearer <token>)
	const token = req.headers["authorization"]?.split(" ")[1]; // Lấy token từ Bearer header
	if (!token) {
		return res.status(401).json({ message: "Access token is missing or invalid" });
	}

	// Xác thực token
	jwt.verify(token, SECRET_KEY, (err, user) => {
		if (err) return res.status(403).json({ message: "Invalid token" });

		req.user = user; // Gán thông tin người dùng vào request object
		next(); // Tiếp tục với request
	});
};

// Middleware kiểm tra quyền admin
const isAdmin = (req, res, next) => {
	if (req.user.role !== "Admin") {
		return res
			.status(403)
			.json({ message: "Quyền truy cập bị từ chối. Bạn cần quyền admin." });
	}
	next();
};

module.exports = { authenticateToken, isAdmin };
