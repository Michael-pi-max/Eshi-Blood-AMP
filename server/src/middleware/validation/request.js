const { body, param } = require("express-validator");
const mongoose = require("mongoose");

exports.validate = (type) => {
  switch (type) {
    case "GET":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid Request ID"),
      ];
    case "CREATE":
      return [
        body("unitsNeeded")
          .not()
          .isEmpty()
          .withMessage("Units of Blood is required"),
       
        body("reason").not().isEmpty().withMessage("Reason is required"),
        body("bloodType").not().isEmpty().withMessage("Blood type is required"),
      ];
    case "UPDATE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid request ID"),
       
      ];
    case "DELETE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid request ID"),
      ];
  }
};
