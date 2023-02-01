////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

var referenceSchema = new Schema({

    referenceBy: {
        type: String
    },
    referenceFile: {
        type: String
    },
    referenceName: {
        type: String
    },
    referenceSize: {
        type: Number
    },
    jobTitle: {
        type: String,
    },
    workArea: {
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
    referenceSchema: referenceSchema,
};