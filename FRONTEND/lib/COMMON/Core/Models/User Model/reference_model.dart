import 'package:origami_structure/imports.dart';

ReferenceModel referenceModelFromJson(String str) => ReferenceModel.fromJson(json.decode(str));

String referenceModelToJson(ReferenceModel data) => json.encode(data.toJson());

class ReferenceModel {
  ReferenceModel({
    this.referenceBy,
    this.referencePhoneNumber,
    this.referenceEmailAddress,
    this.referenceFile,
    this.referenceName,
    this.referenceSize,
    this.jobTitle,
    this.workArea,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? referenceBy;
  String? referencePhoneNumber;
  String? referenceEmailAddress;
  String? referenceFile;
  String? referenceName;
  int? referenceSize;
  String? jobTitle;
  String? workArea;
  String? startDate;
  String? endDate;
  double? duration;

  factory ReferenceModel.fromJson(Map<String, dynamic> json) => ReferenceModel(
    referenceBy: json["referenceBy"] == null ? null : json["referenceBy"],
    referencePhoneNumber: json["referencePhoneNumber"] == null ? null : json["referencePhoneNumber"],
    referenceEmailAddress: json["referenceEmailAddress"] == null ? null : json["referenceEmailAddress"],
    referenceFile: json["referenceFile"] == null ? null : json["referenceFile"],
    referenceName: json["referenceName"] == null ? null : json["referenceName"],
    referenceSize: json["referenceSize"] == null ? null : json["referenceSize"],
    jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
    workArea: json["workArea"] == null ? null : json["workArea"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null : json["duration"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "referenceBy": referenceBy == null ? null : referenceBy,
    "referencePhoneNumber": referencePhoneNumber == null ? null : referencePhoneNumber,
    "referenceEmailAddress": referenceEmailAddress == null ? null : referenceEmailAddress,
    "referenceFile": referenceFile == null ? null : referenceFile,
    "referenceName": referenceName == null ? null : referenceName,
    "referenceSize": referenceSize == null ? null : referenceSize,
    "jobTitle": jobTitle == null ? null : jobTitle,
    "workArea": workArea == null ? null : workArea,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
  };
}
