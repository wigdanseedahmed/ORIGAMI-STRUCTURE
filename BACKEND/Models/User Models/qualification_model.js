////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

var qualificationSchema = new Schema({

    qualificationBy: {
        type: String
    },
    qualificationFile: {
        type: String
    },
    qualificationFileName: {
        type: String
    },
    qualificationSize: {
        type: Number
    },
    qualificationType: {
        type: String
    },
    title: {
        type: String,
    },
    description: {
        type: String,
    },
    obtainedFrom: {
        type: String,
    },
    startDate: {
        type: String
    },
    endDate: {
        type: String,
    },
    duration: {
        type: Number,
    }
});

module.exports = {
    qualificationSchema: qualificationSchema,
};