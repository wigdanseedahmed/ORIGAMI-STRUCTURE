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
    User,
    registerUser
} = require('../Models/User Models/user_model');

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const fs = require("fs");

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////


// Get a list of tasks from the DB
const recommedation = ((req, res, next) => {
    // Count the number of tasks, milestones, phasese and project members 
    // Calculate the total budget, total resource cost and total donated amount

    User.find({}).then(function (users) {
        //console.log(projects.length);
        for (let i = 0; i < users.length; i++) {

            //console.log(projects[i].projectName);

            async function countNumberOfTasksInProject() {
                var availabily;
                var tasksNumber = 0;

                var allUsers = User.find({});
                var allTasks = TaskModel.find({});
                var allProjects = ProjectModel.find({});

                console.log(allProjects)


                try {
                    // Count the number of tasks
                    tasksNumber = await TaskModel.countDocuments({
                        assignedTo: {
                            $eq: users[i].username
                        },
                        $or: [{
                                status: "In Progress"
                            },
                            {
                                status: "Todo"
                            },
                        ]
                    });

                    if (tasksNumber < 8) {
                        availabily = true;
                    } else {
                        availabily = false;
                    }

                    //console.log(`${users[i].username}: tasksNumber: ${tasksNumber}`);

                } catch (err) {
                    res.send('Error: ' + err);
                }

            }
            countNumberOfTasksInProject().catch(console.dir);
        }
    });

    // Get all data
    TaskModel.find({}).then(function (tasks) {
        res.send(tasks);
    });
})

module.exports = recommedation;