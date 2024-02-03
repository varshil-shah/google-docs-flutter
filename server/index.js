const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

dotenv.config({
  path: "./.env",
});

const app = express();

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
