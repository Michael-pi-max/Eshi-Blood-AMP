const BloodType = require("../models/bloodType");
const { validationResult } = require("express-validation");

exports.getAllBloodTypes = async (req, res, next) => {
  try {
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 20;
    const bloodTypeName = req.query.name || null;
    const result = await BloodType.paginate(
      { isDeleted: false, bloodTypeName },
      {
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

exports.getBloodType = async (req, res, next) => {
  try {
    const bloodType = await BloodType.findById(req.params.id);
    if (!bloodType) {
      return res.status(404).json({
        status: "error",
        message: "Blood Type with this ID does not exist",
      });
    }
    if (bloodType.isDeleted) {
      return res.status(404).json({
        status: "error",
        message: "Blood Type with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      bloodType,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.createBloodType = async (req, res, next) => {
  try {
    const bloodType = await BloodType.create({
      ...req.body,
    });

    res.status(201).json({
      status: "success",
      bloodType,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.updateBloodType = async (req, res, next) => {
  try {
    const bloodType = await BloodType.findByIdAndUpdate(
      req.params.id,
      req.body
    );

    if (!bloodType) {
      return res.status(404).json({
        status: "error",
        message: "Blood type with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      bloodType,
    });
  } catch (error) {
    console.log(error);
  }
};

exports.deleteBloodType = async (req, res, next) => {
  try {
    const bloodType = await BloodType.findByIdAndUpdate(req.params.id, {
      isDeleted: true,
    });

    if (!bloodType) {
      return res.status(404).json({
        status: "error",
        message: "Blood type with this ID does not exist",
      });
    }
    res.status(200).json({
      status: "success",
      bloodType: null,
    });
  } catch (error) {
    console.log(error);
  }
};
