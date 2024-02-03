const express = require("express");
const User = require("../models/user.model");
const router = express.Router();

router.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;

    let user = await User.findOne({ email });
    if (!user) {
      user = await User.create({ name, email, profilePic });
      res.status(200).json({
        status: "success",
        user,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: "fail",
      error,
    });
  }
});

module.exports = router;
