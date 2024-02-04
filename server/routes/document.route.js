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

router.get("/docs/me", auth, async (req, res) => {
  try {
    const documents = await Document.find({ uid: req.user });
    res.status(200).json(documents);
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

router.patch("/doc/title", auth, async (req, res) => {
  try {
    const { id, title } = req.body;
    const document = await Document.findByIdAndUpdate(
      id,
      { title },
      { new: true }
    );

    res.status(200).json(document);
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

router.get("/doc/:id", auth, async (req, res) => {
  try {
    const document = await Document.findById(req.params.id);
    res.status(200).json(document);
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

module.exports = router;
