const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth.middleware");

const User = require("../models/user.model");

router.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;

    let user = await User.findOne({ email });
    if (!user) {
      user = await User.create({ name, email, profilePic });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    res.status(200).json({
      status: "success",
      user,
      token,
    });
  } catch (error) {
    res.status(500).json({
      status: "fail",
      error,
    });
  }
});

router.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({
        status: "fail",
        msg: "User not found",
      });
    }

    res.status(200).json({
      status: "success",
      user,
      token: req.token,
    });
  } catch (error) {
    res.status(500).json({
      status: "fail",
      error: error.message,
    });
  }
});

module.exports = router;
