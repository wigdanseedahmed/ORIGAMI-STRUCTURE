////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const {
    addAndUpdateTaskFiles1,
    addAndUpdateTaskFiles,
    getTasks,
    getTaskByTaskName,
    checkTaskExistsByProjectName,
    createTask,
    updateTaskByID,
    updateTaskByTaskName,
    deleteTaskByID,
    deleteTaskByTaskName,
} = require('../Controller/tasks_api_controller')

const express = require('express');
const router = express.Router();

///////////////// OTHERS /////////////////

const config = require("../config");

const jwt = require("jsonwebtoken");

const fs = require("fs");

const multer = require("multer");
const path = require("path");
const {
    GridFsStorage
} = require('multer-gridfs-storage');
const Grid = require('gridfs-stream');
const crypto = require('crypto');

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

const storage = multer.diskStorage({ //memoryStorage
    destination: (req, file, cb) => {
        cb(null, "../Files Uploads");
    },
    filename: (req, file, cb) => {
        cb(null, new Date().toISOString() + file.originalname);
    },
});

const fileFilter = (req, file, cb) => {
    if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
        cb(null, true);
    } else {
        cb(null, false);
    }
};

// create storage engine
const gridFSStorage = new GridFsStorage({
    url: 'mongodb://localhost/origami_structure',
    file: (req, file) => {
        return new Promise((resolve, reject) => {
            crypto.randomBytes(16, (err, buf) => {
                if (err) {
                    return reject(err);
                }
                const filename = buf.toString('hex') + path.extname(file.originalname);
                const fileInfo = {
                    filename: filename,
                    bucketName: 'taskUploads'
                };
                resolve(fileInfo);
            });
        });
    }
});
const gridFSUpload = multer({
    gridFSStorage
});

const upload = multer({
    storage: storage,
    // fileFilter: fileFilter,
});

router.post('/upload', upload.single('myFile'), addAndUpdateTaskFiles1);

router.get('/image', async (req, res) => {
    const image = await model.find();
    res.json(image);
});

// Adding and update user files
router.post("/addFiles/:taskName", upload.array("taskFiles"), addAndUpdateTaskFiles);

// Get a list of tasks from the DB
router.get('/tasks', getTasks);

router.get('/task/:taskName', getTaskByTaskName);

// Check if task exists
router.get('/tasks/checkIfTaskExistsUsingTaskName/:taskName', checkTaskExistsByProjectName)

// Add new task to the DB
router.post('/createTask', createTask);

// Update a task in the DB
router.put('/update/id/:id', updateTaskByID);

router.put('/update/taskName/:taskName', updateTaskByTaskName);


// Delete a task from the DB
router.delete('/delete/id/:id', deleteTaskByID);

router.delete('/delete/taskName/:taskName', deleteTaskByTaskName);


module.exports = router;