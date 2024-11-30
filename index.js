const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
const { connectToDB } = require("./src/config/database.js");

// Load environment variables
dotenv.config();

const app = express();

// Middleware
app.use(express.json());
app.use(morgan("dev"));

// Database
connectToDB();

// Routes
app.get("/", (req, res) => {
	res.send("Welcome to Fashion Store Management!");
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
	console.log(`Server is running on http://localhost:${PORT}`);
});
