import 'dart:ui';

import 'package:origami_structure/imports.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:date_utils/date_utils.dart';

import 'package:http/http.dart' as http;

class ProjectTimelineScreenWS extends StatefulWidget {
  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectTimelineScreenWS({Key? key, this.selectedUser, this.selectedProject, required this.navigationMenu,})
      : super(key: key);

  @override
  State<ProjectTimelineScreenWS> createState() =>
      _ProjectTimelineScreenWSState();
}

class _ProjectTimelineScreenWSState
    extends State<ProjectTimelineScreenWS>
    with TickerProviderStateMixin {
  ///------------- BACKEND DATA -------------///

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

  /// Project information Variables
  late ProjectModel readProjectsJsonFileContent = ProjectModel();

  Future<ProjectModel> readingProjectsJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.getProjectByProjectName}${widget.selectedProject!.projectName}");

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
      readProjectsJsonFileContent = projectModelFromJson(response.body)
          .where((element) =>
              element.projectName == widget.selectedProject!.projectName)
          .toList()[0];
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

      return readProjectsJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Task information Variables
  late List<TaskModel> readTasksJsonFileContent = <TaskModel>[];

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
      readTasksJsonFileContent = taskModelFromJson(response.body)
          .where((element) =>
              element.projectName == widget.selectedProject!.projectName)
          .toList();
      // print("ALL  tasks: $readTasksJsonFileContent");


      return readTasksJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  ///------------- TIMELINE -------------///

  /// VARIABLES FOR TIMELINE

  // late AnimationController? animationController;
  // late DateTime fromDate;
  // late DateTime toDate;

  late int viewRange = 0;
  late int viewRangeToFitScreen = 6;
  late Animation<double> width;

  late AnimationController animationController = AnimationController(
      duration: const Duration(microseconds: 2000), vsync: this);

  DateTime fromDate = DateTime(2018, 1, 1);
  DateTime toDate = DateTime(2019, 1, 1);

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(microseconds: 2000), vsync: this);
    animationController.forward();

    readingProjectsJsonData().then((value) {
      fromDate = DateTime.parse(value.startDate!);
      toDate = DateTime.parse(value.dueDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder(
        future: readingProjectsJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              fromDate = readProjectsJsonFileContent.startDate == null ? DateTime.now() : DateTime.parse(readProjectsJsonFileContent.startDate!);
              toDate = readProjectsJsonFileContent.dueDate == null ? DateTime.now() : DateTime.parse(readProjectsJsonFileContent.dueDate!);

              //print(tasksStatusList);
              return FutureBuilder(
                future: readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Scaffold(
                        body: buildBody(context, screenSize),
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

  buildBody(BuildContext context, Size screenSize) {
    return SingleChildScrollView(
      child:
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarMenuAfterLoginWS(
                isSelectedPage:
                widget.navigationMenu == NavigationMenu.dashboardScreen
                    ? 'Dashboard'
                    : 'Projects',
                user: widget.selectedUser!,
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Flexible(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTasksPerPhaseTimeline(context, screenSize),
                        buildDivider(context),
                        buildTasksPerMemberTimeline(context, screenSize),
                        buildDivider(context),
                        buildPhasesTimeline(context, screenSize),
                        buildDivider(context),
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


  late String selectedSideMenuItem = "Timeline";
  late int selectedSideMenuItemInt = 2;

  buildSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.folder,
                  icon: EvaIcons.folderOutline,
                  title: "Board",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.closeSquare,
                  icon: EvaIcons.closeSquareOutline,
                  title: "Dashboard",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.archiveOutline,
                  title: "Timeline",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "About",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.edit,
                  icon: EvaIcons.editOutline,
                  title: "Edit Information",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedSideMenuItem = value.title;

                  value.title == "Board"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectBoardScreenWS(
                        selectedUser: widget.selectedUser!,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : value.title == "Dashboard"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectDashboardScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : value.title == "Timeline"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectTimelineScreenWS(
                            selectedUser: widget.selectedUser,
                            selectedProject: widget.selectedProject,
                            navigationMenu: widget.navigationMenu,
                          ),
                    ),
                  )
                      :value.title == "About"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProjectDetailScreenWS(
                        selectedUser: widget.selectedUser!,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  );

                  // selectedSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: 2,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  buildDivider(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Divider(
          thickness: 1.5,
          color: primaryColour,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }

  buildTimelineLabel(BuildContext context, Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '= 0.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.circle,
                    color: Colors.lightGreenAccent,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                      '< 20.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.circle,
                    color: Colors.tealAccent,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                      '< 40.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.circle,
                    color: Colors.deepPurpleAccent,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '< 60.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.circle,
                    color: Colors.lime,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                      '< 80.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: primaryColour,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                      '< 100.0%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildTasksPerPhaseTimeline(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TASKS PER PHASES TIMELINE',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.01,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        buildTimelineLabel(context, screenSize),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            height:
                (readTasksJsonFileContent.length * screenSize.height * 0.0458) +
                    readProjectsJsonFileContent.phases!.length *
                        (screenSize.height * 0.1 +
                            screenSize.height * 0.001 +
                            screenSize.height * 0.0034),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: PhasesTasksGanttChartWS(
                    animationController: animationController,
                    projectStartDate: fromDate,
                    projectEndDate: toDate,
                    projectTaskData: readTasksJsonFileContent,
                    phasesInProject: readProjectsJsonFileContent.phases,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  buildTasksPerMemberTimeline(BuildContext context, Size screenSize) {
    var memberWithTasks = [];

    for (int i = 0; i < readProjectsJsonFileContent.members!.length; i++) {
      for (int j = 0; j < readTasksJsonFileContent.length; j++) {
        if (readTasksJsonFileContent[j]
            .assignedTo!
            .contains(readProjectsJsonFileContent.members![i].memberUsername)) {
          if (memberWithTasks.contains(
              readProjectsJsonFileContent.members![i].memberUsername)) {
            memberWithTasks;
          } else {
            memberWithTasks
                .add(readProjectsJsonFileContent.members![i].memberUsername);
          }
        } else {
          memberWithTasks;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TASKS PER MEMBERS TIMELINE',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.01,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        buildTimelineLabel(context, screenSize),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            height:
                (readTasksJsonFileContent.length * screenSize.height * 0.0458) +
                    memberWithTasks.length *
                        (screenSize.height * 0.095 +
                            screenSize.height * 0.001 +
                            screenSize.height * 0.0034),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: MembersTasksGanttChartWS(
                    animationController: animationController,
                    projectStartDate: fromDate,
                    projectEndDate: toDate,
                    projectTaskData: readTasksJsonFileContent,
                    membersOfProject: readProjectsJsonFileContent.members,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  buildPhasesTimeline(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PHASES TIMELINE',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.01,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        buildTimelineLabel(context, screenSize),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            height: (readProjectsJsonFileContent.phases!.length *
                    screenSize.height *
                    0.0458) +
                screenSize.height * 0.1 +
                screenSize.height * 0.001 +
                screenSize.height * 0.0034,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: PhasesGanttChartWS(
                    animationController: animationController,
                    projectStartDate: fromDate,
                    projectEndDate: toDate,
                    phasesInProject: readProjectsJsonFileContent.phases,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
