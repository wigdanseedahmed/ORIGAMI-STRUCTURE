////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

///////////////// MODELS /////////////////
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
  progressCalculation,
  projectComponentsCalculation,
  projectMembersComponentsCalculation
} = require('../Functions/project_data_based_fuctions');
const {
  userComponentsCalculation
} = require('../Functions/task_data_based_fuctions');

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const fs = require("fs");

////////////////////////////////////////////// API CONTROLLER //////////////////////////////////////////////


// Adding and update profile image
const addAndUpdateProjectImage = (async (req, res, next) => {
  /*const file = req.file
  if (!file) {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next("hey error")
  }*/

  var projectPhotoName = req.body.projectPhotoName;
  var projectPhotoFile = req.body.projectPhotoFile;

  var realFile = Buffer.from(projectPhotoFile, "base64");
  fs.writeFile(projectPhotoName, realFile, function (err) {
    if (err)
      console.log(err);
  });
  res.send("OK");


  ProjectModel.findOneAndUpdate({
      projectName: req.params.projectName
    }, {
      $set: {
        projectPhotoName: req.body.projectPhotoName,
        projectPhotoFile: req.body.projectPhotoFile,
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

// Get a list of project from the DB
const getProjects = ((req, res, next) => {

  // 1. Count the Phase Progress Percentage and project Progress Percentage

  ProjectModel.find({}).then(
    progressCalculation
  )

  // 2. Count the number of project tasks, milestones, phasese and project members 
  // 2. Calculate the total budget, total resource cost and total donated amount

  ProjectModel.find({}).then(
    projectComponentsCalculation
  )

  // 3. Count the number of member tasks, milestones, phasese and project members 

  ProjectModel.find({}).then(
    projectMembersComponentsCalculation
  )

  // 4. Count the number of tasks for each user

  UserModel.find({}).then(
    userComponentsCalculation
  )

  // Get all data
  ProjectModel.find({}).then(function (projects) {
    res.send(projects);
  });
})

const getProjectByProjectName = ((req, res, next) => {
  // 1. Count the Phase Progress Percentage and project Progress Percentage

  ProjectModel.find({}).then(
    progressCalculation
  )

  // 2. Count the number of project tasks, milestones, phasese and project members 
  // 2. Calculate the total budget, total resource cost and total donated amount

  ProjectModel.find({}).then(
    projectComponentsCalculation
  )

  // 3. Count the number of member tasks, milestones, phasese and project members 

  ProjectModel.find({}).then(
    projectMembersComponentsCalculation
  )

  // Get all data
  ProjectModel.find({
    projectName: req.params.projectName
  }).then(function (projects) {
    res.send(projects);
  });
})

const getProjectBasedOnMemberUsername = ((req, res, next) => {
  // 1. Count the Phase Progress Percentage and project Progress Percentage

  ProjectModel.find({}).then(
    progressCalculation
  )

  // 2. Count the number of project tasks, milestones, phasese and project members 
  // 2. Calculate the total budget, total resource cost and total donated amount

  ProjectModel.find({}).then(
    projectComponentsCalculation
  )

  // 3. Count the number of member tasks, milestones, phasese and project members 

  ProjectModel.find({}).then(
    projectMembersComponentsCalculation
  )

  // Get all data
  ProjectModel.find({}).then(function (projects) {
    res.send(projects);
  });
})


// Check if project exists
const checkProjectExistsByProjectName = ((req, res, next) => {
  // Get all data
  ProjectModel.findOne({
    projectName: req.params.projectName
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    if (result !== null) {
      return res.json({
        Status: true,
        msg: "Project exists",
        body: result
      });
    } else
      return res.json({
        Status: false,
        msg: "Project doesn't exist",
        body: result
      });
  });
})

// Add new project to the DB
const createProject = ((req, res, next) => {
  ProjectModel.create(req.body).then(function (project) {
    res.send(project);
  }).catch(next);

})

// Update a project in the DB
const updateProjectByID = ((req, res, next) => {
  // 1. Count the Phase Progress Percentage and project Progress Percentage

  ProjectModel.find({}).then(
    progressCalculation
  )

  // 2. Count the number of project tasks, milestones, phasese and project members 
  // 2. Calculate the total budget, total resource cost and total donated amount

  ProjectModel.find({}).then(
    projectComponentsCalculation
  )

  // 3. Count the number of member tasks, milestones, phasese and project members 

  ProjectModel.find({}).then(
    projectMembersComponentsCalculation
  )

  //to access :id ---> req.params.id
  ProjectModel.findByIdAndUpdate({
    _id: req.params.id
  }, {
    $set: req.body
  }).then(function () {
    ProjectModel.findOne({
      _id: req.params.id
    }).then(function (project) {
      res.send(project);
    });
  });
})

const updateProjectByProjectName = ((req, res, next) => {
  // 1. Count the Phase Progress Percentage and project Progress Percentage

  ProjectModel.find({}).then(
    progressCalculation
  )

  // 2. Count the number of project tasks, milestones, phasese and project members 
  // 2. Calculate the total budget, total resource cost and total donated amount

  ProjectModel.find({}).then(
    projectComponentsCalculation
  )

  // 3. Count the number of member tasks, milestones, phasese and project members 

  ProjectModel.find({}).then(
    projectMembersComponentsCalculation
  )

  //to access :id ---> req.params.id
  ProjectModel.findOneAndUpdate({
    projectName: req.params.projectName
  }, {
    $set: req.body
  }).then(function () {
    ProjectModel.findOne({
      projectName: req.params.projectName
    }).then(function (project) {
      res.send(project);
    });
  });
})


// Delete a project from the DB
const deleteProjectByID = ((req, res, next) => {
  //to access :id ---> req.params.id
  ProjectModel.findByIdAndRemove({
    _id: req.params.id
  }).then(function (project) {
    res.send(project);
  });
})

const deleteProjectByProjectName = ((req, res, next) => {
  //to access :id ---> req.params.id
  ProjectModel.findOneAndRemove({
    projectName: req.params.projectName
  }).then(function (project) {
    res.send(project);
  });
})

module.exports = {
  addAndUpdateProjectImage: addAndUpdateProjectImage,
  getProjects: getProjects,
  getProjectByProjectName: getProjectByProjectName,
  checkProjectExistsByProjectName: checkProjectExistsByProjectName,
  createProject: createProject,
  updateProjectByID: updateProjectByID,
  updateProjectByProjectName: updateProjectByProjectName,
  deleteProjectByID: deleteProjectByID,
  deleteProjectByProjectName: deleteProjectByProjectName,
}