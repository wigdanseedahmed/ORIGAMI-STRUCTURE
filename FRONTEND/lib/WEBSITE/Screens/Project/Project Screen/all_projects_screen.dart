import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class ProjectScreenWS extends StatefulWidget {
  static const String id = 'project_screen';

  const ProjectScreenWS({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectScreenWSState createState() => _ProjectScreenWSState();
}

class _ProjectScreenWSState extends State<ProjectScreenWS> {
  late String searchProject;

  List<Widget> _tabTwoParameters() => [
        const Tab(
          child: Text(
            "All",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Open",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Closed",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Expired",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Future",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Suggested",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];

  TabBar _projectTabBarLabel() => TabBar(
        isScrollable: true,
        indicatorColor: primaryColour,
        tabs: _tabTwoParameters(),
        labelColor: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor:
            DynamicTheme.of(context)?.brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
        unselectedLabelStyle: const TextStyle(fontSize: 18),
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "All";
              break;
            case 1:
              content = "Open";
              break;
            case 2:
              content = "Closed";
              break;
            case 3:
              content = "Expired";
              break;
            case 4:
              content = "Future";
              break;
            case 5:
              content = "Suggested";
              break;
            default:
              content = "Other";
              break;
          }
          if (kDebugMode) {
            print("You are clicking the $content");
          }
        },
      );

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
      UserProfile.email = userInfo['data']['email'];
      UserProfile.username = userInfo['data']['username'];
      UserProfile.firstName = userInfo['data']['firstName'];
      UserProfile.userPhotoURL = userInfo['data']["userPhotoURL"];
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

  /// VARIABLES USED FOR RETRIEVING ALL USER
  List<UserModel>? _allUserData = <UserModel>[];

  Future<List<UserModel>?> readAllUsersJsonData() async {
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

    if (response.statusCode == 200) {
      _allUserData = userModelListFromJson(response.body);
      // print("User Model Info : ${readJsonFileContent}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR RETRIEVING ALL PROJECTS FOR USER
  late List<ProjectModel> allProjects = <ProjectModel>[];

  Future<List<ProjectModel>> readingAllProjectJsonData() async {
    /// Read Local Json File Directly
    /*String jsonString = await root_bundle.rootBundle.loadString('jsonFile/project_data.json');*/
    //print(jsonString);

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
      allProjects = projectModelFromJson(response.body)
          .where((element) => element.members!.any((element) =>
              element.memberUsername! == readUserJsonFileContent.username))
          .toList();

      return allProjects;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING TASKS FOR USER
  late List<TaskModel> readTasksContent = <TaskModel>[];

  Future<List<TaskModel>> readingTasksData() async {
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
      readTasksContent = taskModelFromJson(response.body)
          .where((element) =>
          element.assignedTo!.contains(readUserJsonFileContent.username))
          .toList();
      //print("ALL  tasks: allTasks");

      return readTasksContent;
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

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "Add New Project";

  @override
  initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getUserInfo();
    readingUserJsonData();
    readingTasksData();

    super.initState();
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
      child: FutureBuilder<UserModel>(
        future: readingUserJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<ProjectModel>>(
                future: readingAllProjectJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder<List<UserModel>?>(
                        future: readAllUsersJsonData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Scaffold(
                                body: buildBody(),
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

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 10),
        child: Column(
          children: [
            TopBarMenuAfterLoginWS(
              isSelectedPage: 'Projects',
              user: readUserJsonFileContent,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: ResponsiveWidget.isLargeScreen(context) ? 2 : 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: buildSideMenu(),
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildHeader(),
                      const SizedBox(height: 40),
                      buildActiveProject(
                        user: readUserJsonFileContent,
                        projects: allProjects
                            .where((element) =>
                                element.status == selectedSideMenuItem)
                            .toList(),
                        crossAxisCount: 6,
                        crossAxisCellCount:
                            ResponsiveWidget.isLargeScreen(context) ? 3 : 2,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  late String selectedSideMenuItem = "Open";
  late int selectedSideMenuItemInt = 0;

  buildSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.folder,
                  icon: EvaIcons.folderOutline,
                  title: "Open",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.closeSquare,
                  icon: EvaIcons.closeSquareOutline,
                  title: "Closed",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  title: "Expired",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowheadUp,
                  icon: EvaIcons.arrowheadUpOutline,
                  title: "Future",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bulb,
                  icon: EvaIcons.bulbOutline,
                  title: "Suggested",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedSideMenuItem = value.title;
                  selectedSideMenuItemInt = index;
                  print("index : $index | label : ${value.title}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: selectedSideMenuItem == "Open"
                  ? 0
                  : selectedSideMenuItem == "Closed"
                      ? 1
                      : selectedSideMenuItem == "Expired"
                          ? 2
                          : selectedSideMenuItem == "Future"
                              ? 3
                              : 4,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool isSearch = false;

  buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          Expanded(
            child: HeaderWS(
              showTaskCalendar: false,
              user: readUserJsonFileContent,
              allProjectsData: allProjects,
              allUsers: _allUserData,
              taskList: readTasksContent,
              pageName: 'All Projects Screen',
            ),
          ),
        ],
      ),
    );
  }

  buildActiveProject({
    required UserModel user,
    required List<ProjectModel> projects,
    required int crossAxisCount,
    required int crossAxisCellCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: projects.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProjectBoardScreenWS(
                      selectedUser: readUserJsonFileContent,
                      selectedProject: projects[index],
                      navigationMenu: NavigationMenu.projectScreen,
                    ),
                  ),
                );
              },
              child: ProjectCardWS(
                projectTitle: projects[index].projectName!,
                projectDescription: projects[index].projectDescription == null
                    ? null
                    : projects[index].projectDescription!,
                projectProgressPercentage:
                    projects[index].progressPercentage == null
                        ? 0.0
                        : projects[index].progressPercentage!,
                projectTaskNumber: projects[index].tasksNumber == null
                    ? 0
                    : projects[index].tasksNumber!,
                projectTaskDone: projects[index].doneTasksCount == null
                    ? 0
                    : projects[index].doneTasksCount!,
                projectTaskUnDone:
                    projects[index].inProgressTasksCount == null &&
                            projects[index].todoTasksCount == null
                        ? 0
                        : projects[index].inProgressTasksCount != null &&
                                projects[index].todoTasksCount == null
                            ? projects[index].inProgressTasksCount
                            : projects[index].inProgressTasksCount == null &&
                                    projects[index].todoTasksCount != null
                                ? projects[index].todoTasksCount
                                : projects[index].inProgressTasksCount! +
                                    projects[index].todoTasksCount!,
                projectStartDateTime: projects[index].dueDate == null
                    ? null
                    : projects[index].startDate!,
                projectDueDateTime: projects[index].dueDate == null
                    ? null
                    : projects[index].dueDate!,
                colour: labelColours![projects[index].criticalityColour == null
                    ? 5
                    : projects[index].criticalityColour!],
                totalProjectMembers: projects[index].totalProjectMembers == null
                    ? 0
                    : projects[index].totalProjectMembers!,
                projectManager: projects[index].projectManager == null
                    ? null
                    : projects[index].projectManager!,
                projectLeader: projects[index].projectLeader == null
                    ? null
                    : projects[index].projectLeader!,
                projectCoordinator:
                    projects[index].projectAssistantOrCoordinator == null
                        ? null
                        : projects[index].projectAssistantOrCoordinator!,
                projectManagerInfo: projects[index].projectManager == null
                    ? null
                    : _allUserData!
                        .where((element) =>
                            element.username == projects[index].projectManager)
                        .toList()[0],
                projectLeaderInfo: projects[index].projectLeader == null
                    ? null
                    : _allUserData!
                        .where((element) =>
                            element.username == projects[index].projectLeader)
                        .toList()[0],
                projectCoordinatorInfo:
                    projects[index].projectAssistantOrCoordinator == null
                        ? null
                        : _allUserData!
                            .where((element) =>
                                element.username ==
                                projects[index].projectAssistantOrCoordinator)
                            .toList()[0],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }
}
