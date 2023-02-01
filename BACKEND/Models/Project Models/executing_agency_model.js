////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Executing Agencey Schema
const ExecutingAgency = new Schema({
    executingAgencyID: {
        type: String
    },
    executingAgencyName: {
        type: String
    },
    executingAgencyDepartment: {
        type: String
    },
    executingAgencyTeam: {
        type: String
    },
    executingAgencyEmail: {
        type: String
    },
    executingAgencyWebsite: {
        type: String
    },
    executingAgencyPhotoUrl: {
        type: String
    },
    executingAgencyProjectList:{
        type:[String]
    }
})

module.exports = ExecutingAgency;