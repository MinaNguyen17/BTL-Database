const sql = require("mssql");

const config = {
  user: "your-username",
  password: "your-password",
  server: "your-server.database.windows.net",
  database: "your-database",
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

connectToDB();
