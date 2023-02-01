////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const {
    getSoftSkills,
    getSoftSkillBySoftSkill,
    createSoftSkill,
    updateSoftSkillByID,
    updateSoftSkillBySoftSkill,
    deleteSoftSkillByID,
    deleteSoftSkillBySoftSkill,
} = require('../Controller/soft_skills_api_controller')

const express = require('express');
const router = express.Router();

////////////////////////////////////////////// ROUTERS //////////////////////////////////////////////

// Get a list of softSkills from the DB
router.get('/softSkills', getSoftSkills);

router.get('/softSkill/:softSkill', getSoftSkillBySoftSkill);

// Add new softSkill to the DB
router.post('/createSoftSkill', createSoftSkill);

// Update a softSkill in the DB
router.put('/update/id/:id', updateSoftSkillByID);

router.put('/update/softSkill/:softSkill', updateSoftSkillBySoftSkill);


// Delete a softSkill from the DB
router.delete('/delete/id/:id', deleteSoftSkillByID);

router.delete('/delete/softSkill/:softSkill', deleteSoftSkillBySoftSkill);


module.exports = router;