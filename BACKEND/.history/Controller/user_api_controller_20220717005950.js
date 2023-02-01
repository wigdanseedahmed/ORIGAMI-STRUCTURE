////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const {
  ProjectModel,
  ProjectSchema
} = require('../Models/Project Models/projects_model');
const {
  TaskModel,
  TaskSchema
} = require('../Models/Tasks Models/tasks_model');
const {
  UserModel,
  registerUserModel
} = require('../Models/User Models/user_model');

///////////////// FUNCTIONS /////////////////
const {
  countNumberOfTasksAndUserAvailabilityPerUser,
  userComponentCalculation
} = require('../Functions/user_data_based_fuctions');

const config = require("../config");

const jwt = require("jsonwebtoken");

const fs = require("fs");

const multer = require("multer");
const path = require("path");

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////

// Adding and update profile image
const imageStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "../Profile Picture Uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.decoded.username + ".jpg");
  },
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const uploadImage = multer({
  storage: imageStorage,
  limits: {
    fileSize: 1024 * 1024 * 6,
  },
  // fileFilter: fileFilter,
});


// Adding and update profile image
const addAndUpdateProfileImage = (async (req, res, next) => {
  /*const file = req.file
  if (!file) {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next("hey error")
  }*/

  var userPhotoName = req.body.userPhotoName;
  var userPhotoFile = req.body.userPhotoFile;

  var realFile = Buffer.from(userPhotoFile, "base64");
  fs.writeFile(userPhotoName, realFile, function (err) {
    if (err)
      console.log(err);
  });
  res.send("OK");


  UserModel.findOneAndUpdate({
      email: req.params.email
    }, {
      $set: {
        userPhotoName: req.body.userPhotoName,
        userPhotoFile: req.body.userPhotoFile,
      },
    }, {
      new: true
    },
    (err, profile) => {
      if (err) return res.status(500).send(err);
      const response = {
        message: "image added successfully updated",
        data: profile,
      };
      return res.status(200).send(response);
    }
  );


});


// Get a list of users from the DB
const getUsers = ((req, res, next) => {
  // 1. Count Number Of Tasks And User Availability Per User
  UserModel.find({}).then(countNumberOfTasksAndUserAvailabilityPerUser);

  // 2. Count user dashboard components
  UserModel.find({}).then(userComponentCalculation);

  // Get all users
  UserModel.find({}).then(function (users) {
    res.send(users);
    //res.send(project);
  });
});

const getUserUsingUsername = ((req, res) => {
  // 1. Count Number Of Tasks And User Availability Per User
  UserModel.find({}).then(countNumberOfTasksAndUserAvailabilityPerUser);

  // 2. Count user dashboard components
  UserModel.find({}).then(userComponentCalculation);

  // Get user
  UserModel.findOne({
    username: req.params.username
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    return res.json({
      data: result,
      username: req.params.username,
    });
  });
});

const getUserUsingEmail = ((req, res) => {
  // 1. Count Number Of Tasks And User Availability Per User
  UserModel.find({}).then(countNumberOfTasksAndUserAvailabilityPerUser);

  // 2. Count user dashboard components
  UserModel.find({}).then(userComponentCalculation);

  // Get user
  UserModel.findOne({
    email: req.params.email
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    return res.json({
      data: result,
      email: req.params.email,
    });
  });
});

// Check to see if user exists
const checkUsernameExists = ((req, res) => {
  UserModel.findOne({
    username: req.params.username
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    if (result !== null) {
      return res.json({
        Status: true,
        msg: "Username exists",
        body: result
      });
    } else
      return res.json({
        Status: false,
        msg: "Username doesn't exist",
        body: result
      });
  });
});

const checkEmailExists = ((req, res) => {
  UserModel.findOne({
    email: req.params.email
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    if (result !== null) {
      return res.json({
        Status: true,
        msg: "Email exists",
        body: result
      });
    } else
      return res.json({
        Status: false,
        msg: "Email doesn't exist",
        body: result
      });
  });
});

checkDuplicateUsernameOrEmail = (req, res, next) => {
  // Username
  UserModel.findOne({
    username: req.body.username
  }).exec((err, user) => {
    if (err) {
      res.status(500).send({
        message: err
      });
      return;
    }
    if (user) {
      res.status(400).send({
        message: "Failed! Username is already in use!"
      });
      return;
    }
    // Email
    UserModel.findOne({
      email: req.body.email
    }).exec((err, user) => {
      if (err) {
        res.status(500).send({
          message: err
        });
        return;
      }
      if (user) {
        res.status(400).send({
          message: "Failed! Email is already in use!"
        });
        return;
      }
      next();
    });
  });
};

checkRolesExisted = (req, res, next) => {
  if (req.body.roles) {
    for (let i = 0; i < req.body.roles.length; i++) {
      if (!ROLES.includes(req.body.roles[i])) {
        res.status(400).send({
          message: `Failed! Role ${req.body.roles[i]} does not exist!`
        });
        return;
      }
    }
  }
  next();
};

