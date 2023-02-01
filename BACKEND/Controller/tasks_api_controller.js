////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

///////////////// Import Schemas /////////////////

const FileSchema = require('../Models/Tasks Models/file_model');

///////////////// MODELS /////////////////
const {
  ProjectModel,
  ProjectSchema
} = require('../Models/Project Models/projects_model');
const {
  TaskModel,
  TaskSchema
} = require('../Models/Tasks Models/tasks_model');

///////////////// FUNCTIONS /////////////////
const {
  progressCalculation,
  projectComponentsCalculation,
  projectMembersComponentsCalculation
} = require('../Functions/project_data_based_fuctions');

///////////////// OTHERS /////////////////

const config = require("../config");

const jwt = require("jsonwebtoken");

const fs = require("fs");

const multer = require("multer");
const path = require("path");

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////


const addAndUpdateTaskFiles1 =  ((req, res, next) => {
  const file = req.file;

  if (!file) {
      const error = new Error('Please upload a file');
      error.httpStatusCode = 400;
      return next("hey error");
  }

  const imagepost = new TaskModel({
    taskFiles:
      {taskFile: file.path}
  });

  const savedimage = imagepost.save()
  res.json(savedimage)
});

// Adding and update profile image
const addAndUpdateTaskFiles = ((req, res, next) => {
  /*const file = req.file
  if (!file) {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next("hey error")
  }*/
  

  var taskFiles = req.body.taskFiles;

  // var realFile = Buffer.from(taskFiles, "base64");

   console.log(req.body.taskFiles);

  // console.log(req.body.buffer.toString("base64"));

  // fs.writeFile(taskFiles, realFile, function (err) {
  //   if (err)
  //     console.log(err);
  // });

  TaskModel.findOneAndUpdate({
    taskName: req.params.taskName
  }, {
      $set: {
        taskFiles: taskFiles,
      },
    }, {
      new: true
    },
    (err, file) => {
      if (err) {
        console.log(err);
        var response = {
            message: "Error: Could not upload",
        };
        res.writeHead(404, {
            "Content-Type": "application/json",
        });
        return res.end(JSON.stringify(response));
    } else {
      console.log("Success 1");
        var response = {
            message: "Files Added succesfully",
        };
        res.writeHead(200, {
            "Content-Type": "application/json",
        });
        console.log("Success 2");
        return res.end(JSON.stringify(response));
    }

      // if (err) return res.status(500).send(err);
      // const response = {
      //   message: "file added successfully updated",
      //   data: file,
      // };
      // return res.status(200).send(response);
    }
  );


});

// Get a list of tasks from the DB
const getTasks = ((req, res, next) => {
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
  TaskModel.find({}).then(function (tasks) {
    res.send(tasks);
  });
})

const getTaskByTaskName = ((req, res, next) => {
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
  TaskModel.find({
    taskName: req.params.taskName
  }).then(function (task) {
    res.send(task);
  });
})

// Check if Task exists
const checkTaskExistsByProjectName = ((req, res, next) => {
  // Get all data
  TaskModel.findOne({
    taskName: req.params.taskName
  }, (err, result) => {
    if (err) return res.status(500).json({
      msg: err
    });
    if (result !== null) {
      return res.json({
        Status: true,
        msg: "Task exists",
        body: result
      });
    } else
      return res.json({
        Status: false,
        msg: "Task doesn't exist",
        body: result
      });
  });
})

// Add new task to the DB
const createTask = ((req, res, next) => {
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

  // Create New Task
  TaskModel.create(req.body).then(function (task) {
    res.send(task);
  }).catch(next);

})

// Update a task in the DB
const updateTaskByID = ((req, res, next) => {
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
  TaskModel.findByIdAndUpdate({
    _id: req.params.id
  }, {
    $set: req.body
  }).then(function () {
    TaskModel.findOne({
      _id: req.params.id
    }).then(function (task) {
      res.send(task);
    });
  });
})

const updateTaskByTaskName = ((req, res, next) => {
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
  TaskModel.findOneAndUpdate({
    taskName: req.params.taskName
  }, {
    $set: req.body
  }).then(function () {
    TaskModel.findOne({
      taskName: req.params.taskName
    }).then(function (task) {
      res.send(task);
    });
  });
})


// Delete a task from the DB
const deleteTaskByID = ((req, res, next) => {
  //to access :id ---> req.params.id
  TaskModel.findByIdAndRemove({
    _id: req.params.id
  }).then(function (task) {
    res.send(task);
  });
})

const deleteTaskByTaskName = ((req, res, next) => {
  //to access :id ---> req.params.id
  TaskModel.findOneAndRemove({
    taskName: req.params.taskName
  }).then(function (task) {
    res.send(task);
  });
})



module.exports = {
  addAndUpdateTaskFiles1: addAndUpdateTaskFiles1,
  addAndUpdateTaskFiles: addAndUpdateTaskFiles,
  getTasks: getTasks,
  getTaskByTaskName: getTaskByTaskName,
  checkTaskExistsByProjectName: checkTaskExistsByProjectName,
  createTask: createTask,
  updateTaskByID: updateTaskByID,
  updateTaskByTaskName: updateTaskByTaskName,
  deleteTaskByID: deleteTaskByID,
  deleteTaskByTaskName: deleteTaskByTaskName,
}