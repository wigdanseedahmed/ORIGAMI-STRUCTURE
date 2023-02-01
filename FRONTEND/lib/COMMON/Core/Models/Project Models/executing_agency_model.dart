import 'package:origami_structure/imports.dart';

ExecutingAgencyModel executingAgencyModelFromJson(String str) => ExecutingAgencyModel.fromJson(json.decode(str));

String executingAgencyModelToJson(ExecutingAgencyModel data) => json.encode(data.toJson());

class ExecutingAgencyModel {
  ExecutingAgencyModel({
    this.executingAgencyName,
    this.executingAgencyDepartment,
    this.executingAgencyTeam,
    this.executingAgencyEmail,
    this.executingAgencyWebsite,
    this.executingAgencyPhotoUrl,
    this.executingAgencyProjectList,
  });

  String? executingAgencyName;
  String? executingAgencyDepartment;
  String? executingAgencyTeam;
  String? executingAgencyEmail;
  String? executingAgencyWebsite;
  String? executingAgencyPhotoUrl;
  List<String>? executingAgencyProjectList;

  factory ExecutingAgencyModel.fromJson(Map<String, dynamic> json) => ExecutingAgencyModel(
    executingAgencyName: json["executingAgencyName"] == null ? null : json["executingAgencyName"],
    executingAgencyDepartment: json["executingAgencyDepartment"] == null ? null : json["executingAgencyDepartment"],
    executingAgencyTeam: json["executingAgencyTeam"] == null ? null : json["executingAgencyTeam"],
    executingAgencyEmail: json["executingAgencyEmail"] == null ? null : json["executingAgencyEmail"] ,
    executingAgencyWebsite: json["executingAgencyWebsite"] == null ? null : json["executingAgencyWebsite"],
    executingAgencyPhotoUrl: json["executingAgencyPhotoUrl"] == null ? null : json["executingAgencyPhotoUrl"],
    executingAgencyProjectList: json["executingAgencyProjectList"] == null ? null : List<String>.from(json["executingAgencyProjectList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "executingAgencyName": executingAgencyName == null ? null :executingAgencyName ,
    "executingAgencyDepartment": executingAgencyDepartment == null ? null : executingAgencyDepartment,
    "executingAgencyTeam": executingAgencyTeam == null ? null : executingAgencyTeam,
    "executingAgencyEmail": executingAgencyEmail == null ? null : executingAgencyEmail,
    "executingAgencyWebsite": executingAgencyWebsite == null ? null : executingAgencyWebsite,
    "executingAgencyPhotoUrl": executingAgencyPhotoUrl == null ? null : executingAgencyPhotoUrl,
    "executingAgencyProjectList": executingAgencyProjectList == null ? null : List<dynamic>.from(executingAgencyProjectList!.map((x) => x)),
  };
}