const express = require("express");

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.use("/health", (req, res, next) => {
	res.status(200).json({ status: "healthy", timestamp: new Date() });
});

app.get("/api/data", (req, res) => {
	res.status(200).json({
		message: "Hello from Azure Containers!",
		documentation: "Authentication is skipped. This API is fully public.",
	});
});

app.listen(PORT, () => {
	console.log(`Server is running at port ${PORT}`);
});
