const express = require("express");
const roleController = require("../controllers/role");
const roleValidation = require("../middleware/validation/role");
const userController = require("../controllers/user");
const userValidation = require("../middleware/validation/user");
const { verifyUser, verifyRole } = require("../middleware/auth");

const router = express.Router();

router
  .route("/")
  .get(
    verifyUser,
    verifyRole("admin", "read", "role"),
    roleController.getAllRoles
  )
  .post(
    verifyUser,
    verifyRole("admin", "create", "role"),
    roleValidation.validate("CREATE"),
    roleController.createRole
  );

module.exports = router;

router
  .route("/:id")
  .get(
    verifyUser,
    verifyRole("admin", "read", "role"),
    roleValidation.validate("GET"),
    roleController.getRole
  )
  .patch(
    verifyUser,
    verifyRole("admin", "update", "role"),
    roleValidation.validate("UPDATE"),
    roleController.updateRole
  )
  .delete(
    verifyUser,
    verifyRole("admin", "delete", "role"),
    roleValidation.validate("DELETE"),
    roleController.deleteRole
  );

router.route("/:roleName").get(roleController.getRoleByName);

module.exports = router;
