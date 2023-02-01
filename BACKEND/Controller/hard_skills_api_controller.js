////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

  const {
    HardSkillsDataSchema, 
    HardSkillsModel
} = require('../Models/Recommendation Model/hard_skills_model');
  
  ////////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////
  
  // Get a list of skills from the DB
  const getHardSkills = ((req, res, next) => {
    // Get all data
    HardSkillsModel.find({}).then(function (skills) {
      res.send(skills);
    });
  })
  
  const getHardSkillByHardSkill = ((req, res, next) => {
    // Get all data
    HardSkillsModel.find({hardSkill: req.params.hardSkill}).then(function (skill) {
      res.send(skill);
    });
  })
  // Add new skill to the DB
  const createHardSkill = ((req, res, next) => {
    HardSkillsModel.create(req.body).then(function (skill) {
      res.send(skill);
    }).catch(next);
  
  })
  
  // Update a skill in the DB
  const updateHardSkillByID = ((req, res, next) => {
    //to access :id ---> req.params.id
    HardSkillsModel.findByIdAndUpdate({
      _id: req.params.id
    }, {
      $set: req.body
    }).then(function () {
      HardSkillsModel.findOne({
        _id: req.params.id
      }).then(function (skill) {
        res.send(skill);
      });
    });
  })
  
  const updateHardSkillByHardSkill = ((req, res, next) => {
    
    //to access :id ---> req.params.id
    HardSkillsModel.findOneAndUpdate({
      hardSkill: req.params.hardSkill
    }, {
      $set: req.body
    }).then(function () {
      HardSkillsModel.findOne({
        hardSkill: req.params.hardSkill
      }).then(function (skill) {
        res.send(skill);
      });
    });
  })
  
  
  // Delete a skill from the DB
  const deleteHardSkillByID = ((req, res, next) => {
    //to access :id ---> req.params.id
    HardSkillsModel.findByIdAndRemove({
      _id: req.params.id
    }).then(function (skill) {
      res.send(skill);
    });
  })
  
  const deleteHardSkillByHardSkill = ((req, res, next) => {
    //to access :id ---> req.params.id
    HardSkillsModel.findOneAndRemove({
      hardSkill: req.params.hardSkill
    }).then(function (skill) {
      res.send(skill);
    });
  })
  
  
  
  module.exports = {
    getHardSkills: getHardSkills,
    getHardSkillByHardSkill: getHardSkillByHardSkill,
    createHardSkill: createHardSkill,
    updateHardSkillByID: updateHardSkillByID,
    updateHardSkillByHardSkill: updateHardSkillByHardSkill,
    deleteHardSkillByID: deleteHardSkillByID,
    deleteHardSkillByHardSkill: deleteHardSkillByHardSkill,
    }