const express = require("express");
const router = express.Router();
const Document = require("../models/document.model");

const auth = require("../middlewares/auth.middleware");

router.post("/doc/create", auth, async (req, res) => {
  try {
    const { createdAt } = req.body;
    let document = new Document({
      uid: req.user,
      title: "Untitled Document",
      createdAt,
    });
    document = await document.save();

    res.status(200).json(document);
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

module.exports = router;
