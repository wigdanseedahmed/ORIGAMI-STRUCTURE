////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Import Schemas
const BudgetSchema = require('./budget_model');
const DonorSchema = require('./donor_model');
const EstimatedCostSchema = require('./estimated_cost_model');
const ExecutingAgencySchema = require('./executing_agency_model');
const MembersSchema = require('./members_model');
const MilestonesSchema = require('./milestones_model');
const PeopleAllowedToViewProjectSchema = require('./people_allowed_to_view_the_project_model');
const PhasesSchema = require('./phases_model');
const ResourcesSchema = require('./resources_model');
const {
    SkillSchema,
    SkillsRequiredSchema
} = require('./skills_required_model');
const LocationSchema = require('./locations_model');
const {
    TaskModel,
    TaskSchema
} = require('../Tasks Models/tasks_model')

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;


/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Project Schema and Model
const ProjectSchema = new Schema({

    id: {
        type: String
    },
    projectNo: {
        type: Number
    },
    projectName: {
        type: String,
        required: [true]
    },
    projectDescription: {
        type: String
    },
    projectManager: {
        type: String
    },
    projectSeniorManager: {
        type: String
    },
    projectCoordinator: {
        type: String
    },
    aims: {
        type: String
    },
    objective: {
        type: String
    },
    benefits: {
        type: String
    },
    deliverables: {
        type: String
    },
    risks: {
        type: String
    },
    outcome: {
        type: String
    },
    measurableCriteriaForSuccess: {
        type: String
    },
    projectPhotoName: {
        type: String
    },
    projectPhotoFile: {
        type: String
    },
    typeOfProject: {
        type: [String]
    },
    sdgs: {
        type: [String]
    },
    theme: {
        type: [String]
    },
    status: {
        type: String
    },
    tasksStatusList: {
        type: [String]
    },
    criticalityColour: {
        type: Number
    },
    progressPercentage: {
        type: Number
    },
    progressCategories: {
        type: String
    },
    plannedProjectProgressPercentage: {
        type: Number
    },
    phases: [PhasesSchema],
    phasesNumber: {
        type: Number
    },
    tasks: [TaskSchema],
    tasksNumber: {
        type: Number
    },
    onHoldTasksCount: {
        type: Number
    },
    todoTasksCount: {
        type: Number
    },
    inProgressTasksCount: {
        type: Number
    },
    doneTasksCount: {
        type: Number
    },
    overDueTasksCount: {
        type: Number
    },
    doneOnTimeTasksCount: {
        type: Number
    },
    remainingTasksCount: {
        type: Number
    },
    aheadOfScheduleTasksCount: {
        type: Number
    },
    behindScheduleTasksCount: {
        type: Number
    },
    onScheduleTasksCount: {
        type: Number
    },
    milestones: [MilestonesSchema],
    milestonesNumber: {
        type: Number
    },
    estimatedCost: [EstimatedCostSchema],
    totalEstimatedCost: {
        type: Number
    },
    budget: [BudgetSchema],
    totalBudget: {
        type: Number
    },
    donor: [DonorSchema],
    totalDonatedAmount: {
        type: Number
    },
    executingAgency: [ExecutingAgencySchema],
    dataChange: {
        type: Date
    },
    dataCreate: {
        type: Date
    },
    startDate: {
        type: String
    },
    completionDate: {
        type: String
    },
    dueDate: {
        type: String
    },
    duration: {
        type: Number
    },
    locations: [LocationSchema],
    locationsNumber: {
        type: Number
    },
    skillsRequired: [SkillsRequiredSchema],
    members: [MembersSchema],
    totalProjectMembers: {
        type: Number
    },
    peopleAllowedToViewProject: [PeopleAllowedToViewProjectSchema],
    resources: [ResourcesSchema],
    totalResourceCost: {
        type: Number
    },
    contribution: {
        type: String
    },
    dataReliability: {
        type: String
    },

});

const ProjectModel = mongoose.model('project_data', ProjectSchema, 'project_data');
module.exports = {
    ProjectModel: ProjectModel,
    ProjectSchema: ProjectSchema
};