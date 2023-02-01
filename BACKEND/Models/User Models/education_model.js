////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

var educationSchema = new Schema({

  educationReferenceBy: {
        type: String
    },
    educationReferenceFile: {
        type: String
    },
    educationReferenceFileName: {
        type: String
    },
    educationReferenceSize: {
        type: Number
    },
    educationReferenceType: {
        type: String
    },
    discipline: {
        type: String,
    },
    description: {
        type: String,
    },
    institutionName: {
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
    educationSchema: educationSchema,
};