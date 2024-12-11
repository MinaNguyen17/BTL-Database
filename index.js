const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
const { initDBConnection } = require("./src/config/database.js");
const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");
const mainRoutes = require("./src/routes/mainRoutes.js");
// Load environment variables
dotenv.config();
const PORT = process.env.PORT || 3000; // Khai báo biến PORT

const app = express();

// Middleware
app.use(express.json());
app.use(morgan("dev"));

// Khởi tạo kết nối database
(async () => {
  try {
    await initDBConnection(); // Kết nối một lần
    console.log("Database connection initialized");

    // Swagger Documentation
    const swaggerDocument = YAML.load("./swagger.yaml");
    app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

    // Routes
    app.use("/", mainRoutes);

    // Khởi độn g server
    app.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error("Failed to start the application:", err);
    process.exit(1); // Thoát nếu không kết nối được
  }
})();
