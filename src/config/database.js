const sql = require("mssql");

const config = {
	user: "btl-db",
	password: "database@10",
	server: "btl-db.database.windows.net",
	database: "db",
	options: {
		encrypt: true, // Bắt buộc với Azure
		enableArithAbort: true,
	},
};

let pool; // Giữ kết nối duy nhất

async function initDBConnection() {
	try {
		if (!pool) {
			pool = await sql.connect(config);
			console.log("Connected to Azure SQL Database");
		}
		return pool;
	} catch (err) {
		console.error("Database connection failed:", err);
		throw err;
	}
}

// Trả về kết nối đã khởi tạo
function getDBConnection() {
	if (!pool) {
		throw new Error("Database connection is not initialized");
	}
	return pool;
}

module.exports = { initDBConnection, getDBConnection };
