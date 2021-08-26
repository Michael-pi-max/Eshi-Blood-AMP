const path = require("path");
const multer = require("multer");

const ImageType = function (originalUrl) {
  const imageType = originalUrl.split("/")[3];
  return imageType;
};

const destination = function (originalUrl) {
  const imageType = ImageType(originalUrl);
  return `../../public/images/${imageType}`;
};

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, destination(req.originalUrl)));
  },
  filename: function (req, file, cb) {
    cb(
      null,
      `${ImageType(req.originalUrl)}-${Date.now()}-${path.extname(
        file.originalname
      )}`
    );
  },
});

const uploadImage = multer({
  storage,
});

module.exports = uploadImage.single("image");
