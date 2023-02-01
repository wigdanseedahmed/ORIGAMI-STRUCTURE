import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:line_icons/line_icons.dart' as lineIcons;

import 'package:http/http.dart' as http;

class RecommendedUserHistoryScreenMA extends StatefulWidget {
  final UserModel selectedRecommendedUserInformation;
  final RecommendedUserModel selectedRecommendedUserResultDetails;
  final List<RecommendedUserModel> allRecommendedUsers;

  const RecommendedUserHistoryScreenMA({
    Key? key,
    required this.selectedRecommendedUserInformation,
    required this.selectedRecommendedUserResultDetails,
    required this.allRecommendedUsers,
  }) : super(key: key);

  @override
  _RecommendedUserHistoryScreenMAState createState() =>
      _RecommendedUserHistoryScreenMAState();
}

class _RecommendedUserHistoryScreenMAState
    extends State<RecommendedUserHistoryScreenMA>
    with TickerProviderStateMixin {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  UserModel readUserJsonFileContent = UserModel();

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
          .where((element) =>
              element.username ==
              widget.selectedRecommendedUserResultDetails.username)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      userTaskChartData = [
        RecommendedUserTaskChartData(
            "On Hold (${readUserJsonFileContent.onHoldTasksCount})",
            ((readUserJsonFileContent.onHoldTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.grey),
        RecommendedUserTaskChartData(
            "Todo (${readUserJsonFileContent.todoTasksCount})",
            ((readUserJsonFileContent.todoTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.lightGreenAccent),
        RecommendedUserTaskChartData(
            "In Progress (${readUserJsonFileContent.inProgressTasksCount})",
            ((readUserJsonFileContent.inProgressTasksCount! /
                        readUserJsonFileContent.tasksNumber!) *
                    100)
                .toStringAsFixed(2)
                .toDouble(),
            Colors.tealAccent),
        RecommendedUserTaskChartData(
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

  ///VARIABLES USED FOR RETRIEVING TASKS FOR USER

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
      readTaskJsonFileContent = taskModelFromJson(response.body)
          .where((task) =>
              task.assignedTo!.contains(readUserJsonFileContent.username) &&
              task.projectStatus == "Open")
          .toList();
      //print("ALL  tasks: allTasks");

      return readTaskJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR RETRIEVING ALL PROJECTS
  late List<ProjectModel> readProjectsJsonFileContent = <ProjectModel>[];

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
          .where((project) =>
              project.status == "Open" &&
              project.members!
                  .where((member) =>
                      member.memberUsername == readUserJsonFileContent.username)
                  .isNotEmpty)
          .toList();
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

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
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
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

  buildBody(Size screenSize) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildScoreSummary(context, screenSize),
              buildDivider(context, screenSize),
              buildHealth(context, screenSize),
              buildDivider(context, screenSize),
              buildTasks(context, screenSize),
              buildDivider(context, screenSize),
              buildTime(context, screenSize),
              buildDivider(context, screenSize),
              buildTaskProgress(context, screenSize),
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

  //TODO: ADD USER PERCENTAGE INDICATOR OF USER SCORE
  buildUserScore(BuildContext context, Size screenSize) {
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

  buildScoreSummary(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'SCORE SUMMARY',
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
                width: screenSize.width * 0.5,
                child: Text(
                  'Job Title',
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
                width: screenSize.width * 0.3,
                child: Text(
                  widget.selectedRecommendedUserResultDetails.userJobFieldScore == null
                      ? "- / 1.0"
                      : '${widget.selectedRecommendedUserResultDetails.userJobFieldScore} / 1',
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
                width: screenSize.width * 0.5,
                child: Text(
                  'Job Sub-Field',
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
                width: screenSize.width * 0.3,
                child: Text(
                  widget.selectedRecommendedUserResultDetails.userJobSubFieldScore == null
                      ? "- / 1.0"
                      : '${widget.selectedRecommendedUserResultDetails.userJobSubFieldScore} / 1',
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
                width: screenSize.width * 0.5,
                child: Text(
                  'Job Specialization',
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
                width: screenSize.width * 0.3,
                child: Text(
                  widget.selectedRecommendedUserResultDetails.userJobSpecializationScore == null
                      ? "- / 1.0"
                      : '${widget.selectedRecommendedUserResultDetails.userJobSpecializationScore} / 1',
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
                width: screenSize.width * 0.5,
                child: Text(
                  'Hard Skills',
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
                width: screenSize.width * 0.3,
                child: Text(
                  widget.selectedRecommendedUserResultDetails
                              .totalHardSkillsScore ==
                          null
                      ? ''
                      : widget.selectedRecommendedUserResultDetails
                                  .userHardSkillsScore ==
                              null
                          ? '- / ${widget.selectedRecommendedUserResultDetails.totalHardSkillsScore}'
                          : '${widget.selectedRecommendedUserResultDetails.userHardSkillsScore} / ${widget.selectedRecommendedUserResultDetails.totalHardSkillsScore}',
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
            DoughnutSeries<RecommendedUserTaskChartData, String>(
              dataSource: userTaskChartData,
              pointColorMapper: (RecommendedUserTaskChartData data, _) =>
                  data.color,
              xValueMapper: (RecommendedUserTaskChartData data, _) => data.x,
              yValueMapper: (RecommendedUserTaskChartData data, _) => data.y,
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

  //PER TASK
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

  //PER PROJECT
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
}

///------------------------------- COMPONENTS -------------------------------///

class RecommendedUserTaskChartData {
  RecommendedUserTaskChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
