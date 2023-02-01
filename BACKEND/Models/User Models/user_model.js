////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

const mongoose = require('mongoose');
const {
    SkillSchema,
    SkillsRequiredSchema
} = require('../Project Models/skills_required_model');
const Schema = mongoose.Schema;

const educationSchema = require('../User Models/education_model')
const languageSchema = require('../User Models/language_model')
const qualificationSchema = require('../User Models/qualification_model')
const referenceSchema = require('../User Models/reference_model')
const volunteerExperienceSchema = require('../User Models/volunteer_experience_model')
const workExperienceSchema = require('../User Models/work_experience_model')

/////////////////////////////////////////// SCHEMA AND MODEL ///////////////////////////////////////////



var loginUserSchema = new Schema({

    sn: {
        type: Number
    },
    userID: {
        type: String
    },
    companyKey: {
        type: String
    },
    firstName: {
        type: String,
    },
    lastName: {
        type: String,
    },
    username: {
        type: String,
        unique: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    userPhotoURL: {
        type: String,
    },
    userPhotoFile: {
        type: String,
    },
    userPhotoName: {
        type: String,
    },
    userRole: {
        type: String,
    },
    dateOfBirth: {
        type: String,
    },
    gender: {
        type: String,
    },
    personalEmail: {
        type: String,
    },
    workEmail: {
        type: String,
    },
    phoneNumber: {
        type: String,
    },
    optionalPhoneNumber: {
        type: String,
    },
    jobContractType: {
        type: String,
    },
    jobContractExpirationDate: {
        type: String,
    },
    extension: {
        type: String,
    },
    jobField: {
        type: String,
    },
    jobSubField: {
        type: String,
    },
    jobSpecialization: {
        type: String,
    },
    jobTitle: {
        type: String,
    },
    jobDepartment: {
        type: String,
    },
    jobTeam: {
        type: String,
    },
    employmentAgency: {
        type: String,
    },
    nationality: {
        type: String,
    },
    countryOfEmployment: {
        type: String,
    },
    about: {
        type: String,
    },
    languages: [languageSchema],
    bachelors: [educationSchema],
    masters: [educationSchema],
    phd: [educationSchema],
    doctoral: [educationSchema],
    professionalQualifications: [qualificationSchema],
    educationalQualifications: [qualificationSchema],
    otherQualifications: [qualificationSchema],
    workExperience: [workExperienceSchema],
    volunteerExperience: [volunteerExperienceSchema],
    references: [referenceSchema],
    cvName: {
        type: String,
    },
    cvFile: {
        type: String,
    },
    cvSize: {
        type: Number,
    },
    ////// HARD SKILLS //////
    hardSkills: [SkillSchema],
    ////// SOFT SKILLS //////
    timeManagementSoftSkills: [SkillSchema],
    communicationSoftSkills: [SkillSchema],
    adaptabilitySoftSkills: [SkillSchema],
    problemSolvingSoftSkills: [SkillSchema],
    organizationSoftSkills: [SkillSchema],
    teamworkSoftSkills: [SkillSchema],
    creativitySoftSkills: [SkillSchema],
    leadershipSoftSkills: [SkillSchema],
    socialOrInterpersonalSoftSkills: [SkillSchema],
    workEthicSoftSkills: [SkillSchema],
    computerSoftSkills: [SkillSchema],
    lifeSoftSkills: [SkillSchema],
    attentionToDetailSoftSkills: [SkillSchema],
    availability: {
        type: Boolean,
    },
    numberOfTasksAssignedToUser: {
        type: Number,
    },
    tasksNumber: {
        type: Number
    },
    onHoldTasksCount: {
        type: Number
    },
    todoTasksCount: {
        type: Number
    },
    inProgressTasksCount: {
        type: Number
    },
    doneTasksCount: {
        type: Number
    },
    overDueTasksCount: {
        type: Number
    },
    doneOnTimeTasksCount: {
        type: Number
    },
    remainingTasksCount: {
        type: Number
    },
    aheadOfScheduleTasksCount: {
        type: Number
    },
    behindScheduleTasksCount: {
        type: Number
    },
    onScheduleTasksCount: {
        type: Number
    },
    progressPercentage: {
        type: Number
    },
    numberOfProjectsAssignedToUser: {
        type: Number,
    },
    expiredProjectsCount: {
        type: Number
    },
    openProjectsCount: {
        type: Number
    },
    closedProjectsCount: {
        type: Number
    },
    futureProjectsCount: {
        type: Number
    },
    suggestedProjectsCount: {
        type: Number
    },
    overDueProjectsCount: {
        type: Number
    },
    doneOnTimeProjectsCount: {
        type: Number
    },
    remainingProjectsCount: {
        type: Number
    },
    aheadOfScheduleProjectsCount: {
        type: Number
    },
    behindScheduleProjectsCount: {
        type: Number
    },
    onScheduleProjectsCount: {
        type: Number
    },
    projectProgressPercentage: {
        type: Number
    },
    token: {
        type: String,
    },
    renewalToken: {
        type: String,
    },
    roles: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Role"
    }],
    dateUpdated: {
        type: Date,
    },
    dateCreate: {
        type: Date,
    },
});

