const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const morgan = require("morgan");
const http = require("http");

dotenv.config({
  path: "./.env",
});

const app = express();
const server = http.createServer(app);
const io = require("socket.io")(server);

app.use(cors());
app.use(express.json());

const authRouter = require("./routes/auth.route");
const documentRoutes = require("./routes/document.route");

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URL)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.log(err);
  });

app.use(morgan("dev"));

app.use(authRouter);
app.use(documentRoutes);

app.use("*", (req, res) => {
  res.status(404).json({
    status: "fail",
    message: "Page not found",
  });
});

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log("A user joined the document");
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
