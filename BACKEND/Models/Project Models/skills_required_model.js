////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Skill Schema
const SkillSchema = new Schema({
    typeOfSpecialization: {
        type: String
    },
    skillCategory: {
        type: String
    },
    skill: {
        type: String
    },
    level: {
        type: String
    },
})

// Create Skills Required Schema
const SkillsRequiredSchema = new Schema({
    skillID: {
        type: String
    },
    skill: [SkillSchema],
    skillName: {
        type: String
    },
    jobField: {
        type: String
    },
    jobSubField: {
        type: String
    },
    jobSpecialization: {
        type: String
    },
    jobTitle: {
        type: String
    },
    contractType: {
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
    assignedTo: {
        type: String
    }
})



module.exports = {
    SkillSchema: SkillSchema,
    SkillsRequiredSchema: SkillsRequiredSchema
};