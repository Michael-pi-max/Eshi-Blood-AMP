const express = require("express");
const { verifyUser, verifyRole } = require("../middleware/auth");
const bloodTypeController = require("../controllers/bloodType");
const bloodTypeValidation = require("../middleware/validation/bloodType");

const router = express.Router();

router
  .route("/")
  .get(verifyUser, bloodTypeController.getAllBloodTypes)
  .post(
    verifyUser,
    verifyRole("admin", "create", "bloodType"),
    bloodTypeValidation.validate("CREATE"),
    bloodTypeController.createBloodType
  );
router
  .route("/:id")
  .get(
    verifyUser,
    bloodTypeValidation.validate("GET"),
    appointmentController.getAppointment
  )
  .patch(
    verifyUser,
    verifyRole("admin", "update", "bloodType"),
    bloodTypeValidation("UPDATE"),
    bloodTypeController.updateBloodType
  )
  .delete(
    verifyUser,
    verifyRole("admin", "delete", "bloodType"),
    bloodTypeValidation.validate("DELETE"),
    bloodTypeController.deleteBloodType
  );
