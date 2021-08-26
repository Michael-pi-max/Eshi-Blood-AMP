const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const morgan = require("morgan");
const path = require("path");
const cors = require("cors");
dotenv.config();

/**
 * Routers
 */
 const userRouter = require("./routes/user");
 const roleRouter = require("./routes/role");
 const donationCenterRouter = require("./routes/donationCenter");
 const appointmentRouter = require("./routes/appointment");
 const timeSlotRouter = require("./routes/timeSlot");
 const requestRouter = require("./routes/request");
 
 const app = express();

/**
 * Database configuration
 */
mongoose
  .connect(process.env.DATABASE_STRING, {
    useCreateIndex: true,
    useFindAndModify: true,
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("Connected to the database successfuly");
  });

/**
 * Middleware
 */
if (process.env.NODE_ENV == "development") {
  app.use(morgan("dev"));
}
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "../public")));

/**
 * Route Middleware
 */
 app.use("/api/v1/users", userRouter);
 app.use("/api/v1/roles", roleRouter);
 app.use("/api/v1/donationCenters", donationCenterRouter);
 app.use("/api/v1/appointments", appointmentRouter);
 app.use("/api/v1/timeSlots", timeSlotRouter);
 app.use("/api/v1/requests", requestRouter);



const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running at port ${port}`);
});
