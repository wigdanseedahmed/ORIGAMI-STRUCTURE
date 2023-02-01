// Import Schemas
const SkillsRequiredSchema = require('./skills_required_model');

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Create People Allowed To View Project Schema and Model
const PeopleAllowedToViewProjectSchema = new Schema ({
    personAllowedToViewProjectID: {
        type: String
    },
    personAllowedToViewProjectUsername: {
        type: String
    },
    personAllowedToViewProjectName: {
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
    startDate:{
        type:String
    },
    endDate:{
        type:String
    },
    duration: {
        type: Number
    }
  
});

module.exports = PeopleAllowedToViewProjectSchema;