import 'package:origami_structure/imports.dart';

List<UserModel> userModelListFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelListToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userID,
    this.userRole,
    this.username,
    this.firstName,
    this.lastName,
    this.userPhotoURL,
    this.userPhotoFile,
    this.userPhotoName,
    this.email,
    this.personalEmail,
    this.workEmail,
    this.password,
    this.confirmedPassword,
    this.about,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.optionalPhoneNumber,
    this.jobContractType,
    this.jobContractExpirationDate,
    this.extension,
    this.jobField,
    this.jobSubField,
    this.jobSpecialization,
    this.jobTitle,
    this.jobDepartment,
    this.jobTeam,
    this.employmentAgency,
    this.nationality,
    this.countryOfEmployment,
    this.languages,
    this.bachelors,
    this.masters,
    this.phd,
    this.doctoral,
    this.professionalQualifications,
    this.educationalQualifications,
    this.otherQualifications,
    this.competence,
    this.workExperience,
    this.volunteerExperience,
    this.references,
    this.cvName,
    this.cvFile,
    this.cvSize,
    this.hardSkills,
    this.timeManagementSoftSkills,
    this.communicationSoftSkills,
    this.adaptabilitySoftSkills,
    this.problemSolvingSoftSkills,
    this.organizationSoftSkills,
    this.teamworkSoftSkills,
    this.creativitySoftSkills,
    this.leadershipSoftSkills,
    this.socialOrInterpersonalSoftSkills,
    this.workEthicSoftSkills,
    this.computerSoftSkills,
    this.lifeSoftSkills,
    this.attentionToDetailSoftSkills,
    this.availability,
    this.numberOfTasksAssignedToUser,
    this.tasksNumber,
    this.onHoldTasksCount,
    this.todoTasksCount,
    this.inProgressTasksCount,
    this.doneTasksCount,
    this.overDueTasksCount,
    this.doneOnTimeTasksCount,
    this.aheadOfScheduleTasksCount,
    this.behindScheduleTasksCount,
    this.onScheduleTasksCount,
    this.progressPercentage,
    this.numberOfProjectsAssignedToUser,
    this.expiredProjectsCount,
    this.openProjectsCount,
    this.closedProjectsCount,
    this.futureProjectsCount,
    this.suggestedProjectsCount,
    this.overDueProjectsCount,
    this.doneOnTimeProjectsCount,
    this.remainingProjectsCount,
    this.aheadOfScheduleProjectsCount,
    this.behindScheduleProjectsCount,
    this.onScheduleProjectsCount,
    this.projectProgressPercentage,
    this.dateUpdated,
    this.dateCreate,
    this.token,
    this.renewalToken,
  });

  String? userID;
  String? userRole;
  String? username;
  String? firstName;
  String? lastName;
  String? userPhotoURL;
  String? userPhotoName;
  String? userPhotoFile;
  String? dateOfBirth;
  String? gender;
  String? email;
  String? password;
  String? confirmedPassword;
  String? personalEmail;
  String? workEmail;
  String? phoneNumber;
  String? optionalPhoneNumber;
  String? jobContractType;
  String? jobContractExpirationDate;
  String? extension;
  String? jobField;
  String? jobSubField;
  String? jobSpecialization;
  String? jobTitle;
  String? jobDepartment;
  String? jobTeam;
  String? employmentAgency;
  String? nationality;
  String? countryOfEmployment;
  String? about;
  List<LanguageModel>? languages;
  List<EducationModel>? bachelors;
  List<EducationModel>? masters;
  List<EducationModel>? phd;
  List<EducationModel>? doctoral;
  List<WorkExperienceModel>? workExperience;
  List<VolunteerExperienceModel>? volunteerExperience;
  List<ReferenceModel>? references;
  String? cvName;
  String? cvFile;
  int? cvSize;
  List<QualificationModel>? professionalQualifications;
  List<QualificationModel>? educationalQualifications;
  List<QualificationModel>? otherQualifications;
  List<String>? competence;
  List<SkillModel>? hardSkills;
  List<SkillModel>? timeManagementSoftSkills;
  List<SkillModel>? communicationSoftSkills;
  List<SkillModel>? adaptabilitySoftSkills;
  List<SkillModel>? problemSolvingSoftSkills;
  List<SkillModel>? organizationSoftSkills;
  List<SkillModel>? teamworkSoftSkills;
  List<SkillModel>? creativitySoftSkills;
  List<SkillModel>? leadershipSoftSkills;
  List<SkillModel>? socialOrInterpersonalSoftSkills;
  List<SkillModel>? workEthicSoftSkills;
  List<SkillModel>? computerSoftSkills;
  List<SkillModel>? lifeSoftSkills;
  List<SkillModel>? attentionToDetailSoftSkills;
  DateTime? dateUpdated;
  DateTime? dateCreate;
  bool? availability;
  int? numberOfTasksAssignedToUser;
  int? tasksNumber;
  int? onHoldTasksCount;
  int? todoTasksCount;
  int? inProgressTasksCount;
  int? doneTasksCount;
  int? overDueTasksCount;
  int? doneOnTimeTasksCount;
  int? aheadOfScheduleTasksCount;
  int? behindScheduleTasksCount;
  int? onScheduleTasksCount;
  double? progressPercentage;

  int? numberOfProjectsAssignedToUser;
  int? expiredProjectsCount;
  int? openProjectsCount;
  int? closedProjectsCount;
  int? futureProjectsCount;
  int? suggestedProjectsCount;
  int? overDueProjectsCount;
  int? doneOnTimeProjectsCount;
  int? remainingProjectsCount;
  int? aheadOfScheduleProjectsCount;
  int? behindScheduleProjectsCount;
  int? onScheduleProjectsCount;
  double? projectProgressPercentage;

  String? token;
  String? renewalToken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json["userID"] ?? null,
        username: json["username"] ?? null,
        firstName: json["firstName"] ?? null,
        lastName: json["lastName"] ?? null,
        userRole: json["userRole"] ?? null,
        userPhotoURL: json["userPhotoURL"] ?? null,
        userPhotoName: json["userPhotoName"] ?? null,
        userPhotoFile: json["userPhotoFile"] ?? null,
        dateOfBirth: json["dateOfBirth"] ?? null,
        gender: json["gender"] ?? null,
        email: json["email"] ?? null,
        workEmail: json["workEmail"] ?? null,
        personalEmail: json["personalEmail"] ?? null,
        password: json["password"] ?? null,
        confirmedPassword: json["confirmedPassword"] ?? null,
        phoneNumber: json["phoneNumber"] ?? null,
        optionalPhoneNumber: json["optionalPhoneNumber"] ?? null,
        jobContractType: json["jobContractType"] ?? null,
        jobContractExpirationDate: json["jobContractExpirationDate"] ?? null,
        extension: json["extension"] ?? null,
        jobField: json["jobField"] ?? null,
        jobSubField: json["jobSubField"] ?? null,
        jobSpecialization: json["jobSpecialization"] ?? null,
        jobTitle: json["jobTitle"] ?? null,
        jobDepartment: json["jobDepartment"] ?? null,
        jobTeam: json["jobTeam"] ?? null,
        employmentAgency: json["employmentAgency"] ?? null,
        nationality: json["nationality"] ?? null,
        countryOfEmployment: json["countryOfEmployment"] ?? null,
        dateUpdated: json["dateUpdated"] == null
            ? null
            : DateTime.parse(json["dateUpdated"]),
        dateCreate: json["dateCreate"] == null
            ? null
            : DateTime.parse(json["dateCreate"]),
        languages: json["languages"] == null
            ? null
            : List<LanguageModel>.from(
                json["languages"].map((x) => LanguageModel.fromJson(x))),
        bachelors: json["bachelors"] == null
            ? null
            : List<EducationModel>.from(
                json["bachelors"].map((x) => EducationModel.fromJson(x))),
        masters: json["masters"] == null
            ? null
            : List<EducationModel>.from(
                json["masters"].map((x) => EducationModel.fromJson(x))),
        phd: json["phd"] == null
            ? null
            : List<EducationModel>.from(
                json["phd"].map((x) => EducationModel.fromJson(x))),
        doctoral: json["doctoral"] == null
            ? null
            : List<EducationModel>.from(
                json["doctoral"].map((x) => EducationModel.fromJson(x))),
        workExperience: json["workExperience"] == null
            ? null
            : List<WorkExperienceModel>.from(json["workExperience"]
                .map((x) => WorkExperienceModel.fromJson(x))),
        volunteerExperience: json["volunteerExperience"] == null
            ? null
            : List<VolunteerExperienceModel>.from(json["volunteerExperience"]
                .map((x) => VolunteerExperienceModel.fromJson(x))),
        references: json["references"] == null
            ? null
            : List<ReferenceModel>.from(
                json["references"].map((x) => ReferenceModel.fromJson(x))),
        professionalQualifications: json["professionalQualifications"] == null
            ? null
            : List<QualificationModel>.from(json["professionalQualifications"]
                .map((x) => QualificationModel.fromJson(x))),
        educationalQualifications: json["educationalQualifications"] == null
            ? null
            : List<QualificationModel>.from(json["educationalQualifications"]
                .map((x) => QualificationModel.fromJson(x))),
        otherQualifications: json["otherQualifications"] == null
            ? null
            : List<QualificationModel>.from(json["otherQualifications"]
                .map((x) => QualificationModel.fromJson(x))),
        cvName: json["cvName"] ?? null,
        cvFile: json["cvFile"] ?? null,
        cvSize: json["cvSize"] == null ? null : json["cvSize"].toInt(),
        competence: json["competence"] == null
            ? null
            : List<String>.from(json["competence"].map((x) => x)),
        hardSkills: json["hardSkills"] == null
            ? null
            : List<SkillModel>.from(
                json["hardSkills"].map((x) => SkillModel.fromJson(x))),
        timeManagementSoftSkills: json["timeManagementSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["timeManagementSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        communicationSoftSkills: json["communicationSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["communicationSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        adaptabilitySoftSkills: json["adaptabilitySoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["adaptabilitySoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        problemSolvingSoftSkills: json["problemSolvingSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["problemSolvingSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        organizationSoftSkills: json["organizationSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["organizationSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        teamworkSoftSkills: json["teamworkSoftSkills"] == null
            ? null
            : List<SkillModel>.from(
                json["teamworkSoftSkills"].map((x) => SkillModel.fromJson(x))),
        creativitySoftSkills: json["creativitySoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["creativitySoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        leadershipSoftSkills: json["leadershipSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["leadershipSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        socialOrInterpersonalSoftSkills:
            json["socialOrInterpersonalSoftSkills"] == null
                ? null
                : List<SkillModel>.from(json["socialOrInterpersonalSoftSkills"]
                    .map((x) => SkillModel.fromJson(x))),
        workEthicSoftSkills: json["workEthicSoftSkills"] == null
            ? null
            : List<SkillModel>.from(
                json["workEthicSoftSkills"].map((x) => SkillModel.fromJson(x))),
        computerSoftSkills: json["computerSoftSkills"] == null
            ? null
            : List<SkillModel>.from(
                json["computerSoftSkills"].map((x) => SkillModel.fromJson(x))),
        lifeSoftSkills: json["lifeSoftSkills"] == null
            ? null
            : List<SkillModel>.from(
                json["lifeSoftSkills"].map((x) => SkillModel.fromJson(x))),
        attentionToDetailSoftSkills: json["attentionToDetailSoftSkills"] == null
            ? null
            : List<SkillModel>.from(json["attentionToDetailSoftSkills"]
                .map((x) => SkillModel.fromJson(x))),
        availability: json["availability"] ?? null,
        numberOfTasksAssignedToUser: json["numberOfTasksAssignedToUser"] == null
            ? null
            : json["numberOfTasksAssignedToUser"].toInt(),
        tasksNumber: json["tasksNumber"] ?? null,
        onHoldTasksCount: json["onHoldTasksCount"] ?? null,
        todoTasksCount: json["todoTasksCount"] ?? null,
        inProgressTasksCount: json["inProgressTasksCount"] ?? null,
        doneTasksCount: json["doneTasksCount"] ?? null,
        overDueTasksCount: json["overDueTasksCount"] ?? null,
        doneOnTimeTasksCount: json["doneOnTimeTasksCount"] ?? null,
        aheadOfScheduleTasksCount: json["aheadOfScheduleTasksCount"] ?? null,
        behindScheduleTasksCount: json["behindScheduleTasksCount"] ?? null,
        onScheduleTasksCount: json["onScheduleTasksCount"] ?? null,
        progressPercentage: json["progressPercentage"] == null
            ? null
            : json["progressPercentage"].toDouble(),
        numberOfProjectsAssignedToUser:
            json["numberOfProjectsAssignedToUser"] ?? null,
        expiredProjectsCount: json["expiredProjectsCount"] ?? null,
        openProjectsCount: json["openProjectsCount"] ?? null,
        closedProjectsCount: json["closedProjectsCount"] ?? null,
        futureProjectsCount: json["futureProjectsCount"] ?? null,
        suggestedProjectsCount: json["suggestedProjectsCount"] ?? null,
        overDueProjectsCount: json["overDueProjectsCount"] ?? null,
        doneOnTimeProjectsCount: json["doneOnTimeProjectsCount"] ?? null,
        remainingProjectsCount: json["remainingProjectsCount"] ?? null,
        aheadOfScheduleProjectsCount:
            json["aheadOfScheduleProjectsCount"] ?? null,
        behindScheduleProjectsCount:
            json["behindScheduleProjectsCount"] ?? null,
        onScheduleProjectsCount: json["onScheduleProjectsCount"] ?? null,
        projectProgressPercentage: json["projectProgressPercentage"] == null
            ? null
            : json["projectProgressPercentage"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "userID": userID ?? null,
        "username": username ?? null,
        "firstName": firstName ?? null,
        "lastName": lastName ?? null,
        "userRole": userRole ?? null,
        "userPhotoURL": userPhotoURL ?? null,
        "userPhotoName": userPhotoName ?? null,
        "userPhotoFile": userPhotoFile ?? null,
        "dateOfBirth": dateOfBirth ?? null,
        "gender": gender ?? null,
        "email": email ?? null,
        "workEmail": workEmail ?? null,
        "personalEmail": personalEmail ?? null,
        "password": password ?? null,
        "confirmedPassword": confirmedPassword ?? null,
        "jobContractType": jobContractType ?? null,
        "jobContractExpirationDate": jobContractExpirationDate ?? null,
        "extension": extension ?? null,
        "jobDepartment": jobDepartment ?? null,
        "jobTeam": jobTeam ?? null,
        "jobField": jobField ?? null,
        "jobSubField": jobSubField ?? null,
        "jobSpecialization": jobSpecialization ?? null,
        "jobTitle": jobTitle ?? null,
        "phoneNumber": phoneNumber ?? null,
        "optionalPhoneNumber": optionalPhoneNumber ?? null,
        "nationality": nationality ?? null,
        "countryOfEmployment": countryOfEmployment ?? null,
        "dateUpdated":
            dateUpdated == null ? null : dateUpdated!.toIso8601String(),
        "dateCreate": dateCreate == null ? null : dateCreate!.toIso8601String(),
        "languages": languages == null
            ? null
            : List<dynamic>.from(languages!.map((x) => x.toJson())),
        "bachelors": bachelors == null
            ? null
            : List<dynamic>.from(bachelors!.map((x) => x)),
        "masters":
            masters == null ? null : List<dynamic>.from(masters!.map((x) => x)),
        "phd": phd == null ? null : List<dynamic>.from(phd!.map((x) => x)),
        "doctoral": doctoral == null
            ? null
            : List<dynamic>.from(doctoral!.map((x) => x)),
        "workExperience": workExperience == null
            ? null
            : List<dynamic>.from(workExperience!.map((x) => x)),
        "volunteerExperience": volunteerExperience == null
            ? null
            : List<dynamic>.from(volunteerExperience!.map((x) => x)),
        "references": references == null
            ? null
            : List<dynamic>.from(references!.map((x) => x)),
        "cv": cvName ?? null,
        "cvFile": cvFile ?? null,
        "cvSize": cvSize ?? null,
        "professionalQualifications": professionalQualifications == null
            ? null
            : List<dynamic>.from(professionalQualifications!.map((x) => x)),
        "educationalQualifications": educationalQualifications == null
            ? null
            : List<dynamic>.from(educationalQualifications!.map((x) => x)),
        "otherQualifications": otherQualifications == null
            ? null
            : List<dynamic>.from(otherQualifications!.map((x) => x)),
        "competence": competence == null
            ? null
            : List<String>.from(competence!.map((x) => x)),
        "hardSkills": hardSkills == null
            ? null
            : List<dynamic>.from(hardSkills!.map((x) => x.toJson())),
        "timeManagementSoftSkills": timeManagementSoftSkills == null
            ? null
            : List<dynamic>.from(
                timeManagementSoftSkills!.map((x) => x.toJson())),
        "communicationSoftSkills": communicationSoftSkills == null
            ? null
            : List<dynamic>.from(
                communicationSoftSkills!.map((x) => x.toJson())),
        "adaptabilitySoftSkills": adaptabilitySoftSkills == null
            ? null
            : List<dynamic>.from(
                adaptabilitySoftSkills!.map((x) => x.toJson())),
        "problemSolvingSoftSkills": problemSolvingSoftSkills == null
            ? null
            : List<dynamic>.from(
                problemSolvingSoftSkills!.map((x) => x.toJson())),
        "organizationSoftSkills": organizationSoftSkills == null
            ? null
            : List<dynamic>.from(
                organizationSoftSkills!.map((x) => x.toJson())),
        "teamworkSoftSkills": teamworkSoftSkills == null
            ? null
            : List<dynamic>.from(teamworkSoftSkills!.map((x) => x.toJson())),
        "creativitySoftSkills": creativitySoftSkills == null
            ? null
            : List<dynamic>.from(creativitySoftSkills!.map((x) => x.toJson())),
        "leadershipSoftSkills": leadershipSoftSkills == null
            ? null
            : List<dynamic>.from(leadershipSoftSkills!.map((x) => x.toJson())),
        "socialOrInterpersonalSoftSkills":
            socialOrInterpersonalSoftSkills == null
                ? null
                : List<dynamic>.from(
                    socialOrInterpersonalSoftSkills!.map((x) => x.toJson())),
        "workEthicSoftSkills": workEthicSoftSkills == null
            ? null
            : List<dynamic>.from(workEthicSoftSkills!.map((x) => x.toJson())),
        "computerSoftSkills": computerSoftSkills == null
            ? null
            : List<dynamic>.from(computerSoftSkills!.map((x) => x.toJson())),
        "lifeSoftSkills": lifeSoftSkills == null
            ? null
            : List<dynamic>.from(lifeSoftSkills!.map((x) => x.toJson())),
        "attentionToDetailSoftSkills": attentionToDetailSoftSkills == null
            ? null
            : List<dynamic>.from(
                attentionToDetailSoftSkills!.map((x) => x.toJson())),
        "availability": availability ?? null,
        "numberOfTasksAssignedToUser": numberOfTasksAssignedToUser ?? null,
        "tasksNumber": tasksNumber ?? null,
        "onHoldTasksCount": onHoldTasksCount ?? null,
        "todoTasksCount": todoTasksCount ?? null,
        "inProgressTasksCount": inProgressTasksCount ?? null,
        "doneTasksCount": doneTasksCount ?? null,
        "overDueTasksCount": overDueTasksCount ?? null,
        "doneOnTimeTasksCount": doneOnTimeTasksCount ?? null,
        "aheadOfScheduleTasksCount": aheadOfScheduleTasksCount ?? null,
        "behindScheduleTasksCount": behindScheduleTasksCount ?? null,
        "onScheduleTasksCount": onScheduleTasksCount ?? null,
        "progressPercentage": progressPercentage ?? null,
        "numberOfProjectsAssignedToUser":
            numberOfProjectsAssignedToUser ?? null,
        "expiredProjectsCount": expiredProjectsCount ?? null,
        "openProjectsCount": openProjectsCount ?? null,
        "closedProjectsCount": closedProjectsCount ?? null,
        "futureProjectsCount": futureProjectsCount ?? null,
        "suggestedProjectsCount": suggestedProjectsCount ?? null,
        "overDueProjectsCount": overDueProjectsCount ?? null,
        "doneOnTimeProjectsCount": doneOnTimeProjectsCount ?? null,
        "remainingProjectsCount": remainingProjectsCount ?? null,
        "aheadOfScheduleProjectsCount": aheadOfScheduleProjectsCount ?? null,
        "behindScheduleProjectsCount": behindScheduleProjectsCount ?? null,
        "onScheduleProjectsCount": onScheduleProjectsCount ?? null,
        "projectProgressPercentage": projectProgressPercentage ?? null,
      };
}
