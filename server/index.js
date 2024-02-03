const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

dotenv.config({
  path: "./.env",
});

const app = express();
app.use(express.json());

const authRoutes = require("./routes/auth.route");

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URL)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.log(err);
  });

app.use(authRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
