import 'package:origami_structure/imports.dart';

EducationModel educationModelFromJson(String str) => EducationModel.fromJson(json.decode(str));

String educationModelToJson(EducationModel data) => json.encode(data.toJson());

class EducationModel {
  EducationModel({
    this.educationReferenceBy,
    this.educationReferenceFile,
    this.educationReferenceFileName,
    this.educationReferenceSize,
    this.educationReferenceType,
    this.discipline,
    this.description,
    this.institutionName,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? educationReferenceBy;
  String? educationReferenceFile;
  String? educationReferenceFileName;
  int? educationReferenceSize;
  String? educationReferenceType;
  String? discipline;
  String? description;
  String? institutionName;
  String? startDate;
  String? endDate;
  double? duration;

  factory EducationModel.fromJson(Map<String, dynamic> json) => EducationModel(
    educationReferenceBy: json["educationReferenceBy"] == null ? null : json["educationReferenceBy"],
    educationReferenceFile: json["educationReferenceFile"] == null ? null : json["educationReferenceFile"],
    educationReferenceFileName: json["educationReferenceFileName"] == null ? null : json["educationReferenceFileName"],
    educationReferenceSize: json["educationReferenceSize"] == null ? null : json["educationReferenceSize"],
    educationReferenceType: json["educationReferenceType"] == null ? null : json["educationReferenceType"],
    discipline: json["discipline"] == null ? null : json["discipline"],
    description: json["description"] == null ? null : json["description"],
    institutionName: json["institutionName"] == null ? null : json["institutionName"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null : json["duration"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "educationReferenceBy": educationReferenceBy == null ? null : educationReferenceBy,
    "educationReferenceFile": educationReferenceFile == null ? null : educationReferenceFile,
    "educationReferenceFileName": educationReferenceFileName == null ? null : educationReferenceFileName,
    "educationReferenceSize": educationReferenceSize == null ? null : educationReferenceSize,
    "educationReferenceType": educationReferenceType == null ? null : educationReferenceType,
    "discipline": discipline == null ? null : discipline,
    "description": description == null ? null : description,
    "institutionName": institutionName == null ? null : institutionName,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
  };
}
