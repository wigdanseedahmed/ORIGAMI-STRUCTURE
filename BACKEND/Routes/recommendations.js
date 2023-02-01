////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const config = require("../config");
let middleware = require("../middleware");

const jwt = require("jsonwebtoken");

const express = require("express");
const router = express.Router();

const multer = require("multer");
const path = require("path");

///////////

const recommedation = require("../Controller/recommendation_system");

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

// Get a list of users from the DB
router.get('/recommedations', recommedation);

module.exports = router;