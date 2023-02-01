import 'package:origami_structure/imports.dart';

QualificationModel qualificationModelFromJson(String str) => QualificationModel.fromJson(json.decode(str));

String qualificationModelToJson(QualificationModel data) => json.encode(data.toJson());

class QualificationModel {
  QualificationModel({
    this.qualificationBy,
    this.qualificationFile,
    this.qualificationFileName,
    this.qualificationSize,
    this.qualificationType,
    this.title,
    this.description,
    this.obtainedFrom,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? qualificationBy;
  String? qualificationFile;
  String? qualificationFileName;
  int? qualificationSize;
  String? qualificationType;
  String? title;
  String? description;
  String? obtainedFrom;
  String? startDate;
  String? endDate;
  double? duration;

  factory QualificationModel.fromJson(Map<String, dynamic> json) => QualificationModel(
    qualificationBy: json["qualificationBy"] == null ? null : json["qualificationBy"],
    qualificationFile: json["qualificationFile"] == null ? null : json["qualificationFile"],
    qualificationFileName: json["qualificationFileName"] == null ? null : json["qualificationFileName"],
    qualificationSize: json["qualificationSize"] == null ? null : json["qualificationSize"],
    qualificationType: json["qualificationType"] == null ? null : json["qualificationType"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    obtainedFrom: json["obtainedFrom"] == null ? null : json["obtainedFrom"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null : json["duration"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "qualificationBy": qualificationBy == null ? null : qualificationBy,
    "qualificationFile": qualificationFile == null ? null : qualificationFile,
    "qualificationFileName": qualificationFileName == null ? null : qualificationFileName,
    "qualificationSize": qualificationSize == null ? null : qualificationSize,
    "qualificationType": qualificationType == null ? null : qualificationType,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "obtainedFrom": obtainedFrom == null ? null : obtainedFrom,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
  };
}
