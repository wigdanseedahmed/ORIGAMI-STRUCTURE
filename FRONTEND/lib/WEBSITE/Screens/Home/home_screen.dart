import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class HomeScreenWS extends StatefulWidget {
  static const String id = 'dashboard_screen';

  final UserModel? user;

  const HomeScreenWS({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _HomeScreenWSState createState() => _HomeScreenWSState();
}

class _HomeScreenWSState extends State<HomeScreenWS> {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  ///VARIABLES USED FOR RETRIEVING USER INFORMATION
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
      UserProfile.firstName = userInfo['data']['firstName'];
      UserProfile.lastName = userInfo['data']['lastName'];
      UserProfile.userPhotoURL = userInfo['data']["userPhotoURL"];
    });
  }

  UserModel readUserContent = UserModel();
  Future<UserModel>? futureUserInformation;

  Future<UserModel> readingUserData() async {
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
      readUserContent = userModelListFromJson(response.body)
          .where((element) => element.email == UserProfile.email)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING ALL USER
  List<UserModel>? allUsersData = <UserModel>[];

  Future<List<UserModel>?> readAllUsersData() async {
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
      allUsersData = userModelListFromJson(response.body);
      // print("User Model Info : ${readJsonFileContent}");

      return allUsersData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING TASKS FOR USER
  late List<TaskModel> readTasksContent = <TaskModel>[];

  late List<TaskModel> readSelectedTaskContent = <TaskModel>[];

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
              element.assignedTo!.contains(readUserContent.username))
          .toList();
      //print("ALL  tasks: allTasks");

      return readTasksContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Search Bar Variables
  List<TaskModel> searchData = <TaskModel>[];

  TextEditingController taskSearchBarTextEditingController =
      TextEditingController();

  onSearchTextChanged(String? text) async {
    searchData.clear();
    if (text == null || text.isEmpty) {
      // Check textfield is empty or not
      setState(() {});
      return;
    }

    readTasksContent.forEach((data) {
      if (data.taskName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase().toString())) {
        searchData.add(data);
        // If not empty then add search data into search data list
      }
    });

    setState(() {});
  }

  /// VARIABLES FOR RETRIEVING ALL PROJECTS FOR USER
  late List<ProjectModel> allProjectsData = <ProjectModel>[];

  Future<List<ProjectModel>> readingAllProjectsData() async {
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
      allProjectsData = projectModelFromJson(response.body)
          .where((element) => element.members!.any(
              (element) => element.memberUsername! == readUserContent.username))
          .toList();

      return allProjectsData;
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

    /// User Model information Variables
    getUserInfo();

    /// User information Variables
    readingUserData().then((value) => readingAllProjectsData());

    /// Task information Variables
    readingTasksData();

    /// Project information Variables
    readingAllProjectsData();
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
        future: readingUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<TaskModel>>(
                future: readingTasksData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder<List<ProjectModel>>(
                        future: readingAllProjectsData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return FutureBuilder<List<UserModel>?>(
                                future: readAllUsersData(),
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
              isSelectedPage: 'Home',
              user: readUserContent,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Flexible(
                    flex: (MediaQuery.of(context).size.width < 1360) ? 4 : 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: SidebarWS(
                        userData: readUserJsonFileContent,
                        projectData: allProjects[0],
                      ),
                    ),
                  ),*/
                  Flexible(
                    flex: 9,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        buildHeader(),
                        const SizedBox(height: 40),
                        buildProgress(),
                        const SizedBox(height: 40),
                        buildActiveProject(
                          user: readUserContent,
                          openProjects: allProjectsData
                              .where(
                                (element) =>
                                    element.status == 'Open' &&
                                    element.members!.any((members) =>
                                        members.memberUsername ==
                                        readUserContent.username),
                              )
                              .toList(),
                          crossAxisCount: 6,
                          crossAxisCellCount:
                              ResponsiveWidget.isLargeScreen(context) ? 3 : 2,
                        ),
                        const SizedBox(height: 40),
                        buildTaskOverview(
                          taskData: readTasksContent,
                          crossAxisCount: 6,
                          crossAxisCellCount:
                              ResponsiveWidget.isLargeScreen(context) ? 3 : 2,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  /*Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: 20 / 2),
                        _buildProfile(userData: readUserJsonFileContent),
                        const Divider(thickness: 1),
                        const SizedBox(height: 20),
                        // _buildTeamMember(data: controller.getMember()),
                        const SizedBox(height: 20),
                        */
                  /* Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: GetPremiumCard(onPressed: () {}),
                                  ),*/
                  /*
                        const SizedBox(height: 20),
                        const Divider(thickness: 1),
                        const SizedBox(height: 20),
                        // _buildRecentMessages(userData: controller.getChatting()),
                      ],
                    ),
                  )*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              showTaskCalendar: true,
              user: readUserContent,
              allUsers: allUsersData!,
              allProjectsData: allProjectsData,
              taskList: readTasksContent,
              pageName: 'Home',
            ),
          ),
        ],
      ),
    );
  }


  buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCardWS(
                    userData: readUserContent,
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: 20 / 2),
                Flexible(
                  flex: 4,
                  child: ProgressReportCardWS(
                    selectedUser: readUserContent,
                    openProjects: allProjectsData
                        .where((element) => element.status == "Open")
                        .length,
                    closedProjects: allProjectsData
                        .where((element) => element.status == "Closed")
                        .length,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCardWS(
                  userData: readUserContent,
                  onPressedCheck: () {},
                ),
                const SizedBox(height: 10),
                Flexible(
                  flex: 4,
                  child: ProgressReportCardWS(
                    selectedUser: readUserContent,
                    openProjects: allProjectsData
                        .where((element) => element.status == "Open")
                        .length,
                    closedProjects: allProjectsData
                        .where((element) => element.status == "Closed")
                        .length,
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildActiveProject({
    required UserModel user,
    required List<ProjectModel> openProjects,
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
          itemCount: openProjects.length,
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
                      selectedUser: readUserContent,
                      selectedProject: openProjects[index],
                      navigationMenu: NavigationMenu.dashboardScreen,
                    ),
                  ),
                );
              },
              child: ProjectCardWS(
                projectTitle: openProjects[index].projectName!,
                projectDescription:
                    openProjects[index].projectDescription == null
                        ? null
                        : openProjects[index].projectDescription!,
                projectProgressPercentage:
                    openProjects[index].progressPercentage == null
                        ? 0.0
                        : openProjects[index].progressPercentage!,
                projectTaskNumber: openProjects[index].tasksNumber == null
                    ? 0
                    : openProjects[index].tasksNumber!,
                projectTaskDone: openProjects[index].doneTasksCount == null
                    ? 0
                    : openProjects[index].doneTasksCount!,
                projectTaskUnDone: openProjects[index].inProgressTasksCount ==
                            null &&
                        openProjects[index].todoTasksCount == null
                    ? 0
                    : openProjects[index].inProgressTasksCount != null &&
                            openProjects[index].todoTasksCount == null
                        ? openProjects[index].inProgressTasksCount
                        : openProjects[index].inProgressTasksCount == null &&
                                openProjects[index].todoTasksCount != null
                            ? openProjects[index].todoTasksCount
                            : openProjects[index].inProgressTasksCount! +
                                openProjects[index].todoTasksCount!,
                projectStartDateTime: openProjects[index].dueDate == null
                    ? null
                    : openProjects[index].startDate!,
                projectDueDateTime: openProjects[index].dueDate == null
                    ? null
                    : openProjects[index].dueDate!,
                colour: labelColours![
                    openProjects[index].criticalityColour == null
                        ? 5
                        : openProjects[index].criticalityColour!],
                totalProjectMembers:
                    openProjects[index].totalProjectMembers == null
                        ? 0
                        : openProjects[index].totalProjectMembers!,
                projectManager: openProjects[index].projectManager == null
                    ? null
                    : openProjects[index].projectManager!,
                projectLeader: openProjects[index].projectLeader == null
                    ? null
                    : openProjects[index].projectLeader!,
                projectCoordinator:
                    openProjects[index].projectAssistantOrCoordinator == null
                        ? null
                        : openProjects[index].projectAssistantOrCoordinator!,
                projectManagerInfo: openProjects[index].projectManager == null
                    ? null
                    : allUsersData!
                        .where((element) =>
                            element.username ==
                            openProjects[index].projectManager)
                        .toList()[0],
                projectLeaderInfo: openProjects[index].projectLeader == null
                    ? null
                    : allUsersData!
                        .where((element) =>
                            element.username ==
                            openProjects[index].projectLeader)
                        .toList()[0],
                projectCoordinatorInfo:
                    openProjects[index].projectAssistantOrCoordinator == null
                        ? null
                        : allUsersData!
                            .where((element) =>
                                element.username ==
                                openProjects[index]
                                    .projectAssistantOrCoordinator)
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

  DateTime current = DateTime.now();
  late String? isSelected = "All";

  Widget buildTaskOverview({
    required List<TaskModel> taskData,
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,
  }) {
    return Column(
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: isSelected == "Today"
              ? taskData
                      .where(
                        (element) =>
                            DateTime.parse(element.deadlineDate!).year ==
                                current.year &&
                            DateTime.parse(element.deadlineDate!).month ==
                                current.month &&
                            DateTime.parse(element.deadlineDate!).day ==
                                current.day,
                      )
                      .length +
                  1
              : isSelected == "Week"
                  ? taskData
                          .where(
                            (element) =>
                                DateTime.parse(element.deadlineDate!).year ==
                                    current.year &&
                                DateTime.parse(element.deadlineDate!).month ==
                                    current.month &&
                                DateTime.parse(element.deadlineDate!).day >=
                                    current.day &&
                                DateTime.parse(element.deadlineDate!).day <
                                    current.day + 8,
                          )
                          .length +
                      1
                  : isSelected == "Month"
                      ? taskData
                              .where(
                                (element) =>
                                    DateTime.parse(element.deadlineDate!)
                                            .year ==
                                        current.year &&
                                    DateTime.parse(element.deadlineDate!)
                                            .month ==
                                        current.month,
                              )
                              .length +
                          1
                      : taskData.length + 1,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return index == 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: OverviewHeaderWS(
                      axis: headerAxis,
                      onSelected: (task) {},
                      isSelected: isSelected,
                      isSelectedChanged: (String value) {
                        setState(() {
                          isSelected = value;
                          // print(isSelected);
                        });
                      },
                    ),
                  )
                : TaskCardWS(
                    allUserData: allUsersData!,
                    taskData: isSelected == "Today"
                        ? taskData
                            .where(
                              (element) =>
                                  DateTime.parse(element.deadlineDate!).year ==
                                      current.year &&
                                  DateTime.parse(element.deadlineDate!).month ==
                                      current.month &&
                                  DateTime.parse(element.deadlineDate!).day ==
                                      current.day,
                            )
                            .toList()[index - 1]
                        : isSelected == "Week"
                            ? taskData
                                .where(
                                  (element) =>
                                      DateTime.parse(element.deadlineDate!)
                                              .year ==
                                          current.year &&
                                      DateTime.parse(element.deadlineDate!)
                                              .month ==
                                          current.month &&
                                      DateTime.parse(element.deadlineDate!)
                                              .day >=
                                          current.day &&
                                      DateTime.parse(element.deadlineDate!)
                                              .day <
                                          current.day + 8,
                                )
                                .toList()[index - 1]
                            : isSelected == "Month"
                                ? taskData
                                    .where(
                                      (element) =>
                                          DateTime.parse(element.deadlineDate!)
                                                  .year ==
                                              current.year &&
                                          DateTime.parse(element.deadlineDate!)
                                                  .month ==
                                              current.month,
                                    )
                                    .toList()[index - 1]
                                : taskData[index - 1],
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => EditTaskScreenWS(
                          selectedProject: allProjectsData
                              .where((element) =>
                                  element.projectName ==
                                  taskData[index - 1].projectName)
                              .toList()[0],
                          taskTitle: taskData[index - 1].taskName,
                          projectName: taskData[index - 1].projectName,
                          listStatus: taskData[index - 1].status,
                          checkListItem: taskData[index - 1].checklist,
                          navigationMenu: NavigationMenu.dashboardScreen,
                        ),
                      );
                    },
                    onPressedMore: () {
                      print("_Tile");
                    },
                    onPressedTask: () {
                      print("Status");
                    },
                    onPressedContributors: () {
                      print("Contributors");
                    },
                    onPressedComments: () {
                      print("comment");
                    },
                  );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(
              (index == 0) ? crossAxisCount : crossAxisCellCount),
        ),
      ],
    );
  }

  Widget _buildProfile({required UserModel userData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ProfileTileWS(
        userData: userData,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember(
      {required List<ImageProvider> data, required TaskModel selectedTask}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamMemberWS(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: 20 / 2),
          selectedTask.assignedTo == null
              ? Container()
              : ListProfileImageWS(
                  allUserData: allUsersData!,
                  assignedTo: selectedTask.assignedTo!,
                ),
        ],
      ),
    );
  }

/*Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: 20 / 2),
      ...data
          .map(
            (e) => ChattingCard(selectedProject: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }*/

/*
  searchBarUI() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: FloatingSearchBar(
        axisAlignment: isPortrait ? 0.0 : -1.0,
        hint: 'Search task',
        hintStyle: TextStyle(
          color: DynamicTheme.of(context)?.brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        iconColor: primaryColour,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 20),
        borderRadius: BorderRadius.circular(50.0),
        elevation: 4.0,
        physics: const BouncingScrollPhysics(),
        onQueryChanged: onSearchTextChanged,
        automaticallyImplyDrawerHamburger: false,
        transitionCurve: Curves.easeInOut,
        transitionDuration: const Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        debounceDelay: const Duration(milliseconds: 500),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: Icon(
                Icons.mic,
                color: primaryColour,
                size: 28,
              ),
              onPressed: () {
                if (kDebugMode) {
                  print('Places Pressed');
                }
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: [
                           TaskCard(
                            taskTitle: searchData[index].taskName!,
                            taskProjectName: searchData[index].projectName!,
                            taskDueDateTime: searchData[index].deadlineDate!,
                            colour: labelColours![
                                searchData[index].criticalityColour!],
                            taskStatus: searchData[index].status == null
                                ? ""
                                : searchData[index].status!,
                            navigationMenu: NavigationMenu.dashboardScreen,
                            taskProgressPercentage:
                                searchData[index].percentageDone == null
                                    ? 0.0
                                    : searchData[index].percentageDone!,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          );
        },
       body: buildBody(),
      ),
    );
  }

  buildBody() {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            //headerSilverBuilder only accepts slivers
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 75.0,
                  ),
                  const Text(
                    "Projects",
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 250.0,
                    child: readUserJsonFileContent.username == null
                        ? const Text("No Projects found!")
                        : ProjectListViewBuilder(
                            username: readUserJsonFileContent.username!,
                          ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tasks",
                        style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TaskCalendarScreenMA(),
                          ),
                        ),
                        icon: const Icon(Icons.calendar_month, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: _tabBarLabel(),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: <Widget>[
            TodayTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
            WeekTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
            MonthTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
          ],
        ),
      ),
    );
  }

  */
}
