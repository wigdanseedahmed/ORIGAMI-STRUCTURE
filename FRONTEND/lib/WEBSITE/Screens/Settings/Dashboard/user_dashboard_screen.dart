import 'package:origami_structure/imports.dart';

import 'dart:ui';
import 'package:nb_utils/nb_utils.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import 'package:http/http.dart' as http;

class UserDashboardScreenMA extends StatefulWidget {
  const UserDashboardScreenMA({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreenMA> createState() => _UserDashboardScreenMAState();
}

class _UserDashboardScreenMAState extends State<UserDashboardScreenMA> {
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

      userTaskChartData = [
        UserDashboardChartData(
            "On Hold (${readUserJsonFileContent.onHoldTasksCount})",
            ((readUserJsonFileContent.onHoldTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.grey),
        UserDashboardChartData(
            "Todo (${readUserJsonFileContent.todoTasksCount})",
            ((readUserJsonFileContent.todoTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.lightGreenAccent),
        UserDashboardChartData(
            "In Progress (${readUserJsonFileContent.inProgressTasksCount})",
            ((readUserJsonFileContent.inProgressTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.tealAccent),
        UserDashboardChartData(
            "Done (${readUserJsonFileContent.doneTasksCount})",
            ((readUserJsonFileContent.doneTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            primaryColour)
      ];

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Search Bar Variables
  List<TaskModel> searchData = <TaskModel>[];

  ///VARIABLES USED FOR RETRIEVING TASKS FOR USER

  late List<TaskModel> readTaskJsonFileContent = <TaskModel>[];

  late List<UserDashboardChartData> userTaskChartData =
      <UserDashboardChartData>[];

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
      readTaskJsonFileContent = taskModelFromJson(response.body)
          .where((task) =>
              task.assignedTo!.contains(readUserJsonFileContent.username))
          .toList();
      //print("ALL  tasks: allTasks");

      return readTaskJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING ALL PROJECTS
  late List<ProjectModel> readProjectsJsonFileContent = <ProjectModel>[];

  late List<UserDashboardChartData> userProjectChartData =
      <UserDashboardChartData>[];

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
      readProjectsJsonFileContent = projectModelFromJson(response.body)
          .where((project) => project.members!
                  .where((member) =>
                      member.memberUsername == readUserJsonFileContent.username)
                  .isNotEmpty
              // || project.peopleAllowedToViewProject!.where((member) => member.personAllowedToViewProjectUsername == readUserJsonFileContent.username).isNotEmpty
              )
          .toList();
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

      userProjectChartData = [
        UserDashboardChartData(
            "Expired (${readProjectsJsonFileContent.where((element) => element.status == "Expired").length})",
            ((readProjectsJsonFileContent
                            .where((element) => element.status == "Expired")
                            .length /
                        readProjectsJsonFileContent.length) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.grey),
        UserDashboardChartData(
            "Open (${readProjectsJsonFileContent.where((element) => element.status == "Open").length})",
            ((readProjectsJsonFileContent
                            .where((element) => element.status == "Open")
                            .length /
                        readProjectsJsonFileContent.length) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.lightGreenAccent),
        UserDashboardChartData(
            "Future (${readProjectsJsonFileContent.where((element) => element.status == "Future").length})",
            ((readProjectsJsonFileContent
                            .where((element) => element.status == "Future")
                            .length /
                        readProjectsJsonFileContent.length) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.teal),
        UserDashboardChartData(
            "Closed (${readProjectsJsonFileContent.where((element) => element.status == "Closed").length})",
            ((readProjectsJsonFileContent
                            .where((element) => element.status == "Closed")
                            .length /
                        readProjectsJsonFileContent.length) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.cyan),
        UserDashboardChartData(
            "Suggested(${readProjectsJsonFileContent.where((element) => element.status == "Suggested").length})",
            ((readProjectsJsonFileContent
                            .where((element) => element.status == "Suggested")
                            .length /
                        readProjectsJsonFileContent.length) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            primaryColour),
      ];

      return readProjectsJsonFileContent;
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

    /// Task information Variables
    readingTasksJsonData();
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
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: primaryColour,
        ),
      ),
      title: Center(
        child: Text(
          "USER DASHBOARD",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: primaryColour,
          ),
        ),
      ),
    );
  }

  buildBody(Size screenSize) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ///--- PROJECTS ---///
              const Center(
                child: Text(
                  "PROJECTS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    // color: primaryColour,
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              buildProjectStatus(context, screenSize),
              buildDivider(context, screenSize),
              buildProjects(context, screenSize),
              buildDivider(context, screenSize),
              buildProjectsTime(context, screenSize),
              buildDivider(context, screenSize),
              buildProjectProgress(context, screenSize),
              buildDivider(context, screenSize),
              buildProjectsWorkload(context, screenSize),
              buildDivider(context, screenSize),

              ///--- TASKS ---///
              const Center(
                child: Text(
                  "TASKS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    // color: primaryColour,
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              buildTaskStatus(context, screenSize),
              buildDivider(context, screenSize),
              buildTasks(context, screenSize),
              buildDivider(context, screenSize),
              buildTasksTime(context, screenSize),
              buildDivider(context, screenSize),
              buildTaskProgress(context, screenSize),
              buildDivider(context, screenSize),
            ],
          ),
        ),
      ],
    );
  }

  buildDivider(BuildContext context, Size screenSize) {
    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Divider(
          thickness: 1.5,
          color: primaryColour,
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
      ],
    );
  }

  ///--- PROJECTS ---///

  buildProjectStatus(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'STATUS',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Time',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.behindScheduleProjectsCount == null
                      ? readUserJsonFileContent.aheadOfScheduleProjectsCount ==
                              null
                          ? readUserJsonFileContent.onScheduleProjectsCount ==
                                  null
                              ? "No project(s) are scheduled."
                              : "${readUserJsonFileContent.onScheduleProjectsCount} project(s) on schedule."
                          : "${readUserJsonFileContent.aheadOfScheduleProjectsCount} project(s) ahead of schedule."
                      : "${readUserJsonFileContent.behindScheduleProjectsCount} project(s) behind schedule.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Projects',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.openProjectsCount == null
                      ? "No project(s) are open."
                      : '${(readUserJsonFileContent.openProjectsCount!).toInt()} project(s) are open.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Workload',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.overDueProjectsCount == null
                      ? "No projects(s) overdue."
                      : '${readUserJsonFileContent.overDueProjectsCount} projects(s) overdue.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Progress',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.projectProgressPercentage == null
                      ? '0% complete.'
                      : '${readUserJsonFileContent.projectProgressPercentage!.toStringAsFixed(2)}% complete.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildProjects(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROJECTS',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        SfCircularChart(
          //tooltipBehavior: _tooltipBehavior,
          legend: Legend(
            position: LegendPosition.top,
            isVisible: true,
            isResponsive: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries>[
            DoughnutSeries<UserDashboardChartData, String>(
              dataSource: userProjectChartData,
              pointColorMapper: (UserDashboardChartData data, _) => data.color,
              xValueMapper: (UserDashboardChartData data, _) => data.x,
              yValueMapper: (UserDashboardChartData data, _) => data.y,
              // Radius of doughnut's inner circle
              innerRadius: '80%',
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside),
              enableTooltip: true,
            ),
          ],
        ),
      ],
    );
  }

  buildProjectsTime(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TIME',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: readProjectsJsonFileContent.length * screenSize.height * 0.15,
          child: Center(
            child: SfCartesianChart(
              enableAxisAnimation: true,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                maximumLabelWidth: 60,
              ),
              primaryYAxis: NumericAxis(
                numberFormat:
                    NumberFormat.decimalPercentPattern(decimalDigits: 2),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(
                isVisible: true,
                // Legend will placed at the specified offset
                position: LegendPosition.top,
                // Templating the legend item
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              onLegendItemRender: (args) {
                // Setting color for the series legend based on its index.
                if (args.seriesIndex == 0) {
                  args.color = Colors.deepPurpleAccent;
                } else if (args.seriesIndex == 1) {
                  args.color = Colors.tealAccent;
                } else {
                  args.color = Colors.orangeAccent;
                }
              },
              series: <ChartSeries>[
                BarSeries<ProjectModel, String>(
                  name: "Planned Completion",
                  dataSource: readProjectsJsonFileContent,
                  xValueMapper: (ProjectModel data, _) => data.projectName,
                  yValueMapper: (ProjectModel data, _) =>
                      data.plannedProjectProgressPercentage == null ||
                              data.plannedProjectProgressPercentage == 0.0
                          ? null
                          : (data.plannedProjectProgressPercentage! / 100),
                  pointColorMapper: (ProjectModel data, _) =>
                      Colors.deepPurpleAccent,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
                BarSeries<ProjectModel, String>(
                  name: "Actual Completion",
                  dataSource: readProjectsJsonFileContent,
                  xValueMapper: (ProjectModel data, _) => data.projectName,
                  yValueMapper: (ProjectModel data, _) =>
                      data.progressPercentage == null ||
                              data.progressPercentage == 0.0
                          ? null
                          : (data.progressPercentage! / 100),
                  pointColorMapper: (ProjectModel data, _) => Colors.tealAccent,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
                BarSeries<ProjectModel, String>(
                  name: "Schedule",
                  dataSource: readProjectsJsonFileContent,
                  xValueMapper: (ProjectModel data, _) => data.projectName,
                  yValueMapper: (ProjectModel data, _) =>
                      data.progressPercentage == null ||
                              data.plannedProjectProgressPercentage == null
                          ? 0.0
                          : ((data.progressPercentage! -
                                  data.plannedProjectProgressPercentage!) /
                              100),
                  pointColorMapper: (ProjectModel data, _) =>
                      data.plannedProjectProgressPercentage == null ||
                              data.progressPercentage == null
                          ? Colors.transparent
                          : data.plannedProjectProgressPercentage! >
                                  data.progressPercentage!
                              ? Colors.orangeAccent
                              : data.plannedProjectProgressPercentage! <
                                      data.progressPercentage!
                                  ? Colors.blueAccent
                                  : data.plannedProjectProgressPercentage! ==
                                          data.progressPercentage!
                                      ? Colors.greenAccent
                                      : Colors.transparent,
                  dataLabelMapper: (ProjectModel data, _) => data
                                  .progressPercentage ==
                              null ||
                          data.plannedProjectProgressPercentage == null
                      ? ""
                      : data.progressPercentage == 0.0 ||
                              data.plannedProjectProgressPercentage == 0.0
                          ? "No Schedule Yet"
                          : data.plannedProjectProgressPercentage! >
                                  data.progressPercentage!
                              ? "${(data.plannedProjectProgressPercentage! - data.progressPercentage!)}% Behind Schedule"
                              : data.plannedProjectProgressPercentage! <
                                      data.progressPercentage!
                                  ? "${(data.progressPercentage! - data.plannedProjectProgressPercentage!)}% Ahead"
                                  : data.plannedProjectProgressPercentage! ==
                                          data.progressPercentage!
                                      ? "On Time"
                                      : "",
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildProjectProgress(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROGRESS CHART',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
            child: SfCartesianChart(
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            maximumLabelWidth: 50,
          ),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat.decimalPercentPattern(),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          // Columns will be rendered back to back
          enableSideBySideSeriesPlacement: false,

          series: <ChartSeries<ProjectModel, String>>[
            BarSeries<ProjectModel, String>(
              name: "Total Progress",
              dataSource: readProjectsJsonFileContent,
              xValueMapper: (ProjectModel data, _) =>
                  data.projectName == null ? "Project" : data.projectName!,
              yValueMapper: (ProjectModel data, _) => 1,
              pointColorMapper: (ProjectModel data, _) => Colors.grey.shade200,
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
              ),
              enableTooltip: true,
            ),
            BarSeries<ProjectModel, String>(
              opacity: 0.9,
              name: "Actual Progress",
              dataSource: readProjectsJsonFileContent,
              xValueMapper: (ProjectModel data, _) =>
                  data.projectName == null ? "Project" : data.projectName!,
              yValueMapper: (ProjectModel data, _) =>
                  data.progressPercentage!.toDouble() / 100,
              pointColorMapper: (ProjectModel data, _) =>
                  data.progressPercentage == null ||
                          data.progressPercentage == 0.0
                      ? Colors.grey
                      : data.progressPercentage! < 20.0
                          ? Colors.lightGreenAccent
                          : data.progressPercentage! < 40.0
                              ? Colors.tealAccent
                              : data.progressPercentage! < 60.0
                                  ? Colors.deepPurpleAccent
                                  : data.progressPercentage! < 80.0
                                      ? Colors.lime
                                      : primaryColour,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
            ),
          ],
        )),
      ],
    );
  }

  buildProjectsWorkload(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'WORKLOAD',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        Center(
          child: SfCartesianChart(
            enableAxisAnimation: true,
            legend: Legend(
              isVisible: true,
              // Overflowing legend content will be wraped
              overflowMode: LegendItemOverflowMode.wrap,
              // Legend will be placed at the left
              position: LegendPosition.top,
              // Templating the legend item
            ),
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              labelStyle: const TextStyle(overflow: TextOverflow.ellipsis),
              maximumLabelWidth: 60,
            ),
            series: <ChartSeries>[
              StackedBarSeries<ProjectModel, String>(
                name: 'Complete',
                dataSource: readProjectsJsonFileContent,
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) => data.doneTasksCount,
                color: Colors.tealAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
              StackedBarSeries<ProjectModel, String>(
                name: 'Remaining',
                dataSource: readProjectsJsonFileContent,
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) =>
                    data.remainingTasksCount,
                color: Colors.deepPurpleAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
              StackedBarSeries<ProjectModel, String>(
                name: 'Overdue',
                dataSource: readProjectsJsonFileContent,
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) => data.overDueTasksCount,
                color: Colors.red,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///--- TASKS ---///

  buildTaskStatus(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'STATUS',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Time',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.behindScheduleTasksCount == null
                      ? readUserJsonFileContent.aheadOfScheduleTasksCount ==
                              null
                          ? readUserJsonFileContent.onScheduleTasksCount == null
                              ? ""
                              : "${readUserJsonFileContent.onScheduleTasksCount} task(s) on schedule."
                          : "${readUserJsonFileContent.aheadOfScheduleTasksCount} task(s) ahead of schedule."
                      : "${readUserJsonFileContent.behindScheduleTasksCount} task(s) behind schedule.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Tasks',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.todoTasksCount == null &&
                          readUserJsonFileContent.inProgressTasksCount == null
                      ? ""
                      : readUserJsonFileContent.todoTasksCount == null &&
                              readUserJsonFileContent.inProgressTasksCount !=
                                  null
                          ? '${(readUserJsonFileContent.inProgressTasksCount!).toInt()} task(s) to be completed.'
                          : readUserJsonFileContent.todoTasksCount != null &&
                                  readUserJsonFileContent
                                          .inProgressTasksCount ==
                                      null
                              ? '${(readUserJsonFileContent.todoTasksCount!).toInt()} task(s) to be completed.'
                              : '${(readUserJsonFileContent.todoTasksCount! + readUserJsonFileContent.inProgressTasksCount!).toInt()} task(s) to be completed.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Workload',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.overDueTasksCount == null
                      ? ""
                      : '${readUserJsonFileContent.overDueTasksCount} task(s) overdue.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.9,
          child: Divider(
            thickness: 1,
            color: primaryColour,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.3,
                child: Text(
                  'Progress',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontWeight: FontWeight.w700,
                    fontSize: screenSize.width * 0.045,
                    //color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.5,
                child: Text(
                  readUserJsonFileContent.progressPercentage == null
                      ? '0% complete.'
                      : '${readUserJsonFileContent.progressPercentage!.toStringAsFixed(2)}% complete.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: screenSize.width * 0.04,
                    color:
                        DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    //color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildTasks(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TASKS',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        SfCircularChart(
          //tooltipBehavior: _tooltipBehavior,
          legend: Legend(
            position: LegendPosition.top,
            isVisible: true,
            isResponsive: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries>[
            DoughnutSeries<UserDashboardChartData, String>(
              dataSource: userTaskChartData,
              pointColorMapper: (UserDashboardChartData data, _) => data.color,
              xValueMapper: (UserDashboardChartData data, _) => data.x,
              yValueMapper: (UserDashboardChartData data, _) => data.y,
              // Radius of doughnut's inner circle
              innerRadius: '80%',
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside),
              enableTooltip: true,
            ),
          ],
        ),
      ],
    );
  }

  buildTasksTime(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TIME',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: readTaskJsonFileContent.length * screenSize.height * 0.1,
          child: Center(
            child: SfCartesianChart(
              enableAxisAnimation: true,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                maximumLabelWidth: 60,
              ),
              primaryYAxis: NumericAxis(
                numberFormat:
                    NumberFormat.decimalPercentPattern(decimalDigits: 2),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(
                isVisible: true,
                // Legend will placed at the specified offset
                position: LegendPosition.top,
                // Templating the legend item
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              onLegendItemRender: (args) {
                // Setting color for the series legend based on its index.
                if (args.seriesIndex == 0) {
                  args.color = Colors.deepPurpleAccent;
                } else if (args.seriesIndex == 1) {
                  args.color = Colors.tealAccent;
                } else {
                  args.color = Colors.orangeAccent;
                }
              },
              series: <ChartSeries>[
                BarSeries<TaskModel, String>(
                  name: "Planned Completion",
                  dataSource: readTaskJsonFileContent,
                  xValueMapper: (TaskModel data, _) => data.taskName,
                  yValueMapper: (TaskModel data, _) =>
                      data.plannedPercentageDone == null
                          ? 0.0
                          : (data.plannedPercentageDone! / 100),
                  pointColorMapper: (TaskModel data, _) =>
                      Colors.deepPurpleAccent,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
                BarSeries<TaskModel, String>(
                  name: "Actual Completion",
                  dataSource: readTaskJsonFileContent,
                  xValueMapper: (TaskModel data, _) => data.taskName,
                  yValueMapper: (TaskModel data, _) =>
                      data.percentageDone == null
                          ? 0.0
                          : (data.percentageDone! / 100),
                  pointColorMapper: (TaskModel data, _) => Colors.tealAccent,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
                BarSeries<TaskModel, String>(
                  name: "Schedule",
                  dataSource: readTaskJsonFileContent,
                  xValueMapper: (TaskModel data, _) => data.taskName,
                  yValueMapper: (TaskModel data, _) => data.percentageDone ==
                              null ||
                          data.plannedPercentageDone == null
                      ? 0.0
                      : ((data.percentageDone! - data.plannedPercentageDone!) /
                          100),
                  pointColorMapper: (TaskModel data, _) =>
                      data.plannedPercentageDone == null ||
                              data.percentageDone == null
                          ? Colors.transparent
                          : data.plannedPercentageDone! > data.percentageDone!
                              ? Colors.orangeAccent
                              : data.plannedPercentageDone! <
                                      data.percentageDone!
                                  ? Colors.blueAccent
                                  : data.plannedPercentageDone! ==
                                          data.percentageDone!
                                      ? Colors.greenAccent
                                      : Colors.transparent,
                  dataLabelMapper: (TaskModel data, _) => data.percentageDone ==
                              null ||
                          data.plannedPercentageDone == null
                      ? ""
                      : data.plannedPercentageDone! > data.percentageDone!
                          ? "${(data.plannedPercentageDone! - data.percentageDone!)}% Behind Schedule"
                          : data.plannedPercentageDone! < data.percentageDone!
                              ? "${(data.percentageDone! - data.plannedPercentageDone!)}% Ahead"
                              : data.plannedPercentageDone! ==
                                      data.percentageDone!
                                  ? "On Time"
                                  : "",
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildTaskProgress(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROGRESS CHART',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
              //color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
            child: SfCartesianChart(
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            maximumLabelWidth: 50,
          ),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat.decimalPercentPattern(),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          // Columns will be rendered back to back
          enableSideBySideSeriesPlacement: false,

          series: <ChartSeries<TaskModel, String>>[
            BarSeries<TaskModel, String>(
              name: "Total Progress",
              dataSource: readTaskJsonFileContent,
              xValueMapper: (TaskModel data, _) =>
                  data.taskName == null ? "Task" : data.taskName!,
              yValueMapper: (TaskModel data, _) => 1,
              pointColorMapper: (TaskModel data, _) => Colors.grey.shade200,
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
              ),
              enableTooltip: true,
            ),
            BarSeries<TaskModel, String>(
              opacity: 0.9,
              name: "Actual Progress",
              dataSource: readTaskJsonFileContent,
              xValueMapper: (TaskModel data, _) =>
                  data.taskName == null ? "Task" : data.taskName!,
              yValueMapper: (TaskModel data, _) =>
                  data.percentageDone!.toDouble() / 100,
              pointColorMapper: (TaskModel data, _) =>
                  data.percentageDone == null || data.percentageDone == 0.0
                      ? Colors.grey
                      : data.percentageDone! < 20.0
                          ? Colors.lightGreenAccent
                          : data.percentageDone! < 40.0
                              ? Colors.tealAccent
                              : data.percentageDone! < 60.0
                                  ? Colors.deepPurpleAccent
                                  : data.percentageDone! < 80.0
                                      ? Colors.lime
                                      : primaryColour,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
            ),
          ],
        )),
      ],
    );
  }
}

///------------------------------- COMPONENTS -------------------------------///

class UserDashboardChartData {
  UserDashboardChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
