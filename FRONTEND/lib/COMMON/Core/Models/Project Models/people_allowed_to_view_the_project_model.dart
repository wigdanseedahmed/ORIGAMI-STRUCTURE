import 'package:origami_structure/imports.dart';

PeopleAllowedToViewProjectModel peopleAllowedToViewProjectModelFromJson(String str) =>
    PeopleAllowedToViewProjectModel.fromJson(json.decode(str));

String peopleAllowedToViewProjectModelToJson(PeopleAllowedToViewProjectModel data) => json.encode(data.toJson());

class PeopleAllowedToViewProjectModel {
  PeopleAllowedToViewProjectModel({
    this.personAllowedToViewProjectID,
    this.personAllowedToViewProjectUsername,
    this.personAllowedToViewProjectName,
    this.projectJobPosition,
    this.jobTitle,
    this.phoneNumber,
    this.optionalPhoneNumber,
    this.personalEmail,
    this.workEmail,
    this.skills,
    this.contractType,
    this.startDate,
    this.endDate,
    this.duration,
    this.extension,
  });

  String? personAllowedToViewProjectID;
  String? personAllowedToViewProjectUsername;
  String? personAllowedToViewProjectName;
  String? projectJobPosition;
  String? jobTitle;
  String? phoneNumber;
  String? optionalPhoneNumber;
  String? personalEmail;
  String? workEmail;
  List<SkillModel>? skills;
  String? contractType;
  String? startDate;
  String? endDate;
  double? duration;
  String? extension;

  factory PeopleAllowedToViewProjectModel.fromJson(Map<String, dynamic> json) => PeopleAllowedToViewProjectModel(
        personAllowedToViewProjectID: json["personAllowedToViewProjectID"]== null ? null : json["personAllowedToViewProjectID"],
        personAllowedToViewProjectUsername: json["personAllowedToViewProjectUsername"]== null ? null : json["personAllowedToViewProjectUsername"],
        personAllowedToViewProjectName: json["personAllowedToViewProjectName"]== null ? null : json["personAllowedToViewProjectName"],
        projectJobPosition: json["projectJobPosition"]== null ? null : json["projectJobPosition"],
        jobTitle: json["jobTitle"]== null ? null : json["jobTitle"],
        phoneNumber: json["phoneNumber"]== null ? null :json["phoneNumber"] ,
        optionalPhoneNumber: json["optionalPhoneNumber"]== null ? null : json["optionalPhoneNumber"],
        personalEmail: json["personalEmail"]== null ? null : json["personalEmail"],
        workEmail: json["workEmail"]== null ? null : json["workEmail"],
        skills: json["skills"] == null ? null : List<SkillModel>.from(json["skills"].map((x) => SkillModel.fromJson(x))),
        contractType: json["contractType"]== null ? null : json["contractType"],
        startDate: json["startDate"]== null ? null :json["startDate"] ,
        endDate: json["endDate"]== null ? null :json["endDate"] ,
        duration: json["duration"]== null ? null : json["duration"].toDouble(),
        extension: json["extension"]== null ? null : json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "personAllowedToViewProjectID": personAllowedToViewProjectID== null ? null : personAllowedToViewProjectName,
        "personAllowedToViewProjectUsername": personAllowedToViewProjectUsername== null ? null : personAllowedToViewProjectUsername,
        "personAllowedToViewProjectName": personAllowedToViewProjectName== null ? null : personAllowedToViewProjectName,
        "projectJobPosition": projectJobPosition== null ? null : projectJobPosition,
        "jobTitle": jobTitle== null ? null : jobTitle,
        "phoneNumber": phoneNumber== null ? null : phoneNumber,
        "optionalPhoneNumber": optionalPhoneNumber== null ? null : optionalPhoneNumber,
        "personalEmail": personalEmail== null ? null : personalEmail,
        "workEmail": workEmail== null ? null : workEmail,
        "skills": skills == null ? null : List<dynamic>.from(skills!.map((x) => x.toJson())),
        "contractType": contractType== null ? null : contractType,
        "startDate": startDate== null ? null : startDate,
        "endDate": endDate== null ? null : endDate,
        "duration": duration== null ? null : duration,
        "extension": extension== null ? null : extension,
      };
}
