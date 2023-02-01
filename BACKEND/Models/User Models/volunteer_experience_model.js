////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////


var volunteerExperienceSchema = new Schema({

    title: {
        type: String,
    },
   
    description: {
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
    volunteerExperienceSchema: volunteerExperienceSchema,
};