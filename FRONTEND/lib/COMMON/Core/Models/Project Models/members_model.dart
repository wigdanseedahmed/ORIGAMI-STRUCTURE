import 'package:origami_structure/imports.dart';

MembersModel membersModelFromJson(String str) =>
    MembersModel.fromJson(json.decode(str));

String membersModelToJson(MembersModel data) => json.encode(data.toJson());

class MembersModel {
  MembersModel({
    this.memberID,
    this.memberUsername,
    this.memberName,
    this.projectJobPosition,
    this.jobTitle,
    this.phoneNumber,
    this.optionalPhoneNumber,
    this.personalEmail,
    this.workEmail,
    this.skills,
    this.contractType,
    this.startDate,
    this.endDate,
    this.duration,
    this.extension,
    this.skillsAssigned,
    this.tasksNumber,
    this.onHoldTasksCount,
    this.todoTasksCount,
    this.inProgressTasksCount,
    this.doneTasksCount,
    this.overDueTasksCount,
    this.remainingTasksCount,
  });

  String? memberID;
  String? memberUsername;
  String? memberName;
  String? projectJobPosition;
  String? jobTitle;
  String? phoneNumber;
  String? optionalPhoneNumber;
  String? personalEmail;
  String? workEmail;
  List<SkillModel>? skills;
  String? contractType;
  String? startDate;
  String? endDate;
  double? duration;
  String? extension;
  List<String>? skillsAssigned;
  int? tasksNumber;
  int? onHoldTasksCount;
  int? todoTasksCount;
  int? inProgressTasksCount;
  int? doneTasksCount;
  int? overDueTasksCount;
  int? remainingTasksCount;

  factory MembersModel.fromJson(Map<String, dynamic> json) => MembersModel(
        memberID: json["memberID"] == null ? null : json["memberID"],
        memberUsername:
            json["memberUsername"] == null ? null : json["memberUsername"],
        memberName: json["memberName"] == null ? null : json["memberName"],
        projectJobPosition: json["projectJobPosition"] == null
            ? null
            : json["projectJobPosition"],
        jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        optionalPhoneNumber: json["optionalPhoneNumber"] == null
            ? null
            : json["optionalPhoneNumber"],
        personalEmail:
            json["personalEmail"] == null ? null : json["personalEmail"],
        workEmail: json["workEmail"] == null ? null : json["workEmail"],
        skills: json["skills"] == null
            ? null
            : List<SkillModel>.from(
                json["skills"].map((x) => SkillModel.fromJson(x))),
        contractType:
            json["contractType"] == null ? null : json["contractType"],
        startDate: json["startDate"] == null ? null : json["startDate"],
        endDate: json["endDate"] == null ? null : json["endDate"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        extension: json["extension"] == null ? null : json["extension"],
        skillsAssigned: json["skillsAssigned"] == null
            ? null
            : List<String>.from(json["skillsAssigned"].map((x) => x)),
        tasksNumber: json["tasksNumber"] == null ? null : json["tasksNumber"],
        onHoldTasksCount:
            json["onHoldTasksCount"] == null ? null : json["onHoldTasksCount"],
        todoTasksCount:
            json["todoTasksCount"] == null ? null : json["todoTasksCount"],
        inProgressTasksCount: json["inProgressTasksCount"] == null
            ? null
            : json["inProgressTasksCount"],
        doneTasksCount:
            json["doneTasksCount"] == null ? null : json["doneTasksCount"],
        overDueTasksCount: json["overDueTasksCount"] == null
            ? null
            : json["overDueTasksCount"],
        remainingTasksCount: json["remainingTasksCount"] == null
            ? null
            : json["remainingTasksCount"],
      );

  Map<String, dynamic> toJson() => {
        "memberID": memberID == null ? null : memberName,
        "memberUsername": memberUsername == null ? null : memberUsername,
        "memberName": memberName == null ? null : memberName,
        "projectJobPosition":
            projectJobPosition == null ? null : projectJobPosition,
        "jobTitle": jobTitle == null ? null : jobTitle,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "optionalPhoneNumber":
            optionalPhoneNumber == null ? null : optionalPhoneNumber,
        "personalEmail": personalEmail == null ? null : personalEmail,
        "workEmail": workEmail == null ? null : workEmail,
        "skills": skills == null
            ? null
            : List<dynamic>.from(skills!.map((x) => x.toJson())),
        "contractType": contractType == null ? null : contractType,
        "startDate": startDate == null ? null : startDate,
        "endDate": endDate == null ? null : endDate,
        "duration": duration == null ? null : duration,
        "extension": extension == null ? null : extension,
        "skillsAssigned": skillsAssigned == null
            ? null
            : List<dynamic>.from(skillsAssigned!.map((x) => x)),
        "tasksNumber": tasksNumber == null ? null : tasksNumber,
        "onHoldTasksCount": onHoldTasksCount == null ? null : onHoldTasksCount,
        "todoTasksCount": todoTasksCount == null ? null : todoTasksCount,
        "inProgressTasksCount":
            inProgressTasksCount == null ? null : inProgressTasksCount,
        "doneTasksCount": doneTasksCount == null ? null : doneTasksCount,
        "overDueTasksCount":
            overDueTasksCount == null ? null : overDueTasksCount,
        "remainingTasksCount":
            remainingTasksCount == null ? null : remainingTasksCount
      };
}
