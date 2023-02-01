////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Comment Schema and Model
const CommentSchema = new Schema({

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
    content: {
        type: String
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
    textEditingController: {
        type: String
    },

});

//const CommentModel= mongoose.model('comment_data', CommentSchema, 'comment_data');
module.exports = CommentSchema;