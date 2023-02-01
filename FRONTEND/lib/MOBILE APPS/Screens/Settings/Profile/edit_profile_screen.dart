import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class EditProfileScreenMA extends StatefulWidget {
  static const String id = 'edit profile_screen';

  const EditProfileScreenMA({Key? key}) : super(key: key);

  @override
  _EditProfileScreenMAState createState() => _EditProfileScreenMAState();
}

class _EditProfileScreenMAState extends State<EditProfileScreenMA> {
  /// Variables used to add more
  bool addNewLanguage = false;

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  /// User Model information Variables
  getUserInfo() async {
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    var userInfo = await networkHandler
        .get("${AppUrl.getUserUsingEmail}${UserProfile.email}");

    //print(userInfo);
    setState(() {
      UserProfile.username = userInfo['data']['username'];
    });
  }

  UserModel readUserJsonFileContent = UserModel();
  Future<UserModel>? futureUserInformation;

  Future<UserModel> readingUserJsonData() async {
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
    // print('Response status: ${response.statusCode}');
    // print('Response Enter body: ${response.body}');

    if (response.statusCode == 200) {
      readUserJsonFileContent = userModelListFromJson(response.body)
          .where((element) => element.email == UserProfile.email)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<UserModel> updateUserJsonData(
      UserModel selectedTaskInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri =
        Uri.parse("${AppUrl.updateUserInformationByEmail}${UserProfile.email}");

    //print(selectedTaskInformation);

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
      body: json.encode(selectedTaskInformation.toJson()),
    );
    // print(response.body);

    if (response.statusCode == 200) {
      readUserJsonFileContent = UserModel.fromJson(jsonDecode(response.body));
      //print(readUserJsonFileContent);

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR HARD SKILLS

  List<HardSkillsDataModel> readHardSkillsJsonFileContent =
      <HardSkillsDataModel>[];
  List<HardSkillsDataModel> filterHardSkillsJsonFileContent =
      <HardSkillsDataModel>[];

  Future<List<HardSkillsDataModel>>? _futureHardSkillsInformation;

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

      for (int i = 0; i < readHardSkillsJsonFileContent.length; i++) {
        if (readHardSkillsJsonFileContent[i].jobField != null) {
          if (jobFieldList
              .contains(readHardSkillsJsonFileContent[i].jobField!)) {
            jobFieldList = jobFieldList;
          } else {
            jobFieldList.add(readHardSkillsJsonFileContent[i].jobField!);
          }
        } else {
          jobFieldList;
        }
      }

      return readHardSkillsJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR HARD SKILLS

  List<String> adaptabilitySoftSkillsList = [];
  List<String> attentionToDetailSoftSkillsList = [];
  List<String> communicationSoftSkillsList = [];
  List<String> computerSoftSkillsList = [];
  List<String> creativitySoftSkillsList = [];
  List<String> leadershipSoftSkillsList = [];
  List<String> lifeSoftSkillsList = [];
  List<String> organizationSoftSkillsList = [];
  List<String> problemSolvingSoftSkillsList = [];
  List<String> socialSoftSkillsList = [];
  List<String> teamworkSoftSkillsList = [];
  List<String> timeManagementSoftSkillsList = [];
  List<String> workEthicSoftSkillsList = [];

  ///
  List<SoftSkillsDataModel> readSoftSkillsJsonFileContent = <SoftSkillsDataModel>[];
  List<SoftSkillsDataModel> filterSoftSkillsJsonFileContent = <SoftSkillsDataModel>[];

  Future<List<SoftSkillsDataModel>> readSoftSkillsInformationJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.getSoftSkills);

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
      readSoftSkillsJsonFileContent = softSkillsDataListFromJson(response.body);
      //print("readHardSkillsJsonFileContent: ${readHardSkillsJsonFileContent}");

      var adaptabilityList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Adaptability").toList();
      if(adaptabilityList == null)  {
        adaptabilitySoftSkillsList = [];
      } else {
        for (int i = 0; i < adaptabilityList.length; i++) {
          adaptabilitySoftSkillsList.add(adaptabilityList[i].softSkill!);
        }
      }
      var attentionToDetailList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Attention to Detail").toList();
      if(attentionToDetailList == null)  {
        attentionToDetailSoftSkillsList = [];
      } else {
        for (int i = 0; i < attentionToDetailList.length; i++) {
          attentionToDetailSoftSkillsList.add(attentionToDetailList[i].softSkill!);
        }
      }

      var communicationList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Communication Skills").toList();
      if(communicationList == null)  {
        communicationSoftSkillsList = [];
      } else {
        for (int i = 0; i < communicationList.length; i++) {
          communicationSoftSkillsList.add(communicationList[i].softSkill!);
        }
      }

      var computerList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Computer Skills").toList();
      if(computerList == null)  {
        computerSoftSkillsList = [];
      } else {
        for (int i = 0; i < computerList.length; i++) {
          computerSoftSkillsList.add(computerList[i].softSkill!);
        }
      }

      var creativityList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Creativity").toList();
      if(creativityList == null)  {
        creativitySoftSkillsList = [];
      } else {
        for (int i = 0; i < creativityList.length; i++) {
          creativitySoftSkillsList.add(creativityList[i].softSkill!);
        }
      }

      var leadershipList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Leadership").toList();
      if(leadershipList == null)  {
        leadershipSoftSkillsList = [];
      } else {
        for (int i = 0; i < leadershipList.length; i++) {
          leadershipSoftSkillsList.add(leadershipList[i].softSkill!);
        }
      }

      var lifeList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Life Skills").toList();
      if(lifeList == null)  {
        lifeSoftSkillsList = [];
      } else {
        for (int i = 0; i < lifeList.length; i++) {
          lifeSoftSkillsList.add(lifeList[i].softSkill!);
        }
      }

      var organizationList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Organization Skills").toList();
      if(organizationList == null)  {
        organizationSoftSkillsList = [];
      } else {
        for (int i = 0; i < organizationList.length; i++) {
          organizationSoftSkillsList.add(organizationList[i].softSkill!);
        }
      }

      var problemSolvingList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Problem-solving").toList();
      if(problemSolvingList == null)  {
        problemSolvingSoftSkillsList = [];
      } else {
        for (int i = 0; i < problemSolvingList.length; i++) {
          problemSolvingSoftSkillsList.add(problemSolvingList[i].softSkill!);
        }
      }

      var socialList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Social Skills").toList();
      if(socialList == null)  {
        socialSoftSkillsList = [];
      } else {
        for (int i = 0; i < socialList.length; i++) {
          socialSoftSkillsList.add(socialList[i].softSkill!);
        }
      }

      var teamworkList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Teamwork").toList();
      if(teamworkList == null)  {
        teamworkSoftSkillsList = [];
      } else {
        for (int i = 0; i < teamworkList.length; i++) {
          teamworkSoftSkillsList.add(teamworkList[i].softSkill!);
        }
      }

      var timeManagementList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Time Management").toList();
      if(timeManagementList == null)  {
        timeManagementSoftSkillsList = [];
      } else {
        for (int i = 0; i < timeManagementList.length; i++) {
          timeManagementSoftSkillsList.add(timeManagementList[i].softSkill!);
        }
      }

      var workEthicList = readSoftSkillsJsonFileContent.where((element) => element.softSkillCategory == "Work Ethic").toList();
      if(workEthicList == null)  {
        workEthicSoftSkillsList = [];
      } else {
        for (int i = 0; i < workEthicList.length; i++) {
          workEthicSoftSkillsList.add(workEthicList[i].softSkill!);
        }
      }

      return readSoftSkillsJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    /// User Model information Variables
    getUserInfo();
    futureUserInformation = readingUserJsonData();

    readingUserJsonData().then((userInformationFromBackend) {
      return readHardSkillsInformationJsonData()
          .then((hardSkillsListFromBackend) {
        jobFieldList = [];
        jobSubFieldList = [];
        jobSpecializationList = [];
        typeOfSpecializationList = [];
        hardSkillCategoryList = [];
        hardSkillList = [];

        /// Initialize Job Field List

        for (int i = 0; i < hardSkillsListFromBackend.length; i++) {
          if (hardSkillsListFromBackend[i].jobField != null) {
            if (jobFieldList.contains(hardSkillsListFromBackend[i].jobField!)) {
              jobFieldList;
            } else {
              jobFieldList.add(hardSkillsListFromBackend[i].jobField!);
            }
          } else {
            jobFieldList;
          }
        }

        /// Initialize Job Sub-Field List, Job Specialization List and Type Of Specialization List

        if (userInformationFromBackend.jobSpecialization == null) {
          if (userInformationFromBackend.jobSubField == null) {
            if (userInformationFromBackend.jobField == null) {
              for (int i = 0; i < hardSkillsListFromBackend.length; i++) {
                /// Job Sub Field List
                if (hardSkillsListFromBackend[i].jobSubField != null) {
                  if (jobSubFieldList
                      .contains(hardSkillsListFromBackend[i].jobSubField!)) {
                    jobSubFieldList;
                  } else {
                    jobSubFieldList
                        .add(hardSkillsListFromBackend[i].jobSubField!);
                  }
                } else {
                  jobSubFieldList;
                }

                /// Job Specialization List
                if (hardSkillsListFromBackend[i].jobSpecialization != null) {
                  if (jobSpecializationList.contains(
                      hardSkillsListFromBackend[i].jobSpecialization!)) {
                    jobSpecializationList;
                  } else {
                    jobSpecializationList
                        .add(hardSkillsListFromBackend[i].jobSpecialization!);
                  }
                } else {
                  jobSpecializationList;
                }

                /// Type of Specialization List
                if (hardSkillsListFromBackend[i].typeOfSpecialization != null) {
                  if (typeOfSpecializationList.contains(
                      hardSkillsListFromBackend[i].typeOfSpecialization!)) {
                    typeOfSpecializationList;
                  } else {
                    typeOfSpecializationList.add(
                        hardSkillsListFromBackend[i].typeOfSpecialization!);
                  }
                } else {
                  typeOfSpecializationList;
                }
              }
            } else {
              var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
                  .where((element) =>
                      element.jobField == userInformationFromBackend.jobField)
                  .toList();

              for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                /// Job Sub Field List
                if (filterHardSkillsJsonFileContent[i].jobSubField != null) {
                  if (jobSubFieldList.contains(
                      filterHardSkillsJsonFileContent[i].jobSubField!)) {
                    jobSubFieldList;
                  } else {
                    jobSubFieldList
                        .add(filterHardSkillsJsonFileContent[i].jobSubField!);
                  }
                } else {
                  jobSubFieldList;
                }

                /// Job Specialization List
                if (filterHardSkillsJsonFileContent[i].jobSpecialization !=
                    null) {
                  if (jobSpecializationList.contains(
                      filterHardSkillsJsonFileContent[i].jobSpecialization!)) {
                    jobSpecializationList;
                  } else {
                    jobSpecializationList.add(
                        filterHardSkillsJsonFileContent[i].jobSpecialization!);
                  }
                } else {
                  jobSpecializationList;
                }

                /// Type of Specialization List
                if (filterHardSkillsJsonFileContent[i].typeOfSpecialization !=
                    null) {
                  if (typeOfSpecializationList.contains(
                      filterHardSkillsJsonFileContent[i]
                          .typeOfSpecialization!)) {
                    typeOfSpecializationList;
                  } else {
                    typeOfSpecializationList.add(
                        filterHardSkillsJsonFileContent[i]
                            .typeOfSpecialization!);
                  }
                } else {
                  typeOfSpecializationList;
                }
              }
            }
          } else {
            var filterHardSkillsJsonFileContentForSubField =
                hardSkillsListFromBackend
                    .where((element) =>
                        element.jobField == userInformationFromBackend.jobField)
                    .toList();

            for (int i = 0;
                i < filterHardSkillsJsonFileContentForSubField.length;
                i++) {
              /// Job Sub Field List
              if (filterHardSkillsJsonFileContentForSubField[i].jobSubField !=
                  null) {
                if (jobSubFieldList.contains(
                    filterHardSkillsJsonFileContentForSubField[i]
                        .jobSubField!)) {
                  jobSubFieldList;
                } else {
                  jobSubFieldList.add(
                      filterHardSkillsJsonFileContentForSubField[i]
                          .jobSubField!);
                }
              } else {
                jobSubFieldList;
              }
            }

            var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
                .where((element) =>
                    element.jobField == userInformationFromBackend.jobField &&
                    element.jobSubField ==
                        userInformationFromBackend.jobSubField)
                .toList();

            for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
              /// Job Specialization List
              if (filterHardSkillsJsonFileContent[i].jobSpecialization !=
                  null) {
                if (jobSpecializationList.contains(
                    filterHardSkillsJsonFileContent[i].jobSpecialization!)) {
                  jobSpecializationList;
                } else {
                  jobSpecializationList.add(
                      filterHardSkillsJsonFileContent[i].jobSpecialization!);
                }
              } else {
                jobSpecializationList;
              }

              /// Type of Specialization List
              if (filterHardSkillsJsonFileContent[i].typeOfSpecialization !=
                  null) {
                if (typeOfSpecializationList.contains(
                    filterHardSkillsJsonFileContent[i].typeOfSpecialization!)) {
                  typeOfSpecializationList;
                } else {
                  typeOfSpecializationList.add(
                      filterHardSkillsJsonFileContent[i].typeOfSpecialization!);
                }
              } else {
                typeOfSpecializationList;
              }
            }
          }
        }
        else {
          var filterHardSkillsJsonFileContentForSubField =
              hardSkillsListFromBackend
                  .where((element) =>
                      element.jobField == userInformationFromBackend.jobField)
                  .toList();

          for (int i = 0;
              i < filterHardSkillsJsonFileContentForSubField.length;
              i++) {
            /// Job Sub Field List
            if (filterHardSkillsJsonFileContentForSubField[i].jobSubField !=
                null) {
              if (jobSubFieldList.contains(
                  filterHardSkillsJsonFileContentForSubField[i].jobSubField!)) {
                jobSubFieldList;
              } else {
                jobSubFieldList.add(
                    filterHardSkillsJsonFileContentForSubField[i].jobSubField!);
              }
            } else {
              jobSubFieldList;
            }
          }

          var filterHardSkillsJsonFileContentForSpecialization =
              hardSkillsListFromBackend
                  .where((element) =>
                      element.jobField == userInformationFromBackend.jobField &&
                      element.jobSubField ==
                          userInformationFromBackend.jobSubField)
                  .toList();

          for (int i = 0;
              i < filterHardSkillsJsonFileContentForSpecialization.length;
              i++) {
            /// Job Specialization List
            if (filterHardSkillsJsonFileContentForSpecialization[i]
                    .jobSpecialization !=
                null) {
              if (jobSpecializationList.contains(
                  filterHardSkillsJsonFileContentForSpecialization[i]
                      .jobSpecialization!)) {
                jobSpecializationList;
              } else {
                jobSpecializationList.add(
                    filterHardSkillsJsonFileContentForSpecialization[i]
                        .jobSpecialization!);
              }
            } else {
              jobSpecializationList;
            }
          }

          var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
              .where((element) =>
                  element.jobField == userInformationFromBackend.jobField &&
                  element.jobSubField ==
                      userInformationFromBackend.jobSubField &&
                  element.jobSpecialization ==
                      userInformationFromBackend.jobSpecialization)
              .toList();

          for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
            /// Type of Specialization List
            if (filterHardSkillsJsonFileContent[i].typeOfSpecialization !=
                null) {
              if (typeOfSpecializationList.contains(
                  filterHardSkillsJsonFileContent[i].typeOfSpecialization!)) {
                typeOfSpecializationList;
              } else {
                typeOfSpecializationList.add(
                    filterHardSkillsJsonFileContent[i].typeOfSpecialization!);
              }
            } else {
              typeOfSpecializationList;
            }
          }
        }

        /// Initialize Hard Skill Category List AND Hard Skills List

        if (userInformationFromBackend.hardSkills == null) {
          hardSkillCategoryList = [];
          hardSkillList = [];
        }
        else {
          for (int j = 0;
              j < userInformationFromBackend.hardSkills!.length;
              j++) {
            hardSkillCategoryList.add([]);
            hardSkillList.add([]);

            if (userInformationFromBackend.hardSkills![j].skillCategory ==
                null) {
              if (userInformationFromBackend
                      .hardSkills![j].typeOfSpecialization ==
                  null) {
                if (userInformationFromBackend.jobSpecialization == null) {
                  if (userInformationFromBackend.jobSubField == null) {
                    if (userInformationFromBackend.jobField == null) {
                      for (int i = 0;
                          i < hardSkillsListFromBackend.length;
                          i++) {
                        /// Hard Skill
                        if (hardSkillsListFromBackend[i].hardSkill != null) {
                          if (hardSkillList[j].contains(
                              hardSkillsListFromBackend[i].hardSkill!)) {
                            hardSkillList[j];
                          } else {
                            hardSkillList[j]
                                .add(hardSkillsListFromBackend[i].hardSkill!);
                          }
                        } else {
                          hardSkillList[j];
                        }
                      }
                    } else {
                      var filterHardSkillsJsonFileContent =
                          hardSkillsListFromBackend
                              .where((element) =>
                                  element.jobField ==
                                  userInformationFromBackend.jobField)
                              .toList();

                      for (int i = 0;
                          i < filterHardSkillsJsonFileContent.length;
                          i++) {
                        /// Hard Skill Category
                        if (filterHardSkillsJsonFileContent[i]
                                .hardSkillCategory !=
                            null) {
                          if (hardSkillCategoryList[j].contains(
                              filterHardSkillsJsonFileContent[i]
                                  .hardSkillCategory!)) {
                            hardSkillCategoryList[j];
                          } else {
                            hardSkillCategoryList[j].add(
                                filterHardSkillsJsonFileContent[i]
                                    .hardSkillCategory!);
                          }
                        } else {
                          hardSkillCategoryList[j];
                        }

                        /// Hard Skill
                        if (filterHardSkillsJsonFileContent[i].hardSkill !=
                            null) {
                          if (hardSkillList[j].contains(
                              filterHardSkillsJsonFileContent[i].hardSkill!)) {
                            hardSkillList[j];
                          } else {
                            hardSkillList[j].add(
                                filterHardSkillsJsonFileContent[i].hardSkill!);
                          }
                        } else {
                          hardSkillList[j];
                        }
                      }
                    }
                  } else {
                    var filterHardSkillsJsonFileContent =
                        hardSkillsListFromBackend
                            .where((element) =>
                                element.jobField ==
                                    userInformationFromBackend.jobField &&
                                element.jobSubField ==
                                    userInformationFromBackend.jobSubField)
                            .toList();

                    for (int i = 0;
                        i < filterHardSkillsJsonFileContent.length;
                        i++) {
                      /// Hard Skill Category
                      if (filterHardSkillsJsonFileContent[i]
                              .hardSkillCategory !=
                          null) {
                        if (hardSkillCategoryList[j].contains(
                            filterHardSkillsJsonFileContent[i]
                                .hardSkillCategory!)) {
                          hardSkillCategoryList[j];
                        } else {
                          hardSkillCategoryList[j].add(
                              filterHardSkillsJsonFileContent[i]
                                  .hardSkillCategory!);
                        }
                      } else {
                        hardSkillCategoryList[j];
                      }

                      /// Hard Skill
                      if (filterHardSkillsJsonFileContent[i].hardSkill !=
                          null) {
                        if (hardSkillList[j].contains(
                            filterHardSkillsJsonFileContent[i].hardSkill!)) {
                          hardSkillList[j];
                        } else {
                          hardSkillList[j].add(
                              filterHardSkillsJsonFileContent[i].hardSkill!);
                        }
                      } else {
                        hardSkillList[j];
                      }
                    }
                  }
                } else {
                  var filterHardSkillsJsonFileContent =
                      hardSkillsListFromBackend
                          .where((element) =>
                              element.jobField ==
                                  userInformationFromBackend.jobField &&
                              element.jobSubField ==
                                  userInformationFromBackend.jobSubField &&
                              element.jobSpecialization ==
                                  userInformationFromBackend.jobSpecialization)
                          .toList();

                  for (int i = 0;
                      i < filterHardSkillsJsonFileContent.length;
                      i++) {
                    /// Hard Skill Category
                    if (filterHardSkillsJsonFileContent[i].hardSkillCategory !=
                        null) {
                      if (hardSkillCategoryList[j].contains(
                          filterHardSkillsJsonFileContent[i]
                              .hardSkillCategory!)) {
                        hardSkillCategoryList[j];
                      } else {
                        hardSkillCategoryList[j].add(
                            filterHardSkillsJsonFileContent[i]
                                .hardSkillCategory!);
                      }
                    } else {
                      hardSkillCategoryList[j];
                    }

                    /// Hard Skill
                    if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                      if (hardSkillList[j].contains(
                          filterHardSkillsJsonFileContent[i].hardSkill!)) {
                        hardSkillList[j];
                      } else {
                        hardSkillList[j]
                            .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                      }
                    } else {
                      hardSkillList[j];
                    }
                  }
                }
              } else {
                var filterHardSkillsJsonFileContent = hardSkillsListFromBackend
                    .where((element) =>
                        element.jobField ==
                            userInformationFromBackend.jobField &&
                        element.jobSubField ==
                            userInformationFromBackend.jobSubField &&
                        element.jobSpecialization ==
                            userInformationFromBackend.jobSpecialization &&
                        element.typeOfSpecialization ==
                            userInformationFromBackend
                                .hardSkills![j].typeOfSpecialization)
                    .toList();

                for (int i = 0;
                    i < filterHardSkillsJsonFileContent.length;
                    i++) {
                  /// Hard Skill Category
                  if (filterHardSkillsJsonFileContent[i].hardSkillCategory !=
                      null) {
                    if (hardSkillCategoryList[j].contains(
                        filterHardSkillsJsonFileContent[i]
                            .hardSkillCategory!)) {
                      hardSkillCategoryList[j];
                    } else {
                      hardSkillCategoryList[j].add(
                          filterHardSkillsJsonFileContent[i]
                              .hardSkillCategory!);
                    }
                  } else {
                    hardSkillCategoryList[j];
                  }

                  /// Hard Skill
                  if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                    if (hardSkillList[j].contains(
                        filterHardSkillsJsonFileContent[i].hardSkill!)) {
                      hardSkillList[j];
                    } else {
                      hardSkillList[j]
                          .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                    }
                  } else {
                    hardSkillList[j];
                  }
                }
              }
            } else {
              var filterHardSkillsListForHardSkillCategory =
                  hardSkillsListFromBackend
                      .where((element) =>
                          element.jobField ==
                              userInformationFromBackend.jobField &&
                          element.jobSubField ==
                              userInformationFromBackend.jobSubField &&
                          element.jobSpecialization ==
                              userInformationFromBackend.jobSpecialization &&
                          element.typeOfSpecialization ==
                              userInformationFromBackend
                                  .hardSkills![j].typeOfSpecialization)
                      .toList();

              for (int i = 0;
                  i < filterHardSkillsListForHardSkillCategory.length;
                  i++) {
                /// Hard Category Skill
                if (filterHardSkillsListForHardSkillCategory[i]
                        .hardSkillCategory !=
                    null) {
                  if (hardSkillCategoryList[j].contains(
                      filterHardSkillsListForHardSkillCategory[i]
                          .hardSkillCategory!)) {
                    hardSkillCategoryList[j];
                  } else {
                    hardSkillCategoryList[j].add(
                        filterHardSkillsListForHardSkillCategory[i]
                            .hardSkillCategory!);
                  }
                } else {
                  hardSkillCategoryList[j];
                }
              }

              var filterHardSkillsListForHardSkill = hardSkillsListFromBackend
                  .where((element) =>
                      element.jobField == userInformationFromBackend.jobField &&
                      element.jobSubField ==
                          userInformationFromBackend.jobSubField &&
                      element.jobSpecialization ==
                          userInformationFromBackend.jobSpecialization &&
                      element.typeOfSpecialization ==
                          userInformationFromBackend
                              .hardSkills![j].typeOfSpecialization &&
                      element.hardSkillCategory ==
                          userInformationFromBackend
                              .hardSkills![j].skillCategory)
                  .toList();

              for (int i = 0;
                  i < filterHardSkillsListForHardSkill.length;
                  i++) {
                /// Hard SKill
                if (filterHardSkillsListForHardSkill[i].hardSkill != null) {
                  if (hardSkillList[j].contains(
                      filterHardSkillsListForHardSkill[i].hardSkill!)) {
                    hardSkillList[j];
                  } else {
                    hardSkillList[j]
                        .add(filterHardSkillsListForHardSkill[i].hardSkill!);
                  }
                } else {
                  hardSkillList[j];
                }
              }
            }
          }
        }
      });
    });

    /// Initialize Soft Skill List
    readSoftSkillsInformationJsonData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
        : 1;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: futureUserInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: appBar(),
                body: buildBody(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            validateInputs();
          },
          child: Icon(
            Icons.clear,
            size: 24,
            color: primaryColour,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save_outlined,
              size: 24,
              color: primaryColour,
            ),
            onPressed: () {
              setState(() {
                readUserJsonFileContent.dateUpdated = DateTime.now();
                futureUserInformation =
                    updateUserJsonData(readUserJsonFileContent);
              });
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ]);
  }

  validateInputs() {
    Navigator.pop(context);
    return;
  }

  buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      //width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          //physics: const BouncingScrollPhysics(),
          children: [
            ProfileAvatarWidget(
              email: UserProfile.email,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 40),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Personal Information",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title:
                              "General information about yourself that is relevant to your job",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildPersonalInformation(),
                  isExpanded: _expandedPersonalInformation,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedPersonalInformation = !_expandedPersonalInformation;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        ProfileItemCardMA(
                          title: "General",
                          rightWidget: null,
                          callback: () {
                            if (kDebugMode) {
                              // print('Tap About');
                            }
                          },
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title: "General information about your job",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildGeneral(),
                  isExpanded: _expandedGeneral,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedGeneral = !_expandedGeneral;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        ProfileItemCardMA(
                          title: "Languages",
                          rightWidget: null,
                          callback: () {
                            if (kDebugMode) {
                              // print('Tap About');
                            }
                          },
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title: "The languages you know",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildLanguages(),
                  isExpanded: _expandedLanguages,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedLanguages = !_expandedLanguages;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Education",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title: "General information about your education",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildEducation(),
                  isExpanded: _expandedEducation,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedEducation = !_expandedEducation;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Experience",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title:
                              "Any experience gained through work or volunteering",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildExperience(),
                  isExpanded: _expandedExperience,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedExperience = !_expandedExperience;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Qualifications",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title:
                              "Qualifications acquired other than your education",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildQualifications(),
                  isExpanded: _expandedQualifications,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedQualifications = !_expandedQualifications;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        ProfileItemCardMA(
                          title: "Hard Skills",
                          rightWidget: null,
                          callback: () {
                            if (kDebugMode) {
                              // print('Tap About');
                            }
                          },
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title:
                              "Hard skills refer to the technical knowledge or training you have gotten through experience. They are specific and essential to each job and are used for completing your tasks.",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildHardSkills(),
                  isExpanded: _expandedHardSkills,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedHardSkills = !_expandedHardSkills;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 2000),
              elevation: 0.0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Soft Skills",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileHeaderTextStyle,
                        ),
                        ProfileItemCardMA(
                          title:
                              "Soft skills, on the other hand, are attributes and habits that describe how you work individually or with others. They are not specific to a job, but indirectly help you adapt to the work environment and company culture.",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderDetailTextStyle,
                        ),
                      ],
                    );
                  },
                  body: buildSoftSkills(),
                  isExpanded: _expandedSoftSkills,
                  canTapOnHeader: true,
                ),
              ],
              expansionCallback: (int index, bool isExpanded) {
                _expandedSoftSkills = !_expandedSoftSkills;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  ///------------------------------------- PERSONAL INFORMATION -------------------------------------///

  bool _expandedPersonalInformation = false;

  buildPersonalInformation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ProfileItemCardMA(
            title: "First name",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.firstName == null
                ? ''
                : readUserJsonFileContent.firstName!,
            onChanged: (firstName) {
              setState(() {
                firstName == ""
                    ? readUserJsonFileContent.firstName = null
                    : readUserJsonFileContent.firstName = firstName;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Last name",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.lastName == null
                ? ''
                : readUserJsonFileContent.lastName!,
            onChanged: (lastName) {
              setState(() {
                lastName == ""
                    ? readUserJsonFileContent.lastName = null
                    : readUserJsonFileContent.lastName = lastName;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Username",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.username == null
                ? ''
                : readUserJsonFileContent.username!,
            onChanged: (username) {
              setState(() {
                username == ""
                    ? readUserJsonFileContent.username = null
                    : readUserJsonFileContent.username = username;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Nationality",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.nationality == null
                ? ''
                : readUserJsonFileContent.nationality!,
            onChanged: (nationality) {
              setState(() {
                nationality == ""
                    ? readUserJsonFileContent.nationality = null
                    : readUserJsonFileContent.nationality = nationality;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          ProfileItemCardMA(
            title: "Date of birth",
            rightWidget: SizedBox(
              width: MediaQuery.of(context).size.width * 0.275,
              child: CupertinoDateTextBox(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: DynamicTheme.of(context)?.brightness == Brightness.light
                    ? Colors.grey[700]!
                    : Colors.grey[400]!,
                initialValue: readUserJsonFileContent.dateOfBirth == null
                    ? DateTime.now()
                    : DateFormat("yyyy-MM-dd")
                        .parse(readUserJsonFileContent.dateOfBirth!),
                onDateChange: (DateTime? newDate) {
                  //print(newDate);
                  setState(() {
                    newDate == DateTime.now()
                        ? readUserJsonFileContent.dateOfBirth = null
                        : readUserJsonFileContent.dateOfBirth =
                            newDate!.toIso8601String();
                  });
                },
                hintText: readUserJsonFileContent.dateOfBirth == null
                    ? DateFormat().format(DateTime.now())
                    : readUserJsonFileContent.dateOfBirth!,
              ),
            ),
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          ProfileItemCardMA(
            title: "Gender",
            rightWidget: SizedBox(
              width: 180,
              height: 60,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter dropDownState) {
                    return DropdownSearch<String>(
                      popupElevation: 0.0,
                      showClearButton: true,
                      //clearButtonProps: ,
                      dropdownSearchDecoration:
                       InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily:
                          'Montserrat',
                          letterSpacing: 3,
                        ),

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColour,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColour,
                        width: 0.5,
                      ),
                    ),
                  ),
                  //mode of dropdown
                  mode: Mode.MENU,
                  //to show search box
                  showSearchBox: true,
                  //list of dropdown items
                  items: genderList,
                  onChanged: (String? newValue) {
                    dropDownState(() {
                      newValue == ""
                          ? readUserJsonFileContent.gender = null
                          : readUserJsonFileContent.gender = newValue;
                    });
                  },
                  //show selected item
                  selectedItem: readUserJsonFileContent.gender == null
                      ? ""
                      : readUserJsonFileContent.gender!,
                );
              }),
            ),
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          const ProfileItemCardMA(
            title: "Personal email",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.personalEmail == null
                ? ''
                : readUserJsonFileContent.personalEmail!,
            onChanged: (personalEmail) {
              setState(() {
                personalEmail == ""
                    ? readUserJsonFileContent.personalEmail = null
                    : readUserJsonFileContent.personalEmail = personalEmail;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Phone number",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.phoneNumber == null
                ? ''
                : readUserJsonFileContent.phoneNumber!,
            onChanged: (phoneNumber) {
              setState(() {
                phoneNumber == ""
                    ? readUserJsonFileContent.phoneNumber = null
                    : readUserJsonFileContent.phoneNumber = phoneNumber;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Optional Phone number",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.optionalPhoneNumber == null
                ? ''
                : readUserJsonFileContent.optionalPhoneNumber!,
            onChanged: (optionalPhoneNumber) {
              setState(() {
                optionalPhoneNumber == ""
                    ? readUserJsonFileContent.optionalPhoneNumber = null
                    : readUserJsonFileContent.optionalPhoneNumber =
                        optionalPhoneNumber;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "User Model ID",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.userID == null
                ? ''
                : readUserJsonFileContent.userID!,
            onChanged: (userID) {
              setState(() {
                userID == ""
                    ? readUserJsonFileContent.userID = null
                    : readUserJsonFileContent.userID = userID;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
        ],
      );

  ///------------------------------------- GENERAL WORK INFORMATION -------------------------------------///

  List<String> jobFieldList = [];
  List<String> jobSubFieldList = [];
  List<String> jobSpecializationList = [];

  bool _expandedGeneral = false;

  buildGeneral() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ProfileItemCardMA(
            title: "Country of employment",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.countryOfEmployment == null
                ? ''
                : readUserJsonFileContent.countryOfEmployment!,
            onChanged: (countryOfEmployment) {
              setState(() {
                countryOfEmployment == ""
                    ? readUserJsonFileContent.countryOfEmployment = null
                    : readUserJsonFileContent.countryOfEmployment =
                        countryOfEmployment;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Work email",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.workEmail == null
                ? ''
                : readUserJsonFileContent.workEmail!,
            onChanged: (workEmail) {
              setState(() {
                workEmail == ""
                    ? readUserJsonFileContent.workEmail = null
                    : readUserJsonFileContent.workEmail = workEmail;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Job Department",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.jobDepartment == null
                ? ''
                : readUserJsonFileContent.jobDepartment!,
            onChanged: (jobDepartment) {
              setState(() {
                jobDepartment == ""
                    ? readUserJsonFileContent.jobDepartment = null
                    : readUserJsonFileContent.jobDepartment = jobDepartment;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          const ProfileItemCardMA(
            title: "Department Team",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.jobTeam == null
                ? ''
                : readUserJsonFileContent.jobTeam!,
            onChanged: (jobTeam) {
              setState(() {
                jobTeam == ""
                    ? readUserJsonFileContent.jobTeam = null
                    : readUserJsonFileContent.jobTeam = jobTeam;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1.0),
            child: FutureBuilder(
              future: readHardSkillsInformationJsonData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        const ProfileItemCardMA(
                          title: "Job Field",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 6,
                            bottom: 6,
                          ),
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter dropDownState) {
                                      return DropdownSearch<String>(
                                        popupElevation: 0.0,
                                        showClearButton: true,
                                        //clearButtonProps: ,
                                        dropdownSearchDecoration:
                                        InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily:
                                            'Montserrat',
                                            letterSpacing: 3,
                                          ),

                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: jobFieldList,
                                    onChanged: (String? newJobFieldValue) {
                                      dropDownState(() {
                                        setState(() {
                                          readUserJsonFileContent.jobField =
                                              newJobFieldValue!;

                                          jobSubFieldList = [];
                                          jobSpecializationList = [];
                                          typeOfSpecializationList = [];
                                          hardSkillCategoryList = [];
                                          hardSkillList = [];

                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                          if (newJobFieldValue == null) {

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
                                                if (jobSubFieldList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .jobSubField!)) {
                                                  jobSubFieldList;
                                                } else {
                                                  jobSubFieldList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .jobSubField!);
                                                }
                                              } else {
                                                jobSubFieldList;
                                              }

                                              /// Specialization
                                              if (readHardSkillsJsonFileContent[
                                                          i]
                                                      .jobSpecialization !=
                                                  null) {
                                                if (jobSpecializationList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .jobSpecialization!)) {
                                                  jobSpecializationList;
                                                } else {
                                                  jobSpecializationList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .jobSpecialization!);
                                                }
                                              } else {
                                                jobSpecializationList;
                                              }

                                              /// Type of Specialization
                                              if (readHardSkillsJsonFileContent[
                                                          i]
                                                      .typeOfSpecialization !=
                                                  null) {
                                                if (typeOfSpecializationList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (readHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add( readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (readHardSkillsJsonFileContent[
                                                              i]
                                                          .hardSkill !=
                                                      null) {
                                                    if (hardSkillList[j].contains(
                                                        readHardSkillsJsonFileContent[
                                                                i]
                                                            .hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(
                                                          readHardSkillsJsonFileContent[
                                                                  i]
                                                              .hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }
                                            }
                                          } else {

                                            var filterHardSkillsList = readHardSkillsJsonFileContent.where((element) => element.jobField == newJobFieldValue).toList();

                                            for (int i = 0; i < filterHardSkillsList.length; i++) {
                                              /// Sub Field
                                              if (filterHardSkillsList[i].jobSubField != null) {
                                                if (jobSubFieldList.contains(filterHardSkillsList[i].jobSubField!)) {
                                                  jobSubFieldList;
                                                } else {
                                                  jobSubFieldList.add(filterHardSkillsList[i].jobSubField!);
                                                }
                                              } else {
                                                jobSubFieldList;
                                              }

                                              /// Specialization
                                              if (filterHardSkillsList[i].jobSpecialization != null) {
                                                if (jobSpecializationList.contains(filterHardSkillsList[i].jobSpecialization!)) {
                                                  jobSpecializationList;
                                                } else {
                                                  jobSpecializationList.add(filterHardSkillsList[i].jobSpecialization!);
                                                }
                                              } else {
                                                jobSpecializationList;
                                              }

                                              /// Type of Specialization
                                              if (filterHardSkillsList[i].typeOfSpecialization != null) {
                                                if (typeOfSpecializationList.contains(filterHardSkillsList[i].typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(filterHardSkillsList[i].typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (filterHardSkillsList[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(filterHardSkillsList[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add(filterHardSkillsList[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (filterHardSkillsList[i].hardSkill != null) {
                                                    if (hardSkillList[j].contains(filterHardSkillsList[i].hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(filterHardSkillsList[i].hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        });
                                      });
                                    },
                                    selectedItem:
                                        readUserJsonFileContent.jobField == null
                                            ? "Job Field"
                                            : readUserJsonFileContent.jobField!,
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                        const ProfileItemCardMA(
                          title: "Job Sub-Field",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 6,
                            bottom: 6,
                          ),
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter dropDownState) {
                                      return DropdownSearch<String>(
                                        popupElevation: 0.0,
                                        showClearButton: true,
                                        //clearButtonProps: ,
                                        dropdownSearchDecoration:
                                        InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily:
                                            'Montserrat',
                                            letterSpacing: 3,
                                          ),

                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: jobSubFieldList,
                                    onChanged: (String? newJobSubFieldValue) {
                                      dropDownState(() {
                                        setState(() {
                                          readUserJsonFileContent.jobSubField =
                                              newJobSubFieldValue!;

                                          jobSpecializationList = [];
                                          typeOfSpecializationList = [];
                                          hardSkillCategoryList = [];
                                          hardSkillList = [];

                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                          if (newJobSubFieldValue == null) {

                                            for (int i = 0; i < readHardSkillsJsonFileContent.length; i++) {
                                              /// Specialization
                                              if (readHardSkillsJsonFileContent[
                                                          i]
                                                      .jobSpecialization !=
                                                  null) {
                                                if (jobSpecializationList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .jobSpecialization!)) {
                                                  jobSpecializationList;
                                                } else {
                                                  jobSpecializationList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .jobSpecialization!);
                                                }
                                              } else {
                                                jobSpecializationList;
                                              }

                                              /// Type of Specialization
                                              if (readHardSkillsJsonFileContent[
                                                          i]
                                                      .typeOfSpecialization !=
                                                  null) {
                                                if (typeOfSpecializationList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (readHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add(readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (readHardSkillsJsonFileContent[i].hardSkill != null) {
                                                    if (hardSkillList[j].contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }

                                            }
                                          }
                                          else {

                                            var filterHardSkillsList =
                                                readHardSkillsJsonFileContent
                                                    .where((element) =>
                                                        element.jobSubField ==
                                                            newJobSubFieldValue &&
                                                        element.jobField ==
                                                            readUserJsonFileContent
                                                                .jobField)
                                                    .toList();

                                            for (int i = 0;
                                                i < filterHardSkillsList.length;
                                                i++) {
                                              /// Specialization
                                              if (filterHardSkillsList[i]
                                                      .jobSpecialization !=
                                                  null) {
                                                if (jobSpecializationList.contains(
                                                    filterHardSkillsList[i]
                                                        .jobSpecialization!)) {
                                                  jobSpecializationList;
                                                } else {
                                                  jobSpecializationList.add(
                                                      filterHardSkillsList[i]
                                                          .jobSpecialization!);
                                                }
                                              } else {
                                                jobSpecializationList;
                                              }

                                              /// Type of Specialization
                                              if (filterHardSkillsList[i]
                                                      .typeOfSpecialization !=
                                                  null) {
                                                if (typeOfSpecializationList
                                                    .contains(filterHardSkillsList[
                                                            i]
                                                        .typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(
                                                      filterHardSkillsList[i]
                                                          .typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (filterHardSkillsList[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(filterHardSkillsList[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add(filterHardSkillsList[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (filterHardSkillsList[i].hardSkill != null) {
                                                    if (hardSkillList[j].contains(filterHardSkillsList[i].hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(filterHardSkillsList[i].hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        });
                                      });
                                    },
                                    selectedItem: readUserJsonFileContent
                                                .jobSubField ==
                                            null
                                        ? "Job Sub-Field"
                                        : readUserJsonFileContent.jobSubField!,
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                        const ProfileItemCardMA(
                          title: "Job Specialization",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 6,
                            bottom: 6,
                          ),
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter dropDownState) {
                                      return DropdownSearch<String>(
                                        popupElevation: 0.0,
                                        showClearButton: true,
                                        //clearButtonProps: ,
                                        dropdownSearchDecoration:
                                        InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily:
                                            'Montserrat',
                                            letterSpacing: 3,
                                          ),

                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: primaryColour,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                    //mode of dropdown
                                    mode: Mode.MENU,
                                    //to show search box
                                    showSearchBox: true,
                                    //list of dropdown items
                                    items: jobSpecializationList,
                                    onChanged:
                                        (String? newJobSpecializationValue) {
                                      dropDownState(() {
                                        setState(() {
                                          readUserJsonFileContent.jobSpecialization = newJobSpecializationValue!;

                                          typeOfSpecializationList = [];
                                          hardSkillCategoryList = [];
                                          hardSkillList = [];

                                          /// CHANGE: jobSubFieldList based on Job Field Value
                                          if (newJobSpecializationValue == null) {

                                            for (int i = 0; i <
                                                    readHardSkillsJsonFileContent
                                                        .length;
                                                i++) {
                                              /// Type of Specialization
                                              if (readHardSkillsJsonFileContent[
                                                          i]
                                                      .typeOfSpecialization !=
                                                  null) {
                                                if (typeOfSpecializationList.contains(
                                                    readHardSkillsJsonFileContent[
                                                            i]
                                                        .typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(
                                                      readHardSkillsJsonFileContent[
                                                              i]
                                                          .typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (readHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add(readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (readHardSkillsJsonFileContent[i].hardSkill != null) {
                                                    if (hardSkillList[j].contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }

                                            }
                                          }
                                          else {

                                            var filterHardSkillsList =
                                                readHardSkillsJsonFileContent
                                                    .where((element) =>
                                                        element.jobSubField ==
                                                            newJobSpecializationValue &&
                                                        element.jobField ==
                                                            readUserJsonFileContent
                                                                .jobField)
                                                    .toList();

                                            for (int i = 0;
                                                i < filterHardSkillsList.length;
                                                i++) {
                                              /// Type of Specialization
                                              if (filterHardSkillsList[i]
                                                      .typeOfSpecialization !=
                                                  null) {
                                                if (typeOfSpecializationList
                                                    .contains(filterHardSkillsList[
                                                            i]
                                                        .typeOfSpecialization!)) {
                                                  typeOfSpecializationList;
                                                } else {
                                                  typeOfSpecializationList.add(
                                                      filterHardSkillsList[i]
                                                          .typeOfSpecialization!);
                                                }
                                              } else {
                                                typeOfSpecializationList;
                                              }

                                              if (readUserJsonFileContent.hardSkills ==  null) {
                                                hardSkillCategoryList = [];
                                                hardSkillList = [];
                                              } else {
                                                /// Hard Skill Category AND Hard Skill
                                                for (int j = 0; j < readUserJsonFileContent.hardSkills!.length; j++) {
                                                  /// Hard Skill Category
                                                  if (filterHardSkillsList[i].hardSkillCategory != null) {
                                                    if (hardSkillCategoryList[j].contains(filterHardSkillsList[i].hardSkillCategory!)) {
                                                      hardSkillCategoryList[j];
                                                    } else {
                                                      hardSkillCategoryList[j].add(filterHardSkillsList[i].hardSkillCategory!);
                                                    }
                                                  } else {
                                                    hardSkillCategoryList[j];
                                                  }

                                                  /// Hard Skill
                                                  if (filterHardSkillsList[i].hardSkill != null) {
                                                    if (hardSkillList[j].contains(filterHardSkillsList[i].hardSkill!)) {
                                                      hardSkillList[j];
                                                    } else {
                                                      hardSkillList[j].add(filterHardSkillsList[i].hardSkill!);
                                                    }
                                                  } else {
                                                    hardSkillList[j];
                                                  }
                                                }
                                              }

                                            }
                                          }
                                        });
                                      });
                                    },
                                    selectedItem: readUserJsonFileContent
                                                .jobSpecialization ==
                                            null
                                        ? "Job Specialization"
                                        : readUserJsonFileContent
                                            .jobSpecialization!,
                                  );
                                }),
                              )
                            ],
                          ),
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
          ),
          const ProfileItemCardMA(
            title: "Job Title",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          EditProfileItemCardMA(
            text: readUserJsonFileContent.jobTitle == null
                ? ''
                : readUserJsonFileContent.jobTitle!,
            onChanged: (jobTitle) {
              setState(() {
                jobTitle == ""
                    ? readUserJsonFileContent.jobTitle = null
                    : readUserJsonFileContent.jobTitle = jobTitle;
              });
            },
            textStyle: kProfileBodyTextStyle,
            callback: () {},
            rightWidget: null,
          ),
          ProfileItemCardMA(
            title: "Contract Type",
            rightWidget: SizedBox(
              width: 180,
              height: 60,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter dropDownState) {
                    return DropdownSearch<String>(
                      popupElevation: 0.0,
                      showClearButton: true,
                      //clearButtonProps: ,
                      dropdownSearchDecoration:
                      InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily:
                          'Montserrat',
                          letterSpacing: 3,
                        ),

                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                      ),
                  //mode of dropdown
                  mode: Mode.MENU,
                  //to show search box
                  showSearchBox: true,
                  //list of dropdown items
                  items: contractTypeList,
                  onChanged: (String? jobContractType) {
                    dropDownState(() {
                      jobContractType == ""
                          ? readUserJsonFileContent.jobContractType = null
                          : readUserJsonFileContent.jobContractType =
                              jobContractType;
                    });
                  },
                  //show selected item
                  selectedItem: readUserJsonFileContent.jobContractType == null
                      ? ""
                      : readUserJsonFileContent.jobContractType!,
                );
              }),
            ),
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          ProfileItemCardMA(
            title: "Contract Expiration Date",
            rightWidget: SizedBox(
              width: MediaQuery.of(context).size.width * 0.275,
              child: CupertinoDateTextBox(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: DynamicTheme.of(context)?.brightness == Brightness.light
                    ? Colors.grey[700]!
                    : Colors.grey[400]!,
                initialValue:
                    readUserJsonFileContent.jobContractExpirationDate == null
                        ? DateTime.now()
                        : DateFormat("yyyy-MM-dd").parse(
                            readUserJsonFileContent.jobContractExpirationDate!),
                onDateChange: (DateTime? newDate) {
                  //print(newDate);
                  setState(() {
                    newDate == DateTime.now()
                        ? readUserJsonFileContent.jobContractExpirationDate =
                            null
                        : readUserJsonFileContent.jobContractExpirationDate =
                            newDate!.toIso8601String();
                  });
                },
                hintText:
                    readUserJsonFileContent.jobContractExpirationDate == null
                        ? DateFormat().format(DateTime.now())
                        : readUserJsonFileContent.jobContractExpirationDate!,
              ),
            ),
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
        ],
      );

  ///------------------------------------- LANGUAGE -------------------------------------///

  bool _expandedLanguages = false;

  buildLanguages() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Language",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.languages == null
                          ? readUserJsonFileContent.languages =
                              <LanguageModel>[]
                          : readUserJsonFileContent.languages!;

                      readUserJsonFileContent.languages!.add(LanguageModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  // print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.languages == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.languages!.length *
                        MediaQuery.of(context).size.height *
                        0.2,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.languages!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Language ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.languages!.remove(
                                          readUserJsonFileContent
                                              .languages![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.075,
                                      width: MediaQuery.of(context).size.width * 0.405,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: StatefulBuilder(
                                                builder: (BuildContext context, StateSetter dropDownState) {
                                                  return DropdownSearch<String>(
                                                    popupElevation: 0.0,
                                                    showClearButton: true,
                                                    //clearButtonProps: ,
                                                    dropdownSearchDecoration:
                                                    InputDecoration(
                                                      labelStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                        fontFamily:
                                                        'Montserrat',
                                                        letterSpacing: 3,
                                                      ),

                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryColour,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryColour,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                //mode of dropdown
                                                mode: Mode.MENU,
                                                //to show search box
                                                showSearchBox: true,
                                                //list of dropdown items
                                                items: languageList,
                                                onChanged: (String? newValue) {
                                                  dropDownState(() {
                                                    readUserJsonFileContent
                                                                .languages![
                                                                    index]
                                                                .language ==
                                                            "Language"
                                                        ? readUserJsonFileContent
                                                            .languages![index]
                                                            .language = null
                                                        : readUserJsonFileContent
                                                            .languages![index]
                                                            .language = newValue!;
                                                  });
                                                },
                                                selectedItem:
                                                    readUserJsonFileContent
                                                                .languages![
                                                                    index]
                                                                .language ==
                                                            null
                                                        ? "Language"
                                                        : readUserJsonFileContent
                                                            .languages![index]
                                                            .language!,
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.075,
                                      width: MediaQuery.of(context).size.width * 0.44,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: StatefulBuilder(
                                                builder: (BuildContext context, StateSetter dropDownState) {
                                                  return DropdownSearch<String>(
                                                    popupElevation: 0.0,
                                                    showClearButton: true,
                                                    //clearButtonProps: ,
                                                    dropdownSearchDecoration:
                                                    InputDecoration(
                                                      labelStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        'Montserrat',
                                                        letterSpacing: 3,
                                                      ),

                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryColour,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryColour,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                //mode of dropdown
                                                mode: Mode.MENU,
                                                //to show search box
                                                showSearchBox: true,
                                                //list of dropdown items
                                                items: languageLevelList,
                                                onChanged: (String? newValue) {
                                                  dropDownState(() {
                                                    readUserJsonFileContent
                                                                .languages![
                                                                    index]
                                                                .level ==
                                                            "Level"
                                                        ? readUserJsonFileContent
                                                            .languages![index]
                                                            .level = null
                                                        : readUserJsonFileContent
                                                            .languages![index]
                                                            .level = newValue!;
                                                  });
                                                },
                                                selectedItem:
                                                    readUserJsonFileContent
                                                                .languages![
                                                                    index]
                                                                .level ==
                                                            null
                                                        ? "Level"
                                                        : readUserJsonFileContent
                                                            .languages![index]
                                                            .level!,
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------------------------- EDUCATION -------------------------------------///

  bool _expandedEducation = false;

  buildEducation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildBachelorsEducation(),
          buildMastersEducation(),
          buildPHDEducation(),
          buildDoctoralEducation(),
        ],
      );

  ///------------------- BACHELORS -------------------///
  buildBachelorsEducation() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Bachelors",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.bachelors == null
                          ? readUserJsonFileContent.bachelors =
                              <EducationModel>[]
                          : readUserJsonFileContent.bachelors!;

                      readUserJsonFileContent.bachelors!.add(EducationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.bachelors == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.bachelors!.length *
                        MediaQuery.of(context).size.height *
                        1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.bachelors!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Bachelors ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.bachelors!.remove(
                                          readUserJsonFileContent
                                              .bachelors![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (discipline) {
                                  discipline == ""
                                      ? readUserJsonFileContent
                                          .bachelors![index].discipline = null
                                      : readUserJsonFileContent
                                          .bachelors![index]
                                          .discipline = discipline;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (institutionName) {
                                  institutionName == ""
                                      ? readUserJsonFileContent
                                          .bachelors![index]
                                          .institutionName = null
                                      : readUserJsonFileContent
                                          .bachelors![index]
                                          .institutionName = institutionName;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .bachelors![index].description = null
                                      : readUserJsonFileContent
                                          .bachelors![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .bachelors![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .bachelors![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .bachelors![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .bachelors![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .bachelors![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .bachelors![index].startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .bachelors![index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .bachelors![index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .bachelors![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                        .bachelors![index]
                                                        .endDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .bachelors![index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .bachelors![index].endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .bachelors![index].duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .bachelors![index].duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .bachelors![index].duration = null
                                          : readUserJsonFileContent
                                                  .bachelors![index].duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .bachelors![index].duration = null
                                          : readUserJsonFileContent
                                                  .bachelors![index].duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Transcript or Degree",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectBachelorsReferenceFile(
                                        readUserJsonFileContent
                                            .bachelors![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.bachelors![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .bachelors![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .bachelors![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.bachelors![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                        .bachelors![index]
                                                        .educationReferenceFileName =
                                                    null;
                                                readUserJsonFileContent
                                                        .bachelors![index]
                                                        .educationReferenceFile =
                                                    null;
                                                readUserJsonFileContent
                                                        .bachelors![index]
                                                        .educationReferenceSize =
                                                    null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _bachelorsReferenceFile;
  PlatformFile? _bachelorsReferencePlatformFile;

  selectBachelorsReferenceFile(EducationModel bachelorsReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _bachelorsReferenceFile = File(file.files.single.path!);
        _bachelorsReferencePlatformFile = file.files.first;
        bachelorsReference.educationReferenceFileName =
            _bachelorsReferencePlatformFile!.name;
        bachelorsReference.educationReferenceSize =
            _bachelorsReferencePlatformFile!.size;
        bachelorsReference.educationReferenceFile = base64Encode(
            Io.File(_bachelorsReferencePlatformFile!.path!).readAsBytesSync());
      });
    }
  }

  ///------------------- MASTERS -------------------///
  buildMastersEducation() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Masters",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.masters == null
                          ? readUserJsonFileContent.masters = <EducationModel>[]
                          : readUserJsonFileContent.masters!;

                      readUserJsonFileContent.masters!.add(EducationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.masters == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.masters!.length *
                        MediaQuery.of(context).size.height *
                        1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.masters!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Masters ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.masters!.remove(
                                          readUserJsonFileContent
                                              .masters![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (discipline) {
                                  discipline == ""
                                      ? readUserJsonFileContent
                                          .masters![index].discipline = null
                                      : readUserJsonFileContent.masters![index]
                                          .discipline = discipline;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (institutionName) {
                                  institutionName == ""
                                      ? readUserJsonFileContent.masters![index]
                                          .institutionName = null
                                      : readUserJsonFileContent.masters![index]
                                          .institutionName = institutionName;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .masters![index].description = null
                                      : readUserJsonFileContent.masters![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .masters![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .masters![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .masters![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .masters![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .masters![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .masters![index].startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .masters![index].endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .masters![index].endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .masters![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                        .masters![index]
                                                        .endDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .masters![index].endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .masters![index].endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .masters![index].duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .masters![index].duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .masters![index].duration = null
                                          : readUserJsonFileContent
                                                  .masters![index].duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .masters![index].duration = null
                                          : readUserJsonFileContent
                                                  .masters![index].duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Transcript or Degree",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectMastersReferenceFile(
                                        readUserJsonFileContent
                                            .masters![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.masters![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .masters![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .masters![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.masters![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                        .masters![index]
                                                        .educationReferenceFileName =
                                                    null;
                                                readUserJsonFileContent
                                                        .masters![index]
                                                        .educationReferenceFile =
                                                    null;
                                                readUserJsonFileContent
                                                        .masters![index]
                                                        .educationReferenceSize =
                                                    null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _mastersReferenceFile;
  PlatformFile? _mastersReferencePlatformFile;

  selectMastersReferenceFile(EducationModel mastersReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _mastersReferenceFile = File(file.files.single.path!);
        _mastersReferencePlatformFile = file.files.first;
        mastersReference.educationReferenceFileName =
            _mastersReferencePlatformFile!.name;
        mastersReference.educationReferenceSize =
            _mastersReferencePlatformFile!.size;
        mastersReference.educationReferenceFile = base64Encode(
            Io.File(_mastersReferencePlatformFile!.path!).readAsBytesSync());
      });
    }
  }

  ///------------------- PHD -------------------///
  buildPHDEducation() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "PHD",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.phd == null
                          ? readUserJsonFileContent.phd = <EducationModel>[]
                          : readUserJsonFileContent.phd!;

                      readUserJsonFileContent.phd!.add(EducationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.phd == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.phd!.length *
                        MediaQuery.of(context).size.height *
                        1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.phd!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "PHD ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.phd!.remove(
                                          readUserJsonFileContent.phd![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (discipline) {
                                  discipline == ""
                                      ? readUserJsonFileContent
                                          .phd![index].discipline = null
                                      : readUserJsonFileContent
                                          .phd![index].discipline = discipline;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (institutionName) {
                                  institutionName == ""
                                      ? readUserJsonFileContent
                                          .phd![index].institutionName = null
                                      : readUserJsonFileContent.phd![index]
                                          .institutionName = institutionName;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .phd![index].description = null
                                      : readUserJsonFileContent.phd![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .phd![index].startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .phd![index].startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .phd![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .phd![index].startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .phd![index].startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .phd![index].startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .phd![index].endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .phd![index].endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .phd![index].endDate = null
                                                : readUserJsonFileContent
                                                        .phd![index].endDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .phd![index].endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .phd![index].endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .phd![index].duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .phd![index].duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .phd![index].duration = null
                                          : readUserJsonFileContent
                                                  .phd![index].duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .phd![index].duration = null
                                          : readUserJsonFileContent
                                                  .phd![index].duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Transcript or Degree",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectPHDReferenceFile(
                                        readUserJsonFileContent.phd![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .phd![index].educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .phd![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .phd![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.phd![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                        .phd![index]
                                                        .educationReferenceFileName =
                                                    null;
                                                readUserJsonFileContent
                                                        .phd![index]
                                                        .educationReferenceFile =
                                                    null;
                                                readUserJsonFileContent
                                                        .phd![index]
                                                        .educationReferenceSize =
                                                    null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _phdReferenceFile;
  PlatformFile? _phdReferencePlatformFile;

  selectPHDReferenceFile(EducationModel phdReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _phdReferenceFile = File(file.files.single.path!);
        _phdReferencePlatformFile = file.files.first;
        phdReference.educationReferenceFileName =
            _phdReferencePlatformFile!.name;
        phdReference.educationReferenceSize = _phdReferencePlatformFile!.size;
        phdReference.educationReferenceFile = base64Encode(
            Io.File(_phdReferencePlatformFile!.path!).readAsBytesSync());
      });
    }
  }

  ///------------------- DOCTORAL -------------------///
  buildDoctoralEducation() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Doctoral",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.doctoral == null
                          ? readUserJsonFileContent.doctoral =
                              <EducationModel>[]
                          : readUserJsonFileContent.doctoral!;

                      readUserJsonFileContent.doctoral!.add(EducationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  // print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.doctoral == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.doctoral!.length *
                        MediaQuery.of(context).size.height *
                        1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.doctoral!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Doctoral ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.doctoral!.remove(
                                          readUserJsonFileContent
                                              .doctoral![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (discipline) {
                                  discipline == ""
                                      ? readUserJsonFileContent
                                          .doctoral![index].discipline = null
                                      : readUserJsonFileContent.doctoral![index]
                                          .discipline = discipline;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (institutionName) {
                                  institutionName == ""
                                      ? readUserJsonFileContent.doctoral![index]
                                          .institutionName = null
                                      : readUserJsonFileContent.doctoral![index]
                                          .institutionName = institutionName;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .doctoral![index].description = null
                                      : readUserJsonFileContent.doctoral![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .doctoral![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .doctoral![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .doctoral![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .doctoral![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .doctoral![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .doctoral![index].startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .doctoral![index].endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .doctoral![index].endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .doctoral![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                        .doctoral![index]
                                                        .endDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .doctoral![index].endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .doctoral![index].endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .doctoral![index].duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .doctoral![index].duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .doctoral![index].duration = null
                                          : readUserJsonFileContent
                                                  .doctoral![index].duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .doctoral![index].duration = null
                                          : readUserJsonFileContent
                                                  .doctoral![index].duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Transcript or Degree",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectDoctoralReferenceFile(
                                        readUserJsonFileContent
                                            .doctoral![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.doctoral![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .doctoral![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .doctoral![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.doctoral![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                        .doctoral![index]
                                                        .educationReferenceFileName =
                                                    null;
                                                readUserJsonFileContent
                                                        .doctoral![index]
                                                        .educationReferenceFile =
                                                    null;
                                                readUserJsonFileContent
                                                        .doctoral![index]
                                                        .educationReferenceSize =
                                                    null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _doctoralReferenceFile;
  PlatformFile? _doctoralReferencePlatformFile;

  selectDoctoralReferenceFile(EducationModel doctoralReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _doctoralReferenceFile = File(file.files.single.path!);
        _doctoralReferencePlatformFile = file.files.first;
        doctoralReference.educationReferenceFileName =
            _doctoralReferencePlatformFile!.name;
        doctoralReference.educationReferenceSize =
            _doctoralReferencePlatformFile!.size;
        doctoralReference.educationReferenceFile = base64Encode(
            Io.File(_doctoralReferencePlatformFile!.path!).readAsBytesSync());
      });
    }
  }

  ///------------------------------------- EXPERIENCE -------------------------------------///

  bool _expandedExperience = false;

  buildExperience() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildWorkExperience(),
          buildVolunteerExperience(),
          ProfileItemCardMA(
            title: "C.V.",
            rightWidget: IconButton(
              icon: Icon(
                Icons.attach_file_outlined,
                color: Colors.grey[600],
              ),
              onPressed: () {
                selectCVFile();
              },
            ),
            callback: null,
            textStyle: kProfileMidSubHeaderTextStyle,
          ),
          readUserJsonFileContent.cvFile == null
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 6,
                    bottom: 6,
                  ),
                  color:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.white
                          : Colors.black12,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.125,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              readUserJsonFileContent.cvName!
                                          .toString()
                                          .split('.')
                                          .last ==
                                      "pdf"
                                  ? pdfLogo
                                  : fileLogo,
                              width: 70,
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              readUserJsonFileContent.cvName!,
                              style: kProfileSubHeaderTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${(readUserJsonFileContent.cvSize! / 1024).ceil()} KB',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            readUserJsonFileContent.cvName = null;
                            readUserJsonFileContent.cvFile = null;
                            readUserJsonFileContent.cvSize = null;
                          });
                        },
                      )
                    ],
                  ),
                ),
        ],
      );

  ///------------------- WORK EXPERIENCE -------------------///
  buildWorkExperience() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Work Experience",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.workExperience == null
                          ? readUserJsonFileContent.workExperience =
                              <WorkExperienceModel>[]
                          : readUserJsonFileContent.workExperience!;

                      readUserJsonFileContent.workExperience!.add(WorkExperienceModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  // print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.workExperience == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.workExperience!.length *
                        MediaQuery.of(context).size.height *
                        1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.workExperience!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Work Experience ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.workExperience!
                                          .remove(readUserJsonFileContent
                                              .workExperience![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Job Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (jobTitle) {
                                  jobTitle == ""
                                      ? readUserJsonFileContent
                                          .workExperience![index]
                                          .jobTitle = null
                                      : readUserJsonFileContent
                                          .workExperience![index]
                                          .jobTitle = jobTitle;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Work Place",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (workArea) {
                                  workArea == ""
                                      ? readUserJsonFileContent
                                          .workExperience![index]
                                          .workArea = null
                                      : readUserJsonFileContent
                                          .workExperience![index]
                                          .workArea = workArea;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Job Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (jobDescription) {
                                  jobDescription == ""
                                      ? readUserJsonFileContent
                                          .workExperience![index]
                                          .jobDescription = null
                                      : readUserJsonFileContent
                                          .workExperience![index]
                                          .jobDescription = jobDescription;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .workExperience![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .workExperience![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .workExperience![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .workExperience![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .workExperience![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .workExperience![index]
                                                .startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .workExperience![index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .workExperience![index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .workExperience![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                        .workExperience![index]
                                                        .endDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .workExperience![index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .workExperience![index]
                                                .endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .workExperience![index]
                                                .duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .workExperience![index].duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .workExperience![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .workExperience![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .workExperience![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .workExperience![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Reference",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Written By",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (referenceBy) {
                                  readUserJsonFileContent.workExperience![index].referenceBy = referenceBy;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Phone Number",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (referencePhoneNumber) {
                                  readUserJsonFileContent.workExperience![index]
                                          .referencePhoneNumber =
                                      referencePhoneNumber;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Email Address",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (referenceEmailAddress) {
                                  readUserJsonFileContent.workExperience![index]
                                          .referenceEmailAddress =
                                      referenceEmailAddress;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectWorkExperienceReferenceFile(
                                        readUserJsonFileContent
                                            .workExperience![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.workExperience![index]
                                          .referenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .workExperience![
                                                                  index]
                                                              .referenceName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .workExperience![index]
                                                      .referenceName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.workExperience![index].referenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .workExperience![index]
                                                    .referenceName = null;
                                                readUserJsonFileContent
                                                    .workExperience![index]
                                                    .referenceFile = null;
                                                readUserJsonFileContent
                                                    .workExperience![index]
                                                    .referenceSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _workExperienceReferenceFile;
  PlatformFile? _workExperienceReferencePlatformFile;

  selectWorkExperienceReferenceFile(WorkExperienceModel workReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _workExperienceReferenceFile = File(file.files.single.path!);
        _workExperienceReferencePlatformFile = file.files.first;
        workReference.referenceName =
            _workExperienceReferencePlatformFile!.name;
        workReference.referenceSize =
            _workExperienceReferencePlatformFile!.size;
        workReference.referenceFile = base64Encode(
            Io.File(_workExperienceReferencePlatformFile!.path!)
                .readAsBytesSync());
      });
    }
  }

  ///------------------- VOLUNTEER EXPERIENCE -------------------///
  buildVolunteerExperience() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Volunteer Experience",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.volunteerExperience == null
                          ? readUserJsonFileContent.volunteerExperience =
                              <VolunteerExperienceModel>[]
                          : readUserJsonFileContent.volunteerExperience!;

                      readUserJsonFileContent.volunteerExperience!.add(VolunteerExperienceModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  // print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.volunteerExperience == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.volunteerExperience!.length *
                            MediaQuery.of(context).size.height *
                            1.1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.volunteerExperience!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Volunteer Experience ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .volunteerExperience!
                                          .remove(readUserJsonFileContent
                                              .volunteerExperience![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (title) {
                                  title == ""
                                      ? readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .title = null
                                      : readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .title = title;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Work Place",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (workArea) {
                                  workArea == ""
                                      ? readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .workArea = null
                                      : readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .workArea = workArea;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .description = null
                                      : readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .volunteerExperience![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .volunteerExperience![index]
                                                .startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .endDate = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .volunteerExperience![index]
                                                .endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .volunteerExperience![index]
                                                .duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .volunteerExperience![index]
                                            .duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .volunteerExperience![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .volunteerExperience![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .volunteerExperience![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .volunteerExperience![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Reference",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Written By",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (jobDescription) {
                                  readUserJsonFileContent
                                      .volunteerExperience![index]
                                      .referenceBy = jobDescription;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Phone Number",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (referencePhoneNumber) {
                                  readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .referencePhoneNumber =
                                      referencePhoneNumber;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Email Address",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (referenceEmailAddress) {
                                  readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .referenceEmailAddress =
                                      referenceEmailAddress;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectVolunteerExperienceReferenceFile(
                                        readUserJsonFileContent
                                            .volunteerExperience![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .referenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .volunteerExperience![
                                                                  index]
                                                              .referenceName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .volunteerExperience![
                                                          index]
                                                      .referenceName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.volunteerExperience![index].referenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .referenceName = null;
                                                readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .referenceFile = null;
                                                readUserJsonFileContent
                                                    .volunteerExperience![index]
                                                    .referenceSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  /// EXPERIENCE ~ VOLUNTEER EXPERIENCE ~ REFERENCES

  File? _volunteerExperienceReferenceFile;
  PlatformFile? _volunteerExperienceReferencePlatformFile;

  selectVolunteerExperienceReferenceFile(
      VolunteerExperienceModel volunteerReference) async {
    /// Upload Reference File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _volunteerExperienceReferenceFile = File(file.files.single.path!);
        _volunteerExperienceReferencePlatformFile = file.files.first;
        volunteerReference.referenceName =
            _volunteerExperienceReferencePlatformFile!.name;
        volunteerReference.referenceSize =
            _volunteerExperienceReferencePlatformFile!.size;
        volunteerReference.referenceFile = base64Encode(
            Io.File(_volunteerExperienceReferencePlatformFile!.path!)
                .readAsBytesSync());
      });
    }
  }

  ///------------------- CV -------------------///

  File? _cvFile;
  PlatformFile? _cvPlatformFile;

  selectCVFile() async {
    /// Upload CV File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _cvFile = File(file.files.single.path!);
        _cvPlatformFile = file.files.first;
        readUserJsonFileContent.cvName = _cvPlatformFile!.name;
        readUserJsonFileContent.cvSize = _cvPlatformFile!.size;
        readUserJsonFileContent.cvFile =
            base64Encode(Io.File(_cvPlatformFile!.path!).readAsBytesSync());
        // print(_cvPlatformFile!.extension);
      });
    }
  }

  cvBottomSheet(context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose File(s)",
            style: TextStyle(
              fontSize: 20.0,
              color: primaryColour,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.insert_drive_file, color: primaryColour),
                onPressed: () => null, //_pickFiles(),
                label: Text('Pick file(s)',
                    style: TextStyle(color: primaryColour)),
              ),
              const SizedBox(width: 5),
              TextButton.icon(
                icon: Icon(Icons.folder, color: primaryColour),
                onPressed: () => null, //_selectFolder(),
                label:
                    Text('Pick folder', style: TextStyle(color: primaryColour)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///------------------------------------- QUALIFICATIONS -------------------------------------///

  bool _expandedQualifications = false;

  buildQualifications() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildProfessionalQualifications(),
          buildEducationalQualifications(),
          buildOtherQualifications(),
        ],
      );

  ///------------------- PROFESSIONAL QUALIFICATIONS -------------------///
  buildProfessionalQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Professional Qualifications",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.professionalQualifications == null
                          ? readUserJsonFileContent.professionalQualifications =
                              <QualificationModel>[]
                          : readUserJsonFileContent.professionalQualifications!;

                      readUserJsonFileContent.professionalQualifications!.add(QualificationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.professionalQualifications == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .professionalQualifications!.length *
                        MediaQuery.of(context).size.height *
                        1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .professionalQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title:
                                    "Professional Qualification ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .professionalQualifications!
                                          .remove(readUserJsonFileContent
                                                  .professionalQualifications![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (title) {
                                  title == ""
                                      ? readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .title = null
                                      : readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .title = title;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (obtainedFrom) {
                                  obtainedFrom == ""
                                      ? readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .obtainedFrom = null
                                      : readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .obtainedFrom = obtainedFrom;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .description = null
                                      : readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .professionalQualifications![
                                                            index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .professionalQualifications![
                                                    index]
                                                .startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .endDate = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .professionalQualifications![
                                                    index]
                                                .endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .professionalQualifications![
                                                    index]
                                                .duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .professionalQualifications![index]
                                            .duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .professionalQualifications![
                                                  index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .professionalQualifications![
                                                      index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .professionalQualifications![
                                                  index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .professionalQualifications![
                                                      index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectProfessionalQualificationsFile(
                                        readUserJsonFileContent
                                                .professionalQualifications![
                                            index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .professionalQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .professionalQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.professionalQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _professionalQualificationsFile;
  PlatformFile? _professionalQualificationsPlatformFile;

  selectProfessionalQualificationsFile(QualificationModel certificate) async {
    /// Upload Professional Qualification File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _professionalQualificationsFile = File(file.files.single.path!);
        _professionalQualificationsPlatformFile = file.files.first;
        certificate.qualificationFileName =
            _professionalQualificationsPlatformFile!.name;
        certificate.qualificationSize =
            _professionalQualificationsPlatformFile!.size;
        certificate.qualificationFile = base64Encode(
            Io.File(_professionalQualificationsPlatformFile!.path!)
                .readAsBytesSync());
      });
    }
  }

  ///------------------- EDUCATIONAL QUALIFICATIONS -------------------///
  buildEducationalQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Educational Qualifications",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.educationalQualifications == null
                          ? readUserJsonFileContent.educationalQualifications =
                              <QualificationModel>[]
                          : readUserJsonFileContent.educationalQualifications!;

                      readUserJsonFileContent.educationalQualifications!.add(QualificationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.educationalQualifications == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .educationalQualifications!.length *
                        MediaQuery.of(context).size.height *
                        1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .educationalQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Educational Qualification ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .educationalQualifications!
                                          .remove(readUserJsonFileContent
                                                  .educationalQualifications![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (title) {
                                  title == ""
                                      ? readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .title = null
                                      : readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .title = title;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (obtainedFrom) {
                                  obtainedFrom == ""
                                      ? readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .obtainedFrom = null
                                      : readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .obtainedFrom = obtainedFrom;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .description = null
                                      : readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .educationalQualifications![
                                                            index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .educationalQualifications![
                                                    index]
                                                .startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .endDate = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .educationalQualifications![
                                                    index]
                                                .endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .educationalQualifications![
                                                    index]
                                                .duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .educationalQualifications![index]
                                            .duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .educationalQualifications![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                              .educationalQualifications![index]
                                              .duration = double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .educationalQualifications![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                              .educationalQualifications![index]
                                              .duration = double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectEducationalQualificationFile(
                                        readUserJsonFileContent
                                            .educationalQualifications![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .educationalQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .educationalQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.educationalQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _educationalQualificationsFile;
  PlatformFile? _educationalQualificationsPlatformFile;

  selectEducationalQualificationFile(QualificationModel certificate) async {
    /// Upload Professional Qualification File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _educationalQualificationsFile = File(file.files.single.path!);
        _educationalQualificationsPlatformFile = file.files.first;
        certificate.qualificationFileName =
            _educationalQualificationsPlatformFile!.name;
        certificate.qualificationSize =
            _educationalQualificationsPlatformFile!.size;
        certificate.qualificationFile = base64Encode(
            Io.File(_educationalQualificationsPlatformFile!.path!)
                .readAsBytesSync());
      });
    }
  }

  ///------------------- OTHER QUALIFICATIONS -------------------///
  buildOtherQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Other Qualifications",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.otherQualifications == null
                          ? readUserJsonFileContent.otherQualifications =
                              <QualificationModel>[]
                          : readUserJsonFileContent.otherQualifications!;

                      readUserJsonFileContent.otherQualifications!.add(QualificationModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.otherQualifications == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.otherQualifications!.length *
                            MediaQuery.of(context).size.height *
                            1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.otherQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Other Qualification ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .otherQualifications!
                                          .remove(readUserJsonFileContent
                                              .otherQualifications![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (title) {
                                  title == ""
                                      ? readUserJsonFileContent
                                          .otherQualifications![index]
                                          .title = null
                                      : readUserJsonFileContent
                                          .otherQualifications![index]
                                          .title = title;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (obtainedFrom) {
                                  obtainedFrom == ""
                                      ? readUserJsonFileContent
                                          .otherQualifications![index]
                                          .obtainedFrom = null
                                      : readUserJsonFileContent
                                          .otherQualifications![index]
                                          .obtainedFrom = obtainedFrom;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Qualification Type",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (qualificationType) {
                                  qualificationType == ""
                                      ? readUserJsonFileContent
                                          .otherQualifications![index]
                                          .qualificationType = null
                                      : readUserJsonFileContent
                                              .otherQualifications![index]
                                              .qualificationType =
                                          qualificationType;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              EditProfileItemCardMA(
                                text: "",
                                onChanged: (description) {
                                  description == ""
                                      ? readUserJsonFileContent
                                          .otherQualifications![index]
                                          .description = null
                                      : readUserJsonFileContent
                                          .otherQualifications![index]
                                          .description = description;
                                },
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .startDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .startDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .startDate = null
                                                : readUserJsonFileContent
                                                        .otherQualifications![index]
                                                        .startDate =
                                                    newDate!.toIso8601String();
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .startDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .otherQualifications![index]
                                                .startDate!,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: CupertinoDateTextBox(
                                        initialValue: readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .endDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat('yyyy-MM-dd').parse(
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .endDate!),
                                        onDateChange: (DateTime? newDate) {
                                          // print(newDate);
                                          setState(() {
                                            newDate == DateTime.now()
                                                ? readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .endDate = null
                                                : readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .endDate = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(newDate!);
                                          });
                                        },
                                        hintText: readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .endDate ==
                                                null
                                            ? DateFormat()
                                                .format(DateTime.now())
                                            : readUserJsonFileContent
                                                .otherQualifications![index]
                                                .endDate!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readUserJsonFileContent
                                                .otherQualifications![index]
                                                .duration ==
                                            null
                                        ? ""
                                        : readUserJsonFileContent
                                            .otherQualifications![index]
                                            .duration!
                                            .toString(),
                                    cursorColor:
                                        DynamicTheme.of(context)?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .otherQualifications![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .otherQualifications![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue == ""
                                          ? readUserJsonFileContent
                                              .otherQualifications![index]
                                              .duration = null
                                          : readUserJsonFileContent
                                                  .otherQualifications![index]
                                                  .duration =
                                              double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: IconButton(
                                  icon: Icon(
                                    Icons.attach_file_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    selectOtherQualificationFile(
                                        readUserJsonFileContent
                                            .otherQualifications![index]);
                                  },
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .otherQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .otherQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .otherQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.otherQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--------- REFERENCES ---------///

  File? _otherQualificationsFile;
  PlatformFile? _otherQualificationsPlatformFile;

  selectOtherQualificationFile(QualificationModel certificate) async {
    /// Upload Professional Qualification File
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (file != null) {
      setState(() {
        _otherQualificationsFile = File(file.files.single.path!);
        _otherQualificationsPlatformFile = file.files.first;
        certificate.qualificationFileName =
            _otherQualificationsPlatformFile!.name;
        certificate.qualificationSize = _otherQualificationsPlatformFile!.size;
        certificate.qualificationFile = base64Encode(
            Io.File(_otherQualificationsPlatformFile!.path!).readAsBytesSync());
      });
    }
  }

  ///------------------------------------- HARD SKILLS -------------------------------------///

  List<String> typeOfSpecializationList = [];
  List<List<String>> hardSkillCategoryList = [];
  List<List<String>> hardSkillList = [];

  bool _expandedHardSkills = false;

  buildHardSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Skill",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 32),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.hardSkills == null
                          ? readUserJsonFileContent.hardSkills = <SkillModel>[]
                          : readUserJsonFileContent.hardSkills!;

                      readUserJsonFileContent.hardSkills!.add(SkillModel());

                      hardSkillCategoryList.add([]);
                      hardSkillList.add([]);

                       /// CHANGE: Hard Skill Category List AND Hard Skill List
                        if (readUserJsonFileContent.jobSpecialization == null) {
                          if (readUserJsonFileContent.jobSubField == null) {
                            if (readUserJsonFileContent.jobField == null) {
                              for (int i = 0; i < readHardSkillsJsonFileContent.length; i++) {
                                /// Hard Skill Category
                                if (readHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                  if (hardSkillCategoryList.last.contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                    hardSkillCategoryList.last;
                                  } else {
                                    hardSkillCategoryList.last.add(readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                  }
                                } else {
                                  hardSkillCategoryList.last;
                                }

                                /// Hard Skill
                                if (readHardSkillsJsonFileContent[i].hardSkill != null) {
                                  if (hardSkillList.last.contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                    hardSkillList.last;
                                  } else {
                                    hardSkillList.last.add(readHardSkillsJsonFileContent[i].hardSkill!);
                                  }
                                } else {
                                  hardSkillList.last;
                                }
                              }
                            } else {
                              var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                  .where((element) =>  element.jobField == readUserJsonFileContent.jobField).toList();

                              for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                                /// Hard Skill Category
                                if (filterHardSkillsJsonFileContent[i].hardSkillCategory !=  null) {
                                  if (hardSkillCategoryList.last.contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                    hardSkillCategoryList.last;
                                  } else {
                                    hardSkillCategoryList.last.add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                  }
                                } else {
                                  hardSkillCategoryList.last;
                                }

                                /// Hard Skill
                                if (filterHardSkillsJsonFileContent[i].hardSkill !=  null) {
                                  if (hardSkillList.last.contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                    hardSkillList.last;
                                  } else {
                                    hardSkillList.last.add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                  }
                                } else {
                                  hardSkillList.last;
                                }
                              }
                            }
                          } else {
                            var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                .where((element) =>
                            element.jobField == readUserJsonFileContent.jobField &&
                                element.jobSubField == readUserJsonFileContent.jobSubField)
                                .toList();

                            for (int i = 0; i < filterHardSkillsJsonFileContent.length; i++) {
                              /// Hard Skill Category
                              if (filterHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                                if (hardSkillCategoryList.last.contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                  hardSkillCategoryList.last;
                                } else {
                                  hardSkillCategoryList.last.add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                }
                              } else {
                                hardSkillCategoryList.last;
                              }

                              /// Hard Skill
                              if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                                if (hardSkillList.last.contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                  hardSkillList.last;
                                } else {
                                  hardSkillList.last.add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                }
                              } else {
                                hardSkillList.last;
                              }
                            }
                          }
                        }
                        else {
                          var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                              .where((element) =>
                          element.jobField == readUserJsonFileContent.jobField &&
                              element.jobSubField == readUserJsonFileContent.jobSubField &&
                              element.jobSpecialization == readUserJsonFileContent.jobSpecialization)
                              .toList();
                          

                          for (int i = 0; i < filterHardSkillsJsonFileContent.length;i++) {
                            /// Hard Skill Category
                            if (filterHardSkillsJsonFileContent[i].hardSkillCategory != null) {
                              if (hardSkillCategoryList.last.contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                hardSkillCategoryList.last;
                              } else {
                                hardSkillCategoryList.last.add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                              }
                            } else {
                              hardSkillCategoryList.last;
                            }

                            /// Hard Skill
                            if (filterHardSkillsJsonFileContent[i].hardSkill != null) {
                              if (hardSkillList.last.contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                hardSkillList.last;
                              } else {
                                hardSkillList.last.add(filterHardSkillsJsonFileContent[i].hardSkill!);
                              }
                            } else {
                              hardSkillList.last;
                            }
                          }
                        }

                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.hardSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.hardSkills!.length * 475,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.hardSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.hardSkills!
                                          .remove(readUserJsonFileContent
                                              .hardSkills![index]);

                                      hardSkillCategoryList.remove(hardSkillCategoryList[index]);
                                      hardSkillList.remove(hardSkillList[index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.025),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(1.0),
                                child: FutureBuilder(
                                  future: readHardSkillsInformationJsonData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: [
                                            const ProfileItemCardMA(
                                              title: "Type of Specialization",
                                              rightWidget: null,
                                              callback: null,
                                              textStyle:
                                                  kProfileSubHeaderTextStyle,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 6,
                                                bottom: 6,
                                              ),
                                              color: DynamicTheme.of(context)
                                                          ?.brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.black12,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter dropDownState) {
                                                          return DropdownSearch<String>(
                                                            popupElevation: 0.0,
                                                            showClearButton: true,
                                                            //clearButtonProps: ,
                                                            dropdownSearchDecoration:
                                                            InputDecoration(
                                                              labelStyle: const TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'Montserrat',
                                                                letterSpacing: 3,
                                                              ),

                                                              focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                            ),
                                                        //mode of dropdown
                                                        mode: Mode.MENU,
                                                        //to show search box
                                                        showSearchBox: true,
                                                        //list of dropdown items
                                                        items:
                                                            typeOfSpecializationList,
                                                        onChanged: (String?
                                                            newTypeOfSpecializationValue) {
                                                          dropDownState(() {
                                                            setState(() {
                                                              readUserJsonFileContent.hardSkills![index].typeOfSpecialization = newTypeOfSpecializationValue!;

                                                              hardSkillCategoryList[index] = [];
                                                              hardSkillList[index] = [];

                                                              /// CHANGE: Hard Skill Category List AND Hard Skill List
                                                              if (newTypeOfSpecializationValue == null) {
                                                                if (readUserJsonFileContent
                                                                        .jobSpecialization ==
                                                                    null) {
                                                                  if (readUserJsonFileContent
                                                                          .jobSubField ==
                                                                      null) {
                                                                    if (readUserJsonFileContent
                                                                            .jobField ==
                                                                        null) {
                                                                      for (int i =
                                                                              0;
                                                                          i < readHardSkillsJsonFileContent.length;
                                                                          i++) {
                                                                        /// Hard Skill Category
                                                                        if (readHardSkillsJsonFileContent[i].hardSkillCategory !=
                                                                            null) {
                                                                          if (hardSkillCategoryList[index]
                                                                              .contains(readHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                            hardSkillCategoryList[index];
                                                                          } else {
                                                                            hardSkillCategoryList[index].add(readHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                          }
                                                                        } else {
                                                                          hardSkillCategoryList[
                                                                              index];
                                                                        }

                                                                        /// Hard Skill
                                                                        if (readHardSkillsJsonFileContent[i].hardSkill !=
                                                                            null) {
                                                                          if (hardSkillList[index]
                                                                              .contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                            hardSkillList[index];
                                                                          } else {
                                                                            hardSkillList[index].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                                          }
                                                                        } else {
                                                                          hardSkillList[
                                                                              index];
                                                                        }
                                                                      }
                                                                    } else {
                                                                      var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                          .where((element) =>
                                                                              element.jobField ==
                                                                              readUserJsonFileContent.jobField)
                                                                          .toList();

                                                                      for (int i =
                                                                              0;
                                                                          i < filterHardSkillsJsonFileContent.length;
                                                                          i++) {
                                                                        /// Hard Skill Category
                                                                        if (filterHardSkillsJsonFileContent[i].hardSkillCategory !=
                                                                            null) {
                                                                          if (hardSkillCategoryList[index]
                                                                              .contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                            hardSkillCategoryList[index];
                                                                          } else {
                                                                            hardSkillCategoryList[index].add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                          }
                                                                        } else {
                                                                          hardSkillCategoryList[
                                                                              index];
                                                                        }

                                                                        /// Hard Skill
                                                                        if (filterHardSkillsJsonFileContent[i].hardSkill !=
                                                                            null) {
                                                                          if (hardSkillList[index]
                                                                              .contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                            hardSkillList[index];
                                                                          } else {
                                                                            hardSkillList[index].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                          }
                                                                        } else {
                                                                          hardSkillList[
                                                                              index];
                                                                        }
                                                                      }
                                                                    }
                                                                  } else {
                                                                    var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                        .where((element) =>
                                                                            element.jobField == readUserJsonFileContent.jobField &&
                                                                            element.jobSubField ==
                                                                                readUserJsonFileContent.jobSubField)
                                                                        .toList();

                                                                    for (int i =
                                                                            0;
                                                                        i < filterHardSkillsJsonFileContent.length;
                                                                        i++) {
                                                                      /// Hard Skill Category
                                                                      if (filterHardSkillsJsonFileContent[i]
                                                                              .hardSkillCategory !=
                                                                          null) {
                                                                        if (hardSkillCategoryList[index]
                                                                            .contains(filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                          hardSkillCategoryList[
                                                                              index];
                                                                        } else {
                                                                          hardSkillCategoryList[index]
                                                                              .add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                        }
                                                                      } else {
                                                                        hardSkillCategoryList[
                                                                            index];
                                                                      }

                                                                      /// Hard Skill
                                                                      if (filterHardSkillsJsonFileContent[i]
                                                                              .hardSkill !=
                                                                          null) {
                                                                        if (hardSkillList[index]
                                                                            .contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                          hardSkillList[
                                                                              index];
                                                                        } else {
                                                                          hardSkillList[index]
                                                                              .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                        }
                                                                      } else {
                                                                        hardSkillList[
                                                                            index];
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                      .where((element) =>
                                                                          element.jobField == readUserJsonFileContent.jobField &&
                                                                          element.jobSubField ==
                                                                              readUserJsonFileContent
                                                                                  .jobSubField &&
                                                                          element.jobSpecialization ==
                                                                              readUserJsonFileContent.jobSpecialization)
                                                                      .toList();

                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          filterHardSkillsJsonFileContent
                                                                              .length;
                                                                      i++) {
                                                                    /// Hard Skill Category
                                                                    if (filterHardSkillsJsonFileContent[i]
                                                                            .hardSkillCategory !=
                                                                        null) {
                                                                      if (hardSkillCategoryList[
                                                                              index]
                                                                          .contains(
                                                                              filterHardSkillsJsonFileContent[i].hardSkillCategory!)) {
                                                                        hardSkillCategoryList[
                                                                            index];
                                                                      } else {
                                                                        hardSkillCategoryList[index]
                                                                            .add(filterHardSkillsJsonFileContent[i].hardSkillCategory!);
                                                                      }
                                                                    } else {
                                                                      hardSkillCategoryList[
                                                                          index];
                                                                    }

                                                                    /// Hard Skill
                                                                    if (filterHardSkillsJsonFileContent[i]
                                                                            .hardSkill !=
                                                                        null) {
                                                                      if (hardSkillList[
                                                                              index]
                                                                          .contains(
                                                                              filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                        hardSkillList[
                                                                            index];
                                                                      } else {
                                                                        hardSkillList[index]
                                                                            .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                      }
                                                                    } else {
                                                                      hardSkillList[
                                                                          index];
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              else {
                                                                var filterHardSkillsList = readHardSkillsJsonFileContent
                                                                    .where((element) =>
                                                                        element.typeOfSpecialization ==
                                                                            newTypeOfSpecializationValue &&
                                                                        element.jobSpecialization ==
                                                                            readUserJsonFileContent
                                                                                .jobSpecialization &&
                                                                        element.jobSubField ==
                                                                            readUserJsonFileContent
                                                                                .jobSubField &&
                                                                        element.jobField ==
                                                                            readUserJsonFileContent.jobField)
                                                                    .toList();

                                                                for (int i = 0;
                                                                    i <
                                                                        filterHardSkillsList
                                                                            .length;
                                                                    i++) {
                                                                  /// Hard Skill Category
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkillCategory !=
                                                                      null) {
                                                                    if (hardSkillCategoryList[
                                                                            index]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkillCategory!)) {
                                                                      hardSkillCategoryList[
                                                                          index];
                                                                    } else {
                                                                      hardSkillCategoryList[
                                                                              index]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkillCategory!);
                                                                    }
                                                                  } else {
                                                                    hardSkillCategoryList[
                                                                        index];
                                                                  }

                                                                  /// Hard Skill
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[
                                                                            index]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index];
                                                                    } else {
                                                                      hardSkillList[
                                                                              index]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index];
                                                                  }
                                                                }
                                                              }
                                                            });
                                                          });
                                                        },
                                                        selectedItem: readUserJsonFileContent
                                                                    .hardSkills![
                                                                        index]
                                                                    .typeOfSpecialization ==
                                                                null
                                                            ? "Type of Specialization"
                                                            : readUserJsonFileContent
                                                                .hardSkills![
                                                                    index]
                                                                .typeOfSpecialization!,
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const ProfileItemCardMA(
                                              title: "Hard Skill Category",
                                              rightWidget: null,
                                              callback: null,
                                              textStyle:
                                                  kProfileSubHeaderTextStyle,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 6,
                                                bottom: 6,
                                              ),
                                              color: DynamicTheme.of(context)
                                                          ?.brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.black12,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter dropDownState) {
                                                          return DropdownSearch<String>(
                                                            popupElevation: 0.0,
                                                            showClearButton: true,
                                                            //clearButtonProps: ,
                                                            dropdownSearchDecoration:
                                                            InputDecoration(
                                                              labelStyle: const TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'Montserrat',
                                                                letterSpacing: 3,
                                                              ),

                                                              focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                            ),
                                                        //mode of dropdown
                                                        mode: Mode.MENU,
                                                        //to show search box
                                                        showSearchBox: true,
                                                        //list of dropdown items
                                                        items:
                                                            hardSkillCategoryList[
                                                                index],
                                                        onChanged: (String?
                                                            newHardSkillCategoryValue) {
                                                          dropDownState(() {
                                                            setState(() {
                                                              readUserJsonFileContent.hardSkills![index].skillCategory = newHardSkillCategoryValue!;

                                                              hardSkillList[index] = [];

                                                              /// CHANGE: Hard Skill Category
                                                              if (newHardSkillCategoryValue == null) {
                                                                if (readUserJsonFileContent
                                                                        .hardSkills![
                                                                            index]
                                                                        .typeOfSpecialization ==
                                                                    null) {
                                                                  if (readUserJsonFileContent
                                                                          .jobSpecialization ==
                                                                      null) {
                                                                    if (readUserJsonFileContent
                                                                            .jobSubField ==
                                                                        null) {
                                                                      if (readUserJsonFileContent
                                                                              .jobField ==
                                                                          null) {
                                                                        for (int i =
                                                                                0;
                                                                            i < readHardSkillsJsonFileContent.length;
                                                                            i++) {
                                                                          /// Hard Skill
                                                                          if (readHardSkillsJsonFileContent[i].hardSkill !=
                                                                              null) {
                                                                            if (hardSkillList[index].contains(readHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                              hardSkillList[index];
                                                                            } else {
                                                                              hardSkillList[index].add(readHardSkillsJsonFileContent[i].hardSkill!);
                                                                            }
                                                                          } else {
                                                                            hardSkillList[index];
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                            .where((element) =>
                                                                                element.jobField ==
                                                                                readUserJsonFileContent.jobField)
                                                                            .toList();

                                                                        for (int i =
                                                                                0;
                                                                            i < filterHardSkillsJsonFileContent.length;
                                                                            i++) {
                                                                          /// Hard Skill
                                                                          if (filterHardSkillsJsonFileContent[i].hardSkill !=
                                                                              null) {
                                                                            if (hardSkillList[index].contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                              hardSkillList[index];
                                                                            } else {
                                                                              hardSkillList[index].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                            }
                                                                          } else {
                                                                            hardSkillList[index];
                                                                          }
                                                                        }
                                                                      }
                                                                    } else {
                                                                      var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                          .where((element) =>
                                                                              element.jobField == readUserJsonFileContent.jobField &&
                                                                              element.jobSubField == readUserJsonFileContent.jobSubField)
                                                                          .toList();

                                                                      for (int i =
                                                                              0;
                                                                          i < filterHardSkillsJsonFileContent.length;
                                                                          i++) {
                                                                        /// Hard Skill
                                                                        if (filterHardSkillsJsonFileContent[i].hardSkill !=
                                                                            null) {
                                                                          if (hardSkillList[index]
                                                                              .contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                            hardSkillList[index];
                                                                          } else {
                                                                            hardSkillList[index].add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                          }
                                                                        } else {
                                                                          hardSkillList[
                                                                              index];
                                                                        }
                                                                      }
                                                                    }
                                                                  } else {
                                                                    var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                        .where((element) =>
                                                                            element.jobField == readUserJsonFileContent.jobField &&
                                                                            element.jobSubField ==
                                                                                readUserJsonFileContent.jobSubField &&
                                                                            element.jobSpecialization == readUserJsonFileContent.jobSpecialization)
                                                                        .toList();

                                                                    for (int i =
                                                                            0;
                                                                        i < filterHardSkillsJsonFileContent.length;
                                                                        i++) {
                                                                      /// Hard Skill
                                                                      if (filterHardSkillsJsonFileContent[i]
                                                                              .hardSkill !=
                                                                          null) {
                                                                        if (hardSkillList[index]
                                                                            .contains(filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                          hardSkillList[
                                                                              index];
                                                                        } else {
                                                                          hardSkillList[index]
                                                                              .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                        }
                                                                      } else {
                                                                        hardSkillList[
                                                                            index];
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  var filterHardSkillsJsonFileContent = readHardSkillsJsonFileContent
                                                                      .where((element) =>
                                                                          element.jobField == readUserJsonFileContent.jobField &&
                                                                          element.jobSubField ==
                                                                              readUserJsonFileContent
                                                                                  .jobSubField &&
                                                                          element.jobSpecialization ==
                                                                              readUserJsonFileContent
                                                                                  .jobSpecialization &&
                                                                          element.typeOfSpecialization ==
                                                                              readUserJsonFileContent.hardSkills![index].typeOfSpecialization)
                                                                      .toList();

                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          filterHardSkillsJsonFileContent
                                                                              .length;
                                                                      i++) {
                                                                    /// Hard Skill
                                                                    if (filterHardSkillsJsonFileContent[i]
                                                                            .hardSkill !=
                                                                        null) {
                                                                      if (hardSkillList[
                                                                              index]
                                                                          .contains(
                                                                              filterHardSkillsJsonFileContent[i].hardSkill!)) {
                                                                        hardSkillList[
                                                                            index];
                                                                      } else {
                                                                        hardSkillList[index]
                                                                            .add(filterHardSkillsJsonFileContent[i].hardSkill!);
                                                                      }
                                                                    } else {
                                                                      hardSkillList[
                                                                          index];
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              else {
                                                                hardSkillList[
                                                                    index] = [];

                                                                var filterHardSkillsList = readHardSkillsJsonFileContent
                                                                    .where((element) =>
                                                                        element.hardSkillCategory ==
                                                                            newHardSkillCategoryValue &&
                                                                        element.typeOfSpecialization ==
                                                                            readUserJsonFileContent
                                                                                .hardSkills![
                                                                                    index]
                                                                                .typeOfSpecialization &&
                                                                        element.jobSpecialization ==
                                                                            readUserJsonFileContent
                                                                                .jobSpecialization &&
                                                                        element.jobSubField ==
                                                                            readUserJsonFileContent
                                                                                .jobSubField &&
                                                                        element.jobField ==
                                                                            readUserJsonFileContent.jobField)
                                                                    .toList();

                                                                for (int i = 0;
                                                                    i <
                                                                        filterHardSkillsList
                                                                            .length;
                                                                    i++) {
                                                                  /// Hard SKill
                                                                  if (filterHardSkillsList[
                                                                              i]
                                                                          .hardSkill !=
                                                                      null) {
                                                                    if (hardSkillList[
                                                                            index]
                                                                        .contains(
                                                                            filterHardSkillsList[i].hardSkill!)) {
                                                                      hardSkillList[
                                                                          index];
                                                                    } else {
                                                                      hardSkillList[
                                                                              index]
                                                                          .add(filterHardSkillsList[i]
                                                                              .hardSkill!);
                                                                    }
                                                                  } else {
                                                                    hardSkillList[
                                                                        index];
                                                                  }
                                                                }
                                                              }
                                                            });
                                                          });
                                                        },
                                                        selectedItem: readUserJsonFileContent
                                                                    .hardSkills![
                                                                        index]
                                                                    .skillCategory ==
                                                                null
                                                            ? "Hard Skill Category"
                                                            : readUserJsonFileContent
                                                                .hardSkills![
                                                                    index]
                                                                .skillCategory!,
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const ProfileItemCardMA(
                                              title: "Hard Skill",
                                              rightWidget: null,
                                              callback: null,
                                              textStyle:
                                                  kProfileSubHeaderTextStyle,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 6,
                                                bottom: 6,
                                              ),
                                              color: DynamicTheme.of(context)
                                                          ?.brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.black12,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter dropDownState) {
                                                          return DropdownSearch<String>(
                                                            popupElevation: 0.0,
                                                            showClearButton: true,
                                                            //clearButtonProps: ,
                                                            dropdownSearchDecoration:
                                                            InputDecoration(
                                                              labelStyle: const TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'Montserrat',
                                                                letterSpacing: 3,
                                                              ),

                                                              focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: primaryColour,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                            ),
                                                        //mode of dropdown
                                                        mode: Mode.MENU,
                                                        //to show search box
                                                        showSearchBox: true,
                                                        //list of dropdown items
                                                        items: hardSkillList[index],
                                                        onChanged: (String?
                                                            newHardSkillValue) {
                                                          dropDownState(() {
                                                            setState(() {
                                                              readUserJsonFileContent
                                                                      .hardSkills![
                                                                          index]
                                                                      .skill =
                                                                  newHardSkillValue!;
                                                            });
                                                          });
                                                        },
                                                        selectedItem: readUserJsonFileContent
                                                                    .hardSkills![
                                                                        index]
                                                                    .skill ==
                                                                null
                                                            ? ""
                                                            : readUserJsonFileContent
                                                                .hardSkills![
                                                                    index]
                                                                .skill!,
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                            ProfileItemCardMA(
                                              title: "Level",
                                              rightWidget: SizedBox(
                                                height: 50,
                                                width: 250,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter dropDownState) {
                                                            return DropdownSearch<String>(
                                                              popupElevation: 0.0,
                                                              showClearButton: true,
                                                              //clearButtonProps: ,
                                                              dropdownSearchDecoration:
                                                              InputDecoration(
                                                                labelStyle: const TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                  'Montserrat',
                                                                  letterSpacing: 3,
                                                                ),

                                                                focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: primaryColour,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: primaryColour,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                              ),
                                                          //mode of dropdown
                                                          mode: Mode.MENU,
                                                          //to show search box
                                                          showSearchBox: true,
                                                          //list of dropdown items
                                                          items: skillLevelList,
                                                          onChanged:
                                                              (String? level) {
                                                            dropDownState(() {
                                                              readUserJsonFileContent
                                                                          .hardSkills![
                                                                              index]
                                                                          .level ==
                                                                      ""
                                                                  ? readUserJsonFileContent
                                                                          .hardSkills![
                                                                              index]
                                                                          .level =
                                                                      null
                                                                  : readUserJsonFileContent
                                                                      .hardSkills![
                                                                          index]
                                                                      .level = level!;
                                                            });
                                                          },
                                                          selectedItem: readUserJsonFileContent
                                                                      .hardSkills![
                                                                          index]
                                                                      .level ==
                                                                  null
                                                              ? ""
                                                              : readUserJsonFileContent
                                                                  .hardSkills![
                                                                      index]
                                                                  .level!,
                                                        );
                                                      }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              callback: null,
                                              textStyle:
                                                  kProfileSubHeaderTextStyle,
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------------------------- SOFT SKILLS -------------------------------------///

  bool _expandedSoftSkills = false;

  buildSoftSkills() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildAdaptabilitySoftSkills(),
          buildAttentionToDetailSoftSkills(),
          buildCommunicationSoftSkills(),
          buildComputerSoftSkills(),
          buildCreativitySoftSkills(),
          buildLeadershipSoftSkills(),
          buildLifeSoftSkills(),
          buildOrganizationSoftSkills(),
          buildProblemSolvingSoftSkills(),
          buildSocialSoftSkills(),
          buildTeamworkSoftSkills(),
          buildTimeManagementSoftSkills(),
          buildWorkEthicSoftSkills(),
        ],
      );

  ///------------------- ADAPTABILITY -------------------///
  buildAdaptabilitySoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Adaptability",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.adaptabilitySoftSkills == null
                          ? readUserJsonFileContent.adaptabilitySoftSkills = <SkillModel>[]
                          : readUserJsonFileContent.adaptabilitySoftSkills!;

                      readUserJsonFileContent.adaptabilitySoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.adaptabilitySoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.adaptabilitySoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .adaptabilitySoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .adaptabilitySoftSkills!
                                          .remove(readUserJsonFileContent
                                              .adaptabilitySoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter dropDownState) {
                                                        return DropdownSearch<String>(
                                                          popupElevation: 0.0,
                                                          showClearButton: true,
                                                          //clearButtonProps: ,
                                                          dropdownSearchDecoration:
                                                          InputDecoration(
                                                            labelStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontFamily:
                                                              'Montserrat',
                                                              letterSpacing: 3,
                                                            ),

                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          adaptabilitySoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent.adaptabilitySoftSkills![index].skillCategory == "Adaptability";

                                                          readUserJsonFileContent.adaptabilitySoftSkills![index].skill == ""
                                                              ? readUserJsonFileContent.adaptabilitySoftSkills![index].skill = null
                                                              : readUserJsonFileContent.adaptabilitySoftSkills![index].skill =  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .adaptabilitySoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .adaptabilitySoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter dropDownState) {
                                                        return DropdownSearch<String>(
                                                          popupElevation: 0.0,
                                                          showClearButton: true,
                                                          //clearButtonProps: ,
                                                          dropdownSearchDecoration:
                                                          InputDecoration(
                                                            labelStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontFamily:
                                                              'Montserrat',
                                                              letterSpacing: 3,
                                                            ),

                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .adaptabilitySoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .adaptabilitySoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .adaptabilitySoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .adaptabilitySoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .adaptabilitySoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- ATTENTION TO DETAIL -------------------///
  buildAttentionToDetailSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Attention To Detail",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.attentionToDetailSoftSkills ==
                              null
                          ? readUserJsonFileContent
                              .attentionToDetailSoftSkills = <SkillModel>[]
                          : readUserJsonFileContent
                              .attentionToDetailSoftSkills!;

                      readUserJsonFileContent.attentionToDetailSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.attentionToDetailSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .attentionToDetailSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .attentionToDetailSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .attentionToDetailSoftSkills!
                                          .remove(readUserJsonFileContent
                                                  .attentionToDetailSoftSkills![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter dropDownState) {
                                                        return DropdownSearch<String>(
                                                          popupElevation: 0.0,
                                                          showClearButton: true,
                                                          //clearButtonProps: ,
                                                          dropdownSearchDecoration:
                                                          InputDecoration(
                                                            labelStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontFamily:
                                                              'Montserrat',
                                                              letterSpacing: 3,
                                                            ),

                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: primaryColour,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          attentionToDetailSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.adaptabilitySoftSkills![index].skillCategory == "Attention to Detail";

                                                          readUserJsonFileContent
                                                                      .attentionToDetailSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .attentionToDetailSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .attentionToDetailSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .attentionToDetailSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .attentionToDetailSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.attentionToDetailSoftSkills![index].skillCategory == "Attention to Detail";

                                                          readUserJsonFileContent
                                                                      .attentionToDetailSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .attentionToDetailSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .attentionToDetailSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .attentionToDetailSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .attentionToDetailSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- COMMUNICATION -------------------///
  buildCommunicationSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Communication",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.communicationSoftSkills == null
                          ? readUserJsonFileContent.communicationSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.communicationSoftSkills!;

                      readUserJsonFileContent.communicationSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.communicationSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .communicationSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .communicationSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .communicationSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .communicationSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          communicationSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.communicationSoftSkills![index].skillCategory == "Communication Skills";

                                                          readUserJsonFileContent
                                                                      .communicationSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .communicationSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .communicationSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .communicationSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .communicationSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .communicationSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .communicationSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .communicationSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .communicationSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .communicationSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- COMPUTER -------------------///
  buildComputerSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Computer",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.computerSoftSkills == null
                          ? readUserJsonFileContent.computerSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.computerSoftSkills!;

                      readUserJsonFileContent.computerSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.computerSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.computerSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.computerSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .computerSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .computerSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          computerSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.computerSoftSkills![index].skillCategory == "Computer Skills";

                                                          readUserJsonFileContent
                                                                      .computerSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .computerSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .computerSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .computerSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .computerSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .computerSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .computerSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .computerSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .computerSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .computerSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- CREATIVITY -------------------///
  buildCreativitySoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Creativity",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.creativitySoftSkills == null
                          ? readUserJsonFileContent.creativitySoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.creativitySoftSkills!;

                      readUserJsonFileContent.creativitySoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.creativitySoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.creativitySoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.creativitySoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .creativitySoftSkills!
                                          .remove(readUserJsonFileContent
                                              .creativitySoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          creativitySoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.creativitySoftSkills![index].skillCategory == "Creativity";

                                                          readUserJsonFileContent
                                                                      .creativitySoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .creativitySoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .creativitySoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .creativitySoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .creativitySoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .creativitySoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .creativitySoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .creativitySoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .creativitySoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .creativitySoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- LEADERSHIP -------------------///
  buildLeadershipSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Leadership",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.leadershipSoftSkills == null
                          ? readUserJsonFileContent.leadershipSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.leadershipSoftSkills!;

                      readUserJsonFileContent.leadershipSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.leadershipSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.leadershipSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.leadershipSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .leadershipSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .leadershipSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          leadershipSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.leadershipSoftSkills![index].skillCategory == "Leadership";

                                                          readUserJsonFileContent
                                                                      .leadershipSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .leadershipSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .leadershipSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .leadershipSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .leadershipSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .leadershipSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .leadershipSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .leadershipSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .leadershipSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .leadershipSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- LIFE -------------------///
  buildLifeSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Life",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.lifeSoftSkills == null
                          ? readUserJsonFileContent.lifeSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.lifeSoftSkills!;

                      readUserJsonFileContent.lifeSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.lifeSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.lifeSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.lifeSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent.lifeSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .lifeSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: lifeSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.lifeSoftSkills![index].skillCategory == "Life Skills";

                                                          readUserJsonFileContent
                                                                      .lifeSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .lifeSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .lifeSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .lifeSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? "Skill"
                                                          : readUserJsonFileContent
                                                              .lifeSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .lifeSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .lifeSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .lifeSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .lifeSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .lifeSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- ORGANIZATIONAL -------------------///
  buildOrganizationSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Organization",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.organizationSoftSkills == null
                          ? readUserJsonFileContent.organizationSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.organizationSoftSkills!;

                      readUserJsonFileContent.organizationSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.organizationSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.organizationSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .organizationSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .organizationSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .organizationSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          organizationSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.organizationSoftSkills![index].skillCategory == "Organization Skills";

                                                          readUserJsonFileContent
                                                                      .organizationSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .organizationSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .organizationSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .organizationSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .organizationSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .organizationSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .organizationSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .organizationSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .organizationSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .organizationSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- PROBLEM SOLVING -------------------///
  buildProblemSolvingSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Problem Solving",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.problemSolvingSoftSkills == null
                          ? readUserJsonFileContent.problemSolvingSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.problemSolvingSoftSkills!;

                      readUserJsonFileContent.problemSolvingSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.problemSolvingSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .problemSolvingSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .problemSolvingSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .problemSolvingSoftSkills!
                                          .remove(readUserJsonFileContent
                                                  .problemSolvingSoftSkills![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          problemSolvingSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.problemSolvingSoftSkills![index].skillCategory == "Problem-solving";

                                                          readUserJsonFileContent
                                                                      .problemSolvingSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .problemSolvingSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .problemSolvingSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .problemSolvingSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .problemSolvingSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .problemSolvingSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .problemSolvingSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .problemSolvingSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .problemSolvingSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .problemSolvingSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- SOCIAL -------------------///
  buildSocialSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Social",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.socialOrInterpersonalSoftSkills ==
                              null
                          ? readUserJsonFileContent
                                  .socialOrInterpersonalSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent
                              .socialOrInterpersonalSoftSkills!;

                      readUserJsonFileContent.socialOrInterpersonalSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.socialOrInterpersonalSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .socialOrInterpersonalSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .socialOrInterpersonalSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .socialOrInterpersonalSoftSkills!
                                          .remove(readUserJsonFileContent
                                                  .socialOrInterpersonalSoftSkills![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          socialSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.socialOrInterpersonalSoftSkills![index].skillCategory == "Social Skills";

                                                          readUserJsonFileContent
                                                                      .socialOrInterpersonalSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .socialOrInterpersonalSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .socialOrInterpersonalSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .socialOrInterpersonalSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .socialOrInterpersonalSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .socialOrInterpersonalSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .socialOrInterpersonalSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .socialOrInterpersonalSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .socialOrInterpersonalSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .socialOrInterpersonalSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- TEAMWORK -------------------///
  buildTeamworkSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Team Work",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.teamworkSoftSkills == null
                          ? readUserJsonFileContent.teamworkSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.teamworkSoftSkills!;

                      readUserJsonFileContent.teamworkSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.teamworkSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.teamworkSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.teamworkSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .teamworkSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .teamworkSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          teamworkSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.teamworkSoftSkills![index].skillCategory == "Teamwork";


                                                          readUserJsonFileContent
                                                                      .teamworkSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .teamworkSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .teamworkSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .teamworkSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .teamworkSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .teamworkSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .teamworkSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .teamworkSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .teamworkSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .teamworkSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- TIME MANAGEMENT -------------------///
  buildTimeManagementSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Time Management",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.timeManagementSoftSkills == null
                          ? readUserJsonFileContent.timeManagementSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.timeManagementSoftSkills!;

                      readUserJsonFileContent.timeManagementSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.timeManagementSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .timeManagementSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .timeManagementSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .timeManagementSoftSkills!
                                          .remove(readUserJsonFileContent
                                                  .timeManagementSoftSkills![
                                              index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          timeManagementSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.timeManagementSoftSkills![index].skillCategory == "Time Management";

                                                          readUserJsonFileContent
                                                                      .timeManagementSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .timeManagementSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .timeManagementSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .timeManagementSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .timeManagementSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.075,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {
                                                          readUserJsonFileContent
                                                                      .timeManagementSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .timeManagementSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .timeManagementSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .timeManagementSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .timeManagementSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- WORK ETHICS -------------------///
  buildWorkEthicSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Work Ethics",
              rightWidget: Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {
                    setState(() {
                      readUserJsonFileContent.workEthicSoftSkills == null
                          ? readUserJsonFileContent.workEthicSoftSkills =
                              <SkillModel>[]
                          : readUserJsonFileContent.workEthicSoftSkills!;

                      readUserJsonFileContent.workEthicSoftSkills!.add(SkillModel());
                    });
                  },
                ),
              ),
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.workEthicSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.workEthicSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.workEthicSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readUserJsonFileContent
                                          .workEthicSoftSkills!
                                          .remove(readUserJsonFileContent
                                              .workEthicSoftSkills![index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: MediaQuery.of(context).size.height * 0.035),
                                  color: primaryColour,
                                ),
                                callback: null,
                                textStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColour,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                          ?.brightness ==
                                          Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Skill",
                                                style:
                                                kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items:
                                                          workEthicSoftSkillsList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent.workEthicSoftSkills![index].skillCategory == "Work Ethic";

                                                          readUserJsonFileContent
                                                                      .workEthicSoftSkills![
                                                                          index]
                                                                      .skill ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                      .workEthicSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  null
                                                              : readUserJsonFileContent
                                                                      .workEthicSoftSkills![
                                                                          index]
                                                                      .skill =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .workEthicSoftSkills![
                                                                      index]
                                                                  .skill ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .workEthicSoftSkills![
                                                                  index]
                                                              .skill!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 50,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "Level",
                                                style:
                                                    kProfileSubHeaderTextStyle,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 280,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              dropDownState) {
                                                    return DropdownSearch<
                                                        String>(

                                                      showClearButton: true,
                                                      //clearButtonProps: ,
                                                      dropdownSearchDecoration:
                                                      InputDecoration(
                                                        labelStyle: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                          'Montserrat',
                                                          letterSpacing: 3,
                                                        ),

                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: primaryColour,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      popupElevation: 0.0,
                                                      //mode of dropdown
                                                      mode: Mode.MENU,
                                                      //to show search box
                                                      showSearchBox: true,
                                                      //list of dropdown items
                                                      items: skillLevelList,
                                                      onChanged:
                                                          (String? newValue) {
                                                        dropDownState(() {

                                                          readUserJsonFileContent
                                                                      .workEthicSoftSkills![
                                                                          index]
                                                                      .level ==
                                                                  ""
                                                              ? readUserJsonFileContent
                                                                  .workEthicSoftSkills![
                                                                      index]
                                                                  .level = null
                                                              : readUserJsonFileContent
                                                                      .workEthicSoftSkills![
                                                                          index]
                                                                      .level =
                                                                  newValue!;
                                                        });
                                                      },
                                                      selectedItem: readUserJsonFileContent
                                                                  .workEthicSoftSkills![
                                                                      index]
                                                                  .level ==
                                                              null
                                                          ? ""
                                                          : readUserJsonFileContent
                                                              .workEthicSoftSkills![
                                                                  index]
                                                              .level!,
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );
}
