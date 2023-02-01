import 'dart:ui';

import 'package:origami_structure/imports.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class ProjectDashboardScreenMA extends StatefulWidget {
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectDashboardScreenMA({
    Key? key,
    this.selectedProject, required this.navigationMenu,
  }) : super(key: key);

  @override
  State<ProjectDashboardScreenMA> createState() =>
      _ProjectDashboardScreenMAState();
}

class _ProjectDashboardScreenMAState extends State<ProjectDashboardScreenMA> {
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

  List<TaskChartDataSelectedProjectMA> taskChartData = <TaskChartDataSelectedProjectMA>[];

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

      taskChartData = [
        TaskChartDataSelectedProjectMA(
            "On Hold (${readProjectsJsonFileContent.onHoldTasksCount})",
            ((readProjectsJsonFileContent.onHoldTasksCount! /
                        readProjectsJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.grey),
        TaskChartDataSelectedProjectMA(
            "Todo (${readProjectsJsonFileContent.todoTasksCount})",
            ((readProjectsJsonFileContent.todoTasksCount! /
                        readProjectsJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.lightGreenAccent),
        TaskChartDataSelectedProjectMA(
            "In Progress (${readProjectsJsonFileContent.inProgressTasksCount})",
            ((readProjectsJsonFileContent.inProgressTasksCount! /
                        readProjectsJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.tealAccent),
        TaskChartDataSelectedProjectMA(
            "Done (${readProjectsJsonFileContent.doneTasksCount})",
            ((readProjectsJsonFileContent.doneTasksCount! /
                        readProjectsJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            primaryColour)
      ];

      return readTasksJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
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
              //print(tasksStatusList);
              return FutureBuilder(
                future: readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Scaffold(
                        appBar: buildAppBar(context, screenSize),
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

  buildAppBar(BuildContext context, Size screenSize) {
    return AppBar(
      backgroundColor: DynamicTheme.of(context)?.brightness == Brightness.light
          ? Colors.black12
          : Colors.white12,
      elevation: 0.0,
      title: Text(
        readProjectsJsonFileContent.projectName!,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColour,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: primaryColour,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProjectBoardScreenMA(
                    selectedProject: readProjectsJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  ),
            ),
          );
        },
      ),
    );
  }

  buildBody(BuildContext context, Size screenSize) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildHealth(context, screenSize),
              buildDivider(context, screenSize),
              buildTasks(context, screenSize),
              buildDivider(context, screenSize),
              buildProgress(context, screenSize),
              buildDivider(context, screenSize),
              buildPhaseProgress(context, screenSize),
              buildDivider(context, screenSize),
              buildTime(context, screenSize),
              buildDivider(context, screenSize),
              buildTaskProgress(context, screenSize),
              buildDivider(context, screenSize),
              buildCost(context, screenSize),
              buildDivider(context, screenSize),
              buildWorkload(context, screenSize),
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

  buildHealth(BuildContext context, Size screenSize) {
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
                  readProjectsJsonFileContent
                                  .plannedProjectProgressPercentage ==
                              null ||
                          readProjectsJsonFileContent.progressPercentage == null
                      ? ""
                      : readProjectsJsonFileContent
                                  .plannedProjectProgressPercentage! >
                              readProjectsJsonFileContent.progressPercentage!
                          ? "${readProjectsJsonFileContent.plannedProjectProgressPercentage! - readProjectsJsonFileContent.progressPercentage!}% behind Schedule."
                          : readProjectsJsonFileContent
                                      .plannedProjectProgressPercentage! <
                                  readProjectsJsonFileContent
                                      .progressPercentage!
                              ? '${(readProjectsJsonFileContent.progressPercentage! - readProjectsJsonFileContent.plannedProjectProgressPercentage!)}% ahead of schedule.'
                              : readProjectsJsonFileContent
                                          .plannedProjectProgressPercentage! ==
                                      readProjectsJsonFileContent
                                          .progressPercentage!
                                  ? "On Time."
                                  : "",
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
                  readProjectsJsonFileContent.todoTasksCount == null &&
                          readProjectsJsonFileContent.inProgressTasksCount ==
                              null
                      ? ""
                      : readProjectsJsonFileContent.todoTasksCount == null &&
                              readProjectsJsonFileContent
                                      .inProgressTasksCount !=
                                  null
                          ? '${(readProjectsJsonFileContent.inProgressTasksCount!).toInt()} tasks to be completed.'
                          : readProjectsJsonFileContent.todoTasksCount !=
                                      null &&
                                  readProjectsJsonFileContent
                                          .inProgressTasksCount ==
                                      null
                              ? '${(readProjectsJsonFileContent.todoTasksCount!).toInt()} tasks to be completed.'
                              : '${(readProjectsJsonFileContent.todoTasksCount! + readProjectsJsonFileContent.inProgressTasksCount!).toInt()} tasks to be completed.',
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
                  readProjectsJsonFileContent.overDueTasksCount == null
                      ? ""
                      : '${readProjectsJsonFileContent.overDueTasksCount} tasks overdue.',
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
                  'Members',
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
                  readProjectsJsonFileContent.members == null
                      ? ""
                      : '${readProjectsJsonFileContent.members!.length} people in the team.',
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
                  readProjectsJsonFileContent.progressPercentage == null
                      ? '0% complete.'
                      : '${readProjectsJsonFileContent.progressPercentage!.toStringAsFixed(2)}% complete.',
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
                  'Cost',
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
                  readProjectsJsonFileContent.totalResourceCost! >
                          readProjectsJsonFileContent.totalBudget!
                      ? "${(((readProjectsJsonFileContent.totalResourceCost! - readProjectsJsonFileContent.totalBudget!) / readProjectsJsonFileContent.totalBudget!) * 100)}% under budget."
                      : readProjectsJsonFileContent.totalBudget! <
                              readProjectsJsonFileContent.totalResourceCost!
                          ? '${(((readProjectsJsonFileContent.totalBudget! - readProjectsJsonFileContent.totalResourceCost!) / readProjectsJsonFileContent.totalBudget!) * 100)}% over budget.'
                          : readProjectsJsonFileContent.totalBudget! ==
                                  readProjectsJsonFileContent.totalResourceCost!
                              ? "On budget."
                              : readProjectsJsonFileContent.totalBudget ==
                                          null &&
                                      readProjectsJsonFileContent
                                              .totalResourceCost !=
                                          null
                                  ? "No budget defined."
                                  : readProjectsJsonFileContent.totalBudget !=
                                              null &&
                                          readProjectsJsonFileContent
                                                  .totalResourceCost ==
                                              null
                                      ? "No actual cost yet."
                                      : "",
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
                  'Donations',
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
                  readProjectsJsonFileContent.totalDonatedAmount! >
                          readProjectsJsonFileContent.totalBudget!
                      ? "${((readProjectsJsonFileContent.totalDonatedAmount! / readProjectsJsonFileContent.totalBudget!) * 100) - 100}% over donated."
                      : readProjectsJsonFileContent.totalBudget! <
                              readProjectsJsonFileContent.totalDonatedAmount!
                          ? '${(readProjectsJsonFileContent.totalDonatedAmount! / readProjectsJsonFileContent.totalBudget!) * 100}% donated.'
                          : readProjectsJsonFileContent.totalBudget! ==
                                  readProjectsJsonFileContent
                                      .totalDonatedAmount!
                              ? "Total amount donated."
                              : readProjectsJsonFileContent.totalBudget ==
                                          null &&
                                      readProjectsJsonFileContent
                                              .totalDonatedAmount !=
                                          null
                                  ? "No budget defined."
                                  : readProjectsJsonFileContent.totalBudget !=
                                              null &&
                                          readProjectsJsonFileContent
                                                  .totalDonatedAmount ==
                                              null
                                      ? "No donated amount yet."
                                      : "",
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
            DoughnutSeries<TaskChartDataSelectedProjectMA, String>(
              dataSource: taskChartData,
              pointColorMapper: (TaskChartDataSelectedProjectMA data, _) => data.color,
              xValueMapper: (TaskChartDataSelectedProjectMA data, _) => data.x,
              yValueMapper: (TaskChartDataSelectedProjectMA data, _) => data.y,
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

  buildProgress(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROGRESS',
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
          ),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat.decimalPercentPattern(),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: Legend(
            isVisible: true,
            // Legend will placed at the specified offset
            position: LegendPosition.top,
            // Templating the legend item
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          // Event to customize the legend on rendering
          onLegendItemRender: (args) {
            // Setting color for the series legend based on its index.
            args.color = Colors.transparent;
          },
          series: <ChartSeries<PhasesModel, String>>[
            BarSeries<PhasesModel, String>(
              name: "Actual Progress",
              dataSource: readProjectsJsonFileContent.phases!,
              xValueMapper: (PhasesModel data, _) =>
                  data.phase == null ? "Phase" : data.phase!,
              yValueMapper: (PhasesModel data, _) =>
                  data.progressPercentage!.toDouble() / 100,
              pointColorMapper: (PhasesModel data, _) =>
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
            BarSeries<PhasesModel, String>(
              name: "Planned Progress",
              dataSource: readProjectsJsonFileContent.phases!,
              xValueMapper: (PhasesModel data, _) =>
                  data.phase == null ? "Phase" : data.phase!,
              yValueMapper: (PhasesModel data, _) =>
                  data.plannedPhaseProgressPercentage!.toDouble() / 100,
              pointColorMapper: (PhasesModel data, _) =>
                  data.plannedPhaseProgressPercentage == null ||
                          data.plannedPhaseProgressPercentage == 0.0
                      ? Colors.grey.shade500
                      : data.plannedPhaseProgressPercentage! < 20.0
                          ? Colors.lightGreenAccent.shade400
                          : data.plannedPhaseProgressPercentage! < 40.0
                              ? Colors.tealAccent.shade400
                              : data.plannedPhaseProgressPercentage! < 60.0
                                  ? Colors.deepPurpleAccent.shade400
                                  : data.plannedPhaseProgressPercentage! < 80.0
                                      ? Colors.lime.shade400
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

  buildPhaseProgress(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PHASE PROGRESS CHART',
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

          series: <ChartSeries<PhasesModel, String>>[
            BarSeries<PhasesModel, String>(
              name: "Total Progress",
              dataSource: readProjectsJsonFileContent.phases!,
              xValueMapper: (PhasesModel data, _) =>
                  data.phase == null ? "Phase" : data.phase!,
              yValueMapper: (PhasesModel data, _) => 1,
              pointColorMapper: (PhasesModel data, _) => Colors.grey.shade200,
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
              ),
              enableTooltip: true,
            ),
            BarSeries<PhasesModel, String>(
              opacity: 0.9,
              name: "Actual Progress",
              dataSource: readProjectsJsonFileContent.phases!,
              xValueMapper: (PhasesModel data, _) =>
                  data.phase == null ? "Phase" : data.phase!,
              yValueMapper: (PhasesModel data, _) =>
                  data.progressPercentage!.toDouble() / 100,
              pointColorMapper: (PhasesModel data, _) =>
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

  buildTime(BuildContext context, Size screenSize) {
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
        Center(
          child: SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              isVisible: false,
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
                args.color = readProjectsJsonFileContent
                            .plannedProjectProgressPercentage! >
                        readProjectsJsonFileContent.progressPercentage!
                    ? Colors.orangeAccent
                    : readProjectsJsonFileContent
                                .plannedProjectProgressPercentage! <
                            readProjectsJsonFileContent.progressPercentage!
                        ? Colors.blueAccent
                        : readProjectsJsonFileContent
                                    .plannedProjectProgressPercentage! ==
                                readProjectsJsonFileContent.progressPercentage!
                            ? Colors.greenAccent
                            : Colors.transparent;
              }
            },
            series: <ChartSeries>[
              BarSeries<ProjectModel, String>(
                name: "Planned Completion",
                dataSource: [readProjectsJsonFileContent],
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) =>
                    data.plannedProjectProgressPercentage == null
                        ? 0.0
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
                dataSource: [readProjectsJsonFileContent],
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) =>
                    data.progressPercentage == null
                        ? 0.0
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
                name: readProjectsJsonFileContent
                            .plannedProjectProgressPercentage! >
                        readProjectsJsonFileContent.progressPercentage!
                    ? "Behind Schedule"
                    : readProjectsJsonFileContent
                                .plannedProjectProgressPercentage! <
                            readProjectsJsonFileContent.progressPercentage!
                        ? "Ahead"
                        : readProjectsJsonFileContent
                                    .plannedProjectProgressPercentage! ==
                                readProjectsJsonFileContent.progressPercentage!
                            ? "On Time"
                            : "Unknown",
                dataSource: [readProjectsJsonFileContent],
                xValueMapper: (ProjectModel data, _) => data.projectName,
                yValueMapper: (ProjectModel data, _) =>
                    data.progressPercentage == null ||
                            data.plannedProjectProgressPercentage == null
                        ? 0.0
                        : ((data.progressPercentage! -
                                data.plannedProjectProgressPercentage!) /
                            100),
                pointColorMapper: (ProjectModel data, _) =>
                    data.plannedProjectProgressPercentage! >
                            data.progressPercentage!
                        ? Colors.orangeAccent
                        : data.plannedProjectProgressPercentage! <
                                data.progressPercentage!
                            ? Colors.blueAccent
                            : data.plannedProjectProgressPercentage! ==
                                    data.progressPercentage!
                                ? Colors.greenAccent
                                : Colors.transparent,
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
      ],
    );
  }

  buildTaskProgress(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TASKS PROGRESS CHART',
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
              dataSource: readTasksJsonFileContent,
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
              dataSource: readTasksJsonFileContent,
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

  buildCost(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'COST',
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
        SfCartesianChart(
          enableAxisAnimation: true,
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
          ),
          primaryXAxis: CategoryAxis(isVisible: false),
          legend: Legend(
            isVisible: true,
            // Legend will placed at the specified offset
            position: LegendPosition.top,
            // Templating the legend item
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          // Event to customize the legend on rendering
          onLegendItemRender: (args) {
            // Setting color for the series legend based on its index.
            if (args.seriesIndex == 0) {
              args.color = Colors.greenAccent;
            } else if (args.seriesIndex == 1) {
              args.color = Colors.tealAccent;
            } else if (args.seriesIndex == 2) {
              args.color = Colors.blueAccent;
            } else {
              args.color = Colors.deepPurpleAccent;
            }
          },
          series: <CartesianSeries>[
            ColumnSeries<ProjectModel, String>(
              name: "Actual",
              dataSource: [readProjectsJsonFileContent],
              xValueMapper: (ProjectModel data, _) => data.projectName,
              yValueMapper: (ProjectModel data, _) =>
                  data.totalResourceCost == null
                      ? 0.0
                      : data.totalResourceCost!,
              pointColorMapper: (ProjectModel data, _) => Colors.greenAccent,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
            ColumnSeries<ProjectModel, String>(
              name: "Planned",
              dataSource: [readProjectsJsonFileContent],
              xValueMapper: (ProjectModel data, _) => data.projectName,
              yValueMapper: (ProjectModel data, _) =>
                  data.totalEstimatedCost == null
                      ? 0.0
                      : data.totalEstimatedCost!,
              pointColorMapper: (ProjectModel data, _) => Colors.tealAccent,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
            ColumnSeries<ProjectModel, String>(
              name: "Budget",
              dataSource: [readProjectsJsonFileContent],
              xValueMapper: (ProjectModel data, _) => data.projectName,
              yValueMapper: (ProjectModel data, _) =>
                  data.totalBudget == null ? 0.0 : data.totalBudget!,
              pointColorMapper: (ProjectModel data, _) => Colors.blueAccent,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
            ColumnSeries<ProjectModel, String>(
              name: "Donated Amount",
              dataSource: [readProjectsJsonFileContent],
              xValueMapper: (ProjectModel data, _) => data.projectName,
              yValueMapper: (ProjectModel data, _) =>
                  data.totalDonatedAmount == null
                      ? 0.0
                      : data.totalDonatedAmount!,
              pointColorMapper: (ProjectModel data, _) =>
                  Colors.deepPurpleAccent,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildWorkload(BuildContext context, Size screenSize) {
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
              StackedBarSeries<MembersModel, String>(
                name: 'Complete',
                dataSource: readProjectsJsonFileContent.members!,
                xValueMapper: (MembersModel data, _) => data.memberName,
                yValueMapper: (MembersModel data, _) => data.doneTasksCount,
                color: Colors.tealAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
              StackedBarSeries<MembersModel, String>(
                name: 'Remaining',
                dataSource: readProjectsJsonFileContent.members!,
                xValueMapper: (MembersModel data, _) => data.memberName,
                yValueMapper: (MembersModel data, _) =>
                    data.remainingTasksCount,
                color: Colors.deepPurpleAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
              StackedBarSeries<MembersModel, String>(
                name: 'Overdue',
                dataSource: readProjectsJsonFileContent.members!,
                xValueMapper: (MembersModel data, _) => data.memberName,
                yValueMapper: (MembersModel data, _) => data.overDueTasksCount,
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
}

///------------------------------- COMPONENTS -------------------------------///

class TaskChartDataSelectedProjectMA {
  TaskChartDataSelectedProjectMA(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
