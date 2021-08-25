const { body, param } = require("express-validator");
const mongoose = require("mongoose");

exports.validate = (type) => {
  switch (type) {
    case "GET":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.Object.isValid(value);
          })
          .withMessage("Invalid Donation Center ID"),
      ];
    case "CREATE":
      return [
        body("name")
          .not()
          .isEmpty()
          .withMessage("Donation Center Name is Required"),
        body("address")
          .not()
          .isEmpty()
          .withMessage("Donation Center Address is required"),
        // body("createdBy")
        //   .not()
        //   .isEmpty()
        //   .withMessage("Donation Center created is required"),
      ];
    case "UPDATE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid Donation Center ID"),
        
      ];
    case "DELETE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid Donation Center ID"),
      ];
    default:
      return [];
  }
};
