const { body } = require("express-validator");

/**
 *
 * @param {String} type
 * LOGIN | SIGNUP
 */
exports.validate = (type) => {
  switch (type) {
    case "LOGIN":
      return [
        body("phoneNumber")
          .not()
          .isEmpty()
          .withMessage("Phone number is required"),
        body("password").not().isEmpty().withMessage("Password is required"),
      ];
    case "SIGNUP":
      return [
        body("firstName").not().isEmpty().withMessage("First Name is required"),
        body("lastName").not().isEmpty().withMessage("Last Name is required"),
        body("phoneNumber")
          .not()
          .isEmpty()
          .withMessage("Phone Number is Required"),
        body("dateOfBirth")
          .not()
          .isEmpty()
          .withMessage("Date of birth is Required"),
        body("bloodType").not().isEmpty().withMessage("Blood type is Required"),
        body("password").not().isEmpty().withMessage("Password is required"),
      ];
    default:
      return [];
  }
};
