import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class AllRecommendedUsersScreen extends StatefulWidget {
  const AllRecommendedUsersScreen({
    Key? key,
    this.selectedProject,
    this.selectedSkill,
    required this.allRecommendedUsers, required this.navigationMenu,
  }) : super(key: key);

  final NavigationMenu navigationMenu;
  final ProjectModel? selectedProject;
  final SkillsRequiredPerMemberModel? selectedSkill;
  final List<RecommendedUserModel>? allRecommendedUsers;

  @override
  State<AllRecommendedUsersScreen> createState() =>
      _AllRecommendedUsersScreenState();
}

class _AllRecommendedUsersScreenState extends State<AllRecommendedUsersScreen> {
  /// VARIABLES USED FOR RETRIEVING ALL USERS

  List<UserModel> readUsersJsonFileContent = <UserModel>[];
  List<UserModel> readRecommendedUsersInformationJsonFileContent = <UserModel>[];
  List<RecommendedUserModel> readRecommendedUsersJsonFileContent = <RecommendedUserModel>[];
  Future<UserModel>? futureUserInformation;

  Future<List<UserModel>> readingUserJsonData() async {
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
      readUsersJsonFileContent = userModelListFromJson(response.body);
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      readRecommendedUsersJsonFileContent = widget.allRecommendedUsers!;

      readRecommendedUsersJsonFileContent.sort((a, b) {
        return b.userScore!.compareTo(a.userScore!);
      });

      for (int i = 0; i < readRecommendedUsersJsonFileContent.length; i++) {
        readRecommendedUsersInformationJsonFileContent.add(
            readUsersJsonFileContent
                .where((element) =>
                    element.username ==
                    readRecommendedUsersJsonFileContent[i].username)
                .toList()[0]);
      }

      return readRecommendedUsersInformationJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Search Bar Variables
  List<TaskModel> searchData = <TaskModel>[];

  /// VARIABLES USED FOR RETRIEVING ALL TASKS

  late List<TaskModel> readTaskJsonFileContent = <TaskModel>[];

  late List<RecommendedUserTaskChartData> userTaskChartData =
      <RecommendedUserTaskChartData>[];

  Future<List<TaskModel>> readingTasksJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.tasks);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readTaskJsonFileContent = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return readTaskJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING ALL PROJECTS
  late List<ProjectModel> readProjectsJsonFileContent = <ProjectModel>[];
  late SkillsRequiredPerMemberModel selectedSKill = SkillsRequiredPerMemberModel();

  Future<List<ProjectModel>> readingProjectsJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.getProjects);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readProjectsJsonFileContent = projectModelFromJson(response.body);
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

      return readProjectsJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR PROJECT
  ProjectModel readSelectedProjectJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureSelectedProjectInformation;

  var fullSkillsRequired = <SkillsRequiredPerMemberModel>[];

  Future<ProjectModel> readSelectedProjectInformationJsonData() async {
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
      readSelectedProjectJsonFileContent = projectModelFromJson(response.body)[0];
      // print("Project Info : ${readJsonFileContent}");

      selectedSKill = readSelectedProjectJsonFileContent.skillsRequired!.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0];

      return readSelectedProjectJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<ProjectModel> writeSelectedProjectInformationJsonData(ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse("${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

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
      readSelectedProjectJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
      return readSelectedProjectJsonFileContent;
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
  initState() {
    super.initState();

    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _futureSelectedProjectInformation = readSelectedProjectInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.skillsRequired == [] ||
        widget.selectedProject!.skillsRequired == null
        ? fullSkillsRequired = <SkillsRequiredPerMemberModel>[]
        : fullSkillsRequired = widget.selectedProject!.skillsRequired!;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder(
        future: readingUserJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                        future: readingProjectsJsonData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return FutureBuilder(
                                future: _futureSelectedProjectInformation,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Scaffold(
                                        appBar: appBar(screenSize),
                                        body: buildBody(screenSize),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                  }

                                  return const CircularProgressIndicator();
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                          }

                          return const CircularProgressIndicator();
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }

                  return const CircularProgressIndicator();
                },
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

  appBar(Size screenSize) {
    return AppBar(
      toolbarHeight: 100.0,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditProjectDetailScreenMA(
                  selectedProject: widget.selectedProject,
                  navigationMenu: widget.navigationMenu,
                );
              },
            ),
          );
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: primaryColour,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: Text(
              "RECOMMENDATIONS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: primaryColour,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBody(Size screenSize) {
    return ListView.builder(
      itemCount: readRecommendedUsersJsonFileContent.length,
      itemBuilder: (BuildContext context, int index) {
        return UserRecommendationCardMA(
          user: readRecommendedUsersInformationJsonFileContent[index],
          recommendedUser: readRecommendedUsersJsonFileContent[index],
          assignedTo: readSelectedProjectJsonFileContent.skillsRequired!.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0].assignedTo == readRecommendedUsersInformationJsonFileContent[index].username ? true : false,

          deleteOnPressed: () {
            setState(() {

              if(readSelectedProjectJsonFileContent.skillsRequired!.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0].assignedTo == readRecommendedUsersInformationJsonFileContent[index].username){
                readRecommendedUsersJsonFileContent[index].isAssignedTo = false;

                fullSkillsRequired.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0].assignedTo = null;

                readSelectedProjectJsonFileContent.skillsRequired = fullSkillsRequired;

                setState((){
                  _futureSelectedProjectInformation = writeSelectedProjectInformationJsonData(readSelectedProjectJsonFileContent);
                });

              } else {
                readRecommendedUsersJsonFileContent.remove(readRecommendedUsersJsonFileContent[index]);
                readRecommendedUsersInformationJsonFileContent.remove(readRecommendedUsersInformationJsonFileContent[index]);
              }

            });
          },
          selectedRecommendedOnPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendedUserScreenMA(
                    selectedProject: readSelectedProjectJsonFileContent,
                    selectedRecommendedUserResultDetails: readRecommendedUsersJsonFileContent[index],
                    selectedRecommendedUserInformation: readRecommendedUsersInformationJsonFileContent[index],
                    allRecommendedUsers: readRecommendedUsersJsonFileContent,
                    selectedSkill: readSelectedProjectJsonFileContent.skillsRequired!.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0],
                    navigationMenu: widget.navigationMenu,
                  ),
                ),
              );
            });
          },
          assignedToOnPressed: () {
            setState(() {
              readRecommendedUsersJsonFileContent[index].isAssignedTo = true;

              fullSkillsRequired.where((element) => element.skillName == widget.selectedSkill!.skillName).toList()[0].assignedTo = readRecommendedUsersJsonFileContent[index].username;

              readSelectedProjectJsonFileContent.skillsRequired = fullSkillsRequired;

              setState((){
                _futureSelectedProjectInformation = writeSelectedProjectInformationJsonData(readSelectedProjectJsonFileContent);
              });
            });
          },
        );
      },
    );
  }


}
