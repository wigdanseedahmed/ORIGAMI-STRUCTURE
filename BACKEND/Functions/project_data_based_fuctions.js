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


///////////////// PACKAGES /////////////////

const config = require("../config");

const jwt = require("jsonwebtoken");

const multer = require("multer");
const path = require("path");

const fs = require("fs");

////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////


// Count the Phase Progress Percentage and project Progress Percentage and project Planned Progress Percentage
progressCalculation = function (projects) {
    //console.log(projects.length);
    for (let i = 0; i < projects.length; i++) {

        async function calculateProgressPercentage() {
            var progressCategories = '';
            var projectProgressPercentage = 0;
            var plannedProjectProgressPercentage = 0;
            var phaseNo = 0;

            for (var phaseNumber in projects[i].phases) {

                var phaseProgressPercentage = 0;
                var plannedPhaseProgressPercentage = 0;

                phaseNo = phaseNo + 1;

                var tasks = await TaskModel.find({
                    $and: [{
                            projectName: projects[i].projectName
                        },
                        {
                            projectPhase: projects[i].phases[phaseNumber].phase
                        }
                    ]
                });

                //console.log(tasks)


                for (var task in tasks) {
                    if (tasks === null) {
                        phaseProgressPercentage = 0;
                        plannedPhaseProgressPercentage = 0;
                        //console.log(`${projects[i].projectName}:\ntask null: ${projects[i].phases[phase].phase} - ${phaseProgressPercentage}\n\n`);

                    } else {
                        ////////// ACTUAL PHASE PROGRESS PERCENTAGE //////////
                        if (tasks[task].weightGiven === null || tasks[task].percentageDone === null) {

                            phaseProgressPercentage = 0;
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase}\n task: ${tasks[task].taskName} - ${tasks[task].projectPhase} - ${tasks[task].weightGiven} - ${tasks[task].percentageDone} - ${((tasks[task].weightGiven * tasks[task].percentageDone)/100)}\nphaseProgressPercentage: ${phaseProgressPercentage} \n\n`)

                        } else {
                            phaseProgressPercentage = (((tasks[task].weightGiven) / 100 * (tasks[task].percentageDone) / 100) * 100);
                            // console.log(`5. ${projects[i].projectName}: phaseProgressPercentage: ${phaseProgressPercentage} \n\n`)

                        }
                        ////////// PLANNED PHASE PROGRESS PERCENTAGE //////////

                        if (tasks[task].weightGiven === null || tasks[task].plannedPercentageDone === null) {
                            plannedPhaseProgressPercentage = 0;
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase}\n task: ${tasks[task].taskName} - ${tasks[task].projectPhase} - ${tasks[task].weightGiven} - ${tasks[task].percentageDone} - ${((tasks[task].weightGiven * tasks[task].percentageDone)/100)}\nphaseProgressPercentage: ${phaseProgressPercentage} \n\n`)

                        } else {
                            plannedPhaseProgressPercentage = (((tasks[task].weightGiven) / 100 * (tasks[task].plannedPercentageDone) / 100) * 100);
                            // console.log(`5. ${projects[i].projectName}: phaseProgressPercentage: ${phaseProgressPercentage} \n\n`)

                        }
                    }


                    //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase} - ${projects[i].phases[phase].weightGiven}\n task: ${tasks[task].taskName} - ${tasks[task].projectPhase} - ${tasks[task].weightGiven} - ${tasks[task].percentageDone} - ${((tasks[task].weightGiven * tasks[task].percentageDone)/100)}\nphaseProgressPercentage: ${phaseProgressPercentage} \n\n`)


                    ////////// ACTUAL PHASE PROGRESS PERCENTAGE //////////
                    if (projects[i].phases[phaseNumber] === null) {
                        projectProgressPercentage = projectProgressPercentage + 0;
                    } else {
                        if (projects[i].phases[phaseNumber].weightGiven === null || phaseProgressPercentage === null) {
                            projectProgressPercentage = projectProgressPercentage + 0;
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase} - ${projects[i].phases[phase].weightGiven} - ${phaseProgressPercentage}\n projectProgressPercentage: ${projectProgressPercentage}\n\n`);
                        } else {

                            //////////////////// ADD PHASE PROGRESS PERCENTAGE ////////////////////
                            ProjectModel.updateOne({
                                projectName: projects[i].projectName
                            }, {
                                $set: {
                                    "phases.$[phases].progressPercentage": Number(phaseProgressPercentage)
                                }
                            }, {
                                arrayFilters: [{
                                    "phases.phase": projects[i].phases[phaseNumber].phase
                                }]
                            }).then(
                                // console.log(`${phaseNo}. ${projects[i].projectName}:${projects[i].phases[phaseNumber].phase}: ${phaseProgressPercentage}\n\n`)
                            );

                            projectProgressPercentage = projectProgressPercentage + ((projects[i].phases[phaseNumber].weightGiven / 100) * (phaseProgressPercentage / 100) * 100)
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase} - ${projects[i].phases[phase].weightGiven} - ${phaseProgressPercentage}\n projectProgressPercentage: ${projectProgressPercentage}\n\n`);

                        }
                    }


                    ////////// PLANNED PHASE PROGRESS PERCENTAGE //////////
                    if (projects[i].phases[phaseNumber] === null) {
                        plannedProjectProgressPercentage = plannedProjectProgressPercentage + 0;
                    } else {
                        if (projects[i].phases[phaseNumber].weightGiven === null || plannedPhaseProgressPercentage === null) {
                            plannedProjectProgressPercentage = plannedProjectProgressPercentage + 0;
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase} - ${projects[i].phases[phase].weightGiven} - ${plannedPhaseProgressPercentage}\n projectProgressPercentage: ${projectProgressPercentage}\n\n`);
                        } else {

                            //////////////////// ADD PHASE PROGRESS PERCENTAGE ////////////////////
                            ProjectModel.updateOne({
                                projectName: projects[i].projectName
                            }, {
                                $set: {
                                    "phases.$[phases].plannedPhaseProgressPercentage": Number(plannedPhaseProgressPercentage)
                                }
                            }, {
                                arrayFilters: [{
                                    "phases.phase": projects[i].phases[phaseNumber].phase
                                }]
                            }).then(
                                // console.log(`${phaseNo}. ${projects[i].projectName}:${projects[i].phases[phaseNumber].phase}: ${plannedPhaseProgressPercentage}\n\n`)
                            );

                            plannedProjectProgressPercentage = plannedProjectProgressPercentage + ((projects[i].phases[phaseNumber].weightGiven / 100) * (plannedPhaseProgressPercentage / 100) * 100)
                            //console.log(`${projects[i].projectName}:\n phase: ${projects[i].phases[phase].phase} - ${projects[i].phases[phase].weightGiven} - ${phaseProgressPercentage}\n projectProgressPercentage: ${projectProgressPercentage}\n\n`);

                        }
                    }
                }
            }

            if(plannedProjectProgressPercentage < projectProgressPercentage){
                progressCategories = "Ahead of schedule";
            } else if(plannedProjectProgressPercentage > projectProgressPercentage){
                progressCategories = "Behind schedule";
            } else if(plannedProjectProgressPercentage === 0) {
                progressCategories = "No schedule yet";
            } else  {
                progressCategories = "On schedule";
            }

            // console.log(progressCategories)

            // console.log(` 1. ${projects[i].projectName}: ${projectProgressPercentage}  ${plannedProjectProgressPercentage}\n\n`);

            //////////////////// ADD PROJECT PROGRESS PERCENTAGE ////////////////////
            ProjectModel.findOneAndUpdate({
                projectName: projects[i].projectName
            }, {
                $set: {
                    "progressPercentage": projectProgressPercentage,
                    "plannedProjectProgressPercentage": plannedProjectProgressPercentage,
                    "progressCategories": progressCategories
                }
            }).then(
                // console.log(`2. ${projects[i].projectName}: ${projectProgressPercentage}\n\n`)
            );


        }

        calculateProgressPercentage().catch(console.dir);
    }
};

// Count the number of project tasks, milestones, phasese and project members 
// Calculate the total budget, total resource cost and total donated amount
projectComponentsCalculation = function (projects) {
    //console.log(projects.length);
    for (let i = 0; i < projects.length; i++) {

        //console.log(projects[i].projectName);

        async function countNumberOfTasksInProject() {
            var phasesNumber = 0;
            var milestonesNumber = 0;
            var totalProjectMembers = 0;
            var totalBudget = 0;
            var totalResourceCost = 0;
            var totalDonatedAmount = 0;

            var tasksNumber = 0;
            var todoCount = 0;
            var onHoldCount = 0;
            var inProgressCount = 0;
            var doneCount = 0;
            var overDueTasksCount = 0;
            var remainingTasksCount = 0;

            var aheadOfScheduleTasksCount = 0;
            var behindScheduleTasksCount = 0;
            var onScheduleTasksCount = 0;

            var progressCategories = "";

            ///////////////////////////////////// Count the number of tasks /////////////////////////////////////
            tasksNumber = await TaskModel.countDocuments({
                projectName: {
                    $eq: projects[i].projectName
                }
            });

            if (tasksNumber == 0) {
                todoCount = 0;
                onHoldCount = 0;
                inProgressCount = 0;
                doneCount = 0;
                overDueTasksCount = 0;
                remainingTasksCount = 0;
                aheadOfScheduleTasksCount = 0;
                behindScheduleTasksCount = 0;
                onScheduleTasksCount = 0;
                progressCategories = null;
            } else {
                todoCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    status: {
                        $eq: "Todo"
                    }
                });

                onHoldCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    status: {
                        $eq: "On Hold"
                    }
                });

                inProgressCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    status: {
                        $eq: "In Progress"
                    }
                });

                doneCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    status: {
                        $eq: "Done"
                    }
                });

                aheadOfScheduleTasksCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    progressCategories: {
                        $eq: "Ahead of schedule"
                    }
                });

                behindScheduleTasksCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    progressCategories: {
                        $eq: "Behind schedule"
                    }
                });

                onScheduleTasksCount = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    progressCategories: {
                        $eq: "On schedule"
                    }
                });

                await TaskModel.find({
                    projectName: {
                        $eq: projects[i].projectName
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
            }

            // console.log(`4. ${projects[i].projectName} - onHoldCount: ${onHoldCount}\nonHoldCount: ${onHoldCount}\ninProgressCount: ${inProgressCount}\ndoneCount: ${doneCount}`)

            ///////////////////////////////////// Count the number of phases /////////////////////////////////////
            for (var phase in projects[i].phases) {
                phasesNumber = phasesNumber + 1;

            }

            ///////////////////////////////////// Count the number of milestones /////////////////////////////////////
            for (var milestone in projects[i].milestones) {
                milestonesNumber = milestonesNumber + 1;

            }

            ///////////////////////////////////// Count the number of project members /////////////////////////////////////
            for (var member in projects[i].members) {
                if (projects[i].members[member].projectJobPosition === "Project Member") {
                    totalProjectMembers = totalProjectMembers + 1
                } else {
                    totalProjectMembers = totalProjectMembers + 0
                };

            }

            ///////////////////////////////////// Calculate the total budget /////////////////////////////////////
            for (var budget in projects[i].budget) {
                totalBudget = totalBudget + projects[i].budget[budget].cost;

            }

            ///////////////////////////////////// Calculate the total resource cost /////////////////////////////////////
            for (var resources in projects[i].resources) {
                totalResourceCost = totalResourceCost + projects[i].resources[resources].cost;

            }

            ///////////////////////////////////// Calculate the total donated amount /////////////////////////////////////
            for (var donor in projects[i].donor) {
                totalDonatedAmount = totalDonatedAmount + projects[i].donor[donor].donationAmount;

            }

            

            await ProjectModel.findOneAndUpdate({
                projectName: projects[i].projectName
            }, {
                $set: {
                    "tasksNumber": tasksNumber,
                    "phasesNumber": phasesNumber,
                    "milestonesNumber": milestonesNumber,
                    "totalProjectMembers": totalProjectMembers,
                    "totalBudget": totalBudget,
                    "totalResourceCost": totalResourceCost,
                    "totalDonatedAmount": totalDonatedAmount,
                    "todoTasksCount": todoCount,
                    "onHoldTasksCount": onHoldCount,
                    "inProgressTasksCount": inProgressCount,
                    "doneTasksCount": doneCount,
                    "overDueTasksCount": overDueTasksCount,
                    "remainingTasksCount": remainingTasksCount,
                    "aheadOfScheduleTasksCount": aheadOfScheduleTasksCount,
                    "behindScheduleTasksCount": behindScheduleTasksCount,
                    "onScheduleTasksCount": onScheduleTasksCount
                }
            }).then(
                // console.log(`${projects[i].projectName} - onHoldCount: ${onHoldCount}\nonHoldCount: ${onHoldCount}\ninProgressCount: ${inProgressCount}\ndoneCount: ${doneCount}`)

            );

            //console.log(`${projects[i].projectName}:\n tasksNumber: ${tasksNumber}`);



        }
        countNumberOfTasksInProject().catch(console.dir);
    }
};

// Count the number of member tasks, milestones, phasese and project members 
projectMembersComponentsCalculation = function (projects) {
    //console.log(projects.length);
    for (let i = 0; i < projects.length; i++) {

        //console.log(projects[i].projectName);

        async function countNumberOfTasksInProject() {


            ///////////////////////////////////// Count the number of tasks /////////////////////////////////////
            ///////////////////////////////////// Count the number of project members /////////////////////////////////////
            for (var member in projects[i].members) {

                var todoCount = 0;
                var onHoldCount = 0;
                var inProgressCount = 0;
                var doneCount = 0;
                var overDueTasksCount = 0;
                var remainingTasksCount = 0;

                tasksNumber = await TaskModel.countDocuments({
                    projectName: {
                        $eq: projects[i].projectName
                    },
                    assignedTo: {
                        $in: projects[i].members[member].memberUsername
                    },
                });


                if (tasksNumber == 0) {
                    todoCount = 0;
                    onHoldCount = 0;
                    inProgressCount = 0;
                    doneCount = 0;
                    overDueTasksCount = 0;
                    remainingTasksCount = 0;
                } else {
                    todoCount = await TaskModel.countDocuments({
                        projectName: {
                            $eq: projects[i].projectName
                        },
                        assignedTo: {
                            $in: projects[i].members[member].memberUsername
                        },
                        status: {
                            $eq: "Todo"
                        }
                    });


                    onHoldCount = await TaskModel.countDocuments({
                        projectName: {
                            $eq: projects[i].projectName
                        },
                        assignedTo: {
                            $in: projects[i].members[member].memberUsername
                        },
                        status: {
                            $eq: "On Hold"
                        }
                    });


                    inProgressCount = await TaskModel.countDocuments({
                        projectName: {
                            $eq: projects[i].projectName
                        },
                        assignedTo: {
                            $in: projects[i].members[member].memberUsername
                        },
                        status: {
                            $eq: "In Progress"
                        }
                    });


                    doneCount = await TaskModel.countDocuments({
                        projectName: {
                            $eq: projects[i].projectName
                        },
                        assignedTo: {
                            $in: projects[i].members[member].memberUsername
                        },
                        status: {
                            $eq: "Done"
                        }
                    });

                    await TaskModel.find({
                        projectName: {
                            $eq: projects[i].projectName
                        },
                        assignedTo: {
                            $in: projects[i].members[member].memberUsername
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


                }

                //////////////////// ADD PHASE PROGRESS PERCENTAGE ////////////////////
                ProjectModel.updateOne({
                    projectName: projects[i].projectName
                }, {
                    $set: {
                        "members.$[members].tasksNumber": tasksNumber,
                        "members.$[members].todoTasksCount": todoCount,
                        "members.$[members].onHoldTasksCount": onHoldCount,
                        "members.$[members].inProgressTasksCount": inProgressCount,
                        "members.$[members].doneTasksCount": doneCount,
                        "members.$[members].overDueTasksCount": overDueTasksCount,
                        "members.$[members].remainingTasksCount": remainingTasksCount,
                    }
                }, {
                    arrayFilters: [{
                        "members.memberUsername": projects[i].members[member].memberUsername
                    }]
                }).then(
                    // console.log(`${phaseNo}. ${projects[i].projectName}:${projects[i].phases[phaseNumber].phase}: ${phaseProgressPercentage}\n\n`)
                );

            }


            //console.log(`${projects[i].projectName}:\n tasksNumber: ${tasksNumber}`);


        }
        countNumberOfTasksInProject().catch(console.dir);
    }
};


module.exports = {
    progressCalculation: progressCalculation,
    projectComponentsCalculation: projectComponentsCalculation,
    projectMembersComponentsCalculation: projectMembersComponentsCalculation,
};