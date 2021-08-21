const Request = require("../models/request");
const Appointment = require("../models/request");
const BloodType = require("../models/bloodType");

const { validationResult } = require("express-validator");
const User = require("../models/user");
const { model } = require("mongoose");

exports.getAllRequest = async (req, res, next) => {
  try {
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;

    const result = await Request.paginate(
      { isDeleted: false },
      {
        populate: {
          path: "bloodType createdBy updatedBy donors",
          populate: { path: "donors", model: "User" },
        },
        page,
        limit,
        sort: "-createdAt",
      }
    );
    res.status(200).json({
      status: "success",
      result,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.getRequest = async (req, res, next) => {
  try {
    const request = await Request.findOne({
      _id: req.params.id,
      isDeleted: false,
    }).populate("bloodType donors createdBy updatedBy");

    if (!request) {
      return res.status(404).json({
        status: "error",
        message: "Request with this ID does not exist",
      });
    }
    if (request.isDeleted) {
      return res.status(404).json({
        status: "error",
        message: "Request with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      request,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.createRequest = async (req, res, next) => {
  try {
    console.log(req.body.bloodType + "**********************");
    const userBloodType = await BloodType.findOne({
      bloodTypeName: req.body.bloodType,
    });

    let request = await Request.create({
      ...req.body,
      bloodType: userBloodType._id,
      createdBy: req.user._id,
      updatedBy: req.user._id,
      donors: [req.user._id],
    });
    request = await Request.findOne({
      _id: request._id,
      isDeleted: false,
    }).populate("bloodType donors created");

    res.status(201).json({
      status: "success",
      request,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.updateRequest = async (req, res, next) => {
  try {

    const userBloodType = await BloodType.findOne({
      bloodTypeName: req.body.bloodType,
    });

    let request = await Request.findByIdAndUpdate(
      req.params.id,
      { ...req.body, bloodType: userBloodType },
      {
        new: true,
      }
    );
    request = await Request.findOne({
      _id: request._id,
      isDeleted: false,
    }).populate("bloodType donors created");

    if (!request) {
      return res.status(404).json({
        status: "error",
        message: "Request with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      request,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.deleteRequest = async (req, res, next) => {
  try {
    const request = await Request.findByIdAndUpdate(req.params.id, {
      isDeleted: true,
    });

    if (!request) {
      return res.status(404).json({
        status: "error",
        message: "Request with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      request: null,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.acceptRequest = async (req, res, next) => {
  try {

    let request = await Request.findOne({
      _id: req.params.id,
      isDeleted: false,
    });

    if (!request) {
      return res.status(404).json({
        status: "error",
        message: "Request with this ID does not exist",
      });
    }

    request = await Request.updateOne(
      {
        _id: req.params.id,
      },
      { $inc: { totalDonations: 1 }, $push: { donors: req.user._id } }
    ).exec();

    request = await Request.findOne({
      _id: req.params.id,
      isDeleted: false,
    }).populate({
      path: "bloodType donors createdBy",
      populate: { path: "donors", model: "User" },
    });

    let appointment = await Appointment.create({
      userId: req.user._id,
      startDate: new Date().toISOString(),
      endDate: new Date(
        new Date().getTime() + 15 * 24 * 60 * 60 * 1000
      ).toISOString(),
      appointmentDescription: `Appointment using Request ${request._id}: Reason: ${request.reason}`,
    });

    res.status(200).json({
      status: "success",
      request,
    });
  } catch (error) {
    console.log(error);
  }
};
