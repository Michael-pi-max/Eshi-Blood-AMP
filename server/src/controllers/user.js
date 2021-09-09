const User = require("../models/user");
const Role = require("../models/role");
const BloodType = require("../models/bloodType");

const jwt = require("jsonwebtoken");
const { validationResult } = require("express-validator");

// uplodaing images

const getToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const isAgeAboveEighteen = async function (user) {
  const birthDate = new Date(user.dateOfBirth);
  const monthDiff = Date.now() - birthDate.getTime();
  const ageDiff = new Date(monthDiff);
  const year = ageDiff.getUTCFullYear();
  const age = Math.abs(year - 1970);
  return age >= 18 || false;
};

/**
 * @param {Object} req,
 * @param {Object}
 */

exports.login = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const user = await User.findOne({
      phoneNumber: req.body.phoneNumber,
      isDeleted: false,
    })
      .select("+password")
      .populate("roles bloodType");
    if (
      !user ||
      !(await user.verifyPassword(req.body.password, user.password))
    ) {
      return res.status(401).json({
        status: "error",
        message: "Invalid email or password",
      });
    }
    const token = getToken(user._id);
    res.status(201).json({
      status: "success",
      token,
      user,
    });
  } catch (err) {
    console.log(err);
  }
};

exports.signup = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const alreadyUserExisted = await User.exists({
      phoneNumber: req.body.phoneNumber,
    });
    if (alreadyUserExisted) {
      return res.status(400).json({
        status: "error",
        message: "Phone number already existed",
      });
    }

    const defaultRole = await Role.findOne({ roleName: "user" });
    const userBloodType = await BloodType.findOne({
      bloodTypeName: req.body.bloodType,
    });

    if (!req.file) {
      req.file = { filename: `${req.body.bloodType}.png` };
    }

    console.log(req.file.filename);
    let user = await User.create({
      ...req.body,
      bloodType: userBloodType._id,
      image: req.file.filename,
      roles: defaultRole._id,
    });

    user = await User.findById(user._id).populate("roles bloodType");
    const token = getToken(user._id);
    res.status(201).json({
      status: "success",
      token,
      user,
    });
  } catch (err) {
    //TODO: Handle Error
    console.log(err);
  }
};

exports.searchUserByName = async (req, res, next) => {
  try {
    const regex = new RegExp(req.query.q);
    const users = await User.find({
      $and: [
        {
          firstName: {
            $regex: regex,
            $options: "si",
          },
        },
        {
          _id: { $ne: req.user._id },
        },
      ],
    });
    res.status(200).json({
      status: "success",
      users,
    });
  } catch (err) {
    //TODO: Handle Error
  }
};

exports.getUserById = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }
    const user = await User.findById(req.params.id).populate("roles");
    if (!user) {
      return res.status(404).json({
        status: "error",
        message: "User with this ID does not exist",
      });
    }
    if (user.isDeleted) {
      return res.status(404).json({
        status: "error",
        message: "User with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      user,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.updateUser = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const user = await User.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    }).populate("roles");

    if (!user) {
      return res.status(404).json({
        status: "error",
        message: "User with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      user,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.getAllUsers = async (req, res, next) => {
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
    const bloodType = req.query.bloodType || null;

    const result = await User.paginate(
      { isDeleted: false },
      {
        populate: "roles bloodType",
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



exports.deleteUser = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: "error",
        message: errors.array()[0].msg,
      });
    }

    const user = await User.findByIdAndUpdate(req.params.id, {
      isDeleted: true,
    });

    if (!user) {
      return res.status(404).json({
        status: "error",
        message: "User with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      user,
    });
  } catch (error) {
    console.log(error);
  }
};