////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////


var workExperienceSchema = new Schema({

    jobTitle: {
        type: String,
    },
   
    jobDescription: {
        type: String
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
    workExperienceSchema: workExperienceSchema,
};