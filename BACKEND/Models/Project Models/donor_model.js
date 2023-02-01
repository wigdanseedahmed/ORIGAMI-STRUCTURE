////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Donor Schema
const Donor = new Schema({
    donorID: {
        type: String
    },
    donorName: {
        type: String
    },
    donorEmail: {
        type: String
    },
    donorWebsite: {
        type: String
    },
    donorPhotoUrl: {
        type: String
    },
    donorBoardList: {
        type: [String]
    },
    donationAmount: {
        type: Number
    }
})

module.exports = Donor;