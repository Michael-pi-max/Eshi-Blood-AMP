const DonationCenter = require("../models/donationCenter");
const appointmentController = require("../controllers/appointment");
const { validationResult } = require("express-validator");

DonationCenter.createIndexes({ address: { city: "text" } });

exports.getAllDonationCenter = async (req, res, next) => {
  try {
    
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;
    const status = req.query.status || "open";

    const result = await DonationCenter.paginate(
      { isDeleted: false, status },
      {
        page,
        limit,
        sort: "-createdAt",
        populate: {
          path: "timeSlot createdBy updatedBy",
          populate: { path: "roles", model: "Role" },
        },
      }
    );
    return res.status(200).json({
      status: "success",
      result,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.getDonationCenter = async (req, res, next) => {
  try {

    const donationCenter = await DonationCenter.findOne({
      _id: req.params.id,
      isDeleted: false,
    }).populate({
      path: "timeSlot createdBy updatedBy",
      populate: { path: "roles", model: "Role" },
    });

    if (!donationCenter) {
      return res.status(404).json({
        status: "error",
        message: "Donation Center with this ID does not exist",
      });
    }
    if (donationCenter.isDeleted) {
      return res.status(404).json({
        status: "error",
        message: "Donation Center with this ID does not exist",
      });
    }
    return res.status(200).json({
      status: "success",
      donationCenter,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.createDonationCenter = async (req, res, next) => {
  try {
    
    const donationCenter = await DonationCenter.create({
      ...req.body,
      timeSlot: req.body.timeSlot._id,
      createdBy: req.user._id,
      // updatedBy: req.user._id,
    });

    return res.status(201).json({
      status: "success",
      donationCenter,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.updateDonationCenter = async (req, res, next) => {
  try {
    
    const donationCenter = await DonationCenter.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedBy: req.user._id },
      {
        new: true,
        populate: "timeSlot createdBy updatedBy",
      }
    );

    if (!donationCenter) {
      return res.status(404).json({
        status: "error",
        message: "Donation Center with this ID does not exist",
      });
    }
    return res.status(200).json({
      status: "success",
      donationCenter,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.deleteDonationCenter = async (req, res, next) => {
  try {
    
    const donationCenter = await DonationCenter.findByIdAndUpdate(
      req.params.id,
      {
        isDeleted: true,
      }
    );

    if (!donationCenter) {
      return res.status(404).json({
        status: "error",
        message: "Donation Center ID does not exist",
      });
    }
    return res.status(200).json({
      status: "success",
      donationCenter: null,
    });
  } catch (error) {}
};

exports.getNearDonationCenter = async (req, res, next) => {
  try {
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;
    const { state, city } = req.user.address;

    const result = await DonationCenter.paginate(
      {
        isDeleted: false,
        status: "open",
        "address.state": state,
        "address.city": city,
      },

      {
        page,
        limit,
        sort: "-createdAt",
        populate: {
          path: "timeSlot createdBy updatedBy",
          populate: { path: "roles", model: "Role" },
        },
      }
    );
    return res.status(200).json({
      status: "success",
      result,
    });
  } catch (error) {
    console.log(error);
  }
};
