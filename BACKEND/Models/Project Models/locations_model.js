////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;


/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////

// Create Locations Schema and Model
const LocationSchema = new Schema({
    locationId: {
        type: String
    },
       
  location: {
    type: String
},
    Latitude: {
        type: Number
    },
    Longitude: {
        type: Number
    },
localityNameEn: {
    type: String,
}, 
localityNameAr: {
    type: String,
},
localityNamePcode: {
    type: String,
},
cityNameEn: {
    type: String,
},
cityNameAr: {
    type: String,
},
cityPcode: {
    type: String,
},
stateNameEn: {
    type: String,
},
stateNameAr: {
    type: String,
},
stateNamePcode: {
    type: String,
},
provinceNameEn: {
    type: String,
},
provinceNameAr: {
    type: String,
},
provincePcode: {
    type: String,
},
regionNameEn: {
    type: String,
},
regionNameAr: {
    type: String,
},
regionPcode: {
    type: String,
},
countryEn: {
    type: String,
},
countryAr: {
    type: String,
},
countryPcode: {
        type: String,
    },

    startDate: {
        type: String
    },
    cendDate: {
        type: String
    },
    duration: {
        type: Number
    },

});

module.exports = LocationSchema;