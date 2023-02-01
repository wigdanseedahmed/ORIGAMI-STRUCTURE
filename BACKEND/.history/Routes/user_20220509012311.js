////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const config = require("../config");
let middleware = require("../middleware");

const jwt = require("jsonwebtoken");

const express = require("express");
const router = express.Router();

const multer = require("multer");
const path = require("path");

///////////

const {
  addAndUpdateProfileImage,
  getUsers,
  getUserUsingUsername,
  getUserUsingEmail,
  checkUsernameExists,
  checkEmailExists,
  logIn,
  register,
  updateUserInformationByID,
  updateUserInformationByUsername,
  updateUserInformationByEmail,
  updateUserPasswordByUsername,
  updateUserPasswordByEmail,
  deleteUserByID,
  deleteUserByUsername,
  deleteUserByEmail
} = require("../Controller/user_api_controller");

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "../Profile Picture Uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.params.email + ".jpg");
    //cb(null, new Date().toISOString()+file.originalname);
  },
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 6,
  },
  // fileFilter: fileFilter,
});

// Adding and update user image
router.post("/add/image/:email", upload.single("myFile"), addAndUpdateProfileImage);

// Get a list of users from the DB
router.get('/users', getUsers);

router.get("/users/getUserUsingUsername/:username", getUserUsingUsername);

router.get("/users/getUserUsingEmail/:email", getUserUsingEmail);

// Check to see if user exists
router.get("/users/checkUsername/:username", checkUsernameExists);

router.get("/users/checkEmail/:email", checkEmailExists);

// Login User
router.post("/login", logIn);

// Register User
router.post("/register", register);

// Update user information in the DB
router.put("/users/id/:id", updateUserInformationByID);

router.put("/users/updateUserInformationByUsername/:username", updateUserInformationByUsername);

router.put("/users/updateUserInformationByEmail/:email", updateUserInformationByEmail);

// Update user password in the DB
router.put("/users/forgetPassword/username/:username", updateUserPasswordByUsername);

router.put("/users/forgetPassword/email/:email", updateUserPasswordByEmail);

//router.put("/users/forgetPassword/workEmail/:workEmail", updateUserPasswordByEmail);

// Delete a user from the DB
router.delete("/users/id/:id", deleteUserByID);

router.delete("/users/username/:username", deleteUserByUsername);

router.delete("/users/email/:email", deleteUserByEmail);

module.exports = router;