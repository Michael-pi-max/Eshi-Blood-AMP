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
          .withMessage("Invalid role ID"),
      ];
    case "CREATE":
      return [
        body("roleName").not().isEmpty().withMessage("Role name is required"),
        body("permissions")
          .not()
          .isEmpty()
          .withMessage("Role permissions are required"),
        body("title").not().isEmpty().withMessage("Role title is required"),
      ];
    case "UPDATE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid role ID"),
       
      ];
    case "DELETE":
      return [
        param("id")
          .custom((value) => {
            return mongoose.Types.ObjectId.isValid(value);
          })
          .withMessage("Invalid role ID"),
      ];

    default:
      return [];
  }
};
