////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Phases Schema
const PhasesSchema = new Schema({
    phaseID: {
        type: String
    },
    phase: {
        type: String
    },
    weightGiven: {
        type: Number
    },
    progressPercentage: {
        type: Number
    },
    plannedPhaseProgressPercentage: {
        type: Number
    },
    deliverables: {
        type: String
    },
    actionPlan: {
        type: String
    },
    impact: {
        type: String
    },
    risks:{
        type:String
    },
    comments:{
        type:String
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
})

module.exports = PhasesSchema;