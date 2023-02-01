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


///////////////// PACKAGES /////////////////

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const fs = require("fs");
const exp = require('constants');

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////


// Count the Phase Progress Percentage and project Progress Percentage and project Planned Progress Percentage
countNumberOfTasksAndUserAvailabilityPerUser = function (users) {

    for (let i = 0; i < users.length; i++) {
        //console.log(users[i].username);

        var tasksNumber;
        var available;

        async function countNumberOfTasksAndUserAvailabilityPerUser() {
            try {
                // Find the number of documents that match the specified query, and print out the count.
                tasksNumber = await TaskModel.countDocuments({
                    assignedTo: {
                        $in: users[i].username
                    }
                });

                if (tasksNumber <= 9) {
                    available = true;
                } else {
                    available = false;
                }

                //   console.log(`UsertasksNumber ${tasksNumber} ${available}`);

                UserModel.findOneAndUpdate({
                    username: users[i].username
                }, {
                    $set: {
                        "numberOfTasksAssignedToUser": tasksNumber,
                        "availability": available,
                    }
                }).then(function () {

                });

                //   console.log(`${users[i].username}:\n tasksNumber: ${tasksNumber}\n available: ${available}`);
            } catch (err) {
                // res.send('Error: ' + err);
            }

        }
        countNumberOfTasksAndUserAvailabilityPerUser().catch(console.dir);
    }
};


