////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Skill Schema
const SoftSkillsDataSchema = new Schema({
    softSkillID: {
        type: String
    },
    softSkillCategory: {
        type: String
    },
    softSkill: {
        type: String
    },
    level: {
        type: String
    },
})


var SoftSkillsModel = mongoose.model('soft_skills_data', SoftSkillsDataSchema, 'soft_skills_data');
module.exports = {
    SoftSkillsDataSchema: SoftSkillsDataSchema, 
    SoftSkillsModel: SoftSkillsModel
};