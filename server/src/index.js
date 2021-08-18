const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const morgan = require("morgan");
const path = require("path");
const cors = require("cors");
dotenv.config();

const app = express();

/**
 * Routers
 */

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

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running at port ${port}`);
});
