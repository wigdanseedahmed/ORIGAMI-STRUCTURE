////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Estimated cost Schema
const EstimatedCostSchema = new Schema({
    itemID: {
        type: String
    },
    item: {
        type: String
    },
    purchaseDate: {
        type: String
    },
    purchaseFrom: {
        type: String
    },
    cost: {
        type: String
    }
})

module.exports = EstimatedCostSchema;