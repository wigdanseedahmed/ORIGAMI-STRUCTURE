////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Resources Schema
const ResourcesSchema = new Schema({
    resourcessID: {
        type: String
    },
    resourcesType: {
        type: String
    },
    resourcesTool: {
        type: Number
    },
    reference: {
        type: String
    },
    cost: {
        type: Number
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

module.exports = ResourcesSchema;