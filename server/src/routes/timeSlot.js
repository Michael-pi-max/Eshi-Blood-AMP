const express = require("express");
const timeSlotValidation = require("../middleware/validation/timeSlot");
const timeSlotController = require("../controllers/timeSlot");

const router = express.Router();

module.exports = router;
