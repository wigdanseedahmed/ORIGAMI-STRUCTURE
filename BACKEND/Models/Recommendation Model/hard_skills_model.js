////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Skill Schema
const HardSkillsDataSchema = new Schema({
    hardSkillID: {
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
    typeOfSpecialization: {
        type: String
    },
    hardSkillCategory: {
        type: String
    },
    hardSkill: {
        type: String
    },
    level: {
        type: String
    },
})


var HardSkillsModel = mongoose.model('hard_skills_data', HardSkillsDataSchema, 'hard_skills_data');
module.exports = {
    HardSkillsDataSchema: HardSkillsDataSchema, 
    HardSkillsModel: HardSkillsModel
};