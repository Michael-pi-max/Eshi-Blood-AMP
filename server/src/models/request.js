const mongoose = require("mongoose");
const mongoosePaginate = require("mongoose-paginate");

const requestSchema = new mongoose.Schema(
  {
    unitsNeeded: {
      type: Number,
      default:0,
    },
    reason: {
      type: String,
      default:"Emergency"
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
      type: mongoose.Schema.Types.ObjectId,
      ref: "BloodType",
      default :"5d7a514b5d2c12c7449be240",
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

requestSchema.plugin(mongoosePaginate);

const Request = mongoose.model("Request", requestSchema);

module.exports = Request;
