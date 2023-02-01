import 'package:origami_structure/imports.dart';

List<HardSkillsDataModel> hardSkillsDataListFromJson(String str) =>
    List<HardSkillsDataModel>.from(json.decode(str).map((x) => HardSkillsDataModel.fromJson(x)));

String hardSkillsDataListToJson(List<HardSkillsDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

HardSkillsDataModel hardSkillsDataFromJson(String str) => HardSkillsDataModel.fromJson(json.decode(str));

String hardSkillsDataToJson(HardSkillsDataModel data) => json.encode(data.toJson());

class HardSkillsDataModel {
  HardSkillsDataModel({
    this.hardSkillID,
    this.jobField,
   this.jobSubField,
    this.jobSpecialization,
    this.jobTitle,
    this.typeOfSpecialization,
    this.hardSkillCategory,
    this.hardSkill,
    this.level,
  });

  String? hardSkillID;
  String? jobField;
  String? jobSubField;
  String? jobSpecialization;
  String? jobTitle;
  String? typeOfSpecialization;
  String? hardSkillCategory;
  String? hardSkill;
  String? level;

  factory HardSkillsDataModel.fromJson(Map<String, dynamic> json) =>
      HardSkillsDataModel(
        hardSkillID: json["hardSkillID"] ?? null,
        jobField: json["jobField"] ?? null,
        jobSubField: json["jobSubField"] ?? null,
        jobSpecialization: json["jobSpecialization"] ?? null,
        jobTitle: json["jobTitle"] ?? null,
        typeOfSpecialization: json["typeOfSpecialization"] ?? null,
        hardSkillCategory: json["hardSkillCategory"] ?? null,
        hardSkill: json["hardSkill"] ?? null,
        level: json["level"] ?? null,
      );

  Map<String, dynamic> toJson() =>
      {
        "hardSkillID": hardSkillID ?? null,
        "jobField": jobField ?? null,
        "jobSubField": jobSubField ?? null,
        "jobSpecialization": jobSpecialization ?? null,
        "jobTitle": jobTitle ?? null,
        "typeOfSpecialization": typeOfSpecialization ?? null,
        "hardSkillCategory": hardSkillCategory ?? null,
        "hardSkill": hardSkill ?? null,
        "level": level ?? null,
      };
}