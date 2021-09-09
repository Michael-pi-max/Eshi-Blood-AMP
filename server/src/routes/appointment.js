const express = require("express");
const { verifyUser, verifyRole } = require("../middleware/auth");
const appointmentController = require("../controllers/appointment");
const appointmentValidation = require("../middleware/validation/appointment");

const router = express.Router();

router
  .route("/")
  .get(verifyUser, appointmentController.getAllAppointments)
  .post(
    verifyUser,
    verifyRole("user", "create", "appointment"),
    appointmentValidation.validate("CREATE"),
    appointmentController.createAppointment
  );
router
  .route("/:id")
  .get(
    verifyUser,
    appointmentValidation.validate("GET"),
    appointmentController.getAppointment
  )
  .patch(
    verifyUser,
    verifyRole("user", "update", "appointment"),
    appointmentValidation.validate("UPDATE"),
    appointmentController.updateAppointment
  )
  .delete(
    verifyUser,
    verifyRole("user", "delete", "appointment"),
    appointmentValidation.validate("DELETE"),
    appointmentController.deleteAppointment
  );
//appointment by user
router
  .route("/user/history")
  .get(verifyUser, appointmentController.getUserAppointment);

//appointment by donation center
router.route(
  "/donationCenter/:donationCenterId",
  verifyUser,
  appointmentController.getDonationCenterAllAppointments
);
module.exports = router;
