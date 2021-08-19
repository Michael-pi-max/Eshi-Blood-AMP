const mongoose = require("mongoose");

const timeSlotSchema = new mongoose.Schema(
  {
    startDate: { type: Date },
    endDate: { type: Date },
    status: {
      type: String,
      enum: ["open", "closed"],
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


const TimeSlot = mongoose.model("TimeSlot", timeSlotSchema);

module.exports = TimeSlot;
