////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const {
    SkillSchema,
    SkillsRequiredSchema
} = require('./skills_required_model');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Member Schema
const MembersSchema = new Schema({
    memberID: {
        type: String
    },
    memberUsername: {
        type: String
    },
    memberName: {
        type: String
    },
    skills: [SkillsRequiredSchema],
    jobTitle: {
        type: String
    },
    projectJobPosition: {
        type: String
    },
    phoneNumber: {
        type: String
    },
    optionalPhoneNumber: {
        type: String
    },
    personalEmail: {
        type: String
    },
    workEmail: {
        type: String
    },
    contractType: {
        type: String
    },
    extension: {
        type: String
    },
    startDate: {
        type: String
    },
    endDate: {
        type: String
    },
    duration: {
        type: Number
    },
    skillsAssigned: {
        type: [String]
    },
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
    remainingTasksCount: {
        type: Number
    },
})

module.exports = MembersSchema;