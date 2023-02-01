////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

  const {
    SoftSkillsDataSchema, 
    SoftSkillsModel
} = require('../Models/Recommendation Model/soft_skills_model');
  
  ////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////
  
  // Get a list of skills from the DB
  const getSoftSkills = ((req, res, next) => {
    // Get all data
    SoftSkillsModel.find({}).then(function (skills) {
      res.send(skills);
    });
  })
  
  const getSoftSkillBySoftSkill = ((req, res, next) => {
    // Get all data
    SoftSkillsModel.find({softSkill: req.params.softSkill}).then(function (skill) {
      res.send(skill);
    });
  })
  // Add new skill to the DB
  const createSoftSkill = ((req, res, next) => {
    SoftSkillsModel.create(req.body).then(function (skill) {
      res.send(skill);
    }).catch(next);
  
  })
  
  // Update a skill in the DB
  const updateSoftSkillByID = ((req, res, next) => {
    //to access :id ---> req.params.id
    SoftSkillsModel.findByIdAndUpdate({
      _id: req.params.id
    }, {
      $set: req.body
    }).then(function () {
      SoftSkillsModel.findOne({
        _id: req.params.id
      }).then(function (skill) {
        res.send(skill);
      });
    });
  })
  
  const updateSoftSkillBySoftSkill = ((req, res, next) => {
    
    //to access :id ---> req.params.id
    SoftSkillsModel.findOneAndUpdate({
      softSkill: req.params.softSkill
    }, {
      $set: req.body
    }).then(function () {
      SoftSkillsModel.findOne({
        softSkill: req.params.softSkill
      }).then(function (skill) {
        res.send(skill);
      });
    });
  })
  
  
  // Delete a skill from the DB
  const deleteSoftSkillByID = ((req, res, next) => {
    //to access :id ---> req.params.id
    SoftSkillsModel.findByIdAndRemove({
      _id: req.params.id
    }).then(function (skill) {
      res.send(skill);
    });
  })
  
  const deleteSoftSkillBySoftSkill = ((req, res, next) => {
    //to access :id ---> req.params.id
    SoftSkillsModel.findOneAndRemove({
      softSkill: req.params.softSkill
    }).then(function (skill) {
      res.send(skill);
    });
  })
  
  
  
  module.exports = {
    getSoftSkills: getSoftSkills,
    getSoftSkillBySoftSkill: getSoftSkillBySoftSkill,
    createSoftSkill: createSoftSkill,
    updateSoftSkillByID: updateSoftSkillByID,
    updateSoftSkillBySoftSkill: updateSoftSkillBySoftSkill,
    deleteSoftSkillByID: deleteSoftSkillByID,
    deleteSoftSkillBySoftSkill: deleteSoftSkillBySoftSkill,
    }