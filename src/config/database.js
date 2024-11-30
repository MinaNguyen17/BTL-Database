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

async function connectToDB() {
	try {
		let pool = await sql.connect(config);
		console.log("Connected to Azure SQL Database");
		return pool;
	} catch (err) {
		console.error("Database connection failed:", err);
	}
}

module.exports = { connectToDB };
