import 'package:origami_structure/imports.dart';

class CommentModel {
  CommentModel({
    this.image,
    this.username,
    this.firstName,
    this.lastName,
    this.taskTitle,
    this.textEditingController,
    this.content,
    this.focus,
    this.isOnline,
    this.time,
    this.selectedEmoji,
  });

  String? image;
  String? username;
  String? firstName;
  String? lastName;
  String? taskTitle;
  String? content;
  bool? focus;
  bool? isOnline;
  String? time;
  String? selectedEmoji;
  TextEditingController? textEditingController;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    image: json["image"] ?? null,
    username:
    json["username"] ?? null,
    firstName:
    json["firstName"] ?? null,
    lastName:
    json["lastName"] ?? null,
    taskTitle:
    json["taskTitle"] ?? null,
    textEditingController: json["textEditingController"] ?? null,
    content: json["content"] ?? null,
    focus: json["focus"] ?? null,
    isOnline: json["isOnline"] ?? null,
    time: json["time"] ?? null,
    selectedEmoji: json["selectedEmoji"] ?? null,
  );

  Map<String, dynamic> toJson() => {
    "image": image ?? null,
    "username": username ?? null,
    "firstName": firstName ?? null,
    "lastName": lastName ?? null,
    "taskTitle": taskTitle ?? null,
    "textEditingController": textEditingController ?? null,
    "content": content ?? null,
    "focus": focus ?? null,
    "isOnline": isOnline ?? null,
    "time": time ?? null,
    "selectedEmoji": selectedEmoji ?? null,
  };
}
