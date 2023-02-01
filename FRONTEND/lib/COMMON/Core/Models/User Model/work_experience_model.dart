import 'package:origami_structure/imports.dart';

WorkExperienceModel workExperienceModelFromJson(String str) => WorkExperienceModel.fromJson(json.decode(str));

String workExperienceModelToJson(WorkExperienceModel data) => json.encode(data.toJson());

class WorkExperienceModel {
  WorkExperienceModel({
    this.jobTitle,
    this.jobDescription,
    this.workArea,
    this.startDate,
    this.endDate,
    this.duration,
    this.referenceBy,
    this.referencePhoneNumber,
    this.referenceEmailAddress,
    this.referenceFile,
    this.referenceName,
    this.referenceSize,
  });

  String? jobTitle;
  String? jobDescription;
  String? workArea;
  String? startDate;
  String? endDate;
  double? duration;
  String? referenceBy;
  String? referencePhoneNumber;
  String? referenceEmailAddress;
  String? referenceFile;
  String? referenceName;
  int? referenceSize;

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) => WorkExperienceModel(
    jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
    jobDescription: json["jobDescription"] == null ? null : json["jobDescription"],
    workArea: json["workArea"] == null ? null : json["workArea"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null : json["duration"].toDouble(),
    referenceBy: json["referenceBy"] == null ? null : json["referenceBy"],
    referencePhoneNumber: json["referencePhoneNumber"] == null ? null : json["referencePhoneNumber"],
    referenceEmailAddress: json["referenceEmailAddress"] == null ? null : json["referenceEmailAddress"],
    referenceFile: json["referenceFile"] == null ? null : json["referenceFile"],
    referenceName: json["referenceName"] == null ? null : json["referenceName"],
    referenceSize: json["referenceSize"] == null ? null : json["referenceSize"],
  );

  Map<String, dynamic> toJson() => {
    "jobTitle": jobTitle == null ? null : jobTitle,
    "jobDescription": jobDescription == null ? null : jobDescription,
    "workArea": workArea == null ? null : workArea,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
    "referenceBy": referenceBy == null ? null : referenceBy,
    "referencePhoneNumber": referencePhoneNumber == null ? null : referencePhoneNumber,
    "referenceEmailAddress": referenceEmailAddress == null ? null : referenceEmailAddress,
    "referenceFile": referenceFile == null ? null : referenceFile,
    "referenceName": referenceName == null ? null : referenceName,
    "referenceSize": referenceSize == null ? null : referenceSize,
  };
}