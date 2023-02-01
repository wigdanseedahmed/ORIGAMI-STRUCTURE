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

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const fs = require("fs");

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////

// Count the number of project tasks, milestones, phasese and project members 
// Calculate the total budget, total resource cost and total donated amount
userComponentsCalculation = function (users) {
    //console.log(projects.length);
    for (let i = 0; i < users.length; i++) {

        //console.log(projects[i].projectName);

        async function countNumberOfTasksInProject() {

            var tasksNumber = 0;
            var todoCount = 0;
            var onHoldCount = 0;
            var inProgressCount = 0;
            var doneCount = 0;
            var overDueTasksCount = 0;
            var doneOnTimeTasksCount = 0;
            var remainingTasksCount = 0;

            var aheadOfScheduleTasksCount = 0;
            var behindScheduleTasksCount = 0;
            var onScheduleTasksCount = 0;

            var progressPercentage = 0;

                ///////////////////////////////////// Count the number of tasks /////////////////////////////////////
                tasksNumber = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    }
                });

                if (tasksNumber == 0) {
                    todoCount = 0;
                    onHoldCount = 0;
                    inProgressCount = 0;
                    doneCount = 0;
                    overDueTasksCount = 0;
                    doneOnTimeTasksCount = 0;
                    remainingTasksCount = 0;
                    aheadOfScheduleTasksCount = 0;
                    behindScheduleTasksCount = 0;
                    onScheduleTasksCount = 0;
                    progressPercentage = 0;
                } else {
                    todoCount = await TaskModel.countDocuments({
                        assignedTo: {
                        $in: users[i].username
                    },
                    status: {
                        $eq: "Todo"
                    }
                });

                onHoldCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    status: {
                        $eq: "On Hold"
                    }
                });

                inProgressCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    status: {
                        $in: "In Progress"
                    }
                });

                doneCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    status: {
                        $eq: "Done"
                    }
                });

                aheadOfScheduleTasksCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    progressCategories: {
                        $eq: "Ahead of schedule"
                    }
                });

                behindScheduleTasksCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    progressCategories: {
                        $eq: "Behind schedule"
                    }
                });

                onScheduleTasksCount = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    },
                    progressCategories: {
                        $eq: "On schedule"
                    }
                });

                await TaskModel.find({
                    assignedTo: {
                        $in: users[i].username
                    },
                    $or: [{
                            'status': "Todo"
                        },
                        {
                            "status": "In Progress"
                        }
                    ]
                }).then(function (task) {
                    if (task === null) {
                        overDueTasksCount = overDueTasksCount + 0;
                        remainingTasksCount = remainingTasksCount + 0;
                    } else {
                        for (var i = 0; i < task.length; i++) {
                            if (task[i] == null) {
                                overDueTasksCount = overDueTasksCount + 0;
                                remainingTasksCount = remainingTasksCount + 0;
                            } else {
                                if (Date.parse(task[i].dueDateTime) < Date.now()) {
                                    overDueTasksCount = overDueTasksCount + 1;
                                    remainingTasksCount = remainingTasksCount + 0;
                                } else {
                                    overDueTasksCount = overDueTasksCount + 0;
                                    remainingTasksCount = remainingTasksCount + 1;
                                }
                            }
                        }
                    }
                    return overDueTasksCount, remainingTasksCount;
                });

                progressPercentage = (doneCount /  tasksNumber) * 100;
                console.log(progressPercentage);
            }

                // console.log(`4. ${users[i].username} - tasksNumber: ${tasksNumber}\n todoCount: ${todoCount}\n onHoldCount: ${onHoldCount}\n inProgressCount: ${inProgressCount}\n doneCount: ${doneCount}\n overDueTasksCount: ${overDueTasksCount}\n remainingTasksCount: ${remainingTasksCount}`)

               
                await UserModel.findOneAndUpdate({
                    username: users[i].username
                }, {
                    $set: {
                        "tasksNumber": tasksNumber,
                        "todoTasksCount": todoCount,
                        "onHoldTasksCount": onHoldCount,
                        "inProgressTasksCount": inProgressCount,
                        "doneTasksCount": doneCount,
                        "doneOnTimeTasksCount": doneOnTimeTasksCount,
                        "overDueTasksCount": overDueTasksCount,
                        "remainingTasksCount": remainingTasksCount,
                        "aheadOfScheduleTasksCount": aheadOfScheduleTasksCount,
                        "behindScheduleTasksCount": behindScheduleTasksCount,
                        "onScheduleTasksCount": onScheduleTasksCount,
                        "progressPercentage": progressPercentage
                    }
                }).then(
                    // console.log(`${projects[i].projectName} - onHoldCount: ${onHoldCount}\nonHoldCount: ${onHoldCount}\ninProgressCount: ${inProgressCount}\ndoneCount: ${doneCount}`)

                );

                //console.log(`${projects[i].projectName}:\n tasksNumber: ${tasksNumber}`);

           

        }
        countNumberOfTasksInProject().catch(console.dir);
    }
};



module.exports = {
    userComponentsCalculation: userComponentsCalculation,
};