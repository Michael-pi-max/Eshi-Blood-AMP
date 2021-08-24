const fs = require("fs");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const colors = require("colors");

dotenv.config();

const User = require("./models/user");
const Role = require("./models/role");
const Appointment = require("./models/appointment");
const BloodType = require("./models/bloodType");
const DonationCenter = require("./models/donationCenter");
const Request = require("./models/request");
const TimeSlot = require("./models/timeSlot");

mongoose
  .connect("mongodb://localhost:27017/eshi-blood-amp", {
    useCreateIndex: true,
    useFindAndModify: true,
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("Connected to the database successfully".green);
  });

const users = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/users.json`, "utf-8")
);

const roles = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/roles.json`, "utf-8")
);

const appointments = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/appointments.json`, "utf-8")
);

const bloodTypes = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/bloodTypes.json`, "utf-8")
);
const donationCenters = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/donationCenters.json`, "utf-8")
);

const requests = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/requests.json`, "utf-8")
);

const timeSlots = JSON.parse(
  fs.readFileSync(`${__dirname}/_data/timeSlots.json`, "utf-8")
);

const importData = async () => {
  try {
    await Role.create(roles);
    await BloodType.create(bloodTypes);
    await User.create(users);
    await Appointment.create(appointments);
    await DonationCenter.create(donationCenters);
    await Request.create(requests);

    console.log("Data Imported...!".green.inverse);
    process.exit();
  } catch (error) {
    console.log(error);
  }
};

const deleteData = async () => {
  try {
    await User.deleteMany();
    await Role.deleteMany();
    await BloodType.deleteMany();
    await Appointment.deleteMany();
    await DonationCenter.deleteMany();
    await Request.deleteMany();

    console.log("Data Removed".red.inverse);
    process.exit();
  } catch (error) {
    console.log(error);
  }
};

if (process.argv[2] === "-i") {
  importData();
} else if (process.argv[2] === "-d") {
  deleteData();
}
