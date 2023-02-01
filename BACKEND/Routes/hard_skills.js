////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const {
    getHardSkills,
    getHardSkillByHardSkill,
    createHardSkill,
    updateHardSkillByID,
    updateHardSkillByHardSkill,
    deleteHardSkillByID,
    deleteHardSkillByHardSkill,
} = require('../Controller/hard_skills_api_controller')

const express = require('express');
const router = express.Router();

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

// Get a list of hardSkills from the DB
router.get('/hardSkills', getHardSkills);

router.get('/hardSkill/:hardSkill', getHardSkillByHardSkill);

// Add new hardSkill to the DB
router.post('/createHardSkill', createHardSkill);

// Update a hardSkill in the DB
router.put('/update/id/:id', updateHardSkillByID);

router.put('/update/hardSkill/:hardSkill', updateHardSkillByHardSkill);


// Delete a hardSkill from the DB
router.delete('/delete/id/:id', deleteHardSkillByID);

router.delete('/delete/hardSkill/:hardSkill', deleteHardSkillByHardSkill);


module.exports = router;