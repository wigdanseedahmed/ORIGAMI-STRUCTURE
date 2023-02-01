////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const {
    addAndUpdateProjectImage,
    getProjects,
    getProjectByProjectName,
    checkProjectExistsByProjectName,
    createProject,
    updateProjectByID,
    updateProjectByProjectName,
    deleteProjectByID,
    deleteProjectByProjectName,
} = require('../Controller/projects_api_controller')

const express = require('express');
const router = express.Router();

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const middleware = require("../middleware");

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "Uploads");
    },
    filename: (req, file, cb) => {
        cb(null, req.params.projectName + ".jpg");
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
  
  const uploadImage = multer({
    storage: storage,
    limits: {
       fileSize: 1024 * 1024 * 6,
     },
    // fileFilter: fileFilter,
  });

// Adding and update profile image
router.post("/add/image/:projectName", uploadImage.single("myFile"), addAndUpdateProjectImage);

// Get a list of projects from the DB
router.get('/projects', getProjects);

router.get('/getProjectByProjectName/:projectName', getProjectByProjectName);

// Check if project exists
router.get('/projects/checkIfProjectExistsUsingProjectName/:projectName', checkProjectExistsByProjectName)

// Add new project to the DB
router.post('/createProject', createProject);

// Update a project in the DB
router.put('/projects/id/:id', updateProjectByID);

router.put('/projects/projectName/:projectName', updateProjectByProjectName);

// Delete a project from the DB
router.delete('/projects/id/:id', deleteProjectByID);

router.delete('/projects/projectName/:projectName', deleteProjectByProjectName);


module.exports = router;