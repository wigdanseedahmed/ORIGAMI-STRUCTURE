import 'package:origami_structure/imports.dart';

class SkillsRequiredPerMemberModel {
  SkillsRequiredPerMemberModel({
    this.hardSkills,
    this.skillName,
    this.jobField,
    this.jobSubField,
    this.jobSpecialization,
    this.jobTitle,
    this.contractType,
    this.startDate,
    this.endDate,
    this.duration,
    this.assignedTo,
  });

  List<SkillModel>? hardSkills;
  String? skillName;
  String? jobField;
  String? jobSubField;
  String? jobSpecialization;
  String? jobTitle;
  String? contractType;
  String? startDate;
  String? endDate;
  double? duration;
  String? assignedTo;

  factory SkillsRequiredPerMemberModel.fromJson(Map<String, dynamic> json) =>
      SkillsRequiredPerMemberModel(
        hardSkills: json["skill"] == null
            ? null
            : List<SkillModel>.from(
                json["skill"].map((x) => SkillModel.fromJson(x))),
        skillName: json["skillName"] == null ? null : json["skillName"],
        jobField: json["jobField"] == null ? null : json["jobField"],
        jobSubField: json["jobSubField"] == null ? null : json["jobSubField"],
        jobSpecialization: json["jobSpecialization"] == null
            ? null
            : json["jobSpecialization"],
        jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
        contractType:
            json["contractType"] == null ? null : json["contractType"],
        startDate: json["startDate"] == null ? null : json["startDate"],
        endDate: json["endDate"] == null ? null : json["endDate"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        assignedTo: json["assignedTo"] == null ? null : json["assignedTo"],
      );

  Map<String, dynamic> toJson() => {
        "hardSkills": hardSkills == null
            ? null
            : List<dynamic>.from(hardSkills!.map((x) => x.toJson())),
        "skillName": skillName == null ? null : skillName,
        "jobField": jobField == null ? null : jobField,
        "jobSubField": jobSubField == null ? null : jobSubField,
        "jobSpecialization":
            jobSpecialization == null ? null : jobSpecialization,
        "jobTitle": jobTitle == null ? null : jobTitle,
        "contractType": contractType == null ? null : contractType,
        "startDate": startDate == null ? null : startDate,
        "endDate": endDate == null ? null : endDate,
        "duration": duration == null ? null : duration,
        "assignedTo": assignedTo == null ? null : assignedTo,
      };
}

class SkillModel {
  SkillModel({
    this.typeOfSpecialization,
    this.skillCategory,
    this.skill,
    this.level,
  });

  String? typeOfSpecialization;
  String? skillCategory;
  String? skill;
  String? level;

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        typeOfSpecialization: json["typeOfSpecialization"] == null
            ? null
            : json["typeOfSpecialization"],
        skillCategory:
            json["skillCategory"] == null ? null : json["skillCategory"],
        skill: json["skill"] == null ? null : json["skill"],
        level: json["level"] == null ? null : json["level"],
      );

  Map<String, dynamic> toJson() => {
        "typeOfSpecialization":
            typeOfSpecialization == null ? null : typeOfSpecialization,
        "skillCategory": skillCategory == null ? null : skillCategory,
        "skill": skill == null ? null : skill,
        "level": level == null ? null : level,
      };
}
