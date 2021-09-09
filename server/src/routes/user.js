const express = require("express");
const userController = require("../controllers/user");
const userValidation = require("../middleware/validation/user");
const { verifyUser, verifyRole } = require("../middleware/auth");
const uploadImage = require("../controllers/uploadImage");

const router = express.Router();

router.post("/login", userValidation.validate("LOGIN"), userController.login);

router.post(
  "/signup",
  uploadImage,
  userValidation.validate("SIGNUP"),
  userController.signup
);

router
  .get(
    "/:id",
    verifyUser,
    verifyRole("user", "read", "user"),
    userValidation.validate("GET"),
    userController.getUserById
  )
  .patch(
    "/:id",
    verifyUser,
    verifyRole("user", "update", "user"),
    userValidation.validate("UPDATE"),
    userController.updateUser
  );

router.get(
  "/",
  verifyUser,
  verifyRole("user", "read", "user"),
  userValidation.validate("GET"),
  userController.getAllUsers
);

router.get("/search", verifyUser, userController.searchUserByName);

router.delete(
  "/:id",
  verifyUser,
  userValidation.validate("DELETE"),
  userController.deleteUser
)

module.exports = router;
