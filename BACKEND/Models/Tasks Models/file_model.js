////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create File Schema and Model
const FileSchema = new Schema({
    image: {
        type: String
    },
    username: {
        type: String
    },
    firstName: {
        type: String
    },
    lastName: {
        type: String
    },
    taskTitle: {
        type: String
    },
    taskFileName: {
        type: String
    },
    taskFile: {
        type: String
    },
    taskBase64File: {
        type: String
    },
    taskFileSize: {
        type: Number
    },
    focus: {
        type: Boolean
    },
    time: {
        type: String
    },
    selectedEmoji: {
        type: String
    },
});

//const CommentModel= mongoose.model('comment_data', CommentSchema, 'comment_data');
module.exports = FileSchema;