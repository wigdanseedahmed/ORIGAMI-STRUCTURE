import 'package:origami_structure/imports.dart';

class FileModel {
  String? image;
  String? username;
  String? firstName;
  String? lastName;
  String? taskTitle;
  String? taskFileName;
  String? taskBase64File;
  String? taskFile;
  double? taskFileSize;
  bool? focus;
  String? time;
  String? selectedEmoji;


  FileModel({
    this.image,
    this.username,
    this.firstName,
    this.lastName,
    this.taskTitle,
    this.taskFileName,
    this.taskBase64File,
    this.taskFile,
    this.taskFileSize,
    this.focus,
    this.time,
    this.selectedEmoji,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    image: json["image"] ?? null,
    username:
    json["username"] ?? null,
    firstName:
    json["firstName"] ?? null,
    lastName:
    json["lastName"] ?? null,
    taskTitle:
    json["taskTitle"] ?? null,
    taskFileName: json["taskFileName"] ?? null,
    taskBase64File: json["taskBase64File"] ?? null,
    taskFile: json["taskFile"] ?? null,
    taskFileSize: json["taskFileSize"] == null ? null : json["taskFileSize"].toDouble(),
    focus: json["focus"] ?? null,
    time: json["time"] ?? null,
    selectedEmoji: json["selectedEmoji"] == null ? null : json["selectedEmoji"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "image": image ?? null,
    "username": username ?? null,
    "firstName": firstName ?? null,
    "lastName": lastName ?? null,
    "taskTitle": taskTitle ?? null,
    "taskFileName": taskFileName ?? null,
    "taskBase64File": taskBase64File ?? null,
    "taskFile": taskFile ?? null,
    "taskFileSize": taskFileSize ?? null,
    "focus": focus ?? null,
    "time": time ?? null,
    "selectedEmoji": selectedEmoji ?? null,
  };
}