var registerUserSchema = new Schema({
    dateTimeAccountCreated: {
        type: String,
    },
    sn: {
        type: Number
    },
    userID: {
        type: Number,
    },
    companyKey: {
        type: String
    },
    firstName: {
        type: String
    },
    lastName: {
        type: String
    },
    username: {
        type: String,
        required: true,
        unique: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true,
    },
    confirmedPassword: {
        type: String,
        required: true,
    },
    userPhotoURL: {
        type: String,
    },
    userPhotoFile: {
        type: String,
    },
    userPhotoName: {
        type: String,
    },
    userRole: {
        type: String,
    },
    dateOfBirth: {
        type: String,
    },
    gender: {
        type: String,
    },
    personalEmail: {
        type: String,
    },
    workEmail: {
        type: String,
    },
    phoneNumber: {
        type: String,
    },
    optionalPhoneNumber: {
        type: String,
    },
    jobContractType: {
        type: String,
    },
    extension: {
        type: String,
    },
    jobField: {
        type: String,
    },
    jobTitle: {
        type: String,
    },
    jobTeam: {
        type: String,
    },
    employmentAgency: {
        type: String,
    },
    nationality: {
        type: String,
    },
    countryOfEmployment: {
        type: String,
    },
    about: {
        type: String,
    },
    languages: [languageSchema],
    bachelors: {
        type: String,
    },
    masters: {
        type: String,
    },
    phd: {
        type: String,
    },
    doctoral: {
        type: String,
    },
    professionalQualifications: [qualificationSchema],
    educationalQualifications: [qualificationSchema],
    otherQualifications: [qualificationSchema],
    workExperience: [workExperienceSchema],
    volunteerExperience: [volunteerExperienceSchema],
    references: [referenceSchema],
    cvName: {
        type: String,
    },
    cvFile: {
        type: String,
    },
    cvSize: {
        type: Number,
    },
    // skills: [SkillsRequiredSchema],
    ////// HARD SKILLS //////
    hardSkills: [SkillsRequiredSchema],
    ////// SOFT SKILLS //////
    timeManagementSoftSkills: [SkillsRequiredSchema],
    communicationSoftSkills: [SkillsRequiredSchema],
    adaptabilitySoftSkills: [SkillsRequiredSchema],
    problemSolvingSoftSkills: [SkillsRequiredSchema],
    organizationSoftSkills: [SkillsRequiredSchema],
    teamworkSoftSkills: [SkillsRequiredSchema],
    creativitySoftSkills: [SkillsRequiredSchema],
    leadershipSoftSkills: [SkillsRequiredSchema],
    socialOrInterpersonalSoftSkills: [SkillsRequiredSchema],
    workEthicSoftSkills: [SkillsRequiredSchema],
    computerSoftSkills: [SkillsRequiredSchema],
    lifeSoftSkills: [SkillsRequiredSchema],
    attentionToDetailSoftSkills: [SkillsRequiredSchema],
    availability: {
        type: Boolean,
    },
    numberOfTasksAssignedToUser: {
        type: Number,
    },
    dateUpdated: {
        type: Date,
    },
    dateCreate: {
        type: Date,
    },
    token: {
        type: String,
    },
    renewalToken: {
        type: String,
    },
    roles: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Role"
    }],
});


// This two schemas will save on the 'users' collection.
var UserModel = mongoose.model('User', loginUserSchema, 'user_data');
var registerUserModel = mongoose.model('Registered', registerUserSchema, 'user_data');

module.exports = {
    UserModel: UserModel,
    registerUserModel: registerUserModel
};