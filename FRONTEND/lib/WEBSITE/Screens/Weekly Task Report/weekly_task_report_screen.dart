import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:http/http.dart' as http;

class WeeklyTaskReportScreenWS extends StatefulWidget {
  const WeeklyTaskReportScreenWS({Key? key}) : super(key: key);

  @override
  State<WeeklyTaskReportScreenWS> createState() =>
      _WeeklyTaskReportScreenWSState();
}

class _WeeklyTaskReportScreenWSState extends State<WeeklyTaskReportScreenWS> {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  ///VARIABLES USED FOR RETRIEVING USER INFORWSTION
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
      readUserContent = userModelListFromJson(response.body)
          .where((element) => element.email == UserProfile.email)
          .toList()[0];
      //print("User Model Info : ${readUserContent.firstName}");

      return readUserContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Search Bar Variables
  List<TaskModel> searchData = <TaskModel>[];

  ///VARIABLES USED FOR RETRIEVING TASKS FOR USER

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
          .where((task) =>
              task.assignedTo!.contains(readUserContent.username) &&
              task.projectStatus == "Open")
          .toList();
      //print("ALL  tasks: allTasks");

      return readTasksContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR ALL PROJECT INFO

  List<ProjectModel> readProjectContent = <ProjectModel>[];

