const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

app.use("/health", (req, res, next) => {
	res.status(200).json({ status: "healthy", timestamp: new Date() });
});

app.get("/api/data", (req, res) => {
	res.status(200).json({
		message: "Hello from Azure Containers!",
		documentation: "Authentication is skipped. This API is fully public.",
	});
});

app.get("/api/ram", (req, res, next) => {
	res.sendFile(`${path.join(__dirname, "index.html")}`);
});

app.listen(PORT, () => {
	console.log(`Server is running at port ${PORT}`);
});
