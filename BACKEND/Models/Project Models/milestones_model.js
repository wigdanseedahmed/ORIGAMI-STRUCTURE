////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Milestones Schema
const MilestonesSchema = new Schema({
    milestonesID: {
        type: String
    },
    milestones: {
        type: String
    },
    weightGiven: {
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

module.exports = MilestonesSchema;