// Login User
const logIn = ((req, res) => {
  // 1. Count Number Of Tasks And User Availability Per User
  UserModel.find({}).then(countNumberOfTasksAndUserAvailabilityPerUser);

  // 2. Count user dashboard components
  UserModel.find({}).then(userComponentCalculation);

  // Get user
  UserModel.findOne({
    $or: [{
        "email": req.body.email
      },
      //{"phone": userEmailPhone},
      {
        "userName": req.body.username
      }
    ]
  }, (err, result) => {
    if (err) {
      return res.status(500).json({
        msg: err
      });
    }

    // validate username, email, or phone number
    if (result === null) {
      return res.status(404).json("Username or email incorrect");
    }

    //Validate password
    if (result.password === req.body.password) {
      // here we implement the JWT token functionality
      let token = jwt.sign({
        $or: [{
            "email": req.body.email
          },
          //{"phone": userEmailPhone},
          {
            "userName": req.body.username
          }
        ]
      }, config.key, {});

      res.json({
        token: token,
        msg: "success",
      });
    } else {
      res.status(403).json("password is incorrect");
    }
  });
});

// Register User
const register = ((req, res) => {
  console.log("inside the register");
  const user = new UserModel({
    username: req.body.username,
    password: req.body.password,
    email: req.body.email,
  });
  user
    .save()
    .then(() => {
      console.log("user registered");
      res.status(200).json({
        msg: "User Successfully Registered"
      });
    })
    .catch((err) => {
      res.status(403).json({
        msg: err
      });
    });
});

// Update a user information in the DB
const updateUserInformationByID = ((req, res, next) => {
  //to access :id ---> req.params.id
  UserModel.findByIdAndUpdate({
    _id: req.params.id
  }, {
    $set: req.body
  }).then(function () {
    UserModel.findOne({
      _id: req.params.id
    }).then(function (user) {
      res.send(user);
    });
  });
});

const updateUserInformationByUsername = ((req, res, next) => {
  //to access :id ---> req.params.id
  UserModel.findOneAndUpdate({
    username: req.params.username
  }, {
    $set: req.body
  }).then(function () {
    UserModel.findOne({
      username: req.params.username
    }).then(function (user) {
      res.send(user);
    });
  });
});

const updateUserInformationByEmail = ((req, res, next) => {
  //to access :id ---> req.params.id
  UserModel.findOneAndUpdate({
    email: req.params.email
  }, {
    $set: req.body
  }).then(function () {
    UserModel.findOne({
      email: req.params.email
    }).then(function (user) {
      res.send(user);
    });
  });
});

// Update a user password in the DB
const updateUserPasswordByUsername = ((req, res, next) => {
  //to access :username ---> req.params.username
  console.log(req.params.username);
  UserModel.findOneAndUpdate({
      username: req.params.username
    }, {
      $set: {
        password: req.body.password
      }
    },
    (err, result) => {
      if (err) return res.status(500).json({
        msg: err
      });
      const msg = {
        msg: "password successfully updated",
        username: req.params.username,
      };
      return res.json(msg);
    }
  );
});

const updateUserPasswordByEmail = ((req, res, next) => {
  //to access :id ---> req.params.id
  console.log(req.params.email);
  UserModel.findOneAndUpdate({
      email: req.params.email
    }, {
      $set: {
        password: req.body.password
      }
    },
    (err, result) => {
      if (err) return res.status(500).json({
        msg: err
      });
      const msg = {
        msg: "password successfully updated",
        email: req.params.email,
      };
      return res.json(msg);
    }
  );
});

// Delete a user from the DB
const deleteUserByID = ((req, res, next) => {
  //to access :id ---> req.params.id
  UserModel.findByIdAndRemove({
    _id: req.params.id
  }).then(function (user) {
    res.send(user);
  });
})

const deleteUserByUsername = ((req, res, next) => {
  //to access :username ---> req.params.username
  UserModel.findOneAndDelete({
      username: req.params.username
    },
    (err, result) => {
      if (err) return res.status(500).json({
        msg: err
      });
      const msg = {
        msg: "user deleted",
        username: req.params.username,
      };
      return res.json(msg);
    });
});

const deleteUserByEmail = ((req, res, next) => {
  //to access :email ---> req.params.email
  UserModel.findOneAndDelete({
      email: req.params.email
    },
    (err, result) => {
      if (err) return res.status(500).json({
        msg: err
      });
      const msg = {
        msg: "user deleted",
        email: req.params.email,
      };
      return res.json(msg);
    });
});

module.exports = {
  addAndUpdateProfileImage: addAndUpdateProfileImage,
  getUsers: getUsers,
  getUserUsingUsername: getUserUsingUsername,
  getUserUsingEmail: getUserUsingEmail,
  checkUsernameExists: checkUsernameExists,
  checkEmailExists: checkEmailExists,
  logIn: logIn,
  register: register,
  updateUserInformationByID: updateUserInformationByID,
  updateUserInformationByUsername: updateUserInformationByUsername,
  updateUserInformationByEmail: updateUserInformationByEmail,
  updateUserPasswordByUsername: updateUserPasswordByUsername,
  updateUserPasswordByEmail: updateUserPasswordByEmail,
  deleteUserByID: deleteUserByID,
  deleteUserByUsername: deleteUserByUsername,
  deleteUserByEmail: deleteUserByEmail
};