// Count the number of projects, Open/Closed/Future/Suggested/OnH Hold
// Calculate the Progress of Project, Overdue Project, Remaining Projects
userComponentCalculation = function (users) {
    //console.log(projects.length);
    for (let i = 0; i < users.length; i++) {

        //console.log(users[i].username);

        async function countNumberOfProjectsInProject() {

            var projectsNumber = 0;
            var openProjectsCount = 0;
            var expiredProjectsCount = 0;
            var closedProjectsCount = 0;
            var futureProjectsCount = 0;
            var suggestedProjectsCount = 0;

            var overDueProjectsCount = 0;
            var remainingProjectsCount = 0;

            var aheadOfScheduleProjectsCount = 0;
            var behindScheduleProjectsCount = 0;
            var onScheduleProjectsCount = 0;

            var projectProgress = 0;
            var projectProgressPercentage = 0;

            ///////////////////////////////////// Count the number of projects /////////////////////////////////////


            await ProjectModel.find({}).then(function (projects) {

                for (let k = 0; k < projects.length; k++) {
                    for (let j = 0; j < projects[k].members.length; j++) {
                        if (projects[k].members[j].memberUsername == users[i].username) {
                            projectsNumber = projectsNumber + 1;
                        } else {
                            {
                                projectsNumber = projectsNumber + 0;
                            }
                        }
                    }
                }

                return projectsNumber;
            });
            console.log(projectsNumber)


            if (projectsNumber == 0) {
                openProjectsCount = 0;
                expiredProjectsCount = 0;
                closedProjectsCount = 0;
                futureProjectsCount = 0;
                suggestedProjectsCount = 0;
                overDueProjectsCount = 0;
                remainingProjectsCount = 0;
                aheadOfScheduleProjectsCount = 0;
                behindScheduleProjectsCount = 0;
                onScheduleProjectsCount = 0;
                projectProgress = 0;
                projectProgressPercentage = 0;
            } else {

                await ProjectModel.find({
                    status: {
                        $eq: "Open"
                    }
                }).then(function (projects) {
                    if (projects === null) {
                        openProjectsCount = openProjectsCount + 0;
                    } else {
                        for (let k = 0; k < projects.length; k++) {
                            for (let j = 0; j < projects[k].members.length; j++) {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    openProjectsCount = openProjectsCount + 1;
                                } else {
                                    {
                                        openProjectsCount = openProjectsCount + 0;
                                    }
                                }
                            }
                        }
                    }
                    return openProjectsCount;
                });
                // console.log(openProjectsCount);


                await ProjectModel.find({
                    status: {
                        $eq: "Expired"
                    }
                }).then(function (projects) {
                    if (projects === null) {
                        expiredProjectsCount = expiredProjectsCount + 0;
                    } else {
                        for (let k = 0; k < projects.length; k++) {
                            for (let j = 0; j < projects[k].members.length; j++) {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    expiredProjectsCount = expiredProjectsCount + 1;
                                } else {
                                    {
                                        expiredProjectsCount = expiredProjectsCount + 0;
                                    }
                                }
                            }
                        }
                    }
                    return expiredProjectsCount;
                });

                await ProjectModel.find({
                    status: {
                        $eq: "Closed"
                    }
                }).then(function (projects) {
                    if (projects === null) {
                        closedProjectsCount = closedProjectsCount + 0;
                    } else {
                        for (let k = 0; k < projects.length; k++) {
                            for (let j = 0; j < projects[k].members.length; j++) {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    closedProjectsCount = closedProjectsCount + 1;
                                } else {
                                    {
                                        closedProjectsCount = closedProjectsCount + 0;
                                    }
                                }
                            }
                        }
                    }
                    return closedProjectsCount;
                });

                await ProjectModel.find({
                    status: {
                        $eq: "Future"
                    }
                }).then(function (projects) {
                    if (projects === null) {
                        futureProjectsCount = futureProjectsCount + 0;
                    } else {
                        for (let k = 0; k < projects.length; k++) {
                            for (let j = 0; j < projects[k].members.length; j++) {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    futureProjectsCount = futureProjectsCount + 1;
                                } else {
                                    {
                                        futureProjectsCount = futureProjectsCount + 0;
                                    }
                                }
                            }
                        }
                    }
                    return futureProjectsCount;
                });

                await ProjectModel.find({
                    status: {
                        $eq: "Suggested"
                    }
                }).then(function (projects) {
                    if (projects === null) {
                        suggestedProjectsCount = suggestedProjectsCount + 0;
                    } else {
                        for (let k = 0; k < projects.length; k++) {
                            for (let j = 0; j < projects[k].members.length; j++) {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    suggestedProjectsCount = suggestedProjectsCount + 1;
                                } else {

                                    suggestedProjectsCount = suggestedProjectsCount + 0;

                                }
                            }
                        }
                    }
                    return suggestedProjectsCount;
                });


                await ProjectModel.find({
                    progressCategories: {
                        $eq: "Ahead of schedule"
                    }
                }).then(function (projects) {

                    for (let k = 0; k < projects.length; k++) {
                        for (let j = 0; j < projects[k].members.length; j++) {
                            if (projects === null) {
                                aheadOfScheduleProjectsCount = aheadOfScheduleProjectsCount + 0;
                            } else {
                                for (let k = 0; k < projects.length; k++) {
                                    for (let j = 0; j < projects[k].members.length; j++) {
                                        if (projects[k].members[j].memberUsername == users[i].username) {
                                            aheadOfScheduleProjectsCount = aheadOfScheduleProjectsCount + 1;
                                        } else {

                                            aheadOfScheduleProjectsCount = aheadOfScheduleProjectsCount + 0;

                                        }
                                    }
                                }
                            }


                        }
                    }

                    return aheadOfScheduleProjectsCount;
                });

                await ProjectModel.find({
                    progressCategories: {
                        $eq: "Behind schedule"
                    }
                }).then(function (projects) {

                    for (let k = 0; k < projects.length; k++) {
                        for (let j = 0; j < projects[k].members.length; j++) {
                            if (projects === null) {
                                behindScheduleProjectsCount = behindScheduleProjectsCount + 0;
                            } else {
                                for (let k = 0; k < projects.length; k++) {
                                    for (let j = 0; j < projects[k].members.length; j++) {
                                        if (projects[k].members[j].memberUsername == users[i].username) {
                                            behindScheduleProjectsCount = behindScheduleProjectsCount + 1;
                                        } else {

                                            behindScheduleProjectsCount = behindScheduleProjectsCount + 0;

                                        }
                                    }
                                }
                            }


                        }
                    }

                    return behindScheduleProjectsCount;
                });



                await ProjectModel.find({
                    progressCategories: {
                        $eq: "On schedule"
                    }
                }).then(function (projects) {

                    for (let k = 0; k < projects.length; k++) {
                        for (let j = 0; j < projects[k].members.length; j++) {
                            if (projects === null) {
                                onScheduleProjectsCount = onScheduleProjectsCount + 0;
                            } else {
                                for (let k = 0; k < projects.length; k++) {
                                    for (let j = 0; j < projects[k].members.length; j++) {
                                        if (projects[k].members[j].memberUsername == users[i].username) {
                                            onScheduleProjectsCount = onScheduleProjectsCount + 1;
                                        } else {

                                            onScheduleProjectsCount = onScheduleProjectsCount + 0;

                                        }
                                    }
                                }
                            }


                        }
                    }

                    return onScheduleProjectsCount;
                });


                await ProjectModel.find({
                    status: {
                        $eq: "Open"
                    }
                }).then(function (projects) {

                    for (let k = 0; k < projects.length; k++) {
                        for (let j = 0; j < projects[k].members.length; j++) {
                            if (projects === null) {
                                overDueProjectsCount = overDueProjectsCount + 0;
                                remainingProjectsCount = remainingProjectsCount + 0;
                            } else {
                                if (projects[k].members[j].memberUsername == users[i].username) {
                                    if (Date.parse(projects[k].dueDate) < Date.now()) {
                                        overDueProjectsCount = overDueProjectsCount + 1;
                                        remainingProjectsCount = remainingProjectsCount + 0;
                                    } else {
                                        overDueProjectsCount = overDueProjectsCount + 0;
                                        remainingProjectsCount = remainingProjectsCount + 1;
                                    }
                                } else {
                                    {
                                        overDueProjectsCount = overDueProjectsCount + 0;
                                        remainingProjectsCount = remainingProjectsCount + 0;
                                    }
                                }

                            }
                            return overDueProjectsCount, remainingProjectsCount;


                        }
                    }

                    return openProjectsCount;
                });

                await ProjectModel.find({}).then(function (projects) {

                    for (let k = 0; k < projects.length; k++) {
                        for (let j = 0; j < projects[k].members.length; j++) {
                            if (projects === null) {
                                projectProgress = projectProgress + 0;
                            } else {
                                for (let k = 0; k < projects.length; k++) {
                                    for (let j = 0; j < projects[k].members.length; j++) {
                                        if (projects[k].members[j].memberUsername == users[i].username) {
                                            projectProgress = projectProgress + projects[k].progressPercentage;
                                        } else {

                                            projectProgress = projectProgress + 0;

                                        }
                                    }
                                }
                            }


                        }
                        projectProgressPercentage = (projectProgress / projects.length);
                    }


                    return projectProgressPercentage;
                });


            }


            // console.log(`4. ${users[i].username} - expiredCount: ${expiredCount}\nexpiredCount: ${expiredCount}\ninProgressCount: ${inProgressCount}\ndoneCount: ${doneCount}`)


            await UserModel.findOneAndUpdate({
                projectName: users[i].username
            }, {
                $set: {
                    "numberOfProjectsAssignedToUser": projectsNumber,
                    "expiredProjectsCount": expiredProjectsCount,
                    "openProjectsCount": openProjectsCount,
                    "closedProjectsCount": closedProjectsCount,
                    "futureProjectsCount": futureProjectsCount,
                    "suggestedProjectsCount": suggestedProjectsCount,
                    "overDueProjectsCount": overDueProjectsCount,
                    "remainingProjectsCount": remainingProjectsCount,
                    "aheadOfScheduleProjectsCount": aheadOfScheduleProjectsCount,
                    "behindScheduleProjectsCount": behindScheduleProjectsCount,
                    "onScheduleProjectsCount": onScheduleProjectsCount,
                    "projectProgressPercentage": projectProgressPercentage
                }
            }).then(
                // console.log(`${users[i].username} - expiredCount: ${expiredCount}\nexpiredCount: ${expiredCount}\ninProgressCount: ${inProgressCount}\ndoneCount: ${doneCount}`)

            );

            //console.log(`${users[i].username}:\n projectsNumber: ${projectsNumber}`);



        }
        countNumberOfProjectsInProject().catch(console.dir);
    }
};

// Count the number of project projects, milestones, phasese and project members 
// Calculate the total budget, total resource cost and total donated amount

module.exports = {
    countNumberOfTasksAndUserAvailabilityPerUser: countNumberOfTasksAndUserAvailabilityPerUser,
    userComponentCalculation: userComponentCalculation,
};