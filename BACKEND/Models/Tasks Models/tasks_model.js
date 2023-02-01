////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

///////////////// Import Schemas /////////////////
const ChecklistSchema = require('../Tasks Models/checklist_model');
const MembersSchema = require('../Project Models/members_model');
const CommentSchema = require('../Tasks Models/comment_model');
const FileSchema = require('../Tasks Models/file_model');

///////////////// Others /////////////////
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Task Schema and Model
const TaskSchema = new Schema({

    id: {
        type: String
    },
    taskNo: {
        type: String
    },
    taskName: {
        type: String,
        required: [true]
    },
    projectName: {
        type: String
    },
    projectStatus: {
        type: String
    },
    projectLeader: {
        type: String
    },
    projectDeadline: {
        type: String
    },
    projectType: {
        type: String
    },
    projectMilestone: {
        type: String
    },
    projectPhase: {
        type: String
    },
    skillsAssigned: {
        type: [String]
    },
    taskDetail: {
        type: String
    },
    assignedTo: {
        type: [String]
    },
    assignedBy: {
        type: String
    },
    status: {
        type: String
    },
    deliverable: {
        type: String
    },
    percentageDone: {
        type: Number
    },
    plannedPercentageDone: {
        type: Number
    },
    progressCategories: {
        type: String
    },
    weightGiven: {
        type: Number
    },
    priority: {
        type: String
    },
    dateCreated: {
        type: Date
    },
    dateChanged: {
        type: Date
    },
    startDate: {
        type: String
    },
    submissionDate: {
        type: String
    },
    deadlineDate: {
        type: String
    },
    duration: {
        type: Number
    },
    criticalityColour: {
        type: Number
    },
    activities: {
        type: [String]
    },
    checklist: [ChecklistSchema],
    risks: {
        type: String
    },
    issuesCategory: {
        type: String
    },
    rootCauseOfIssues: {
        type: String
    },
    remarks: {
        type: String
    },
    nextWeekOutlook: {
        type: String
    },
    comments: [CommentSchema],
    taskFiles: [FileSchema]

});

const TaskModel = mongoose.model('task_data', TaskSchema, 'task_data');
module.exports = {
    TaskModel: TaskModel,
    TaskSchema: TaskSchema
};