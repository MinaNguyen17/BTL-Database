const express = require("express");
const cors = require('cors');
const morgan = require("morgan");
const dotenv = require("dotenv").config();

const { initDBConnection } = require("./src/config/database.js");
const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");
const mainRoutes = require("./src/routes/mainRoutes.js");
// Load environment variables
const PORT = process.env.PORT || 3000; // Khai báo biến PORT

const app = express();





const corsOptions = {
	origin: function (origin, callback) {
	  // Allow requests with no origin (like mobile apps or curl requests)
	  const allowedOrigins = [
		'http://localhost:5173',  // Vite dev server
		'http://127.0.0.1:5173',
		'http://localhost:3000',  // React default
		'http://localhost:4869'   // Your backend server
	  ];
	  
	  if (!origin || allowedOrigins.indexOf(origin) !== -1) {
		callback(null, true);
	  } else {
		callback(new Error('Not allowed by CORS'));
	  }
	},
	methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
	allowedHeaders: [
	  'Content-Type', 
	  'Authorization', 
	  'Access-Control-Allow-Methods', 
	  'Access-Control-Allow-Origin'
	],
	credentials: true,
	optionsSuccessStatus: 200
  };
  
  // Apply CORS middleware
  app.use(cors(corsOptions));
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
