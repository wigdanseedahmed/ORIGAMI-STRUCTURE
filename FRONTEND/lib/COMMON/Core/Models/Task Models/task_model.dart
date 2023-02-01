import 'package:origami_structure/imports.dart';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

TaskModel taskFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskToJson(TaskModel date) => json.encode(date.toJson());

String taskModelToJson(List<TaskModel> date) =>
    json.encode(List<dynamic>.from(date.map((x) => x.toJson())));

class TaskModel {
  TaskModel({
    this.id,
    this.taskNo,
    this.taskName,
    this.projectName,
    this.projectStatus,
    this.projectLeader,
    this.projectDeadline,
    this.projectType,
    this.projectMilestone,
    this.projectPhase,
    this.skillsAssigned,
    this.taskDetail,
    this.deliverable,
    this.percentageDone,
    this.plannedPercentageDone,
    this.progressCategories,
    this.weightGiven,
    this.priority,
    this.status,
    this.dateChanged,
    this.dateCreated,
    this.startDate,
    this.submissionDate,
    this.deadlineDate,
    this.duration,
    this.criticalityColour,
    this.assignedTo,
    this.assignedBy,
    this.activities,
    this.checklist,
    this.risks,
    this.issuesCategory,
    this.rootCauseOfIssues,
    this.remarks,
    this.nextWeekOutlook,
    this.comments,
    this.taskFiles,
  });

  String? id;
  String? taskNo;
  String? taskName;
  String? projectName;
  String? projectStatus;
  String? projectLeader;
  String? projectDeadline;
  List<String>? projectType;
  String? projectMilestone;
  String? projectPhase;
  String? projectPhaseDeadline;
  List<String>? skillsAssigned;
  String? taskDetail;
  String? deliverable;
  double? percentageDone;
  double? plannedPercentageDone;
  String? progressCategories;
  double? weightGiven;
  String? priority; //Urgency
  String? status;
  DateTime? dateChanged;
  DateTime? dateCreated;
  String? startDate;
  String? submissionDate;
  String? deadlineDate;
  double? duration;
  int? criticalityColour;
  List<String>? assignedTo;
  String? assignedBy;
  List? activities;
  List<ChecklistModel>? checklist;
  String? risks;
  String? issuesCategory;
  String? rootCauseOfIssues;
  String? remarks;
  String? nextWeekOutlook;
  List<CommentModel>? comments;
  List<FileModel>? taskFiles;

