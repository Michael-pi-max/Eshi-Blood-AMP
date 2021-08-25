const express = require("express");
const donationCenterValidation = require("../middleware/validation/donationCenter");
const donationCenterController = require("../controllers/donationCenter");
const appointmentController = require("../controllers/appointment");
const { verifyUser, verifyRole } = require("../middleware/auth");

const router = express.Router();

router
  .route("/")
  .get(
    verifyUser,
    donationCenterController.getAllDonationCenter
  )
  .post(
    verifyUser,
    verifyRole("admin", "create", "donationCenter"),
    donationCenterValidation.validate("CREATE"),
    donationCenterController.createDonationCenter
  );

router
  .route("/:id")
  .get(
    verifyUser,
    verifyRole("user", "read", "donationCenter"),
    donationCenterValidation.validate("GET"),
    donationCenterController.getDonationCenter
  )
  .patch(
    verifyUser,
    verifyRole("admin", "update", "donationCenter"),
    donationCenterValidation.validate("UPDATE"),
    donationCenterController.updateDonationCenter
  )
  .delete(
    verifyUser,
    verifyRole("admin", "delete", "donationCenter"),
    donationCenterValidation.validate("DELETE"),
    donationCenterController.deleteDonationCenter
  );

router
  .route("/user/near")
  .get(verifyUser, donationCenterController.getNearDonationCenter);

// donation center appointments
router.route(
  "/:donationCenterId/appointments/",
  verifyUser,
  appointmentController.getDonationCenterAllAppointments
);

module.exports = router;
