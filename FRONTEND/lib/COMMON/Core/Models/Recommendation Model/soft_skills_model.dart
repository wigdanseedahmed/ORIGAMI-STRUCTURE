import 'package:origami_structure/imports.dart';

List<SoftSkillsDataModel> softSkillsDataListFromJson(String str) =>
    List<SoftSkillsDataModel>.from(json.decode(str).map((x) => SoftSkillsDataModel.fromJson(x)));

String softSkillsDataListToJson(List<SoftSkillsDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

SoftSkillsDataModel softSkillsDataFromJson(String str) => SoftSkillsDataModel.fromJson(json.decode(str));

String softSkillsDataToJson(SoftSkillsDataModel data) => json.encode(data.toJson());

class SoftSkillsDataModel {
  SoftSkillsDataModel({
    this.softSkillID,
    this.softSkillCategory,
    this.softSkill,
    this.level,
  });

  String? softSkillID;
  String? softSkillCategory;
  String? softSkill;
  String? level;

  factory SoftSkillsDataModel.fromJson(Map<String, dynamic> json) =>
      SoftSkillsDataModel(
        softSkillID: json["softSkillID"] ?? null,
        softSkillCategory: json["softSkillCategory"] ?? null,
        softSkill: json["softSkill"] ?? null,
        level: json["level"] ?? null,
      );

  Map<String, dynamic> toJson() =>
      {
        "softSkillID": softSkillID ?? null,
        "softSkillCategory": softSkillCategory ?? null,
        "softSkill": softSkill ?? null,
        "level": level ?? null,
      };
}