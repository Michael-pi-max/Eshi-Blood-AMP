const { body, param } = require("express-validator");
const mongoose = require("mongoose");

/**
 *
 * @param {String} type
 * LOGIN | SIGNUP
 */
exports.validate = (type) => {
  switch (type) {
    case "GET":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid blood type ID"),
      ];
    case "CREATE":
      return [
        body("bloodType").not().isEmpty().withMessage("Blood Type is required"),
        body("description")
          .not()
          .isEmpty()
          .withMessage("Blood type description is required"),
      ];
    case "UPDATE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid Blood type  ID"),
        
      ];
    case "DELETE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid blood type ID"),
      ];

    default:
      return [];
  }
};
