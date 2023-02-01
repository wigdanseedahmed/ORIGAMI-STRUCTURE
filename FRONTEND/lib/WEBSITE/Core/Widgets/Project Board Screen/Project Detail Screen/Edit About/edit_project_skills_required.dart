import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_tags/flutter_tags.dart';

class EditProjectSkillsRequiredWS extends StatefulWidget {
  const EditProjectSkillsRequiredWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditProjectSkillsRequiredWS> createState() =>
      _EditProjectSkillsRequiredWSState();
}

class _EditProjectSkillsRequiredWSState
    extends State<EditProjectSkillsRequiredWS> with TickerProviderStateMixin {
  /// Variables used to add more
  bool addNewItemPhase = false;
  var fullSkillsRequiredContainer = <Container>[];
  var fullSkillsRequired = <SkillsRequiredPerMemberModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readSkillsRequiredInformationJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.getProjectByProjectName}${widget.selectedProject!.projectName}");

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readJsonFileContent = projectModelFromJson(response.body)[0];
      // print("Project Info : ${readJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<ProjectModel> writeProjectData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

    // print(selectedProjectInformation);

    /// Create Request to get data and response to read data
    final response = await http.put(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      readJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR USERS

  List<String>? jobTitleList = [];

  List<String>? _allUserNameList = <String>[];
  List<String>? _allUserFullNameList = <String>[];

  List<UserModel> readUsersJsonFileContent = <UserModel>[];
  List<UserModel> filterUsersJsonFileContent = <UserModel>[];

  Future<List<UserModel>> readUsersInformationJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.users);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    _allUserNameList = <String>[];
    _allUserFullNameList = <String>[];

    if (response.statusCode == 200) {
      readUsersJsonFileContent = userModelListFromJson(response.body);
      // print("readUsersJsonFileContent: ${readUsersJsonFileContent}");

      filterUsersJsonFileContent = readUsersJsonFileContent;

      for (int i = 0; i < filterUsersJsonFileContent.length; i++) {
        if (filterUsersJsonFileContent[i].jobTitle != null) {
          if (jobTitleList!.contains(filterUsersJsonFileContent[i].jobTitle!)) {
            jobTitleList!;
          } else {
            jobTitleList!.add(filterUsersJsonFileContent[i].jobTitle!);
          }
        } else {
          jobTitleList!.add(filterUsersJsonFileContent[i].jobTitle!);
        }
      }

      for (int i = 0; i < readUsersJsonFileContent.length; i++) {
        _allUserNameList!.add(readUsersJsonFileContent[i].username!);
        _allUserFullNameList!.add(
            "${readUsersJsonFileContent[i].firstName!} ${readUsersJsonFileContent[i].lastName!}");
      }

      return filterUsersJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR HARD SKILLS

  List<bool> isAssignedToSelected = [false, false];

  List<String> jobFieldList = [];
  List<List<String>> jobSubFieldList = [];
  List<List<String>> jobSpecializationList = [];
  List<List<String>> typeOfSpecializationList = [];
  List<List<List<String>>> hardSkillCategoryList = [];
  List<List<List<String>>> hardSkillList = [];

  ///
  List<HardSkillsDataModel> readHardSkillsJsonFileContent =
      <HardSkillsDataModel>[];
  List<HardSkillsDataModel> filterHardSkillsJsonFileContent =
      <HardSkillsDataModel>[];

  Future<List<HardSkillsDataModel>> readHardSkillsInformationJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.getHardSkills);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readHardSkillsJsonFileContent = hardSkillsDataListFromJson(response.body);
      //print("readHardSkillsJsonFileContent: ${readHardSkillsJsonFileContent}");

      return readHardSkillsJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    /// VARIABLES FOR PROJECT
    _futureProjectInformation = readSkillsRequiredInformationJsonData();

    /// VARIABLES FOR HARD SKILLS
    filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent;

    jobFieldList = [];
    jobSubFieldList = [];
    jobSpecializationList = [];
    typeOfSpecializationList = [];
    hardSkillCategoryList = [];
    hardSkillList = [];

    readSkillsRequiredInformationJsonData()
        .then((projectInformationFromBackend) {
      return readHardSkillsInformationJsonData()
          .then((hardSkillsListFromBackend) {
        isAssignedToSelected = [];

        if (projectInformationFromBackend.skillsRequired == null) {
          jobFieldList = [];
          jobSubFieldList = [];
          jobSpecializationList = [];
          typeOfSpecializationList = [];
          hardSkillCategoryList = [];
          hardSkillList = [];
        } else {
          for (int p = 0;
              p < projectInformationFromBackend.skillsRequired!.length;
              p++) {
            isAssignedToSelected.add(false);

            jobSubFieldList.add([]);
            jobSpecializationList.add([]);
            typeOfSpecializationList.add([]);
            hardSkillCategoryList.add([]);
            hardSkillList.add([]);

            /// Initialize Job Field List

            for (int h = 0; h < hardSkillsListFromBackend.length; h++) {
              if (hardSkillsListFromBackend[h].jobField != null) {
                if (jobFieldList
                    .contains(hardSkillsListFromBackend[h].jobField!)) {
                  jobFieldList;
                } else {
                  jobFieldList.add(hardSkillsListFromBackend[h].jobField!);
                }
              } else {
                jobFieldList;
              }
            }

            /// Initialize Job Sub-Field List, Job Specialization List and Type Of Specialization List

            if (projectInformationFromBackend
                    .skillsRequired![p].jobSpecialization ==
                null) {
              if (projectInformationFromBackend
                      .skillsRequired![p].jobSubField ==
                  null) {
                if (projectInformationFromBackend.skillsRequired![p].jobField ==
                    null) {
                  for (int i = 0; i < hardSkillsListFromBackend.length; i++) {
                    /// Job Sub Field List
                    if (hardSkillsListFromBackend[i].jobSubField != null) {
                      if (jobSubFieldList[p].contains(
                          hardSkillsListFromBackend[i].jobSubField!)) {
                        jobSubFieldList[p];
                      } else {
                        jobSubFieldList[p]
                            .add(hardSkillsListFromBackend[i].jobSubField!);
                      }
                    } else {
                      jobSubFieldList[p];
                    }

                    /// Job Specialization List
                    if (hardSkillsListFromBackend[i].jobSpecialization !=
                        null) {
                      if (jobSpecializationList[p].contains(
                          hardSkillsListFromBackend[i].jobSpecialization!)) {
                        jobSpecializationList[p];
                      } else {
                        jobSpecializationList[p].add(
                            hardSkillsListFromBackend[i].jobSpecialization!);
                      }
                    } else {
                      jobSpecializationList[p];
                    }

                    /// Type of Specialization List
                    if (hardSkillsListFromBackend[i].typeOfSpecialization !=
                        null) {
                      if (typeOfSpecializationList[p].contains(
                          hardSkillsListFromBackend[i].typeOfSpecialization!)) {
                        typeOfSpecializationList[p];
                      } else {
                        typeOfSpecializationList[p].add(
                            hardSkillsListFromBackend[i].typeOfSpecialization!);
                      }
                    } else {
                      typeOfSpecializationList[p];
                    }
                  }
                } else {
                  var filterHardSkillsJsonFileContent =
                      hardSkillsListFromBackend
                          .where((element) =>
                              element.jobField ==
                              projectInformationFromBackend
                                  .skillsRequired![p].jobField)
                          .toList();

                  for (int i = 0;
                      i < filterHardSkillsJsonFileContent.length;
                      i++) {
                    /// Job Sub Field List
                    if (filterHardSkillsJsonFileContent[i].jobSubField !=
                        null) {
                      if (jobSubFieldList[p].contains(
                          filterHardSkillsJsonFileContent[i].jobSubField!)) {
                        jobSubFieldList[p];
                      } else {
                        jobSubFieldList[p].add(
                            filterHardSkillsJsonFileContent[i].jobSubField!);
                      }
                    } else {
                      jobSubFieldList[p];
                    }

                    /// Job Specialization List
                    if (filterHardSkillsJsonFileContent[i].jobSpecialization !=
                        null) {
                      if (jobSpecializationList[p].contains(
                          filterHardSkillsJsonFileContent[i]
                              .jobSpecialization!)) {
                        jobSpecializationList[p];
                      } else {
                        jobSpecializationList[p].add(
                            filterHardSkillsJsonFileContent[i]
                                .jobSpecialization!);
                      }
                    } else {
                      jobSpecializationList[p];
                    }

                    /// Type of Specialization List
                    if (filterHardSkillsJsonFileContent[i]
                            .typeOfSpecialization !=
                        null) {
                      if (typeOfSpecializationList[p].contains(
                          filterHardSkillsJsonFileContent[i]
                              .typeOfSpecialization!)) {
                        typeOfSpecializationList[p];
                      } else {
                        typeOfSpecializationList[p].add(
                            filterHardSkillsJsonFileContent[i]
                                .typeOfSpecialization!);
                      }
                    } else {
                      typeOfSpecializationList[p];
                    }
                  }
                }
              } else {
                var filterHardSkillsJsonFileContentForSubField =
                    hardSkillsListFromBackend
                        .where((element) =>
                            element.jobField ==
                            projectInformationFromBackend
                                .skillsRequired![p].jobField)
                        .toList();

                for (int i = 0;
                    i < filterHardSkillsJsonFileContentForSubField.length;
                    i++) {
                  /// Job Sub Field List
                  if (filterHardSkillsJsonFileContentForSubField[i]
                          .jobSubField !=
                      null) {
                    if (jobSubFieldList[p].contains(
                        filterHardSkillsJsonFileContentForSubField[i]
                            .jobSubField!)) {
                      jobSubFieldList[p];
                    } else {
                      jobSubFieldList[p].add(
                          filterHardSkillsJsonFileContentForSubField[i]
                              .jobSubField!);
                    }
                  } else {
                    jobSubFieldList[p];
                  }
                }

                var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
                    .where((element) =>
                        element.jobField ==
                            projectInformationFromBackend
                                .skillsRequired![p].jobField &&
                        element.jobSubField ==
                            projectInformationFromBackend
                                .skillsRequired![p].jobSubField)
                    .toList();

                for (int i = 0;
                    i < filterHardSkillsJsonFileContent.length;
                    i++) {
                  /// Job Specialization List
                  if (filterHardSkillsJsonFileContent[i].jobSpecialization !=
                      null) {
                    if (jobSpecializationList[p].contains(
                        filterHardSkillsJsonFileContent[i]
                            .jobSpecialization!)) {
                      jobSpecializationList[p];
                    } else {
                      jobSpecializationList[p].add(
                          filterHardSkillsJsonFileContent[i]
                              .jobSpecialization!);
                    }
                  } else {
                    jobSpecializationList[p];
                  }

                  /// Type of Specialization List
                  if (filterHardSkillsJsonFileContent[i].typeOfSpecialization !=
                      null) {
                    if (typeOfSpecializationList[p].contains(
                        filterHardSkillsJsonFileContent[i]
                            .typeOfSpecialization!)) {
                      typeOfSpecializationList[p];
                    } else {
                      typeOfSpecializationList[p].add(
                          filterHardSkillsJsonFileContent[i]
                              .typeOfSpecialization!);
                    }
                  } else {
                    typeOfSpecializationList[p];
                  }
                }
              }
            } else {
              var filterHardSkillsJsonFileContentForSubField =
                  hardSkillsListFromBackend
                      .where((element) =>
                          element.jobField ==
                          projectInformationFromBackend
                              .skillsRequired![p].jobField)
                      .toList();

              for (int i = 0;
                  i < filterHardSkillsJsonFileContentForSubField.length;
                  i++) {
                /// Job Sub Field List
                if (filterHardSkillsJsonFileContentForSubField[i].jobSubField !=
                    null) {
                  if (jobSubFieldList[p].contains(
                      filterHardSkillsJsonFileContentForSubField[i]
                          .jobSubField!)) {
                    jobSubFieldList[p];
                  } else {
                    jobSubFieldList[p].add(
                        filterHardSkillsJsonFileContentForSubField[i]
                            .jobSubField!);
                  }
                } else {
                  jobSubFieldList[p];
                }
              }

              var filterHardSkillsJsonFileContentForSpecialization =
                  hardSkillsListFromBackend
                      .where((element) =>
                          element.jobField ==
                              projectInformationFromBackend
                                  .skillsRequired![p].jobField &&
                          element.jobSubField ==
                              projectInformationFromBackend
                                  .skillsRequired![p].jobSubField)
                      .toList();

              for (int i = 0;
                  i < filterHardSkillsJsonFileContentForSpecialization.length;
                  i++) {
                /// Job Specialization List
                if (filterHardSkillsJsonFileContentForSpecialization[i]
                        .jobSpecialization !=
                    null) {
                  if (jobSpecializationList[p].contains(
                      filterHardSkillsJsonFileContentForSpecialization[i]
                          .jobSpecialization!)) {
                    jobSpecializationList[p];
                  } else {
                    jobSpecializationList[p].add(
                        filterHardSkillsJsonFileContentForSpecialization[i]
                            .jobSpecialization!);
                  }
                } else {
                  jobSpecializationList[p];
                }
              }

              var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
                  .where((element) =>
                      element.jobField ==
                          projectInformationFromBackend
                              .skillsRequired![p].jobField &&
                      element.jobSubField ==
                          projectInformationFromBackend
                              .skillsRequired![p].jobSubField &&
                      element.jobSpecialization ==
                          projectInformationFromBackend
                              .skillsRequired![p].jobSpecialization)
                  .toList();

              for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                /// Type of Specialization List
                if (filterHardSkillsJsonFileContent[i].typeOfSpecialization !=
                    null) {
                  if (typeOfSpecializationList[p].contains(
                      filterHardSkillsJsonFileContent[i]
                          .typeOfSpecialization!)) {
                    typeOfSpecializationList[p];
                  } else {
                    typeOfSpecializationList[p].add(
                        filterHardSkillsJsonFileContent[i]
                            .typeOfSpecialization!);
                  }
                } else {
                  typeOfSpecializationList[p];
                }
              }
            }

            /// Initialize Hard Skill Category List AND Hard Skills List

            if (projectInformationFromBackend.skillsRequired![p].hardSkills ==
                null) {
              hardSkillCategoryList[p] = [];
              hardSkillList[p] = [];
            } else {
              for (int ps = 0;
                  ps <
                      projectInformationFromBackend
                          .skillsRequired![p].hardSkills!.length;
                  ps++) {
                hardSkillCategoryList[p].add([]);
                hardSkillList[p].add([]);

                if (projectInformationFromBackend
                        .skillsRequired![p].hardSkills![ps].skillCategory ==
                    null) {
                  if (projectInformationFromBackend.skillsRequired![p]
                          .hardSkills![ps].typeOfSpecialization ==
                      null) {
                    if (projectInformationFromBackend
                            .skillsRequired![p].jobSpecialization ==
                        null) {
                      if (projectInformationFromBackend
                              .skillsRequired![p].jobSubField ==
                          null) {
                        if (projectInformationFromBackend
                                .skillsRequired![p].jobField ==
                            null) {
                          for (int h = 0;
                              h < hardSkillsListFromBackend.length;
                              h++) {
                            /// Hard Skill
                            if (hardSkillsListFromBackend[h].hardSkill !=
                                null) {
                              if (hardSkillList[p][ps].contains(
                                  hardSkillsListFromBackend[h].hardSkill!)) {
                                hardSkillList[p][ps];
                              } else {
                                hardSkillList[p][ps].add(
                                    hardSkillsListFromBackend[h].hardSkill!);
                              }
                            } else {
                              hardSkillList[p][ps];
                            }
                          }
                        } else {
                          var filterHardSkillsJsonFileContent =
                              hardSkillsListFromBackend
                                  .where((element) =>
                                      element.jobField ==
                                      projectInformationFromBackend
                                          .skillsRequired![p].jobField)
                                  .toList();

                          for (int i = 0;
                              i < filterHardSkillsJsonFileContent.length;
                              i++) {
                            /// Hard Skill Category
                            if (filterHardSkillsJsonFileContent[i]
                                    .hardSkillCategory !=
                                null) {
                              if (hardSkillCategoryList[p][ps].contains(
                                  filterHardSkillsJsonFileContent[i]
                                      .hardSkillCategory!)) {
                                hardSkillCategoryList[p][ps];
                              } else {
                                hardSkillCategoryList[p][ps].add(
                                    filterHardSkillsJsonFileContent[i]
                                        .hardSkillCategory!);
                              }
                            } else {
                              hardSkillCategoryList[p][ps];
                            }

                            /// Hard Skill
                            if (filterHardSkillsJsonFileContent[i].hardSkill !=
                                null) {
                              if (hardSkillList[p][ps].contains(
                                  filterHardSkillsJsonFileContent[i]
                                      .hardSkill!)) {
                                hardSkillList[p][ps];
                              } else {
                                hardSkillList[p][ps].add(
                                    filterHardSkillsJsonFileContent[i]
                                        .hardSkill!);
                              }
                            } else {
                              hardSkillList[p][ps];
                            }
                          }
                        }
                      } else {
                        var filterHardSkillsJsonFileContent =
                            hardSkillsListFromBackend
                                .where((element) =>
                                    element.jobField ==
                                        projectInformationFromBackend
                                            .skillsRequired![p].jobField &&
                                    element.jobSubField ==
                                        projectInformationFromBackend
                                            .skillsRequired![p].jobSubField)
                                .toList();

                        for (int i = 0;
                            i < filterHardSkillsJsonFileContent.length;
                            i++) {
                          /// Hard Skill Category
                          if (filterHardSkillsJsonFileContent[i]
                                  .hardSkillCategory !=
                              null) {
                            if (hardSkillCategoryList[p][ps].contains(
                                filterHardSkillsJsonFileContent[i]
                                    .hardSkillCategory!)) {
                              hardSkillCategoryList[p][ps];
                            } else {
                              hardSkillCategoryList[p][ps].add(
                                  filterHardSkillsJsonFileContent[i]
                                      .hardSkillCategory!);
                            }
                          } else {
                            hardSkillCategoryList[p][ps];
                          }

                          /// Hard Skill
                          if (filterHardSkillsJsonFileContent[i].hardSkill !=
                              null) {
                            if (hardSkillList[p][ps].contains(
                                filterHardSkillsJsonFileContent[i]
                                    .hardSkill!)) {
                              hardSkillList[p][ps];
                            } else {
                              hardSkillList[p][ps].add(
                                  filterHardSkillsJsonFileContent[i]
                                      .hardSkill!);
                            }
                          } else {
                            hardSkillList[p][ps];
                          }
                        }
                      }
                    } else {
                      var filterHardSkillsJsonFileContent =
                          hardSkillsListFromBackend
                              .where((element) =>
                                  element.jobField ==
                                      projectInformationFromBackend
                                          .skillsRequired![p].jobField &&
                                  element.jobSubField ==
                                      projectInformationFromBackend
                                          .skillsRequired![p].jobSubField &&
                                  element.jobSpecialization ==
                                      projectInformationFromBackend
                                          .skillsRequired![p].jobSpecialization)
                              .toList();

                      for (int i = 0;
                          i < filterHardSkillsJsonFileContent.length;
                          i++) {
                        /// Hard Skill Category
                        if (filterHardSkillsJsonFileContent[i]
                                .hardSkillCategory !=
                            null) {
                          if (hardSkillCategoryList[p][ps].contains(
                              filterHardSkillsJsonFileContent[i]
                                  .hardSkillCategory!)) {
                            hardSkillCategoryList[p][ps];
                          } else {
                            hardSkillCategoryList[p][ps].add(
                                filterHardSkillsJsonFileContent[i]
                                    .hardSkillCategory!);
                          }
                        } else {
                          hardSkillCategoryList[p][ps];
                        }

                        /// Hard Skill
                        if (filterHardSkillsJsonFileContent[i].hardSkill !=
                            null) {
                          if (hardSkillList[p][ps].contains(
                              filterHardSkillsJsonFileContent[i].hardSkill!)) {
                            hardSkillList[p][ps];
                          } else {
                            hardSkillList[p][ps].add(
                                filterHardSkillsJsonFileContent[i].hardSkill!);
                          }
                        } else {
                          hardSkillList[p][ps];
                        }
                      }
                    }
                  } else {
                    var filterHardSkillsJsonFileContent =
                        hardSkillsListFromBackend
                            .where((element) =>
                                element.jobField ==
                                    projectInformationFromBackend
                                        .skillsRequired![p].jobField &&
                                element.jobSubField ==
                                    projectInformationFromBackend
                                        .skillsRequired![p].jobSubField &&
                                element.jobSpecialization ==
                                    projectInformationFromBackend
                                        .skillsRequired![p].jobSpecialization &&
                                element.typeOfSpecialization ==
                                    projectInformationFromBackend
                                        .skillsRequired![p]
                                        .hardSkills![ps]
                                        .typeOfSpecialization)
                            .toList();

                    for (int i = 0;
                        i < filterHardSkillsJsonFileContent.length;
                        i++) {
                      /// Hard Skill Category
                      if (filterHardSkillsJsonFileContent[i]
                              .hardSkillCategory !=
                          null) {
                        if (hardSkillCategoryList[p][ps].contains(
                            filterHardSkillsJsonFileContent[i]
                                .hardSkillCategory!)) {
                          hardSkillCategoryList[p][ps];
                        } else {
                          hardSkillCategoryList[p][ps].add(
                              filterHardSkillsJsonFileContent[i]
                                  .hardSkillCategory!);
                        }
                      } else {
                        hardSkillCategoryList[p][ps];
                      }

                      /// Hard Skill
                      if (filterHardSkillsJsonFileContent[i].hardSkill !=
                          null) {
                        if (hardSkillList[p][ps].contains(
                            filterHardSkillsJsonFileContent[i].hardSkill!)) {
                          hardSkillList[p][ps];
                        } else {
                          hardSkillList[p][ps].add(
                              filterHardSkillsJsonFileContent[i].hardSkill!);
                        }
                      } else {
                        hardSkillList[p][ps];
                      }
                    }
                  }
                } else {
                  var filterHardSkillsListForHardSkillCategory =
                      hardSkillsListFromBackend
                          .where((element) =>
                              element.jobField ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobField &&
                              element.jobSubField ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobSubField &&
                              element.jobSpecialization ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobSpecialization &&
                              element.typeOfSpecialization ==
                                  projectInformationFromBackend
                                      .skillsRequired![p]
                                      .hardSkills![ps]
                                      .typeOfSpecialization)
                          .toList();

                  for (int i = 0;
                      i < filterHardSkillsListForHardSkillCategory.length;
                      i++) {
                    /// Hard Category Skill
                    if (filterHardSkillsListForHardSkillCategory[i]
                            .hardSkillCategory !=
                        null) {
                      if (hardSkillCategoryList[p][ps].contains(
                          filterHardSkillsListForHardSkillCategory[i]
                              .hardSkillCategory!)) {
                        hardSkillCategoryList[p][ps];
                      } else {
                        hardSkillCategoryList[p][ps].add(
                            filterHardSkillsListForHardSkillCategory[i]
                                .hardSkillCategory!);
                      }
                    } else {
                      hardSkillCategoryList[p][ps];
                    }
                  }

                  var filterHardSkillsListForHardSkill =
                      hardSkillsListFromBackend
                          .where((element) =>
                              element.jobField ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobField &&
                              element.jobSubField ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobSubField &&
                              element.jobSpecialization ==
                                  projectInformationFromBackend
                                      .skillsRequired![p].jobSpecialization &&
                              element.typeOfSpecialization ==
                                  projectInformationFromBackend
                                      .skillsRequired![p]
                                      .hardSkills![ps]
                                      .typeOfSpecialization &&
                              element.hardSkillCategory ==
                                  projectInformationFromBackend
                                      .skillsRequired![p]
                                      .hardSkills![ps]
                                      .skillCategory)
                          .toList();

                  for (int i = 0;
                      i < filterHardSkillsListForHardSkill.length;
                      i++) {
                    /// Hard SKill
                    if (filterHardSkillsListForHardSkill[i].hardSkill != null) {
                      if (hardSkillList[p][ps].contains(
                          filterHardSkillsListForHardSkill[i].hardSkill!)) {
                        hardSkillList[p][ps];
                      } else {
                        hardSkillList[p][ps].add(
                            filterHardSkillsListForHardSkill[i].hardSkill!);
                      }
                    } else {
                      hardSkillList[p][ps];
                    }
                  }
                }
              }
            }
          }
        }
      });
    });

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.skillsRequired == [] ||
            widget.selectedProject!.skillsRequired == null
        ? fullSkillsRequired = <SkillsRequiredPerMemberModel>[]
        : fullSkillsRequired = widget.selectedProject!.skillsRequired!;

    /// VARIABLES FOR INITIALIZATION
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              /// CALCULATE TOTAL NUMBER OF SKILLS ADDED TO USE FOR THE HEIGHT
              int totalSkills = 0;
              // print("fullSkillsRequired: ${fullSkillsRequired}");

              if (fullSkillsRequired.isEmpty) {
                totalSkills = 0;
              } else {
                for (var i = 0; i < fullSkillsRequired.length; i++) {
                  // print(fullChecklistList.length);
                  if (fullSkillsRequired[i].hardSkills == null) {
                    totalSkills = totalSkills + 0;
                  } else {
                    for (var j = 0;
                        j < fullSkillsRequired[i].hardSkills!.length;
                        j++) {
                      //print(fullChecklistList[i].checklistItems!.length);

                      totalSkills = totalSkills + 1;
                    }
                  }
                }
              }

              /// CALCULATE IS ASSIGNED TO ADDED TO USE FOR THE HEIGHT
              int totalIsAssignedToSelected =
                  isAssignedToSelected.where((item) => item == true).length;

              // print("readJsonFileContent.skillsRequired!: ${readJsonFileContent.skillsRequired!}");

              if (readJsonFileContent.skillsRequired == null ||
                  readJsonFileContent.skillsRequired!.isEmpty) {
                totalSkills = totalSkills + 0;
                rows;
              } else {
                for (var i = 0;
                    i < readJsonFileContent.skillsRequired!.length;
                    i++) {
                  if (readJsonFileContent.skillsRequired![i].hardSkills ==
                          null ||
                      readJsonFileContent
                          .skillsRequired![i].hardSkills!.isEmpty) {
                    totalSkills = totalSkills + 0;

                    rows.add(
                      PlutoRow(
                        cells: {
                          'id': PlutoCell(value: '${i + 1}'),
                          'skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].skillName),
                          'job field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobField),
                          'job sub field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSubField),
                          'job specialization': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSpecialization),
                          'job title': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobTitle),
                          'contract type': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].contractType),
                          'type of specialization': PlutoCell(value: ''),
                          'hard skill category': PlutoCell(value: ''),
                          'hard skill': PlutoCell(value: ''),
                          'level': PlutoCell(value: ''),
                          'start date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].startDate),
                          'end date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].endDate),
                          'duration': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].duration),
                          'assigned to': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].assignedTo),
                        },
                      ),
                    );
                  } else {
                    rows.add(
                      PlutoRow(
                        cells: {
                          'id': PlutoCell(value: '${i + 1}'),
                          'skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].skillName),
                          'job field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobField),
                          'job sub field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSubField),
                          'job specialization': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSpecialization),
                          'job title': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobTitle),
                          'contract type': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].contractType),
                          'type of specialization': PlutoCell(
                              value: readJsonFileContent.skillsRequired![i]
                                  .hardSkills![0].typeOfSpecialization),
                          'hard skill category': PlutoCell(
                              value: readJsonFileContent.skillsRequired![i]
                                  .hardSkills![0].skillCategory),
                          'hard skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].hardSkills![0].skill),
                          'level': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].hardSkills![0].level),
                          'start date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].startDate),
                          'end date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].endDate),
                          'duration': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].duration),
                          'assigned to': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].assignedTo),
                        },
                      ),
                    );
                    for (var j = 0;
                        j <
                            readJsonFileContent
                                    .skillsRequired![i].hardSkills!.length -
                                1;
                        j++) {
                      totalSkills = totalSkills + 1;

                      rows.add(
                        PlutoRow(
                          cells: {
                            'id': PlutoCell(value: ''),
                            'skill': PlutoCell(value: ''),
                            'job field': PlutoCell(value: ''),
                            'job sub field': PlutoCell(value: ''),
                            'job specialization': PlutoCell(value: ''),
                            'job title': PlutoCell(value: ''),
                            'contract type': PlutoCell(value: ''),
                            'type of specialization': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].typeOfSpecialization),
                            'hard skill category': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].skillCategory),
                            'hard skill': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].skill),
                            'level': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].level),
                            'start date': PlutoCell(value: ''),
                            'end date': PlutoCell(value: ''),
                            'duration': PlutoCell(value: ''),
                            'assigned to': PlutoCell(value: ''),
                          },
                        ),
                      );
                    }
                  }
                }
              }

              return buildBody(
                  context, screenSize, totalSkills, totalIsAssignedToSelected);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildBody(BuildContext context, Size screenSize, int totalSkills,
      int totalIsAssignedToSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SKILLS REQUIRED FOR TASKS",
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: 'Electrolize',
                fontSize: MediaQuery.of(context).size.width / 75,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (() {
                    setState(() {
                      if (bodyViewSelected == "Table") {
                        bodyViewSelected = "Grid";
                      } else if (bodyViewSelected == "Grid") {
                        bodyViewSelected = "Table";
                      }
                    });
                  }),
                  icon: Icon(
                    bodyViewSelected == "Table"
                        ? Icons.grid_view_rounded
                        : Icons.table_view_rounded,
                  ),
                ),
                bodyViewSelected == "Table"
                    ? tableOptionsPopup()
                    : gridOptionsPopup(),
              ],
            ),
          ],
        ),
        SizedBox(height: screenSize.height / 20),
        // buildMap(context, screenSize),

        bodyViewSelected == "Table"
            ? buildTable(context, screenSize, totalSkills)
            : buildGrid(context, totalSkills, totalIsAssignedToSelected),
      ],
    );
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Skill',
      field: 'skill',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Job Field',
      field: 'job field',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Job Sub Field',
      field: 'job sub field',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Job Specialization',
      field: 'job specialization',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Job Title',
      field: 'job title',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Contract Type',
      field: 'contract type',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Type of Specialization',
      field: 'type of specialization',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Hard Skill Category',
      field: 'hard skill category',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Hard Skill',
      field: 'hard skill',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Level',
      field: 'level',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Assigned To',
      field: 'assigned to',
      type: PlutoColumnType.text(),
      backgroundColor: kViolet,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
  ];

  final List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Skill', fields: ['skill'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Field', fields: ['job field'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Sub Field',
        fields: ['job sub field'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Specialization',
        fields: ['job specialization'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Title', fields: ['job title'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Contract Type',
        fields: ['contract type'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Type of Specialization',
        fields: ['type of specialization'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Hard Skill Category',
        fields: ['hard skill category'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Hard Skill', fields: ['hard skill'], expandedColumn: true),
    PlutoColumnGroup(title: 'Level', fields: ['level'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Assigned To', fields: ['assigned to'], expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late PlutoGridStateManager stateManager;

  late String bodyViewSelected = "Table";

  int addCount = 1;

  int addedCount = 0;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  void handleAddColumns() {
    final List<PlutoColumn> addedColumns = [];

    for (var i = 0; i < addCount; i += 1) {
      addedColumns.add(
        PlutoColumn(
          title: "column${++addedCount}",
          field: 'column${++addedCount}',
          type: PlutoColumnType.text(),
        ),
      );
    }

    stateManager.insertColumns(
      stateManager.bodyColumns.length,
      addedColumns,
    );
  }

  void handleAddRows() {
    setState(() {
      fullSkillsRequired.add(SkillsRequiredPerMemberModel()
        ..skillName = "Skill NAme ${fullSkillsRequired.length + 1}");

      final newRows = stateManager.getNewRows(count: addCount);

      stateManager.appendRows(newRows);

      stateManager.setCurrentCell(
        newRows.first.cells.entries.first.value,
        stateManager.refRows.length - 1,
      );

      stateManager.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager.refRows.length - 2,
      );

      stateManager.setKeepFocus(true);

      readJsonFileContent.skillsRequired = fullSkillsRequired;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullSkillsRequired.add(SkillsRequiredPerMemberModel()
        ..skillName = "Skill NAme ${fullSkillsRequired.length + 1}");

      readJsonFileContent.skillsRequired = fullSkillsRequired;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleSaveAll() {
    stateManager.setShowLoading(true);

    Future.delayed(const Duration(milliseconds: 500), () {
      for (var row in stateManager.refRows) {
        if (row.cells['id']!.value == '') {
          row.cells['id']!.value = 'guest';
        }

        if (row.cells['name']!.value == '') {
          row.cells['name']!.value = 'anonymous';
        }
      }

      stateManager.setShowLoading(false);
    });
  }

  void handleRemoveCurrentColumnButton() {
    final currentColumn = stateManager.currentColumn;

    if (currentColumn == null) {
      return;
    }

    stateManager.removeColumns([currentColumn]);
  }

  void handleRemoveCurrentRowButton() {
    setState(() {
      fullSkillsRequired.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.skillsRequired = fullSkillsRequired;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullSkillsRequired.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.skillsRequired = fullSkillsRequired;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleFiltering() {
    stateManager.setShowColumnFilter(!stateManager.showColumnFilter);
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      stateManager.setSelectingMode(mode);
    });
  }

  Widget tableOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
            /*const PopupMenuItem(
        value: 1,
        child: Text(
          "Add Columns",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),*/
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Add New Skill",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            /* const PopupMenuItem(
        value: 3,
        child: Text(
          "Save All",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            /*const PopupMenuItem(
        value: 4,
        child: Text(
          "Remove Current Column",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            const PopupMenuItem(
              value: 5,
              child: Text(
                "Remove Current Selected Skill",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const PopupMenuItem(
              value: 6,
              child: Text(
                "Remove Selected Skills",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            /* const PopupMenuItem(
        value: 7,
        child: Text(
          "Toggle Filtering",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            /* const PopupMenuItem(
        value: 8,
        child: Text(
          "Cells",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
          ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
                  ? bodyViewSelected == "Table"
                      ? handleAddRows()
                      : handleAddGrids()
                  : int == 3
                      ? handleSaveAll()
                      : int == 4
                          ? handleRemoveCurrentColumnButton()
                          : int == 5
                              ? handleRemoveCurrentRowButton()
                              : int == 6
                                  ? handleRemoveSelectedRowsButton()
                                  : int == 7
                                      ? handleFiltering()
                                      : Container();
        });
      });

  Widget gridOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Add New Skill",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
                  ? bodyViewSelected == "Table"
                      ? handleAddRows()
                      : handleAddGrids()
                  : int == 3
                      ? handleSaveAll()
                      : int == 4
                          ? handleRemoveCurrentColumnButton()
                          : int == 5
                              ? handleRemoveCurrentRowButton()
                              : int == 6
                                  ? handleRemoveSelectedRowsButton()
                                  : int == 7
                                      ? handleFiltering()
                                      : Container();
        });
      });

  ///----------------------------- BUILD TABLE VIEW -----------------------------///

  buildTable(BuildContext context, Size screenSize, int totalSkills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: readJsonFileContent.skillsRequired == null ||
                  readJsonFileContent.skillsRequired!.isEmpty
              ? (screenSize.height * 0.131)
              : (screenSize.height * 0.131) +
                  (rows.length * screenSize.height * 0.065),
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            columnGroups: columnGroups,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
            },
            onChanged: (PlutoGridOnChangedEvent event) {
              setState(() {
                if (event.columnIdx == 1) {
                  fullSkillsRequired[event.rowIdx!].skillName = event.value;
                } else if (event.columnIdx == 2) {
                  fullSkillsRequired[event.rowIdx!].jobField = event.value;
                } else if (event.columnIdx == 3) {
                  fullSkillsRequired[event.rowIdx!].jobSubField = event.value;
                } else if (event.columnIdx == 4) {
                  fullSkillsRequired[event.rowIdx!].jobSpecialization =
                      event.value;
                } else if (event.columnIdx == 5) {
                  fullSkillsRequired[event.rowIdx!].jobTitle = event.value;
                } else if (event.columnIdx == 6) {
                  fullSkillsRequired[event.rowIdx!].contractType = event.value;
                } else if (event.columnIdx == 7) {
                  fullSkillsRequired[event.rowIdx!]
                      .hardSkills![0]
                      .typeOfSpecialization = event.value;
                } else if (event.columnIdx == 8) {
                  fullSkillsRequired[event.rowIdx!]
                      .hardSkills![0]
                      .skillCategory = event.value;
                } else if (event.columnIdx == 9) {
                  fullSkillsRequired[event.rowIdx!].hardSkills![0].skill =
                      event.value;
                } else if (event.columnIdx == 10) {
                  fullSkillsRequired[event.rowIdx!].hardSkills![0].level =
                      event.value;
                } else if (event.columnIdx == 11) {
                  fullSkillsRequired[event.rowIdx!].startDate = event.value;
                } else if (event.columnIdx == 12) {
                  fullSkillsRequired[event.rowIdx!].endDate = event.value;
                } else if (event.columnIdx == 13) {
                  fullSkillsRequired[event.rowIdx!].duration = event.value;
                } else if (event.columnIdx == 14) {
                  fullSkillsRequired[event.rowIdx!].assignedTo = event.value;
                }

                readJsonFileContent.skillsRequired = fullSkillsRequired;

                _futureProjectInformation =
                    writeProjectData(readJsonFileContent);
              });
            },
            configuration: const PlutoGridConfiguration(
              columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.none,
              ),
              style: PlutoGridStyleConfig(
                gridBorderColor: Colors.transparent,
                gridBackgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                iconColor: kPlatinum,
                columnTextStyle: TextStyle(
                  color: kPlatinum,
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenSize.height / 10),
      ],
    );
  }

  ///----------------------------- BUILD GRID VIEW -----------------------------///

  buildGrid(
      BuildContext context, int totalSkills, int totalIsAssignedToSelected) {
    return Column(
      children: [
        fullSkillsRequired.isEmpty
            ? Container()
            : SizedBox(
                height: (fullSkillsRequired.length * 900) +
                    (totalSkills * 450) +
                    (totalIsAssignedToSelected * 150) +
                    ((fullSkillsRequired.length - 1) * 20),
                child: ListView.builder(
                    itemCount: fullSkillsRequired.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      fullSkillsRequired[index].skillName =
                          "SKILL REQUIRED ${index + 1}";

                      totalIsAssignedToSelected = isAssignedToSelected
                          .where((item) => item == true)
                          .length;

                      return Column(
                        children: [
                          Container(
                            color: Colors.black12,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SKILL REQUIRED ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColour,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              readJsonFileContent.members!
                                                  .where((element) =>
                                                      element.memberUsername ==
                                                      fullSkillsRequired[index]
                                                          .assignedTo)
                                                  .toList()[0]
                                                  .skillsAssigned!
                                                  .remove(
                                                      fullSkillsRequired[index]
                                                          .skillName!);

                                              fullSkillsRequired.remove(
                                                  fullSkillsRequired[index]);

                                              jobSubFieldList.remove(
                                                  jobSubFieldList[index]);
                                              jobSpecializationList.remove(
                                                  jobSpecializationList[index]);

                                              typeOfSpecializationList.remove(
                                                  typeOfSpecializationList[
                                                      index]);
                                              hardSkillCategoryList.remove(
                                                  hardSkillCategoryList[index]);
                                              hardSkillList
                                                  .remove(hardSkillList[index]);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  FutureBuilder(
                                    future: readHardSkillsInformationJsonData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "JOB FIELD",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter
                                                            dropDownState) {
                                                  return DropdownSearch<String>(
                                                    popupElevation: 0.0,
                                                    showClearButton: true,
                                                    //clearButtonProps: ,
                                                    dropdownSearchDecoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat',
                                                        letterSpacing: 3,
                                                      ),
                                                    ),
                                                    //mode of dropdown
                                                    mode: Mode.MENU,
                                                    //to show search box
                                                    showSearchBox: true,
                                                    //list of dropdown items
                                                    items: jobFieldList,
                                                    onChanged: (String?
                                                        newJobFieldValue) {
                                                      dropDownState(() {
                                                        setState(() {
                                                          fullSkillsRequired[
                                                                      index]
                                                                  .jobField =
                                                              newJobFieldValue!;

                                                          jobSubFieldList[
                                                              index] = [];
                                                          jobSpecializationList[
                                                              index] = [];
                                                          typeOfSpecializationList[
                                                              index] = [];
                                                          hardSkillCategoryList[
                                                              index] = [];
                                                          hardSkillList[index] =
                                                              [];

                                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                                          if (newJobFieldValue ==
                                                              null) {
                                                            for (int i = 0;
                                                                i <
                                                                    readHardSkillsJsonFileContent
                                                                        .length;
                                                                i++) {
                                                              /// Sub Field
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .jobSubField !=
                                                                  null) {
                                                                if (jobSubFieldList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .jobSubField!)) {
                                                                  jobSubFieldList[
                                                                      index];
                                                                } else {
                                                                  jobSubFieldList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .jobSubField!);
                                                                }
                                                              } else {
                                                                jobSubFieldList[
                                                                    index];
                                                              }

                                                              /// Specialization
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .jobSpecialization !=
                                                                  null) {
                                                                if (jobSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .jobSpecialization!)) {
                                                                  jobSpecializationList[
                                                                      index];
                                                                } else {
                                                                  jobSpecializationList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .jobSpecialization!);
                                                                }
                                                              } else {
                                                                jobSpecializationList[
                                                                    index];
                                                              }

                                                              /// Type of Specialization
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList[
                                                                    index];
                                                              }

                                                              /// Hard Skill Category AND Hard Skill
                                                              for (int j = 0;
                                                                  j <
                                                                      fullSkillsRequired[
                                                                              index]
                                                                          .hardSkills!
                                                                          .length;
                                                                  j++) {
                                                                /// Hard Skill Category
                                                                if (readHardSkillsJsonFileContent[
                                                                            i]
                                                                        .hardSkillCategory !=
                                                                    null) {
                                                                  if (hardSkillCategoryList[
                                                                              index]
                                                                          [j]
                                                                      .contains(
                                                                          readHardSkillsJsonFileContent[i]
                                                                              .hardSkillCategory!)) {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  } else {
                                                                    hardSkillCategoryList[index]
                                                                            [j]
                                                                        .add(readHardSkillsJsonFileContent[i]
                                                                            .hardSkillCategory!);
                                                                  }
                                                                } else {
                                                                  hardSkillCategoryList[
                                                                      index][j];
                                                                }

                                                                /// Hard Skill
                                                                if (readHardSkillsJsonFileContent[
                                                                            i]
                                                                        .hardSkill !=
                                                                    null) {
                                                                  if (hardSkillList[
                                                                              index]
                                                                          [j]
                                                                      .contains(
                                                                          readHardSkillsJsonFileContent[i]
                                                                              .hardSkill!)) {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  } else {
                                                                    hardSkillList[index]
                                                                            [j]
                                                                        .add(readHardSkillsJsonFileContent[i]
                                                                            .hardSkill!);
                                                                  }
                                                                } else {
                                                                  hardSkillList[
                                                                      index][j];
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            var filterHardSkillsList =
                                                                readHardSkillsJsonFileContent
                                                                    .where((element) =>
                                                                        element
                                                                            .jobField ==
                                                                        newJobFieldValue)
                                                                    .toList();

                                                            for (int i = 0;
                                                                i <
                                                                    filterHardSkillsList
                                                                        .length;
                                                                i++) {
                                                              /// Sub Field
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .jobSubField !=
                                                                  null) {
                                                                if (jobSubFieldList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .jobSubField!)) {
                                                                  jobSubFieldList[
                                                                      index];
                                                                } else {
                                                                  jobSubFieldList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .jobSubField!);
                                                                }
                                                              } else {
                                                                jobSubFieldList[
                                                                    index];
                                                              }

                                                              /// Specialization
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .jobSpecialization !=
                                                                  null) {
                                                                if (jobSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .jobSpecialization!)) {
                                                                  jobSpecializationList[
                                                                      index];
                                                                } else {
                                                                  jobSpecializationList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .jobSpecialization!);
                                                                }
                                                              } else {
                                                                jobSpecializationList[
                                                                    index];
                                                              }

                                                              /// Type of Specialization
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList[
                                                                    index];
                                                              }

                                                              if (fullSkillsRequired[
                                                                          index]
                                                                      .hardSkills ==
                                                                  null) {
                                                                hardSkillCategoryList[
                                                                    index] = [];
                                                                hardSkillList[
                                                                    index] = [];
                                                              } else {
                                                                /// Hard Skill Category AND Hard Skill
                                                                for (int j = 0;
                                                                    j <
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills!
                                                                            .length;
                                                                    j++) {
                                                                  /// Hard Skill Category
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillCategoryList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        });
                                                      });
                                                    },
                                                    //show selected item
                                                    selectedItem:
                                                        fullSkillsRequired[
                                                                        index]
                                                                    .jobField ==
                                                                null
                                                            ? "Job Field"
                                                            : fullSkillsRequired[
                                                                    index]
                                                                .jobField!,
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      70),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "JOB SUB-FIELD",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter
                                                            dropDownState) {
                                                  return DropdownSearch<String>(
                                                    popupElevation: 0.0,
                                                    showClearButton: true,
                                                    //clearButtonProps: ,
                                                    dropdownSearchDecoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat',
                                                        letterSpacing: 3,
                                                      ),
                                                    ),
                                                    //mode of dropdown
                                                    mode: Mode.MENU,
                                                    //to show search box
                                                    showSearchBox: true,
                                                    //list of dropdown items
                                                    items:
                                                        jobSubFieldList.isEmpty
                                                            ? []
                                                            : jobSubFieldList[
                                                                index],
                                                    onChanged: (String?
                                                        newJobSubFieldValue) {
                                                      dropDownState(() {
                                                        setState(() {
                                                          fullSkillsRequired[
                                                                      index]
                                                                  .jobSubField =
                                                              newJobSubFieldValue!;

                                                          jobSpecializationList[
                                                              index] = [];
                                                          typeOfSpecializationList[
                                                              index] = [];
                                                          hardSkillCategoryList[
                                                              index] = [];
                                                          hardSkillList[index] =
                                                              [];

                                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                                          if (newJobSubFieldValue ==
                                                              null) {
                                                            for (int i = 0;
                                                                i <
                                                                    readHardSkillsJsonFileContent
                                                                        .length;
                                                                i++) {
                                                              /// Specialization
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .jobSpecialization !=
                                                                  null) {
                                                                if (jobSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .jobSpecialization!)) {
                                                                  jobSpecializationList[
                                                                      index];
                                                                } else {
                                                                  jobSpecializationList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .jobSpecialization!);
                                                                }
                                                              } else {
                                                                jobSpecializationList[
                                                                    index];
                                                              }

                                                              /// Type of Specialization
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList;
                                                              }

                                                              if (fullSkillsRequired[
                                                                          index]
                                                                      .hardSkills ==
                                                                  null) {
                                                                hardSkillCategoryList[
                                                                    index] = [];
                                                                hardSkillList[
                                                                    index] = [];
                                                              } else {
                                                                /// Hard Skill Category AND Hard Skill
                                                                for (int j = 0;
                                                                    j <
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills!
                                                                            .length;
                                                                    j++) {
                                                                  /// Hard Skill Category
                                                                  if (readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[index]
                                                                            [j]
                                                                        .contains(
                                                                            readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillCategoryList[index]
                                                                              [
                                                                              j]
                                                                          .add(readHardSkillsJsonFileContent[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[index]
                                                                            [j]
                                                                        .contains(
                                                                            readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillList[index]
                                                                              [
                                                                              j]
                                                                          .add(readHardSkillsJsonFileContent[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            var filterHardSkillsList = readHardSkillsJsonFileContent
                                                                .where((element) =>
                                                                    element.jobSubField ==
                                                                        newJobSubFieldValue &&
                                                                    element.jobField ==
                                                                        fullSkillsRequired[index]
                                                                            .jobField)
                                                                .toList();

                                                            for (int i = 0;
                                                                i <
                                                                    filterHardSkillsList
                                                                        .length;
                                                                i++) {
                                                              /// Specialization
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .jobSpecialization !=
                                                                  null) {
                                                                if (jobSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .jobSpecialization!)) {
                                                                  jobSpecializationList[
                                                                      index];
                                                                } else {
                                                                  jobSpecializationList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .jobSpecialization!);
                                                                }
                                                              } else {
                                                                jobSpecializationList[
                                                                    index];
                                                              }

                                                              /// Type of Specialization
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList[
                                                                    index];
                                                              }

                                                              if (fullSkillsRequired[
                                                                          index]
                                                                      .hardSkills ==
                                                                  null) {
                                                                hardSkillCategoryList[
                                                                    index] = [];
                                                                hardSkillList[
                                                                    index] = [];
                                                              } else {
                                                                /// Hard Skill Category AND Hard Skill
                                                                for (int j = 0;
                                                                    j <
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills!
                                                                            .length;
                                                                    j++) {
                                                                  /// Hard Skill Category
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillCategoryList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        });
                                                      });
                                                    },
                                                    //show selected item
                                                    selectedItem:
                                                        fullSkillsRequired[
                                                                        index]
                                                                    .jobSubField ==
                                                                null
                                                            ? "Job Sub-Field"
                                                            : fullSkillsRequired[
                                                                    index]
                                                                .jobSubField!,
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      70),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "JOB SPECIALIZATION",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter
                                                            dropDownState) {
                                                  return DropdownSearch<String>(
                                                    popupElevation: 0.0,
                                                    showClearButton: true,
                                                    //clearButtonProps: ,
                                                    dropdownSearchDecoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat',
                                                        letterSpacing: 3,
                                                      ),
                                                    ),
                                                    //mode of dropdown
                                                    mode: Mode.MENU,
                                                    //to show search box
                                                    showSearchBox: true,
                                                    //list of dropdown items
                                                    items: jobSpecializationList
                                                            .isEmpty
                                                        ? []
                                                        : jobSpecializationList[
                                                            index],
                                                    onChanged: (String?
                                                        newJobSpecializationValue) {
                                                      dropDownState(() {
                                                        setState(() {
                                                          fullSkillsRequired[
                                                                      index]
                                                                  .jobSpecialization =
                                                              newJobSpecializationValue!;

                                                          typeOfSpecializationList[
                                                              index] = [];
                                                          hardSkillCategoryList[
                                                              index] = [];
                                                          hardSkillList[index] =
                                                              [];

                                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                                          if (newJobSpecializationValue ==
                                                              null) {
                                                            for (int i = 0;
                                                                i <
                                                                    readHardSkillsJsonFileContent
                                                                        .length;
                                                                i++) {
                                                              /// Type of Specialization
                                                              if (readHardSkillsJsonFileContent[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        readHardSkillsJsonFileContent[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList[
                                                                    index];
                                                              }

                                                              if (fullSkillsRequired[
                                                                          index]
                                                                      .hardSkills ==
                                                                  null) {
                                                                hardSkillCategoryList[
                                                                    index] = [];
                                                                hardSkillList[
                                                                    index] = [];
                                                              } else {
                                                                /// Hard Skill Category AND Hard Skill
                                                                for (int j = 0;
                                                                    j <
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills!
                                                                            .length;
                                                                    j++) {
                                                                  /// Hard Skill Category
                                                                  if (readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[index]
                                                                            [j]
                                                                        .contains(
                                                                            readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillCategoryList[index]
                                                                              [
                                                                              j]
                                                                          .add(readHardSkillsJsonFileContent[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (readHardSkillsJsonFileContent[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[index]
                                                                            [j]
                                                                        .contains(
                                                                            readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillList[index]
                                                                              [
                                                                              j]
                                                                          .add(readHardSkillsJsonFileContent[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            var filterHardSkillsList = readHardSkillsJsonFileContent
                                                                .where((element) =>
                                                                    element.jobSubField ==
                                                                        newJobSpecializationValue &&
                                                                    element.jobField ==
                                                                        fullSkillsRequired[index]
                                                                            .jobField)
                                                                .toList();

                                                            for (int i = 0;
                                                                i <
                                                                    filterHardSkillsList
                                                                        .length;
                                                                i++) {
                                                              /// Type of Specialization
                                                              if (filterHardSkillsList[
                                                                          i]
                                                                      .typeOfSpecialization !=
                                                                  null) {
                                                                if (typeOfSpecializationList[
                                                                        index]
                                                                    .contains(
                                                                        filterHardSkillsList[i]
                                                                            .typeOfSpecialization!)) {
                                                                  typeOfSpecializationList[
                                                                      index];
                                                                } else {
                                                                  typeOfSpecializationList[
                                                                          index]
                                                                      .add(filterHardSkillsList[
                                                                              i]
                                                                          .typeOfSpecialization!);
                                                                }
                                                              } else {
                                                                typeOfSpecializationList[
                                                                    index];
                                                              }

                                                              if (fullSkillsRequired[
                                                                          index]
                                                                      .hardSkills ==
                                                                  null) {
                                                                hardSkillCategoryList =
                                                                    [];
                                                                hardSkillList =
                                                                    [];
                                                              } else {
                                                                /// Hard Skill Category AND Hard Skill
                                                                for (int j = 0;
                                                                    j <
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills!
                                                                            .length;
                                                                    j++) {
                                                                  /// Hard Skill Category
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillCategoryList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index][j];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[index]
                                                                            [j]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index][j];
                                                                    } else {
                                                                      hardSkillList[index]
                                                                              [
                                                                              j]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index][j];
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        });
                                                      });
                                                    },
                                                    //show selected item
                                                    selectedItem: fullSkillsRequired[
                                                                    index]
                                                                .jobSpecialization ==
                                                            null
                                                        ? "Job Specialization"
                                                        : fullSkillsRequired[
                                                                index]
                                                            .jobSpecialization!,
                                                  );
                                                }),
                                              ),
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        }
                                      }

                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "JOB TITLE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: readUsersInformationJsonData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          return SizedBox(
                                            height: 60,
                                            child: StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter dropDownState) {
                                              return DropdownSearch<String>(
                                                popupElevation: 0.0,
                                                showClearButton: true,
                                                //clearButtonProps: ,
                                                dropdownSearchDecoration:
                                                    const InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontFamily: 'Montserrat',
                                                    letterSpacing: 3,
                                                  ),
                                                ),
                                                //mode of dropdown
                                                mode: Mode.MENU,
                                                //to show search box
                                                showSearchBox: true,
                                                //list of dropdown items
                                                items: jobTitleList,
                                                onChanged: (String? newValue) {
                                                  dropDownState(() {
                                                    fullSkillsRequired[index]
                                                        .jobTitle = newValue!;
                                                  });
                                                },
                                                //show selected item
                                                selectedItem:
                                                    fullSkillsRequired[index]
                                                                .jobTitle ==
                                                            null
                                                        ? "Job Title"
                                                        : fullSkillsRequired[
                                                                index]
                                                            .jobTitle!,
                                              );
                                            }),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        }
                                      }

                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SKILLS",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontFamily: 'Electrolize',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColour,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            fullSkillsRequired[index]
                                                        .hardSkills ==
                                                    null
                                                ? fullSkillsRequired[index]
                                                    .hardSkills = <SkillModel>[]
                                                : fullSkillsRequired[index]
                                                    .hardSkills!;

                                            hardSkillCategoryList[index]
                                                .add([]);
                                            hardSkillList[index].add([]);

                                            fullSkillContainer.add(
                                                addSkillsContainer(
                                                    fullSkillList:
                                                        fullSkillsRequired[
                                                                index]
                                                            .hardSkills));

                                            /// CHANGE: Hard Skill Category List AND Hard Skill List
                                            if (fullSkillsRequired[index]
                                                    .jobSpecialization ==
                                                null) {
                                              if (fullSkillsRequired[index]
                                                      .jobSubField ==
                                                  null) {
                                                if (fullSkillsRequired[index]
                                                        .jobField ==
                                                    null) {
                                                  for (int i = 0;
                                                      i <
                                                          readHardSkillsJsonFileContent
                                                              .length;
                                                      i++) {
                                                    /// Hard Skill Category
                                                    if (readHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory !=
                                                        null) {
                                                      if (hardSkillCategoryList[
                                                              index]
                                                          .last
                                                          .contains(
                                                              readHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkillCategory!)) {
                                                        hardSkillCategoryList[
                                                                index]
                                                            .last;
                                                      } else {
                                                        hardSkillCategoryList[
                                                                index]
                                                            .last
                                                            .add(readHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!);
                                                      }
                                                    } else {
                                                      hardSkillCategoryList[
                                                              index]
                                                          .last;
                                                    }

                                                    /// Hard Skill
                                                    if (readHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill !=
                                                        null) {
                                                      if (hardSkillList[index]
                                                          .last
                                                          .contains(
                                                              readHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!)) {
                                                        hardSkillList[index]
                                                            .last;
                                                      } else {
                                                        hardSkillList[index]
                                                            .last
                                                            .add(readHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                      }
                                                    } else {
                                                      hardSkillList[index].last;
                                                    }
                                                  }
                                                } else {
                                                  var filterHardSkillsJsonFileContent =
                                                      readHardSkillsJsonFileContent
                                                          .where((element) =>
                                                              element
                                                                  .jobField ==
                                                              fullSkillsRequired[
                                                                      index]
                                                                  .jobField)
                                                          .toList();

                                                  for (int i = 0;
                                                      i <
                                                          filterHardSkillsJsonFileContent
                                                              .length;
                                                      i++) {
                                                    /// Hard Skill Category
                                                    if (filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory !=
                                                        null) {
                                                      if (hardSkillCategoryList[
                                                              index]
                                                          .last
                                                          .contains(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkillCategory!)) {
                                                        hardSkillCategoryList[
                                                                index]
                                                            .last;
                                                      } else {
                                                        hardSkillCategoryList[
                                                                index]
                                                            .last
                                                            .add(filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!);
                                                      }
                                                    } else {
                                                      hardSkillCategoryList[
                                                              index]
                                                          .last;
                                                    }

                                                    /// Hard Skill
                                                    if (filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill !=
                                                        null) {
                                                      if (hardSkillList[index]
                                                          .last
                                                          .contains(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!)) {
                                                        hardSkillList[index]
                                                            .last;
                                                      } else {
                                                        hardSkillList[index]
                                                            .last
                                                            .add(filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                      }
                                                    } else {
                                                      hardSkillList[index].last;
                                                    }
                                                  }
                                                }
                                              } else {
                                                var filterHardSkillsJsonFileContent =
                                                    readHardSkillsJsonFileContent
                                                        .where((element) =>
                                                            element.jobField ==
                                                                fullSkillsRequired[
                                                                        index]
                                                                    .jobField &&
                                                            element.jobSubField ==
                                                                fullSkillsRequired[
                                                                        index]
                                                                    .jobSubField)
                                                        .toList();

                                                for (int i = 0;
                                                    i <
                                                        filterHardSkillsJsonFileContent
                                                            .length;
                                                    i++) {
                                                  /// Hard Skill Category
                                                  if (filterHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkillCategory !=
                                                      null) {
                                                    if (hardSkillCategoryList[
                                                            index]
                                                        .last
                                                        .contains(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!)) {
                                                      hardSkillCategoryList[
                                                              index]
                                                          .last;
                                                    } else {
                                                      hardSkillCategoryList[
                                                              index]
                                                          .last
                                                          .add(filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[index]
                                                        .last;
                                                  }

                                                  /// Hard Skill
                                                  if (filterHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkill !=
                                                      null) {
                                                    if (hardSkillList[index]
                                                        .last
                                                        .contains(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!)) {
                                                      hardSkillList[index].last;
                                                    } else {
                                                      hardSkillList[index].last.add(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[index].last;
                                                  }
                                                }
                                              }
                                            } else {
                                              var filterHardSkillsJsonFileContent =
                                                  readHardSkillsJsonFileContent
                                                      .where((element) =>
                                                          element.jobField ==
                                                              fullSkillsRequired[
                                                                      index]
                                                                  .jobField &&
                                                          element.jobSubField ==
                                                              fullSkillsRequired[
                                                                      index]
                                                                  .jobSubField &&
                                                          element.jobSpecialization ==
                                                              fullSkillsRequired[
                                                                      index]
                                                                  .jobSpecialization)
                                                      .toList();

                                              for (int i = 0;
                                                  i <
                                                      filterHardSkillsJsonFileContent
                                                          .length;
                                                  i++) {
                                                /// Hard Skill Category
                                                if (filterHardSkillsJsonFileContent[
                                                            i]
                                                        .hardSkillCategory !=
                                                    null) {
                                                  if (hardSkillCategoryList[
                                                          index]
                                                      .last
                                                      .contains(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkillCategory!)) {
                                                    hardSkillCategoryList[index]
                                                        .last;
                                                  } else {
                                                    hardSkillCategoryList[index]
                                                        .last
                                                        .add(filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory!);
                                                  }
                                                } else {
                                                  hardSkillCategoryList[index]
                                                      .last;
                                                }

                                                /// Hard Skill
                                                if (filterHardSkillsJsonFileContent[
                                                            i]
                                                        .hardSkill !=
                                                    null) {
                                                  if (hardSkillList[index]
                                                      .last
                                                      .contains(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill!)) {
                                                    hardSkillList[index].last;
                                                  } else {
                                                    hardSkillList[index].last.add(
                                                        filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill!);
                                                  }
                                                } else {
                                                  hardSkillList[index].last;
                                                }
                                              }
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                        color: primaryColour,
                                      )
                                    ],
                                  ),
                                  fullSkillsRequired[index].hardSkills == null
                                      ? Container()
                                      : SizedBox(
                                          height: fullSkillsRequired[index]
                                                  .hardSkills!
                                                  .length *
                                              450,
                                          child: ListView.builder(
                                            itemCount: fullSkillsRequired[index]
                                                .hardSkills!
                                                .length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (context, skillsRequiredIndex) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    color: Colors.black12,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          FutureBuilder(
                                                            future:
                                                                readHardSkillsInformationJsonData(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "SKILLS ${skillsRequiredIndex + 1}",
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(letterSpacing: 2, fontFamily: 'Electrolize', fontSize: 15, fontWeight: FontWeight.bold, color: primaryColour),
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(Icons.clear),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                fullSkillsRequired[index].hardSkills!.remove(fullSkillsRequired[index].hardSkills![skillsRequiredIndex]);
                                                                              });
                                                                            },
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "TYPE OF SPECIALIZATION",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            //letterSpacing: 8,
                                                                            fontFamily:
                                                                                'Electrolize',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child: StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                dropDownState) {
                                                                          return DropdownSearch<
                                                                              String>(
                                                                            popupElevation:
                                                                                0.0,
                                                                            showClearButton:
                                                                                true,
                                                                            //clearButtonProps: ,
                                                                            dropdownSearchDecoration:
                                                                                const InputDecoration(
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 16,
                                                                                fontFamily: 'Montserrat',
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            //mode of dropdown
                                                                            mode:
                                                                                Mode.MENU,
                                                                            //to show search box
                                                                            showSearchBox:
                                                                                true,
                                                                            //list of dropdown items
                                                                            items:
                                                                                typeOfSpecializationList[index],
                                                                            onChanged:
                                                                                (String? newTypeOfSpecializationValue) {
                                                                              dropDownState(() {
                                                                                setState(() {
                                                                                  fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization = newTypeOfSpecializationValue!;

                                                                                  hardSkillCategoryList[index][skillsRequiredIndex] = [];
                                                                                  hardSkillList[index][skillsRequiredIndex] = [];

                                                                                  /// CHANGE: jobSubFieldList based on Job Field Value
                                                                                  if (newTypeOfSpecializationValue == null) {
                                                                                    if (fullSkillsRequired[index].jobSpecialization == null) {
                                                                                      if (fullSkillsRequired[index].jobSubField == null) {
                                                                                        if (fullSkillsRequired[index].jobField == null) {
                                                                                          for (int i = 0; i < readHardSkillsJsonFileContent.length; i++) {
                                                                                            /// Hard Skill Category
                                                                                            if (readHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                                                              if (hardSkillCategoryList[index][skillsRequiredIndex].contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                                                hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                              } else {
                                                                                                hardSkillCategoryList[index][skillsRequiredIndex].add(readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                                              }
                                                                                            } else {
                                                                                              hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                            }

                                                                                            /// Hard Skill
                                                                                            if (readHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                              if (hardSkillList[index][skillsRequiredIndex].contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                                hardSkillList[index][skillsRequiredIndex];
                                                                                              } else {
                                                                                                hardSkillList[index][skillsRequiredIndex].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                                                              }
                                                                                            } else {
                                                                                              hardSkillList[index][skillsRequiredIndex];
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField).toList();

                                                                                          for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                            /// Hard Skill Category
                                                                                            if (filterHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                                                              if (hardSkillCategoryList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                                                hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                              } else {
                                                                                                hardSkillCategoryList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                                              }
                                                                                            } else {
                                                                                              hardSkillCategoryList[index];
                                                                                            }

                                                                                            /// Hard Skill
                                                                                            if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                              if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                                hardSkillList[index][skillsRequiredIndex];
                                                                                              } else {
                                                                                                hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                              }
                                                                                            } else {
                                                                                              hardSkillList[index][skillsRequiredIndex];
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else {
                                                                                        var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField && element.jobSubField == fullSkillsRequired[index].jobSubField).toList();

                                                                                        for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                          /// Hard Skill Category
                                                                                          if (filterHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                                                            if (hardSkillCategoryList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                                              hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                            } else {
                                                                                              hardSkillCategoryList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                                            }
                                                                                          } else {
                                                                                            hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                          }

                                                                                          /// Hard Skill
                                                                                          if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                            if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                              hardSkillList[index][skillsRequiredIndex];
                                                                                            } else {
                                                                                              hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                            }
                                                                                          } else {
                                                                                            hardSkillList[index][skillsRequiredIndex];
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    } else {
                                                                                      var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField && element.jobSubField == fullSkillsRequired[index].jobSubField && element.jobSpecialization == fullSkillsRequired[index].jobSpecialization).toList();

                                                                                      for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                        /// Hard Skill Category
                                                                                        if (filterHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                                                          if (hardSkillCategoryList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                                            hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                          } else {
                                                                                            hardSkillCategoryList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                                          }
                                                                                        } else {
                                                                                          hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                        }

                                                                                        /// Hard Skill
                                                                                        if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                          if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                            hardSkillList[index][skillsRequiredIndex];
                                                                                          } else {
                                                                                            hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                          }
                                                                                        } else {
                                                                                          hardSkillList[index][skillsRequiredIndex];
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    var filterHardSkillsList = readHardSkillsJsonFileContent.where((element) => element.typeOfSpecialization == newTypeOfSpecializationValue && element.jobSpecialization == fullSkillsRequired[index].jobSpecialization && element.jobSubField == fullSkillsRequired[index].jobSubField && element.jobField == fullSkillsRequired[index].jobField).toList();

                                                                                    for (int i = 0; i < filterHardSkillsList.length; i++) {
                                                                                      /// Hard Skill Category
                                                                                      if (filterHardSkillsList[i].hardSkillCategory != null) {
                                                                                        if (hardSkillCategoryList[index][skillsRequiredIndex].contains(filterHardSkillsList[i].hardSkillCategory!)) {
                                                                                          hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                        } else {
                                                                                          hardSkillCategoryList[index][skillsRequiredIndex].add(filterHardSkillsList[i].hardSkillCategory!);
                                                                                        }
                                                                                      } else {
                                                                                        hardSkillCategoryList[index][skillsRequiredIndex];
                                                                                      }

                                                                                      /// Hard Skill
                                                                                      if (filterHardSkillsList[i].hardSkill != null) {
                                                                                        if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsList[i].hardSkill!)) {
                                                                                          hardSkillList[index][skillsRequiredIndex];
                                                                                        } else {
                                                                                          hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsList[i].hardSkill!);
                                                                                        }
                                                                                      } else {
                                                                                        hardSkillList[index][skillsRequiredIndex];
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                });
                                                                              });
                                                                            },
                                                                            //show selected item
                                                                            selectedItem: fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization == null
                                                                                ? "Type Of Specialization"
                                                                                : fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization!,
                                                                          );
                                                                        }),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height / 70),
                                                                      const Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "HARD SKILL CATEGORY",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            //letterSpacing: 8,
                                                                            fontFamily:
                                                                                'Electrolize',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child: StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                dropDownState) {
                                                                          return DropdownSearch<
                                                                              String>(
                                                                            popupElevation:
                                                                                0.0,
                                                                            showClearButton:
                                                                                true,
                                                                            //clearButtonProps: ,
                                                                            dropdownSearchDecoration:
                                                                                const InputDecoration(
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 16,
                                                                                fontFamily: 'Montserrat',
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            //mode of dropdown
                                                                            mode:
                                                                                Mode.MENU,
                                                                            //to show search box
                                                                            showSearchBox:
                                                                                true,
                                                                            //list of dropdown items
                                                                            items: hardSkillCategoryList[index].isEmpty
                                                                                ? []
                                                                                : hardSkillCategoryList[index][skillsRequiredIndex],
                                                                            onChanged:
                                                                                (String? newHardSkillCategoryValue) {
                                                                              dropDownState(() {
                                                                                setState(() {
                                                                                  fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skillCategory = newHardSkillCategoryValue!;

                                                                                  hardSkillList[index][skillsRequiredIndex] = [];

                                                                                  /// CHANGE: Hard Skill Category
                                                                                  if (newHardSkillCategoryValue == null) {
                                                                                    if (fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization == null) {
                                                                                      if (fullSkillsRequired[index].jobSpecialization == null) {
                                                                                        if (fullSkillsRequired[index].jobSubField == null) {
                                                                                          if (fullSkillsRequired[index].jobField == null) {
                                                                                            for (int i = 0; i < readHardSkillsJsonFileContent.length; i++) {
                                                                                              /// Hard Skill
                                                                                              if (readHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                                if (hardSkillList[index][skillsRequiredIndex].contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                                  hardSkillList[index][skillsRequiredIndex];
                                                                                                } else {
                                                                                                  hardSkillList[index][skillsRequiredIndex].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                                                                }
                                                                                              } else {
                                                                                                hardSkillList[index][skillsRequiredIndex];
                                                                                              }
                                                                                            }
                                                                                          } else {
                                                                                            var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField).toList();

                                                                                            for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                              /// Hard Skill
                                                                                              if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                                if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                                  hardSkillList[index][skillsRequiredIndex];
                                                                                                } else {
                                                                                                  hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                                }
                                                                                              } else {
                                                                                                hardSkillList[index][skillsRequiredIndex];
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField && element.jobSubField == fullSkillsRequired[index].jobSubField).toList();

                                                                                          for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                            /// Hard Skill
                                                                                            if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                              if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                                hardSkillList[index][skillsRequiredIndex];
                                                                                              } else {
                                                                                                hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                              }
                                                                                            } else {
                                                                                              hardSkillList[index][skillsRequiredIndex];
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else {
                                                                                        var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField && element.jobSubField == fullSkillsRequired[index].jobSubField && element.jobSpecialization == fullSkillsRequired[index].jobSpecialization).toList();

                                                                                        for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                          /// Hard Skill
                                                                                          if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                            if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                              hardSkillList[index][skillsRequiredIndex];
                                                                                            } else {
                                                                                              hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                            }
                                                                                          } else {
                                                                                            hardSkillList[index][skillsRequiredIndex];
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    } else {
                                                                                      var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent.where((element) => element.jobField == fullSkillsRequired[index].jobField && element.jobSubField == fullSkillsRequired[index].jobSubField && element.jobSpecialization == fullSkillsRequired[index].jobSpecialization && element.typeOfSpecialization == fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization).toList();

                                                                                      for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                                                                        /// Hard Skill
                                                                                        if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                                                                          if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                                            hardSkillList[index][skillsRequiredIndex];
                                                                                          } else {
                                                                                            hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                                          }
                                                                                        } else {
                                                                                          hardSkillList[index][skillsRequiredIndex];
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    hardSkillList[index][skillsRequiredIndex] = [];

                                                                                    var filterHardSkillsList = readHardSkillsJsonFileContent.where((element) => element.hardSkillCategory == newHardSkillCategoryValue && element.typeOfSpecialization == fullSkillsRequired[index].hardSkills![skillsRequiredIndex].typeOfSpecialization && element.jobSpecialization == fullSkillsRequired[index].jobSpecialization && element.jobSubField == fullSkillsRequired[index].jobSubField && element.jobField == fullSkillsRequired[index].jobField).toList();

                                                                                    for (int i = 0; i < filterHardSkillsList.length; i++) {
                                                                                      /// Hard SKill
                                                                                      if (filterHardSkillsList[i].hardSkill != null) {
                                                                                        if (hardSkillList[index][skillsRequiredIndex].contains(filterHardSkillsList[i].hardSkill!)) {
                                                                                          hardSkillList[index][skillsRequiredIndex];
                                                                                        } else {
                                                                                          hardSkillList[index][skillsRequiredIndex].add(filterHardSkillsList[i].hardSkill!);
                                                                                        }
                                                                                      } else {
                                                                                        hardSkillList[index][skillsRequiredIndex];
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                });
                                                                              });
                                                                            },
                                                                            //show selected item
                                                                            selectedItem: fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skillCategory == null
                                                                                ? "Hard Skill Category"
                                                                                : fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skillCategory!,
                                                                          );
                                                                        }),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height / 70),
                                                                      const Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "HARD SKILL",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            //letterSpacing: 8,
                                                                            fontFamily:
                                                                                'Electrolize',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child: StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                dropDownState) {
                                                                          return DropdownSearch<
                                                                              String>(
                                                                            popupElevation:
                                                                                0.0,
                                                                            showClearButton:
                                                                                true,
                                                                            //clearButtonProps: ,
                                                                            dropdownSearchDecoration:
                                                                                const InputDecoration(
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 16,
                                                                                fontFamily: 'Montserrat',
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            //mode of dropdown
                                                                            mode:
                                                                                Mode.MENU,
                                                                            //to show search box
                                                                            showSearchBox:
                                                                                true,
                                                                            //list of dropdown items
                                                                            items: hardSkillList[index][skillsRequiredIndex].isEmpty
                                                                                ? []
                                                                                : hardSkillList[index][skillsRequiredIndex],
                                                                            onChanged:
                                                                                (String? newHarSkillValue) {
                                                                              dropDownState(() {
                                                                                setState(() {
                                                                                  fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skill = newHarSkillValue!;
                                                                                });
                                                                              });
                                                                            },
                                                                            //show selected item
                                                                            selectedItem: fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skill == null
                                                                                ? "Hard Skill"
                                                                                : fullSkillsRequired[index].hardSkills![skillsRequiredIndex].skill!,
                                                                          );
                                                                        }),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  return Text(
                                                                      '${snapshot.error}');
                                                                }
                                                              }

                                                              return const CircularProgressIndicator();
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.25,
                                                                child:
                                                                    const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "LEVEL",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        TextStyle(
                                                                      //letterSpacing: 8,
                                                                      fontFamily:
                                                                          'Electrolize',
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 200,
                                                                height: 60,
                                                                child: StatefulBuilder(builder:
                                                                    (BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            dropDownState) {
                                                                  return DropdownSearch<
                                                                      String>(
                                                                    popupElevation:
                                                                        0.0,
                                                                    showClearButton:
                                                                        true,
                                                                    //clearButtonProps: ,
                                                                    dropdownSearchDecoration:
                                                                        const InputDecoration(
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        letterSpacing:
                                                                            3,
                                                                      ),
                                                                    ),
                                                                    //mode of dropdown
                                                                    mode: Mode
                                                                        .MENU,
                                                                    //to show search box
                                                                    showSearchBox:
                                                                        true,
                                                                    //list of dropdown items
                                                                    items:
                                                                        skillLevelList,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      dropDownState(
                                                                          () {
                                                                        fullSkillsRequired[index]
                                                                            .hardSkills![skillsRequiredIndex]
                                                                            .level = newValue!;
                                                                      });
                                                                    },
                                                                    //show selected item
                                                                    selectedItem: fullSkillsRequired[index].hardSkills![skillsRequiredIndex].level ==
                                                                            null
                                                                        ? ""
                                                                        : fullSkillsRequired[index]
                                                                            .hardSkills![skillsRequiredIndex]
                                                                            .level!,
                                                                  );
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "CONTRACT TYPE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 60,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            //clearButtonProps: ,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Montserrat',
                                                letterSpacing: 3,
                                              ),
                                            ),
                                            //mode of dropdown
                                            mode: Mode.MENU,
                                            //to show search box
                                            showSearchBox: true,
                                            //list of dropdown items
                                            items: contractTypeList,
                                            onChanged: (String? newValue) {
                                              dropDownState(() {
                                                fullSkillsRequired[index]
                                                    .contractType = newValue!;
                                              });
                                            },
                                            //show selected item
                                            selectedItem:
                                                fullSkillsRequired[index]
                                                            .contractType ==
                                                        null
                                                    ? ""
                                                    : fullSkillsRequired[index]
                                                        .contractType!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                25,
                                        child: const Text(
                                          "DURATION\n(in Weeks)",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            //letterSpacing: 8,
                                            fontFamily: 'Electrolize',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 60,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue:
                                              fullSkillsRequired[index]
                                                          .duration ==
                                                      null
                                                  ? ""
                                                  : fullSkillsRequired[index]
                                                      .duration!
                                                      .toString(),
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullSkillsRequired[index].duration =
                                                double.parse(newValue);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullSkillsRequired[index].duration =
                                                double.parse(newValue);
                                          },
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          decoration: const InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.3,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Icon(
                                              Icons.access_time_outlined,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "START DATE",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 95),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Icon(
                                              Icons.access_time_outlined,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "END DATE",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullSkillsRequired[
                                                          index]
                                                      .startDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat("yyyy-MM-dd").parse(
                                                  fullSkillsRequired[index]
                                                      .startDate!),
                                          onDateChange: (DateTime? newDate) {
                                            //print(newDate);
                                            setState(() {
                                              fullSkillsRequired[index]
                                                      .startDate =
                                                  newDate!.toIso8601String();
                                            });
                                          },
                                          hintText: fullSkillsRequired[index]
                                                      .startDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullSkillsRequired[index]
                                                  .startDate!,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullSkillsRequired[
                                                          index]
                                                      .endDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat('yyyy-MM-dd').parse(
                                                  fullSkillsRequired[index]
                                                      .endDate!),
                                          onDateChange: (DateTime? newDate) {
                                            // print(newDate);
                                            setState(() {
                                              fullSkillsRequired[index]
                                                      .endDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(newDate!);
                                            });
                                          },
                                          hintText: fullSkillsRequired[index]
                                                      .endDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullSkillsRequired[index]
                                                  .endDate!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  isAssignedToSelected[index] == true ||
                                          fullSkillsRequired[index]
                                                  .assignedTo !=
                                              null
                                      ? FutureBuilder(
                                          future:
                                              readUsersInformationJsonData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              EvaIcons
                                                                  .personOutline,
                                                            ),
                                                            SizedBox(
                                                                width: 20.0),
                                                            Text(
                                                              "ASSIGNED TO",
                                                              style: TextStyle(
                                                                //letterSpacing: 8,
                                                                fontFamily:
                                                                    'Electrolize',
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.clear,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              readJsonFileContent
                                                                  .members!
                                                                  .where((element) =>
                                                                      element
                                                                          .memberUsername ==
                                                                      fullSkillsRequired[
                                                                              index]
                                                                          .assignedTo)
                                                                  .toList()[0]
                                                                  .skillsAssigned!
                                                                  .remove(fullSkillsRequired[
                                                                          index]
                                                                      .skillName!);

                                                              fullSkillsRequired[
                                                                          index]
                                                                      .assignedTo =
                                                                  null;

                                                              isAssignedToSelected[
                                                                      index] =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: StatefulBuilder(
                                                            builder: (BuildContext
                                                                    context,
                                                                StateSetter
                                                                    dropDownState) {
                                                          return DropdownSearch<
                                                              String>(
                                                            //show selected item
                                                            key: Key(fullSkillsRequired[
                                                                            index]
                                                                        .assignedTo ==
                                                                    null
                                                                ? ""
                                                                : _allUserFullNameList![_allUserNameList!.indexWhere((element) =>
                                                                    element ==
                                                                    fullSkillsRequired[
                                                                            index]
                                                                        .assignedTo)]),
                                                            //show selected item
                                                            selectedItem: fullSkillsRequired[
                                                                            index]
                                                                        .assignedTo ==
                                                                    null
                                                                ? ""
                                                                : _allUserFullNameList![_allUserNameList!.indexWhere((element) =>
                                                                    element ==
                                                                    fullSkillsRequired[
                                                                            index]
                                                                        .assignedTo)],
                                                            showClearButton:
                                                                true,
                                                            popupElevation: 0.0,
                                                            dropdownSearchDecoration:
                                                                InputDecoration(
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  subTitleTextStyleMA,
                                                            ),
                                                            //mode of dropdown
                                                            mode: Mode.MENU,
                                                            //to show search box
                                                            showSearchBox: true,
                                                            //list of dropdown items
                                                            items:
                                                                _allUserFullNameList,
                                                            onChanged: (String?
                                                                newValue) {
                                                              dropDownState(() {
                                                                setState(() {
                                                                  if (fullSkillsRequired[
                                                                              index]
                                                                          .assignedTo !=
                                                                      null) {
                                                                    readJsonFileContent
                                                                        .members!
                                                                        .where((element) =>
                                                                            element.memberUsername ==
                                                                            fullSkillsRequired[index]
                                                                                .assignedTo)
                                                                        .toList()[
                                                                            0]
                                                                        .skillsAssigned!
                                                                        .remove(
                                                                            fullSkillsRequired[index].skillName!);
                                                                  }

                                                                  newValue ==
                                                                          null
                                                                      ? fullSkillsRequired[index]
                                                                              .assignedTo =
                                                                          null
                                                                      : fullSkillsRequired[index]
                                                                              .assignedTo =
                                                                          _allUserNameList![_allUserFullNameList!.indexWhere((element) =>
                                                                              element ==
                                                                              newValue)];

                                                                  if (readJsonFileContent
                                                                      .members!
                                                                      .where((element) =>
                                                                          element
                                                                              .memberUsername ==
                                                                          fullSkillsRequired[index]
                                                                              .assignedTo)
                                                                      .isNotEmpty) {
                                                                    if (readJsonFileContent
                                                                            .members!
                                                                            .where((element) =>
                                                                                element.memberUsername ==
                                                                                fullSkillsRequired[index].assignedTo)
                                                                            .toList()[0]
                                                                            .skillsAssigned ==
                                                                        null) {
                                                                      readJsonFileContent
                                                                          .members!
                                                                          .where((element) =>
                                                                              element.memberUsername ==
                                                                              fullSkillsRequired[index]
                                                                                  .assignedTo)
                                                                          .toList()[
                                                                              0]
                                                                          .skillsAssigned = [
                                                                        fullSkillsRequired[index]
                                                                            .skillName!
                                                                      ];
                                                                    } else {
                                                                      if (readJsonFileContent
                                                                              .members!
                                                                              .where((element) => element.memberUsername == fullSkillsRequired[index].assignedTo)
                                                                              .toList()[0]
                                                                              .skillsAssigned
                                                                              ?.contains(fullSkillsRequired[index].skillName!) ==
                                                                          false) {
                                                                        readJsonFileContent
                                                                            .members!
                                                                            .where((element) =>
                                                                                element.memberUsername ==
                                                                                fullSkillsRequired[index].assignedTo)
                                                                            .toList()[0]
                                                                            .skillsAssigned!
                                                                            .add(fullSkillsRequired[index].skillName!);
                                                                      } else {
                                                                        readJsonFileContent
                                                                            .members!
                                                                            .where((element) =>
                                                                                element.memberUsername ==
                                                                                fullSkillsRequired[index].assignedTo)
                                                                            .toList()[0]
                                                                            .skillsAssigned!;
                                                                      }
                                                                    }
                                                                  } else {
                                                                    var newMember =
                                                                        MembersModel()
                                                                          ..memberUsername =
                                                                              fullSkillsRequired[index].assignedTo
                                                                          ..skillsAssigned =
                                                                              [
                                                                            fullSkillsRequired[index].skillName!
                                                                          ]
                                                                          ..memberName =
                                                                              newValue;

                                                                    readJsonFileContent
                                                                        .members!
                                                                        .add(
                                                                            newMember);
                                                                  }
                                                                });
                                                              });
                                                            },
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    '${snapshot.error}');
                                              }
                                            }

                                            return const CircularProgressIndicator();
                                          },
                                        )
                                      : Container(),
                                  isAssignedToSelected[index] == true ||
                                          fullSkillsRequired[index]
                                                  .assignedTo !=
                                              null
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              70)
                                      : Container(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isAssignedToSelected[index] = true;
                                          });
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 28,
                                          color: Colors.black12,
                                          child: const Center(
                                            child: Text(
                                              "Assign To",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                letterSpacing: 1,
                                                fontFamily: 'Electrolize',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 140,
                                        height: 28,
                                        color: Colors.black12,
                                        child: const Center(
                                          child: Text(
                                            "Recommend",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              letterSpacing: 1,
                                              fontFamily: 'Electrolize',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      );
                    }),
              ),
        fullSkillsRequired.isEmpty ? Container() : const SizedBox(height: 100),
      ],
    );
  }

  buildAllSkillsListView(
      {required List<SkillModel> fullSkillsList,
      required SkillsRequiredPerMemberModel skillsRequired,
      List<String>? typeOfSpecializationSubList,
      required List<List<String>> hardSkillCategorySubList,
      required List<List<String>> hardSkillSubList}) {
    return ListView.builder(
      itemCount: fullSkillsList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, skillsRequiredIndex) {
        return Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.001),
          child: Container(
            color: Colors.black12,
            height: 800,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.009),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: readHardSkillsInformationJsonData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "TYPE OF SPECIALIZATION",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        fullSkillsList.remove(fullSkillsList[
                                            skillsRequiredIndex]);
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter dropDownState) {
                                  return DropdownSearch<String>(
                                    popupElevation: 0.0,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: typeOfSpecializationSubList,
                                    onChanged:
                                        (String? newTypeOfSpecializationValue) {
                                      dropDownState(() {
                                        setState(() {
                                          fullSkillsList[skillsRequiredIndex]
                                                  .typeOfSpecialization =
                                              newTypeOfSpecializationValue!;

                                          hardSkillCategorySubList[
                                              skillsRequiredIndex] = [];
                                          hardSkillSubList[
                                              skillsRequiredIndex] = [];

                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                          if (newTypeOfSpecializationValue ==
                                              null) {
                                            if (skillsRequired
                                                    .jobSpecialization ==
                                                null) {
                                              if (skillsRequired.jobSubField ==
                                                  null) {
                                                if (skillsRequired.jobField ==
                                                    null) {
                                                  for (int i = 0;
                                                      i <
                                                          readHardSkillsJsonFileContent
                                                              .length;
                                                      i++) {
                                                    /// Hard Skill Category
                                                    if (readHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory !=
                                                        null) {
                                                      if (hardSkillCategorySubList[
                                                              skillsRequiredIndex]
                                                          .contains(
                                                              readHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkillCategory!)) {
                                                        hardSkillCategorySubList[
                                                            skillsRequiredIndex];
                                                      } else {
                                                        hardSkillCategorySubList[
                                                                skillsRequiredIndex]
                                                            .add(readHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!);
                                                      }
                                                    } else {
                                                      hardSkillCategorySubList[
                                                          skillsRequiredIndex];
                                                    }

                                                    /// Hard Skill
                                                    if (readHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill !=
                                                        null) {
                                                      if (hardSkillSubList[
                                                              skillsRequiredIndex]
                                                          .contains(
                                                              readHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!)) {
                                                        hardSkillSubList[
                                                            skillsRequiredIndex];
                                                      } else {
                                                        hardSkillSubList[
                                                                skillsRequiredIndex]
                                                            .add(readHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                      }
                                                    } else {
                                                      hardSkillSubList[
                                                          skillsRequiredIndex];
                                                    }
                                                  }
                                                } else {
                                                  var filterHardSkillsJsonFileContent =
                                                      readHardSkillsJsonFileContent
                                                          .where((element) =>
                                                              element
                                                                  .jobField ==
                                                              skillsRequired
                                                                  .jobField)
                                                          .toList();

                                                  for (int i = 0;
                                                      i <
                                                          filterHardSkillsJsonFileContent
                                                              .length;
                                                      i++) {
                                                    /// Hard Skill Category
                                                    if (filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory !=
                                                        null) {
                                                      if (hardSkillCategorySubList[
                                                              skillsRequiredIndex]
                                                          .contains(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkillCategory!)) {
                                                        hardSkillCategorySubList[
                                                            skillsRequiredIndex];
                                                      } else {
                                                        hardSkillCategorySubList[
                                                                skillsRequiredIndex]
                                                            .add(filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!);
                                                      }
                                                    } else {
                                                      hardSkillCategorySubList;
                                                    }

                                                    /// Hard Skill
                                                    if (filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill !=
                                                        null) {
                                                      if (hardSkillSubList[
                                                              skillsRequiredIndex]
                                                          .contains(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!)) {
                                                        hardSkillSubList[
                                                            skillsRequiredIndex];
                                                      } else {
                                                        hardSkillSubList[
                                                                skillsRequiredIndex]
                                                            .add(filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                      }
                                                    } else {
                                                      hardSkillSubList[
                                                          skillsRequiredIndex];
                                                    }
                                                  }
                                                }
                                              } else {
                                                var filterHardSkillsJsonFileContent =
                                                    readHardSkillsJsonFileContent
                                                        .where((element) =>
                                                            element.jobField ==
                                                                skillsRequired
                                                                    .jobField &&
                                                            element.jobSubField ==
                                                                skillsRequired
                                                                    .jobSubField)
                                                        .toList();

                                                for (int i = 0;
                                                    i <
                                                        filterHardSkillsJsonFileContent
                                                            .length;
                                                    i++) {
                                                  /// Hard Skill Category
                                                  if (filterHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkillCategory !=
                                                      null) {
                                                    if (hardSkillCategorySubList[
                                                            skillsRequiredIndex]
                                                        .contains(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkillCategory!)) {
                                                      hardSkillCategorySubList[
                                                          skillsRequiredIndex];
                                                    } else {
                                                      hardSkillCategorySubList[
                                                              skillsRequiredIndex]
                                                          .add(filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategorySubList[
                                                        skillsRequiredIndex];
                                                  }

                                                  /// Hard Skill
                                                  if (filterHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkill !=
                                                      null) {
                                                    if (hardSkillSubList[
                                                            skillsRequiredIndex]
                                                        .contains(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!)) {
                                                      hardSkillSubList[
                                                          skillsRequiredIndex];
                                                    } else {
                                                      hardSkillSubList[
                                                              skillsRequiredIndex]
                                                          .add(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillSubList[
                                                        skillsRequiredIndex];
                                                  }
                                                }
                                              }
                                            } else {
                                              var filterHardSkillsJsonFileContent =
                                                  readHardSkillsJsonFileContent
                                                      .where((element) =>
                                                          element.jobField ==
                                                              skillsRequired
                                                                  .jobField &&
                                                          element.jobSubField ==
                                                              skillsRequired
                                                                  .jobSubField &&
                                                          element.jobSpecialization ==
                                                              skillsRequired
                                                                  .jobSpecialization)
                                                      .toList();

                                              for (int i = 0;
                                                  i <
                                                      filterHardSkillsJsonFileContent
                                                          .length;
                                                  i++) {
                                                /// Hard Skill Category
                                                if (filterHardSkillsJsonFileContent[
                                                            i]
                                                        .hardSkillCategory !=
                                                    null) {
                                                  if (hardSkillCategorySubList[
                                                          skillsRequiredIndex]
                                                      .contains(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkillCategory!)) {
                                                    hardSkillCategorySubList[
                                                        skillsRequiredIndex];
                                                  } else {
                                                    hardSkillCategorySubList[
                                                            skillsRequiredIndex]
                                                        .add(filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkillCategory!);
                                                  }
                                                } else {
                                                  hardSkillCategorySubList[
                                                      skillsRequiredIndex];
                                                }

                                                /// Hard Skill
                                                if (filterHardSkillsJsonFileContent[
                                                            i]
                                                        .hardSkill !=
                                                    null) {
                                                  if (hardSkillSubList[
                                                          skillsRequiredIndex]
                                                      .contains(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill!)) {
                                                    hardSkillSubList[
                                                        skillsRequiredIndex];
                                                  } else {
                                                    hardSkillSubList[
                                                            skillsRequiredIndex]
                                                        .add(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                  }
                                                } else {
                                                  hardSkillSubList[
                                                      skillsRequiredIndex];
                                                }
                                              }
                                            }
                                          } else {
                                            var filterHardSkillsList =
                                                readHardSkillsJsonFileContent
                                                    .where((element) =>
                                                        element.typeOfSpecialization ==
                                                            newTypeOfSpecializationValue &&
                                                        element.jobSpecialization ==
                                                            skillsRequired
                                                                .jobSpecialization &&
                                                        element.jobSubField ==
                                                            skillsRequired
                                                                .jobSubField &&
                                                        element.jobField ==
                                                            skillsRequired
                                                                .jobField)
                                                    .toList();

                                            for (int i = 0;
                                                i < filterHardSkillsList.length;
                                                i++) {
                                              /// Hard Skill Category
                                              if (filterHardSkillsList[i]
                                                      .hardSkillCategory !=
                                                  null) {
                                                if (hardSkillCategorySubList[
                                                        skillsRequiredIndex]
                                                    .contains(
                                                        filterHardSkillsList[i]
                                                            .hardSkillCategory!)) {
                                                  hardSkillCategorySubList[
                                                      skillsRequiredIndex];
                                                } else {
                                                  hardSkillCategorySubList[
                                                          skillsRequiredIndex]
                                                      .add(filterHardSkillsList[
                                                              i]
                                                          .hardSkillCategory!);
                                                }
                                              } else {
                                                hardSkillCategorySubList[
                                                    skillsRequiredIndex];
                                              }

                                              /// Hard Skill
                                              if (filterHardSkillsList[i]
                                                      .hardSkill !=
                                                  null) {
                                                if (hardSkillSubList[
                                                        skillsRequiredIndex]
                                                    .contains(
                                                        filterHardSkillsList[i]
                                                            .hardSkill!)) {
                                                  hardSkillSubList[
                                                      skillsRequiredIndex];
                                                } else {
                                                  hardSkillSubList[
                                                          skillsRequiredIndex]
                                                      .add(filterHardSkillsList[
                                                              i]
                                                          .hardSkill!);
                                                }
                                              } else {
                                                hardSkillSubList[
                                                    skillsRequiredIndex];
                                              }
                                            }
                                          }
                                        });
                                      });
                                    },
                                    //show selected item
                                    selectedItem: fullSkillsList[
                                                    skillsRequiredIndex]
                                                .typeOfSpecialization ==
                                            null
                                        ? "Type Of Specialization"
                                        : fullSkillsList[skillsRequiredIndex]
                                            .typeOfSpecialization!,
                                  );
                                }),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 70),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "HARD SKILL CATEGORY",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter dropDownState) {
                                  return DropdownSearch<String>(
                                    popupElevation: 0.0,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: hardSkillCategorySubList.isEmpty
                                        ? []
                                        : hardSkillCategorySubList[
                                            skillsRequiredIndex],
                                    onChanged:
                                        (String? newHardSkillCategoryValue) {
                                      dropDownState(() {
                                        setState(() {
                                          fullSkillsList[skillsRequiredIndex]
                                                  .skillCategory =
                                              newHardSkillCategoryValue!;

                                          hardSkillSubList[
                                              skillsRequiredIndex] = [];

                                          /// CHANGE: Hard Skill Category
                                          if (newHardSkillCategoryValue ==
                                              null) {
                                            if (fullSkillsList[
                                                        skillsRequiredIndex]
                                                    .typeOfSpecialization ==
                                                null) {
                                              if (skillsRequired
                                                      .jobSpecialization ==
                                                  null) {
                                                if (skillsRequired
                                                        .jobSubField ==
                                                    null) {
                                                  if (skillsRequired.jobField ==
                                                      null) {
                                                    for (int i = 0;
                                                        i <
                                                            readHardSkillsJsonFileContent
                                                                .length;
                                                        i++) {
                                                      /// Hard Skill
                                                      if (readHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill !=
                                                          null) {
                                                        if (hardSkillSubList[
                                                                skillsRequiredIndex]
                                                            .contains(
                                                                readHardSkillsJsonFileContent[
                                                                        i]
                                                                    .hardSkill!)) {
                                                          hardSkillSubList[
                                                              skillsRequiredIndex];
                                                        } else {
                                                          hardSkillSubList[
                                                                  skillsRequiredIndex]
                                                              .add(readHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!);
                                                        }
                                                      } else {
                                                        hardSkillSubList[
                                                            skillsRequiredIndex];
                                                      }
                                                    }
                                                  } else {
                                                    var filterHardSkillsJsonFileContent =
                                                        readHardSkillsJsonFileContent
                                                            .where((element) =>
                                                                element
                                                                    .jobField ==
                                                                skillsRequired
                                                                    .jobField)
                                                            .toList();

                                                    for (int i = 0;
                                                        i <
                                                            filterHardSkillsJsonFileContent
                                                                .length;
                                                        i++) {
                                                      /// Hard Skill
                                                      if (filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill !=
                                                          null) {
                                                        if (hardSkillSubList[
                                                                skillsRequiredIndex]
                                                            .contains(
                                                                filterHardSkillsJsonFileContent[
                                                                        i]
                                                                    .hardSkill!)) {
                                                          hardSkillSubList[
                                                              skillsRequiredIndex];
                                                        } else {
                                                          hardSkillSubList[
                                                                  skillsRequiredIndex]
                                                              .add(filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!);
                                                        }
                                                      } else {
                                                        hardSkillSubList[
                                                            skillsRequiredIndex];
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  var filterHardSkillsJsonFileContent =
                                                      readHardSkillsJsonFileContent
                                                          .where((element) =>
                                                              element.jobField ==
                                                                  skillsRequired
                                                                      .jobField &&
                                                              element.jobSubField ==
                                                                  skillsRequired
                                                                      .jobSubField)
                                                          .toList();

                                                  for (int i = 0;
                                                      i <
                                                          filterHardSkillsJsonFileContent
                                                              .length;
                                                      i++) {
                                                    /// Hard Skill
                                                    if (filterHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill !=
                                                        null) {
                                                      if (hardSkillSubList[
                                                              skillsRequiredIndex]
                                                          .contains(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!)) {
                                                        hardSkillSubList[
                                                            skillsRequiredIndex];
                                                      } else {
                                                        hardSkillSubList[
                                                                skillsRequiredIndex]
                                                            .add(filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                      }
                                                    } else {
                                                      hardSkillSubList[
                                                          skillsRequiredIndex];
                                                    }
                                                  }
                                                }
                                              } else {
                                                var filterHardSkillsJsonFileContent =
                                                    readHardSkillsJsonFileContent
                                                        .where((element) =>
                                                            element.jobField ==
                                                                skillsRequired
                                                                    .jobField &&
                                                            element.jobSubField ==
                                                                skillsRequired
                                                                    .jobSubField &&
                                                            element.jobSpecialization ==
                                                                skillsRequired
                                                                    .jobSpecialization)
                                                        .toList();

                                                for (int i = 0;
                                                    i <
                                                        filterHardSkillsJsonFileContent
                                                            .length;
                                                    i++) {
                                                  /// Hard Skill
                                                  if (filterHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkill !=
                                                      null) {
                                                    if (hardSkillSubList[
                                                            skillsRequiredIndex]
                                                        .contains(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!)) {
                                                      hardSkillSubList[
                                                          skillsRequiredIndex];
                                                    } else {
                                                      hardSkillSubList[
                                                              skillsRequiredIndex]
                                                          .add(
                                                              filterHardSkillsJsonFileContent[
                                                                      i]
                                                                  .hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillSubList[
                                                        skillsRequiredIndex];
                                                  }
                                                }
                                              }
                                            } else {
                                              var filterHardSkillsJsonFileContent =
                                                  readHardSkillsJsonFileContent
                                                      .where((element) =>
                                                          element.jobField ==
                                                              skillsRequired
                                                                  .jobField &&
                                                          element.jobSubField ==
                                                              skillsRequired
                                                                  .jobSubField &&
                                                          element.jobSpecialization ==
                                                              skillsRequired
                                                                  .jobSpecialization &&
                                                          element.typeOfSpecialization ==
                                                              skillsRequired
                                                                  .hardSkills![
                                                                      skillsRequiredIndex]
                                                                  .typeOfSpecialization)
                                                      .toList();

                                              for (int i = 0;
                                                  i <
                                                      filterHardSkillsJsonFileContent
                                                          .length;
                                                  i++) {
                                                /// Hard Skill
                                                if (filterHardSkillsJsonFileContent[
                                                            i]
                                                        .hardSkill !=
                                                    null) {
                                                  if (hardSkillSubList[
                                                          skillsRequiredIndex]
                                                      .contains(
                                                          filterHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill!)) {
                                                    hardSkillSubList[
                                                        skillsRequiredIndex];
                                                  } else {
                                                    hardSkillSubList[
                                                            skillsRequiredIndex]
                                                        .add(
                                                            filterHardSkillsJsonFileContent[
                                                                    i]
                                                                .hardSkill!);
                                                  }
                                                } else {
                                                  hardSkillSubList[
                                                      skillsRequiredIndex];
                                                }
                                              }
                                            }
                                          } else {
                                            hardSkillSubList[
                                                skillsRequiredIndex] = [];

                                            var filterHardSkillsList = readHardSkillsJsonFileContent
                                                .where((element) =>
                                                    element.hardSkillCategory ==
                                                        newHardSkillCategoryValue &&
                                                    element.typeOfSpecialization ==
                                                        skillsRequired
                                                            .hardSkills![
                                                                skillsRequiredIndex]
                                                            .typeOfSpecialization &&
                                                    element.jobSpecialization ==
                                                        skillsRequired
                                                            .jobSpecialization &&
                                                    element.jobSubField ==
                                                        skillsRequired
                                                            .jobSubField &&
                                                    element.jobField ==
                                                        skillsRequired.jobField)
                                                .toList();

                                            for (int i = 0;
                                                i < filterHardSkillsList.length;
                                                i++) {
                                              /// Hard SKill
                                              if (filterHardSkillsList[i]
                                                      .hardSkill !=
                                                  null) {
                                                if (hardSkillSubList[
                                                        skillsRequiredIndex]
                                                    .contains(
                                                        filterHardSkillsList[i]
                                                            .hardSkill!)) {
                                                  hardSkillSubList[
                                                      skillsRequiredIndex];
                                                } else {
                                                  hardSkillSubList[
                                                          skillsRequiredIndex]
                                                      .add(filterHardSkillsList[
                                                              i]
                                                          .hardSkill!);
                                                }
                                              } else {
                                                hardSkillSubList[
                                                    skillsRequiredIndex];
                                              }
                                            }
                                          }
                                        });
                                      });
                                    },
                                    //show selected item
                                    selectedItem: fullSkillsList[
                                                    skillsRequiredIndex]
                                                .skillCategory ==
                                            null
                                        ? "Hard Skill Category"
                                        : fullSkillsList[skillsRequiredIndex]
                                            .skillCategory!,
                                  );
                                }),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 70),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "HARD SKILL",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter dropDownState) {
                                  return DropdownSearch<String>(
                                    popupElevation: 0.0,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: hardSkillSubList[skillsRequiredIndex]
                                            .isEmpty
                                        ? []
                                        : hardSkillSubList[skillsRequiredIndex],
                                    onChanged: (String? newHarSkillValue) {
                                      dropDownState(() {
                                        setState(() {
                                          fullSkillsList[skillsRequiredIndex]
                                              .skill = newHarSkillValue!;
                                        });
                                      });
                                    },
                                    //show selected item
                                    selectedItem: fullSkillsList[
                                                    skillsRequiredIndex]
                                                .skill ==
                                            null
                                        ? "Hard Skill"
                                        : fullSkillsList[skillsRequiredIndex]
                                            .skill!,
                                  );
                                }),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "LEVEL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 150,
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter dropDownState) {
                          return DropdownSearch<String>(
                            popupElevation: 0.0,
                            showClearButton: true,
                            dropdownSearchDecoration: const InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                letterSpacing: 3,
                              ),
                            ),
                            //mode of dropdown
                            mode: Mode.MENU,
                            //to show search box
                            showSearchBox: true,
                            //list of dropdown items
                            items: skillLevelList,
                            onChanged: (String? newValue) {
                              dropDownState(() {
                                fullSkillsList[skillsRequiredIndex].level =
                                    newValue!;
                              });
                            },
                            //show selected item
                            selectedItem: fullSkillsList[skillsRequiredIndex]
                                        .level ==
                                    null
                                ? "Level"
                                : fullSkillsList[skillsRequiredIndex].level!,
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //var fullChecklistItemsList = <ChecklistItemModel>[];
  var fullSkillContainer = <Container>[];

  addSkillsContainer({List<SkillModel>? fullSkillList}) {
    var skill = SkillModel();
    fullSkillList!.add(skill);
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "SKILL NEEDED",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 130),
              Text(
                "LEVEL",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 250,
                  autofocus: false,
                  initialValue:
                      skill.skill == null ? "" : skill.skill!.toString(),
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    skill.skill = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    skill.skill = newValue;
                  },
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState) {
                  return DropdownSearch<String>(
                    popupElevation: 0.0,
                    dropdownSearchDecoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                        fontFamily: 'Montserrat',
                        letterSpacing: 3,
                      ),
                    ),
                    //mode of dropdown
                    mode: Mode.MENU,
                    //to show search box
                    showSearchBox: true,
                    //list of dropdown items
                    items: skillLevelList,
                    onChanged: (String? newValue) {
                      dropDownState(() {
                        skill.level = newValue!;
                      });
                    },
                    //show selected item
                    selectedItem: skill.level == null ? "Level" : skill.level!,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  addNewSkillContainer() {
    var skillRequired = SkillsRequiredPerMemberModel();
    fullSkillsRequired.add(skillRequired);
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SKILL REQUIRED ${fullSkillsRequired.length}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: primaryColour,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      // print("Delete");
                      fullSkillsRequired.remove(skillRequired);
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "JOB FIELD",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 250,
                  autofocus: false,
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    skillRequired.jobField = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    skillRequired.jobField = newValue;
                  },
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "JOB TITLE",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 250,
                  autofocus: false,
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    skillRequired.jobTitle = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    skillRequired.jobTitle = newValue;
                  },
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SKILLS",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    fullSkillContainer.add(
                      addSkillsContainer(
                          fullSkillList: skillRequired.hardSkills),
                    );
                  });
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          skillRequired.hardSkills == null
              ? Container()
              : SizedBox(
                  height: skillRequired.hardSkills!.length * 400,
                  child: buildAllSkillsListView(
                      fullSkillsList: skillRequired.hardSkills!,
                      typeOfSpecializationSubList: [],
                      hardSkillSubList: [],
                      hardSkillCategorySubList: [],
                      skillsRequired: skillRequired),
                ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CONTRACT TYPE",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState) {
                  return DropdownSearch<String>(
                    popupElevation: 0.0,
                    dropdownSearchDecoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                        fontFamily: 'Montserrat',
                        letterSpacing: 3,
                      ),
                    ),
                    //mode of dropdown
                    mode: Mode.MENU,
                    //to show search box
                    showSearchBox: true,
                    //list of dropdown items
                    items: contractTypeList,
                    onChanged: (String? newValue) {
                      dropDownState(() {
                        skillRequired.contractType = newValue!;
                      });
                    },
                    //show selected item
                    selectedItem: "Type",
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
                child: const Text(
                  "DURATION (in Weeks)",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    //letterSpacing: 8,
                    fontFamily: 'Electrolize',
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                //
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 250,
                  autofocus: false,
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    skillRequired.duration = double.parse(newValue);
                  },
                  onFieldSubmitted: (newValue) {
                    skillRequired.duration = double.parse(newValue);
                  },
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 50),
                    const Text(
                      "START DATE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 110),
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 50),
                    const Text(
                      "END DATE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoDateTextBox(
                  initialValue: DateTime.now(),
                  onDateChange: (DateTime? newDate) {
                    //print(newDate);
                    setState(() {
                      skillRequired.startDate = newDate!.toIso8601String();
                    });
                  },
                  hintText: skillRequired.startDate == null
                      ? DateFormat().format(DateTime.now())
                      : skillRequired.startDate!,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoDateTextBox(
                  initialValue: DateTime.now(),
                  onDateChange: (DateTime? newDate) {
                    // print(newDate);
                    setState(() {
                      skillRequired.endDate =
                          DateFormat('yyyy-MM-dd').format(newDate!);
                    });
                  },
                  hintText: skillRequired.endDate == null
                      ? DateFormat().format(DateTime.now())
                      : skillRequired.endDate!,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 70),
        ],
      ),
    );
  }
}
