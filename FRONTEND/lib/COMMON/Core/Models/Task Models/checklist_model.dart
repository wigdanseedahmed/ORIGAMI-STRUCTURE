import 'package:origami_structure/imports.dart';

class ChecklistModel {
  String? checklistTitle;
  String? assignedTo;
  String? createdBy;
  String? taskTitle;
  String? time;
  bool? isChecked;
  List<ChecklistItemModel>? checklistItems;

  ChecklistModel({
    this.checklistTitle,
    this.assignedTo,
    this.createdBy,
    this.taskTitle,
    this.time,
    this.isChecked,
    this.checklistItems,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) => ChecklistModel(
        checklistTitle:
            json["checklistTitle"] == null ? null : json["checklistTitle"],
        assignedTo: json["assignedTo"] == null ? null : json["assignedTo"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        taskTitle: json["taskTitle"] == null ? null : json["taskTitle"],
        time: json["time"] == null ? null : json["time"],
        isChecked: json["isChecked"] == null ? null : json["isChecked"],
        checklistItems: json["checklistItems"] == null
            ? null
            : List<ChecklistItemModel>.from(json["checklistItems"]
                .map((x) => ChecklistItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "checklistTitle": checklistTitle == null ? null : checklistTitle,
        "assignedTo": assignedTo == null ? null : assignedTo,
        "createdBy": createdBy == null ? null : createdBy,
        "taskTitle": taskTitle == null ? null : taskTitle,
        "time": time == null ? null : time,
        "isChecked": isChecked == null ? null : isChecked,
        "checklistItems": checklistItems == null
            ? null
            : List<dynamic>.from(checklistItems!.map((x) => x.toJson())),
      };
}

class ChecklistItemModel {
  String? checklistTitle;
  String? checklistItem;
  bool? isChecked;
  String? createdBy;
  String? taskTitle;
  String? time;

  ChecklistItemModel({
    this.checklistTitle,
    this.checklistItem,
    this.isChecked,
    this.createdBy,
    this.taskTitle,
    this.time,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      ChecklistItemModel(
        checklistTitle:
            json["checklistTitle"] == null ? null : json["checklistTitle"],
        checklistItem:
            json["checklistItem"] == null ? null : json["checklistItem"],
        isChecked: json["isChecked"] == null ? null : json["isChecked"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        taskTitle: json["taskTitle"] == null ? null : json["taskTitle"],
        time: json["time"] == null ? null : json["time"],
      );

  Map<String, dynamic> toJson() => {
        "checklistTitle": checklistTitle == null ? null : checklistTitle,
        "checklistItem": checklistItem == null ? null : checklistItem,
        "isChecked": isChecked == null ? null : isChecked,
        "createdBy": createdBy == null ? null : createdBy,
        "taskTitle": taskTitle == null ? null : taskTitle,
        "time": time == null ? null : time,
      };
}