  factory TaskModel.fromJson(Map<String, dynamic>? json) => TaskModel(
        id: json!["id"] == null ? null : json["id"],
        taskNo: json["taskNo"] == null ? null : json["taskNo"],
        taskName: json["taskName"] == null ? null : json["taskName"],
        projectName: json['projectName'] == null ? null : json['projectName'],
        projectStatus:
            json['projectStatus'] == null ? null : json['projectStatus'],
        projectLeader:
            json['projectLeader'] == null ? null : json['projectLeader'],
        projectDeadline:
            json['projectDeadline'] == null ? null : json['projectDeadline'],
        projectType: json['projectType'] == null
            ? null
            : List<String>.from(json["projectType"].map((x) => x)),
        projectMilestone:
            json['projectMilestone'] == null ? null : json['projectMilestone'],
        projectPhase:
            json["projectPhase"] == null ? null : json["projectPhase"],
        skillsAssigned: json["skillsAssigned"] == null
            ? null
            : List<String>.from(json["skillsAssigned"].map((x) => x)),
        taskDetail: json["taskDetail"] == null ? null : json["taskDetail"],
        assignedTo: json["assignedTo"] == null
            ? null
            : List<String>.from(json["assignedTo"].map((x) => x)),
        assignedBy: json['assignedBy'] == null ? null : json['assignedBy'],
        status: json["status"] == null ? null : json["status"],
        deliverable: json["deliverable"] == null ? null : json["deliverable"],
        percentageDone: json["percentageDone"] == null
            ? null
            : json["percentageDone"].toDouble(),
        plannedPercentageDone: json["plannedPercentageDone"] == null
            ? null
            : json["plannedPercentageDone"].toDouble(),
        progressCategories: json["progressCategories"] == null
            ? null
            : json["progressCategories"],
        weightGiven:
            json["weightGiven"] == null ? null : json["weightGiven"].toDouble(),
        priority: json["priority"] == null ? null : json["priority"],
        dateChanged: json["dateChanged"] == null
            ? null
            : DateTime.parse(json["dateChanged"]),
        dateCreated: json["dateCreated"] == null
            ? null
            : DateTime.parse(json["dateCreated"]),
        startDate: json['startDate'] == null ? null : json['startDate'],
        submissionDate:
            json['submissionDate'] == null ? null : json['submissionDate'],
        deadlineDate:
            json['deadlineDate'] == null ? null : json['deadlineDate'],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        criticalityColour: json['criticalityColour'] == null
            ? null
            : json['criticalityColour'],
        activities: json['activities'] == null ? null : json['activities'],
        checklist: json['checklist'] == null
            ? null
            : List<ChecklistModel>.from(
                json["checklist"].map((x) => ChecklistModel.fromJson(x))),
        risks: json['risks'] == null ? null : json['risks'],
        issuesCategory:
            json['issuesCategory'] == null ? null : json['issuesCategory'],
        rootCauseOfIssues: json['rootCauseOfIssues'] == null
            ? null
            : json['rootCauseOfIssues'],
        remarks: json['remarks'] == null ? null : json['remarks'],
        nextWeekOutlook:
            json['nextWeekOutlook'] == null ? null : json['nextWeekOutlook'],
        comments: json['comments'] == null
            ? null
            : List<CommentModel>.from(
                json["comments"].map((x) => CommentModel.fromJson(x))),
        taskFiles: json['taskFiles'] == null
            ? null
            : List<FileModel>.from(
            json["taskFiles"].map((x) => FileModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "taskNo": taskNo == null ? null : taskNo,
        "taskName": taskName == null ? null : taskName,
        "projectLeader": projectLeader == null ? null : projectLeader,
        "projectStatus": projectStatus == null ? null : projectStatus,
        "projectDeadline": projectDeadline == null ? null : projectDeadline,
        "projectType": projectType == null
            ? null
            : List<dynamic>.from(projectType!.map((x) => x)),
        "projectName": projectName == null ? null : projectName,
        "projectMilestone": projectMilestone == null ? null : projectMilestone,
        "projectPhase": projectPhase == null ? null : projectPhase,
        "skillsAssigned": skillsAssigned == null
            ? null
            : List<dynamic>.from(skillsAssigned!.map((x) => x)),
        "taskDetail": taskDetail == null ? null : taskDetail,
        "deliverable": deliverable == null ? null : deliverable,
        "percentageDone": percentageDone == null ? null : percentageDone,
        "plannedPercentageDone":
            plannedPercentageDone == null ? null : plannedPercentageDone,
        "progressCategories":
            progressCategories == null ? null : progressCategories,
        "weightGiven": weightGiven == null ? null : weightGiven,
        "priority": priority == null ? null : priority,
        "status": status == null ? null : status,
        "dateChanged":
            dateChanged == null ? null : dateChanged!.toIso8601String(),
        "dateCreated":
            dateCreated == null ? null : dateCreated!.toIso8601String(),
        "startDate": startDate == null ? null : startDate,
        "submissionDate": submissionDate == null ? null : submissionDate,
        "deadlineDate": deadlineDate == null ? null : deadlineDate,
        "duration": duration == null ? null : duration,
        "criticalityColour":
            criticalityColour == null ? null : criticalityColour,
        "assignedTo": assignedTo == null
            ? null
            : List<dynamic>.from(assignedTo!.map((x) => x)),
        "assignedBy": assignedBy == null ? null : assignedBy,
        "activities": activities == null ? null : activities,
        "checklist": checklist == null
            ? null
            : List<dynamic>.from(checklist!.map((x) => x.toJson())),
        "risks": risks == null ? null : risks,
        "issuesCategory": issuesCategory == null ? null : issuesCategory,
        "rootCauseOfIssues":
            rootCauseOfIssues == null ? null : rootCauseOfIssues,
        "remarks": remarks == null ? null : remarks,
        "nextWeekOutlook": risks == null ? null : risks,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "taskFiles": taskFiles == null
            ? null
            : List<dynamic>.from(taskFiles!.map((x) => x.toJson())),
      };
}
