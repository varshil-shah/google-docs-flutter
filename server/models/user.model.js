const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please provide your name"],
  },
  email: {
    type: String,
    required: [true, "Please provide your email"],
    unique: true,
  },
  profilePic: {
    type: String,
    default: "https://ik.imagekit.io/varshilshah/users/default.jpg",
  },
});

const User = mongoose.model("user", userSchema);

module.exports = User;