  Future<List<ProjectModel>> readingProjectData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.getProjects);

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
      readProjectContent = projectModelFromJson(response.body)
          .where((project) =>
              project.status == "Open" &&
              project.members!
                  .where((member) =>
                      member.memberUsername == readUserContent.username)
                  .isNotEmpty)
          .toList();

      return readProjectContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  ////VARIABLES USED TO DETERMINE SCREEN SIZE
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

    /// Task information Variables
    readingTasksData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: readingUserJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<ProjectModel>>(
                future: readingProjectData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder<List<TaskModel>>(
                        future: readingTasksData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              if (readTasksContent == null ||
                                  readTasksContent.isEmpty) {
                                rows;
                              } else {
                                for (int i = 0;
                                    i < readTasksContent.length;
                                    i++) {
                                  rows.add(
                                    PlutoRow(
                                      cells: {
                                        'id': PlutoCell(value: '${i + 1}'),
                                        'project name': PlutoCell(
                                            value: readTasksContent[i]
                                                .projectName),
                                        'phase': PlutoCell(
                                            value: readTasksContent[i]
                                                .projectPhase),
                                        'phase deadline': PlutoCell(
                                            value: readTasksContent[i]
                                                .projectPhaseDeadline),
                                        'task name': PlutoCell(
                                            value:
                                                readTasksContent[i].taskName),
                                        'status': PlutoCell(
                                            value: readTasksContent[i].status),
                                        'priority': PlutoCell(
                                            value:
                                                readTasksContent[i].priority),
                                        'weight given': PlutoCell(
                                            value: readTasksContent[i]
                                                .weightGiven),
                                        'start date': PlutoCell(
                                            value:
                                                readTasksContent[i].startDate),
                                        'deadline': PlutoCell(
                                            value: readTasksContent[i]
                                                .deadlineDate),
                                        'submission date': PlutoCell(
                                            value: readTasksContent[i]
                                                .submissionDate),
                                        'duration': PlutoCell(
                                            value:
                                                readTasksContent[i].duration),
                                        'progress completed': PlutoCell(
                                            value: readTasksContent[i]
                                                .percentageDone),
                                        'progress planned': PlutoCell(
                                            value: readTasksContent[i]
                                                .plannedPercentageDone),
                                        'schedule': PlutoCell(
                                            value: readTasksContent[i]
                                                .progressCategories),
                                        'issue type': PlutoCell(
                                            value: readTasksContent[i]
                                                .issuesCategory),
                                        'root cause of issue': PlutoCell(
                                            value: readTasksContent[i]
                                                .rootCauseOfIssues),
                                        'remarks': PlutoCell(
                                            value: readTasksContent[i].remarks),
                                        'next week outlook': PlutoCell(
                                            value: readTasksContent[i]
                                                .nextWeekOutlook),
                                      },
                                    ),
                                  );
                                }
                              }

                              return buildBody(context, screenSize);
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Project Name',
      field: 'project name',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Phase',
      field: 'phase',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Phase Deadline',
      field: 'phase deadline',
      type: PlutoColumnType.date(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Task Name',
      field: 'task name',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = primaryColour;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
        title: 'Status',
        field: 'status',
        type: PlutoColumnType.text(),
        backgroundColor: kBlueChill,
        enableEditingMode: false,
        readOnly: true,
        renderer: (rendererContext) {
          Color textColor = Colors.grey;

          if (rendererContext.cell.value == 'Todo') {
            textColor = Colors.orange;
          } else if (rendererContext.cell.value == 'Done') {
            textColor = Colors.green;
          } else if (rendererContext.cell.value == 'In Progress') {
            textColor = Colors.yellow;
          } else if (rendererContext.cell.value == 'On Hold') {
            textColor = Colors.grey;
          }

          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          );
        },
    ),
    PlutoColumn(
      title: 'Priority',
      field: 'priority',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == 'Critical') {
          textColor = criticalLabel;
        } else if (rendererContext.cell.value == 'High') {
          textColor = highLabel;
        } else if (rendererContext.cell.value == 'Medium') {
          textColor = mediumLabel;
        }else if (rendererContext.cell.value == 'Low') {
          textColor = lowLabel;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Weight Given',
      field: 'weight given',
      type: PlutoColumnType.number(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Deadline',
      field: 'deadline',
      type: PlutoColumnType.date(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Submission Date',
      field: 'submission date',
      type: PlutoColumnType.date(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Progress Completed',
      field: 'progress completed',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Progress Planned',
      field: 'progress planned',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Schedule',
      field: 'schedule',
      type: PlutoColumnType.text(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == "Behind schedule") {
          textColor = Colors.red;
        } else if (rendererContext.cell.value == 'Ahead of schedule') {
          textColor = Colors.green;
        } else if (rendererContext.cell.value == 'On schedule') {
          textColor = Colors.yellow;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Issue Type',
      field: 'issue type',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Root Cause Of Issue *',
      field: 'root cause of issue',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Remarks',
      field: 'remarks',
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
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Next Week Outlook',
      field: 'next week outlook',
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
    PlutoColumnGroup(
        title: 'Project Name', fields: ['project name'], expandedColumn: true),
    PlutoColumnGroup(title: 'Phase', fields: ['phase'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Phase Deadline',
        fields: ['phase deadline'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Task Name', fields: ['task name'], expandedColumn: true),
    PlutoColumnGroup(title: 'Status', fields: ['status'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Priority', fields: ['priority'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Weight Given', fields: ['weight given'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Deadline', fields: ['deadline'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Submission Date',
        fields: ['submission date'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Progress Completed',
        fields: ['progress completed'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Progress Planned',
        fields: ['progress planned'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Schedule', fields: ['schedule'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Issue Type', fields: ['issue type'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Root Cause Of Issue *',
        fields: ['root cause of issue'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Remarks', fields: ['remarks'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Next Week Outlook',
        fields: ['next week outlook'],
        expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  buildBody(BuildContext context, Size screenSize) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
          child: Column(
            children: [
              TopBarMenuAfterLoginWS(
                isSelectedPage: 'Weekly Report',
                user: readUserContent,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width / 20),
                child: Row(
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
                      child: buildBodyCentre(screenSize),
                    ),
                    /*Flexible(
                      flex: 4,
                      child: Column(
                        children: [
                          const SizedBox(height: 20 / 2),
                          _buildProfile(userData: readUserContent),
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
      ),
    );
  }

  late String selectedSideMenuItem = "Detail";
  late int selectedSideMenuItemInt = 0;

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
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "Detail",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.closeSquare,
                  icon: EvaIcons.closeSquareOutline,
                  title: "Dashboard",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedSideMenuItem = value.title;

                  selectedSideMenuItem == "Detail"
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const WeeklyTaskReportScreenWS(),
                          ),
                        )
                      : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const WeeklyTaskReportDashboardScreenWS(),
                          ),
                        );

                  // selectedSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: 0,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  late String bodyViewSelected = "Table";

  buildBodyCentre(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
          ProjectDetailHeaderWS(
            headerTitle: 'Weekly Report Update',
            icon: Icon(
              bodyViewSelected == "Table"
                  ? Icons.grid_view_rounded
                  : Icons.table_view_rounded,
            ),
            onPressed: () {
              setState(() {
                if (bodyViewSelected == "Table") {
                  bodyViewSelected = "Grid";
                } else if (bodyViewSelected == "Grid") {
                  bodyViewSelected = "Table";
                }
              });
            },
          ),
          SizedBox(height: screenSize.height * 0.01),
          bodyViewSelected == "Table"
              ? buildTableView(screenSize)
              : buildGridView(screenSize),
        ],
      ),
    );
  }

  buildTableView(Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: readTasksContent == null || readTasksContent.isEmpty
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
          print(event);
        },
        onRowDoubleTap: (onRowDoubleTapEvent){
          setState(() {
            print('onRowDoubleTap');
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
    );
  }

  buildGridView(Size screenSize) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: readTasksContent.length,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => EditTaskScreenWS(
                        projectName: readTasksContent[index].projectName,
                        taskTitle: readTasksContent[index].taskName!,
                        listStatus: readTasksContent[index].status,
                        checkListItem: readTasksContent[index].checklist,
                        selectedProject: readProjectContent.where((element) => element.projectName == readTasksContent[index].projectName).toList()[0],
                        navigationMenu: NavigationMenu.weeklyMeetingReportScreen,
                      ),
                    );
                  });
                },
                child: Container(
                  height: screenSize.height * 0.9,
                  width: screenSize.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    // border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            readTasksContent[index].status == "Done"
                                ? SizedBox(
                                    width: screenSize.width * 0.03,
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.greenAccent,
                                    ),
                                  )
                                : readTasksContent[index].status == "In Progress"
                                    ? SizedBox(
                                        width: screenSize.width * 0.03,
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.redAccent,
                                        ),
                                      )
                                    : readTasksContent[index].status == "On Hold"
                                        ? SizedBox(
                                            width: screenSize.width * 0.03,
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.blueGrey,
                                            ),
                                          )
                                        : SizedBox(
                                            width: screenSize.width * 0.03,
                                            child: const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.grey,
                                            ),
                                          ),
                            SizedBox(
                              width: screenSize.width * 0.15,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].projectName!,
                                  style: TextStyle(
                                    color: primaryColour,
                                    fontSize: screenSize.width * 0.02,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.03,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditTaskScreenMA(
                                            projectName: readTasksContent[index]
                                                .projectName,
                                            taskTitle:
                                                readTasksContent[index].taskName!,
                                            listStatus:
                                                readTasksContent[index].status,
                                            checkListItem:
                                                readTasksContent[index].checklist,
                                            selectedProject: readProjectContent
                                                .where((element) =>
                                                    element.projectName ==
                                                    readTasksContent[index]
                                                        .projectName)
                                                .toList()[0],
                                            navigationMenu: NavigationMenu
                                                .weeklyMeetingReportScreen,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: primaryColour,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PHASE",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].projectPhase == null
                                      ? ""
                                      : readTasksContent[index].projectPhase!,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PHASE\nDEADLINE",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].projectPhaseDeadline ==
                                          null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(readTasksContent[index]
                                              .projectPhaseDeadline!)),
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "TASK NAME",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].taskName == null
                                      ? ""
                                      : readTasksContent[index].taskName!,
                                  style: TextStyle(
                                    color: primaryColour,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "STATUS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].status == null
                                      ? ""
                                      : readTasksContent[index].status!,
                                  style: TextStyle(
                                    color: readTasksContent[index].status ==
                                            "Todo"
                                        ? Colors.orange
                                        : readTasksContent[index].status ==
                                                "In Progress"
                                            ? Colors.yellow
                                            : readTasksContent[index].status ==
                                                    "On Hold"
                                                ? Colors.grey
                                                : Colors.green,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PRIORITY",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].criticalityColour ==
                                          null
                                      ? ""
                                      : impactLabel![readTasksContent[index]
                                          .criticalityColour!],
                                  style: TextStyle(
                                    color: labelColours![readTasksContent[index]
                                        .criticalityColour!],
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "WEIGHT GIVEN",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].weightGiven == null
                                      ? ""
                                      : "${readTasksContent[index].weightGiven!}%",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "START",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "DEADLINE",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].startDate == null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(readTasksContent[index]
                                              .startDate!)),
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].deadlineDate == null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(readTasksContent[index]
                                              .deadlineDate!)),
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "DURATION",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].duration == null
                                      ? ""
                                      : "${readTasksContent[index].duration!} Weeks",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PROGRESS COMPLETED",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PROGRESS PLANNED",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].percentageDone == null
                                      ? ""
                                      : "${readTasksContent[index].percentageDone!}%",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].plannedPercentageDone ==
                                          null
                                      ? ""
                                      : "${readTasksContent[index].plannedPercentageDone!}%",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SCHEDULE",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].progressCategories ==
                                          null
                                      ? ""
                                      : readTasksContent[index]
                                          .progressCategories!,
                                  style: TextStyle(
                                    color: readTasksContent[index]
                                                .progressCategories ==
                                            "Behind schedule"
                                        ? Colors.red
                                        : readTasksContent[index]
                                                    .progressCategories ==
                                                null
                                            ? Colors.black
                                            : Colors.green,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ISSUE TYPE",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  readTasksContent[index].issuesCategory == null
                                      ? "No Issue"
                                      : readTasksContent[index].issuesCategory!,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ROOT CAUSE\nOF ISSUE *",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenSize.width * 0.08),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    readTasksContent[index].rootCauseOfIssues ==
                                            null
                                        ? ""
                                        : readTasksContent[index]
                                            .rootCauseOfIssues!,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "REMARKS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenSize.width * 0.08),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    readTasksContent[index].remarks == null
                                        ? ""
                                        : readTasksContent[index].remarks!,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "NEXT WEEK OUTLOOK",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenSize.width * 0.01,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.12,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenSize.width * 0.08),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    readTasksContent[index].nextWeekOutlook ==
                                            null
                                        ? ""
                                        : readTasksContent[index]
                                            .nextWeekOutlook!,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(ResponsiveWidget.isLargeScreen(context) ? 2 : 1),
    );
  }

  buildListView(Size screenSize) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: buildEachTaskListView(readTasksContent, screenSize),
    );
  }

  Widget buildEachTaskListView(List<TaskModel> taskData, Size screenSize) {
    var taskBars = buildTaskBarsListView(taskData, screenSize);

    return SizedBox(
      height:
          taskData.length * screenSize.height * 0.09 + screenSize.height * 0.06,
      width: screenSize.width * 8.6,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: taskBars,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildTaskBarsListView(
      List<TaskModel> taskData, Size screenSize) {
    List<Widget> taskBars = [];

    taskBars.add(
      Container(
        height: screenSize.height * 0.05,
        width: screenSize.width * 8.6,
        alignment: Alignment.centerLeft,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: screenSize.height * 0.008,
            ),
            child: Row(
              children: [
                SizedBox(width: screenSize.width * 0.15),
                SizedBox(
                  width: screenSize.width * 0.6,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PROJECT NAME",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PHASE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PHASE DEADLINE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.6,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "TASK NAME",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "STATUS",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.35,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "WEIGHT\n(per phase)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "START\nDATE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DEADLINE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SUBMISSION\nDATE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.35,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DURATION\n(in weeks)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PROGRESS\nCOMPLETED",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PROGRESS\nPLANNED",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SCHEDULE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ISSUES\nTYPE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ROOT CAUSE OF ISSUES *",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "REWSRKS",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "NEXT WEEK OUTLOOK",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.01,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /*

   Project ------- DONE
   Project Deadline
   Leader
   Type
   Milestone
   Phase ------- DONE
   Phase Overall Deadline * ------- DONE
   Tasks	------- DONE
   Task Description
   Checklist
   Tasks Weight (per phase) ------- DONE
   Task Start Date M/D/Y ------- DONE
   Task Deadline * M/D/Y ------- DONE
   Task Submission Deadline M/D/Y ------- DONE
   Duration in weeks 	------- DONE
   Status	------- DONE
   Urgency	------- DONE
   Task Progress % * ------- DONE
   Planned Task Progress % ------- DONE
   Progress Categories ------- DONE
   Issues Category ------- DONE
   Root Cause of Issues * ------- DONE
   Remarks ------- DONE
   Next Week Outlook ------- DONE

     */

    for (int i = 0; i < taskData.length; i++) {
      taskBars.add(
        Container(
          height: screenSize.height * 0.075,
          width: screenSize.width * 8.6,
          alignment: Alignment.centerLeft,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenSize.height * 0.01,
              ),
              child: Container(
                decoration: BoxDecoration(
                  //color: Color.fromRGBO(202, 202, 202, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    taskData[i].status == "Done"
                        ? SizedBox(
                            width: screenSize.width * 0.15,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                            ),
                          )
                        : taskData[i].status == "In Progress"
                            ? SizedBox(
                                width: screenSize.width * 0.15,
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.redAccent,
                                ),
                              )
                            : taskData[i].status == "On Hold"
                                ? SizedBox(
                                    width: screenSize.width * 0.15,
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : SizedBox(
                                    width: screenSize.width * 0.15,
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.grey,
                                    ),
                                  ),
                    SizedBox(
                      width: screenSize.width * 0.6,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].projectName!,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].projectPhase == null
                              ? ""
                              : taskData[i].projectPhase!,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].projectPhaseDeadline == null
                              ? ""
                              : DateFormat("EEE, MMM d, yyyy").format(
                                  DateTime.parse(
                                      taskData[i].projectPhaseDeadline!)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.6,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].taskName == null
                              ? ""
                              : taskData[i].taskName!,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: labelColours![
                              taskData[i].criticalityColour == null
                                  ? 5
                                  : taskData[i].criticalityColour!],
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        SizedBox(
                          width: screenSize.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              taskData[i].status == null
                                  ? ""
                                  : taskData[i].status!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenSize.width * 0.35,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.03),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].weightGiven == null
                                ? ""
                                : "${taskData[i].weightGiven!}%",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].startDate == null
                              ? ""
                              : DateFormat("EEE, MMM d, yyyy").format(
                                  DateTime.parse(taskData[i].startDate!)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].deadlineDate == null
                              ? ""
                              : DateFormat("EEE, MMM d, yyyy").format(
                                  DateTime.parse(taskData[i].deadlineDate!)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskData[i].submissionDate == null
                              ? ""
                              : DateFormat("EEE, MMM d, yyyy").format(
                                  DateTime.parse(taskData[i].submissionDate!)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.35,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.03),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].duration == null
                                ? ""
                                : "${taskData[i].duration!} Weeks",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].percentageDone == null
                                ? ""
                                : "${taskData[i].percentageDone!}%",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].plannedPercentageDone == null
                                ? ""
                                : "${taskData[i].plannedPercentageDone!}%",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.01),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].progressCategories == null
                                ? ""
                                : taskData[i].progressCategories!,
                            style: TextStyle(
                                color: taskData[i].progressCategories ==
                                        "Behind schedule"
                                    ? Colors.red
                                    : taskData[i].progressCategories == null
                                        ? Colors.black
                                        : Colors.green),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.1,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].issuesCategory == null
                                ? ""
                                : taskData[i].issuesCategory!,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].rootCauseOfIssues == null
                                ? ""
                                : taskData[i].rootCauseOfIssues!,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].remarks == null
                                ? ""
                                : taskData[i].remarks!,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.08),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskData[i].nextWeekOutlook == null
                                ? ""
                                : taskData[i].nextWeekOutlook!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return taskBars;
  }
}
