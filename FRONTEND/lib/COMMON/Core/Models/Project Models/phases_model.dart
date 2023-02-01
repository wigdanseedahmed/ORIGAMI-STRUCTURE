import 'package:origami_structure/imports.dart';

PhasesModel phaseModelFromJson(String str) => PhasesModel.fromJson(json.decode(str));

String phaseModelToJson(PhasesModel data) => json.encode(data.toJson());

class PhasesModel {
  PhasesModel({
    this.phaseId,
    this.phase,
    this.weightGiven,
    this.progressPercentage,
    this.plannedPhaseProgressPercentage,
    this.deliverables,
    this.actionPlan,
    this.impact,
    this.risks,
    this.comments,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? phaseId;
  String? phase;
  double? weightGiven;
  double? progressPercentage;
  double? plannedPhaseProgressPercentage;
  String? deliverables;
  String? actionPlan;
  String? impact;
  String? risks;
  String? comments;
  String? startDate;
  String? endDate;
  double? duration;

  factory PhasesModel.fromJson(Map<String, dynamic> json) => PhasesModel(
    phaseId: json["phaseID"] == null ? null : json["phaseID"],
    phase: json["phase"] == null ? null : json["phase"],
    weightGiven: json["weightGiven"] == null ? null :  json["weightGiven"].toDouble(),
    progressPercentage: json["progressPercentage"] == null ? null :  json["progressPercentage"].toDouble(),
    plannedPhaseProgressPercentage: json["plannedPhaseProgressPercentage"] == null ? null :  json["plannedPhaseProgressPercentage"].toDouble(),
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
    "phaseID": phaseId == null ? null : phaseId,
    "phase": phase == null ? null : phase,
    "weightGiven": weightGiven == null ? null : weightGiven,
    "progressPercentage": progressPercentage == null ? null : progressPercentage,
    "plannedPhaseProgressPercentage": plannedPhaseProgressPercentage == null ? null : plannedPhaseProgressPercentage,
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
