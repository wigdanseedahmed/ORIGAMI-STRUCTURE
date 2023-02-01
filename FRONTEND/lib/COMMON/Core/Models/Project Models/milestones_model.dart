import 'package:origami_structure/imports.dart';

MilestonesModel milestoneModelFromJson(String str) => MilestonesModel.fromJson(json.decode(str));

String milestoneModelToJson(MilestonesModel data) => json.encode(data.toJson());

class MilestonesModel {
  MilestonesModel({
    this.milestonesId,
    this.milestones,
    this.weightGiven,
    this.deliverables,
    this.actionPlan,
    this.impact,
    this.risks,
    this.comments,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? milestonesId;
  String? milestones;
  double? weightGiven;
  String? deliverables;
  String? actionPlan;
  String? impact;
  String? risks;
  String? comments;
  String? startDate;
  String? endDate;
  double? duration;


  factory MilestonesModel.fromJson(Map<String, dynamic> json) => MilestonesModel(
    milestonesId: json["milestonesID"] == null ? null : json["milestonesID"],
    milestones: json["milestones"] == null ? null : json["milestones"],
    weightGiven: json["weightGiven"] == null ? null :  json["weightGiven"].toDouble(),
    deliverables: json["deliverables"] == null ? null : json["deliverables"],
    actionPlan: json["actionPlan"] == null ? null : json["actionPlan"],
    impact: json["impact"] == null ? null : json["impact"],
    risks: json["risks"] == null ? null : json["risks"],
    comments: json["comments"] == null ? null : json["comments"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null :  json["duration"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "milestonesID": milestonesId == null ? null : milestonesId,
    "milestones": milestones == null ? null : milestones,
    "weightGiven": weightGiven == null ? null : weightGiven,
    "deliverables": deliverables == null ? null : deliverables,
    "actionPlan": actionPlan == null ? null : actionPlan,
    "impact": impact == null ? null : impact,
    "risks": risks == null ? null : risks,
    "comments": comments == null ? null : comments,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
  };
}
