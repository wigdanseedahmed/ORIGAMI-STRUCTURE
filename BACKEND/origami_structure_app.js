const express = require('express');
const bodyParser = require("body-parser");
const multer = require('multer')
const mongoose = require('mongoose');
const {GridFsStorage} = require('multer-gridfs-storage');
const Grid = require('gridfs-stream');
const crypto = require('crypto');

const port = process.env.port || 1000;


// Set up Express app
const sudanHorizonScannerApp = express();

// Connect to mongodb
mongoose.connect(
    'mongodb://localhost/origami_structure', {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    }
);
mongoose.Promise = global.Promise;

const connection = mongoose.connection;
connection.once("open", () => {
    console.log("MongoDb connected");
});

// Init gfs
let gfs;

connection.once('open', () => {
  // Init stream
  gfs = Grid(connection.db, mongoose.mongo);
  gfs.collection('taskUploads');
});

// Middleware to allow users to input output image
sudanHorizonScannerApp.use(express.static('public'))

// Body Parse Middleware 
sudanHorizonScannerApp.use(bodyParser.json());

// Initialize routes
data = {
    msg: "Welcome on DevStack Blog App development YouTube video series",
    info: "This is a root endpoint",
    Working: "Documentations of other endpoints will be release soon :)",
    request: "Hey if you did'nt subscribed my YouTube channle please subscribe it",
};

sudanHorizonScannerApp.route("/").get((req, res) => res.json(data));

// CORS
const cors = require('cors');
sudanHorizonScannerApp.use(cors({
    origin: '*',
    credentials: true,

}));

// Middleware

sudanHorizonScannerApp.use(bodyParser.json({
    limit: "50mb" //increased the limit to receive base64
}))
sudanHorizonScannerApp.use(bodyParser.urlencoded({
    limit: "50mb",
    extended: true,
    parameterLimit: 500000
}))

// parse application/json
sudanHorizonScannerApp.use(bodyParser.json())

sudanHorizonScannerApp.use(cors());
sudanHorizonScannerApp.use("*", cors());


sudanHorizonScannerApp.use(express.json({limit: '50mb'}));

sudanHorizonScannerApp.use(express.urlencoded({ 
    limit: "50mb",
    extended: true
}));

sudanHorizonScannerApp.use(express.static("public")); //static folder so that files can be received using a link


//sudanHorizonScannerApp.use("/uploads", express.static(__dirname + " /Uploads"));
//sudanHorizonScannerApp.use(express.static("/Uploads"));
//sudanHorizonScannerApp.use(express.json());

// Initialize routes
////sudanHorizonScannerApp.use('/notifications', require('./Routes/notifications'));
sudanHorizonScannerApp.use('/project', require('./Routes/projects'))
sudanHorizonScannerApp.use('/task', require('./Routes/tasks'))
sudanHorizonScannerApp.use("/user", require("./Routes/user"))
sudanHorizonScannerApp.use("/hardSkill", require("./Routes/hard_skills"))
sudanHorizonScannerApp.use("/softSkill", require("./Routes/soft_skills"))
sudanHorizonScannerApp.use("/recommedation", require("./Routes/recommendations"))

//sudanHorizonScannerApp.use("/api", require("./routes/profile"))

// Error handling Middleware
sudanHorizonScannerApp.use(function (err, req, res, next) {
    //console.log(err);
    res.status(422).send({
        error: err.message
    });
});

// Listen for requests
sudanHorizonScannerApp.listen(port, function () {
    console.log('now listening for requests');
});