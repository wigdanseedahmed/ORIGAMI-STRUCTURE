import 'package:origami_structure/imports.dart';

List<ProjectModel> projectModelFromJson(String str) => List<ProjectModel>.from(
    json.decode(str).map((x) => ProjectModel.fromJson(x)));

ProjectModel projectFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectToJson(ProjectModel data) => json.encode(data.toJson());

String projectModelToJson(List<ProjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectModel {
  ProjectModel({
    this.id,
    this.projectNo,
    this.projectName,
    this.projectDescription,
    this.projectLeader,
    this.projectManager,
    this.projectAssistantOrCoordinator,
    this.aims,
    this.objective,
    this.benefits,
    this.deliverables,
    this.initialRisks,
    this.expectedOutcome,
    this.measurableCriteriaForSuccess,
    this.projectPhotoName,
    this.projectPhotoFile,
    this.phases,
    this.phasesNumber,
    this.tasks,
    this.tasksNumber,
    this.onHoldTasksCount,
    this.todoTasksCount,
    this.inProgressTasksCount,
    this.doneTasksCount,
    this.overDueTasksCount,
    this.remainingTasksCount,
    this.doneOnTimeTasksCount,
    this.aheadOfScheduleTasksCount,
    this.behindScheduleTasksCount,
    this.onScheduleTasksCount,
    this.milestones,
    this.milestonesNumber,
    this.status,
    this.tasksStatusList,
    this.typeOfProject,
    this.sdgs,
    this.theme,
    this.estimatedCost,
    this.totalEstimatedCost,
    this.budget,
    this.totalBudget,
    this.donor,
    this.totalDonatedAmount,
    this.executingAgency,
    this.dateChange,
    this.dateCreate,
    this.startDate,
    this.completionDate,
    this.dueDate,
    this.duration,
    this.progressPercentage,
    this.plannedProjectProgressPercentage,
    this.progressCategories,
    this.criticalityColour,
    this.locations,
    this.locationsNumber,
    this.skillsRequired,
    this.resources,
    this.totalResourceCost,
    this.members,
    this.totalProjectMembers,
    // this.peopleAllowedToViewProject,
    this.contribution,
    this.dataReliability,
  });

  String? id;
  int? projectNo;
  String? projectName;
  String? projectDescription;
  String? projectLeader;
  String? projectManager;
  String? projectAssistantOrCoordinator;
  String? aims;
  String? objective;
  String? benefits;
  String? deliverables;
  String? initialRisks;
  String? expectedOutcome;
  String? measurableCriteriaForSuccess;
  String? projectPhotoName;
  String? projectPhotoFile;
  List<PhasesModel>? phases;
  int? phasesNumber;
  List<TaskModel>? tasks;
  int? tasksNumber;
  int? onHoldTasksCount;
  int? todoTasksCount;
  int? inProgressTasksCount;
  int? doneTasksCount;
  int? overDueTasksCount;
  int? remainingTasksCount;
  int? doneOnTimeTasksCount;
  int? aheadOfScheduleTasksCount;
  int? behindScheduleTasksCount;
  int? onScheduleTasksCount;
  List<MilestonesModel>? milestones;
  int? milestonesNumber;
  String? status;
  List<String>? tasksStatusList;
  List<String>? typeOfProject;
  List<String>? sdgs;
  List<String>? theme;
  List<EstimatedCostModel>? estimatedCost;
  double? totalEstimatedCost;
  List<BudgetModel>? budget;
  double? totalBudget;
  List<DonorModel>? donor;
  double? totalDonatedAmount;
  List<ExecutingAgencyModel>? executingAgency;
  String? dateChange;
  String? dateCreate;
  String? startDate;
  String? completionDate;
  String? dueDate;
  double? duration;
  double? progressPercentage;
  double? plannedProjectProgressPercentage;
  String? progressCategories;
  int? criticalityColour;
  List<LocationsModel>? locations;
  int? locationsNumber;
  List<SkillsRequiredPerMemberModel>? skillsRequired;
  List<MembersModel>? members;
  double? totalProjectMembers;
  // List<PeopleAllowedToViewProjectModel>? peopleAllowedToViewProject;
  List<ResourcesModel>? resources;
  double? totalResourceCost;
  String? contribution;
  String? dataReliability;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"] ?? null,
        projectNo: json["projectNo"] ?? null,
        projectName: json["projectName"] ?? null,
        projectDescription: json["projectDescription"] ?? null,
        projectLeader: json["projectManager"] ?? null,
        projectManager: json["projectSeniorManager"] ?? null,
        projectAssistantOrCoordinator: json["projectCoordinator"] ?? null,
        aims: json["aims"] ?? null,
        objective: json["objective"] ?? null,
        benefits: json["benefits"] ?? null,
        deliverables: json["deliverables"] ?? null,
        initialRisks: json["risks"] ?? null,
        expectedOutcome: json["outcome"] ?? null,
        measurableCriteriaForSuccess:
            json["measurableCriteriaForSuccess"] ?? null,
        projectPhotoName: json["projectPhotoName"] ?? null,
        projectPhotoFile: json["projectPhotoFile"] ?? null,
        phases: json["phases"] == null
            ? null
            : List<PhasesModel>.from(
                json["phases"].map((x) => PhasesModel.fromJson(x))),
        phasesNumber: json["phasesNumber"] ?? null,
        tasks: json["tasks"] == null
            ? null
            : List<TaskModel>.from(
                json["tasks"].map((x) => TaskModel.fromJson(x))),
        tasksNumber: json["tasksNumber"] ?? null,
        onHoldTasksCount: json["onHoldTasksCount"] ?? null,
        todoTasksCount: json["todoTasksCount"] ?? null,
        inProgressTasksCount: json["inProgressTasksCount"] ?? null,
        doneTasksCount: json["doneTasksCount"] ?? null,
        remainingTasksCount: json["remainingTasksCount"] ?? null,
        overDueTasksCount: json["overDueTasksCount"] ?? null,
        doneOnTimeTasksCount: json["doneOnTimeTasksCount"] ?? null,
        aheadOfScheduleTasksCount: json["aheadOfScheduleTasksCount"] ?? null,
        behindScheduleTasksCount: json["behindScheduleTasksCount"] ?? null,
        onScheduleTasksCount: json["onScheduleTasksCount"] ?? null,
        milestones: json["milestones"] == null
            ? null
            : List<MilestonesModel>.from(
                json["milestones"].map((x) => MilestonesModel.fromJson(x))),
        milestonesNumber: json["milestonesNumber"] ?? null,
        status: json["status"] ?? null,
        tasksStatusList: json["tasksStatusList"] == null
            ? null
            : List<String>.from(json["tasksStatusList"].map((x) => x)),
        typeOfProject: json["typeOfProject"] == null
            ? null
            : List<String>.from(json["typeOfProject"].map((x) => x)),
        sdgs: json["sdgs"] == null
            ? null
            : List<String>.from(json["sdgs"].map((x) => x)),
        theme: json["theme"] == null
            ? null
            : List<String>.from(json["theme"].map((x) => x)),
        estimatedCost: json["estimatedCost"] == null
            ? null
            : List<EstimatedCostModel>.from(json["estimatedCost"]
                .map((x) => EstimatedCostModel.fromJson(x))),
        totalEstimatedCost: json["totalEstimatedCost"] == null
            ? null
            : json["totalEstimatedCost"].toDouble(),
        budget: json["budget"] == null
            ? null
            : List<BudgetModel>.from(
                json["budget"].map((x) => BudgetModel.fromJson(x))),
        totalBudget:
            json["totalBudget"] == null ? null : json["totalBudget"].toDouble(),
        donor: json["donor"] == null
            ? null
            : List<DonorModel>.from(
                json["donor"].map((x) => DonorModel.fromJson(x))),
        totalDonatedAmount: json["totalDonatedAmount"] == null
            ? null
            : json["totalDonatedAmount"].toDouble(),
        executingAgency: json["executingAgency"] == null
            ? null
            : List<ExecutingAgencyModel>.from(json["executingAgency"]
                .map((x) => ExecutingAgencyModel.fromJson(x))),
        dateChange: json["dateChange"] ?? null,
        dateCreate: json["dateCreate"] ?? null,
        startDate: json["startDate"] ?? null,
        completionDate: json["completionDate"] ?? null,
        dueDate: json["dueDate"] ?? null,
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        progressPercentage: json["progressPercentage"] == null
            ? null
            : json["progressPercentage"].toDouble(),
        plannedProjectProgressPercentage:
            json["plannedProjectProgressPercentage"] == null
                ? null
                : json["plannedProjectProgressPercentage"].toDouble(),
        progressCategories: json["progressCategories"] ?? null,
        criticalityColour: json["criticalityColour"] ?? null,
        locations: json["locations"] == null
            ? null
            : List<LocationsModel>.from(
                json["locations"].map((x) => LocationsModel.fromJson(x))),
        locationsNumber: json["locationsNumber"] ?? null,
        members: json["members"] == null
            ? null
            : List<MembersModel>.from(
                json["members"].map((x) => MembersModel.fromJson(x))),
        totalProjectMembers: json["totalProjectMembers"] == null
            ? null
            : json["totalProjectMembers"].toDouble(),
        skillsRequired: json["skillsRequired"] == null
            ? null
            : List<SkillsRequiredPerMemberModel>.from(json["skillsRequired"]
                .map((x) => SkillsRequiredPerMemberModel.fromJson(x))),
        resources: json["resources"] == null
            ? null
            : List<ResourcesModel>.from(
                json["resources"].map((x) => ResourcesModel.fromJson(x))),
        totalResourceCost: json["totalResourceCost"] == null
            ? null
            : json["totalResourceCost"].toDouble(),
        // peopleAllowedToViewProject: json["peopleAllowedToViewProject"] == null
        //     ? null
        //     : List<PeopleAllowedToViewProjectModel>.from(json["peopleAllowedToViewProject"].map((x) => PeopleAllowedToViewProjectModel.fromJson(x))),
        contribution: json["contribution"] ?? null,
        dataReliability: json["dataReliability"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "projectNo": projectNo ?? null,
        "projectName": projectName ?? null,
        "projectDescription": projectDescription ?? null,
        "projectManager": projectLeader ?? null,
        "projectSeniorManager": projectManager ?? null,
        "projectCoordinator": projectAssistantOrCoordinator ?? null,
        "aims": aims ?? null,
        "objective": objective ?? null,
        "benefits": benefits ?? null,
        "deliverables": deliverables ?? null,
        "risks": initialRisks ?? null,
        "outcome": expectedOutcome ?? null,
        "measurableCriteriaForSuccess": measurableCriteriaForSuccess ?? null,
        "projectPhotoName": projectPhotoName ?? null,
        "projectPhotoFile": projectPhotoFile ?? null,
        "phases": phases == null
            ? null
            : List<dynamic>.from(phases!.map((x) => x.toJson())),
        "phasesNumber": phasesNumber ?? null,
        "tasks": tasks == null
            ? null
            : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "tasksNumber": tasksNumber ?? null,
        "onHoldTasksCount": onHoldTasksCount ?? null,
        "todoTasksCount": todoTasksCount ?? null,
        "inProgressTasksCount": inProgressTasksCount ?? null,
        "doneTasksCount": doneTasksCount ?? null,
        "overDueTasksCount": overDueTasksCount ?? null,
        "remainingTasksCount": remainingTasksCount ?? null,
        "doneOnTimeTasksCount": doneOnTimeTasksCount ?? null,
        "aheadOfScheduleTasksCount": aheadOfScheduleTasksCount ?? null,
        "behindScheduleTasksCount": behindScheduleTasksCount ?? null,
        "onScheduleTasksCount": onScheduleTasksCount ?? null,
        "milestones": milestones == null
            ? null
            : List<dynamic>.from(milestones!.map((x) => x.toJson())),
        "milestonesNumber": milestonesNumber ?? null,
        "status": status ?? null,
        "tasksStatusList": tasksStatusList == null
            ? null
            : List<dynamic>.from(tasksStatusList!.map((x) => x)),
        "typeOfProject": typeOfProject == null
            ? null
            : List<dynamic>.from(typeOfProject!.map((x) => x)),
        "sdgs": sdgs == null ? null : List<dynamic>.from(sdgs!.map((x) => x)),
        "theme":
            theme == null ? null : List<dynamic>.from(theme!.map((x) => x)),
        "estimatedCost": estimatedCost == null
            ? null
            : List<dynamic>.from(estimatedCost!.map((x) => x)),
        "totalEstimatedCost": totalEstimatedCost ?? null,
        "budget":
            budget == null ? null : List<dynamic>.from(budget!.map((x) => x)),
        "totalBudget": totalBudget ?? null,
        "donor": donor == null
            ? null
            : List<dynamic>.from(donor!.map((x) => x.toJson())),
        "totalDonatedAmount": totalDonatedAmount ?? null,
        "executingAgency": executingAgency == null
            ? null
            : List<dynamic>.from(executingAgency!.map((x) => x.toJson())),
        "dateChange": dateChange ?? null,
        "dateCreate": dateCreate ?? null,
        "startDate": startDate ?? null,
        "completionDate": completionDate ?? null,
        "dueDate": dueDate ?? null,
        "duration": duration ?? null,
        "progressPercentage": progressPercentage ?? null,
        "plannedProjectProgressPercentage":
            plannedProjectProgressPercentage ?? null,
        "progressCategories": progressCategories ?? null,
        "criticalityColour": criticalityColour ?? null,
        "locations": locations == null
            ? null
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "locationsNumber": locationsNumber ?? null,
        "skillsRequired": skillsRequired == null
            ? null
            : List<dynamic>.from(skillsRequired!.map((x) => x.toJson())),
        "resources": resources == null
            ? null
            : List<dynamic>.from(resources!.map((x) => x.toJson())),
        "totalProjectMembers": totalProjectMembers ?? null,
        "members": members == null
            ? null
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "totalResourceCost": totalResourceCost ?? null,
        // "peopleAllowedToViewProject": peopleAllowedToViewProject == null
        //     ? null
        //     : List<dynamic>.from(peopleAllowedToViewProject!.map((x) => x.toJson())),
        "contribution": contribution ?? null,
        "dataReliability": dataReliability ?? null,
      };
}
