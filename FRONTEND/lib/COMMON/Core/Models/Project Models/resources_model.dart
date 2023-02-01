import 'package:origami_structure/imports.dart';

class ResourcesModel {
  ResourcesModel({
    this.resourcesID,
    this.resourcesType,
    this.resourcesTool,
    this.reference,
    this.cost,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? resourcesID;
  String? resourcesType;
  String? resourcesTool;
  String? reference;
  double? cost;
  String? startDate;
  String? endDate;
  double? duration;

  factory ResourcesModel.fromJson(Map<String, dynamic> json) => ResourcesModel(
        resourcesID: json["resourcesID"] == null ? null : json["resourcesID"],
        resourcesType:
            json["resourcesType"] == null ? null : json["resourcesType"],
        resourcesTool:
            json["resourcesTool"] == null ? null : json["resourcesTool"],
        reference: json["reference"] == null ? null : json["reference"],
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        startDate: json["startDate"] == null ? null : json["startDate"],
        endDate: json["endDate"] == null ? null : json["endDate"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "resourcesID": resourcesID == null? null: resourcesID,
        "resourcesType": resourcesType == null? null: resourcesType,
        "resourcesTool": resourcesTool == null? null: resourcesTool,
        "reference": reference == null? null: reference,
        "cost": cost == null? null: cost,
        "startDate": startDate == null? null: startDate,
        "endDate": endDate == null? null: endDate,
        "duration": duration == null? null: duration,
      };
}
