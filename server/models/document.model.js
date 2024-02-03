const mongoose = require("mongoose");

const documentSchema = mongoose.Schema({
  uid: {
    type: String,
    required: [true, "UID is required"],
  },
  createdAt: {
    type: Number,
    required: [true, "CreatedAt is required"],
  },
  title: {
    type: String,
    required: [true, "Title is required"],
    trim: true,
  },
  content: {
    type: Array,
    default: [],
  },
});

const Document = mongoose.model("document", documentSchema);

module.exports = Document;
