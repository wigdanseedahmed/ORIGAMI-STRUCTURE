////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Budget Schema
const BudgetSchema = new Schema({
    itemID: {
        type: String
    },
    item: {
        type: String,
    },
    itemType: {
        type: String,
    },
    purchaseDate: {
        type: String
    },
    purchaseFrom: {
        type: String
    },
    duration: {
        type: Number
    },
    cost: {
        type: Number
    }
})

module.exports = BudgetSchema;