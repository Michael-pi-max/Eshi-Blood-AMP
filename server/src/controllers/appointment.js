const Appointment = require("../models/appointment");
const DonationCenter = require("../models/donationCenter");
const { validationResult } = require("express-validator");
const User = require("../models/user");

exports.getAllAppointments = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;
    const status = req.query.status || "pending";
    const startDate =
      req.query.startDate || new Date("December 17, 2000 03:24:00");
    const endDate =
      req.query.endDate || new Date('"December 17, 3000 03:24:00"');

    const result = await Appointment.paginate(
      {
        isDeleted: false,
        status,
        // startDate: { $lte: Date(startDate) },
        // endDate: { $gte: Date(endDate) },
      },
      {
        page,
        limit,
        sort: "-createdAt",
        populate: {
          path: "userId acceptorId donationCenter bloodType",
          populate: { path: "roles", model: "Role" },
        },
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

exports.getAppointment = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const appointment = await Appointment.findById(req.params.id).populate({
      path: "userId acceptorId donationCenter",
      populate: { path: "roles", model: "Role" },
    });

    if (!appointment) {
      return res.status(404).json({
        status: "error",
        message: "Appointment with this ID does not exist",
      });
    }
    if (appointment.isDeleted) {
      return res.status(404).json({
        status: "error",
        message: "Appointment with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      appointment,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.createAppointment = async (req, res, next) => {
  try {
    console.log(req.body);
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    let donationCenter = await DonationCenter.findOne({name:req.body.donationCenter});
    const appointment = await Appointment.create({
      ...req.body,
      userId: req.user._id,
      donationCenter: donationCenter._id,
      startDate: Date(req.body.startDate),
      endDate: Date(req.body.endDate),
    });

    const user = await User.updateOne(
      {
        _id: req.user._id,
      },
      { appointed: true }
    );

    // appointment = await Appointment.findById(appointment._id).populate({
    //   path: "userId acceptorId donationCenter",
    //   populate: { path: "roles", model: "Role" },
    // });

    res.status(201).json({
      status: "success",
      appointment,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.updateAppointment = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    console.log(req.body);
    let donationCenter = await DonationCenter.findOne({name:req.body.donationCenter});

    if(donationCenter == null ){
      donationCenter = req.body.donationCenter
    }else{
      donationCenter = donationCenter._id;
    }
    let appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      {
        ...req.body,
        // acceptorId: req.user._id ? ,
        donationCenter : donationCenter ,
        startDate: Date(req.body.startDate),
        endDate: Date(req.body.endDate),
      },
      { new: true, populate: "userId acceptorId donationCenter" }
    );

    if (!appointment) {
      return res.status(404).json({
        status: "error",
        message: "Appointment with this ID does not exist",
      });
    }

    if (req.body.status == "donated") {
       await User.updateOne(
        {
          _id: appointment.userId,
        },
        {
          appointed: false,
          $inc: { totalDonations: 1 },
          lastDonation: Date.now(),
        }
      ).populate("bloodType roles");
    }

    res.status(200).json({
      status: "success",
      appointment,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.deleteAppointment = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const appointment = await Appointment.findByIdAndUpdate(req.params.id, {
      isDeleted: true,
    });

    let user = await User.findByIdAndUpdate(appointment.userId, {appointed:false});

    if (!appointment) {
      return res.status(404).json({
        status: "error",
        message: "Appointment with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      appointment: null,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.getUserAppointment = async (req, res, next) => {
  try {
    const userId = req.user._id;
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 1;
    const status = req.query.status || "pending";

    const appointments = await Appointment.paginate(
      {
        $and: [
          {
            isDeleted: { $eq: false },
          },
          {
            userId: { $eq: userId },
          },
        ],
        status
      },
      {
        page,
        limit,
        sort: "-createdAt",
        populate: "userId acceptorId donationCenter",
      }
    );

    res.status(200).json({
      status: "success",
      appointments,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.getDonationCenterAllAppointments = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 1;
    const status = req.query.status || "pending";
    const startDate = req.query.startDate || "";
    const endDate = req.query.endDate || "";

    const result = await Appointment.paginate(
      { isDeleted: false, donationCenter: req.params.donationCenterId, status },
      {
        page,
        limit,
        sort: "-createdAt",
        populate: "userId acceptorId donationCenter",
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
