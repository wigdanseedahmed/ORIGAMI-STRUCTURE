import 'package:origami_structure/imports.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' as root_bundle;

class FileManager{
  // The start point .
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  late File jsonFile;
  String filePath = "/Users/izzy/StudioProjects/origami_structure/jsonFile/task_data.json";
  String dir = '/Users/izzy/StudioProjects/origami_structure';
  String fileName = 'jsonFile/task_data.json';
  bool fileExists = false;
  late List<TaskModel> jsonFileContent = <TaskModel>[];
  late List<TaskModel> _readJsonFileContent = <TaskModel>[];

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _file async {
    final path = await _directoryPath;
    return File('$path/' + fileName);
  }

  bool checkFileExists() {
    jsonFile = File(dir + "/" + fileName);
    if (jsonFile.existsSync() == true) {
      fileExists = true;
    }else{
      fileExists = false;
    }
    return fileExists;
  }

  void createFile(List<TaskModel>? content, String fileName) {
    if (kDebugMode) {
      print("Creating file!");
    }
    File file = File(filePath);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  Future<List<TaskModel>> readingTasksJsonData() async {
    final jsonData = await root_bundle.rootBundle.loadString(fileName);
    _readJsonFileContent = taskModelFromJson(jsonData);
    return _readJsonFileContent;
  }

  Future<List<TaskModel>> writeToJsonFile(List<TaskModel>? task, Function function) async {
    if (kDebugMode) {
      print("Writing to file!");
    }
    final jsonData = await root_bundle.rootBundle.loadString(fileName);
    _readJsonFileContent = taskModelFromJson(jsonData);
    jsonFile = File(dir + "/" + fileName);
    checkFileExists();
    if (kDebugMode) {
      print(fileExists);
    }
    if (fileExists == true) {
      if (kDebugMode) {
        print("File exists");
      }
      jsonFileContent.addAll(_readJsonFileContent);
      jsonFileContent.addAll(task!);
      jsonFile.writeAsStringSync(taskModelToJson(jsonFileContent));
    } else {
      if (kDebugMode) {
        print("File does not exist!");
      }
      createFile(_readJsonFileContent, fileName);
    }
    function;//setState(() => jsonFileContent = taskModelFromJson(jsonData));
    return jsonFileContent;
  }

}