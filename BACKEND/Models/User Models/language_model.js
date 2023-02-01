////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

var languageSchema = new Schema({

    language: {
        type: String,
    },
   
    level: {
        type: String
    }
});

module.exports = {
    languageSchema: languageSchema,
};