const mongoose = require("mongoose");
const mongoosePaginate = require("mongoose-paginate");

const requestSchema = new mongoose.Schema(
  {
    unitsNeeded: {
      type: Number,
    },
    reason: {
      type: String,
    },
    totalDonations: {
      type: Number,
      default: 0,
    },
    status: {
      type: String,
      enum: ["active", "pending", "closed"],
      default: "pending",
    },
    bloodType: {
      type: "mongoose.Schema.Types.ObjectId",
      ref: "BloodType",
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    updatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    donors: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
    isDeleted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);
appointmentSchema.plugin(mongoosePaginate);

const Request = mongoose.model("Request", requestSchema);

module.exports = Request;
