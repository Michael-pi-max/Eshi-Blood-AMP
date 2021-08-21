const mongoose = require("mongoose");

const schema = new mongoose.Schema(
  {
    bloodTypeName: {
      type: String,
      enum: [
        "A",
        "A+",
        "A-",
        "B",
        "B+",
        "B-",
        "AB",
        "AB+",
        "AB-",
        "O",
        "O+",
        "O-",
      ],
    },
    description: {
      type: String,
    },
    isDeleted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);


const BloodType = mongoose.model("BloodType", schema);

module.exports = BloodType;
