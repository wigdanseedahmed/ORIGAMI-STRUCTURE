import 'dart:ui';

import 'package:origami_structure/imports.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:date_utils/date_utils.dart';

import 'package:http/http.dart' as http;

class ProjectTimelineScreenMA extends StatefulWidget {
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectTimelineScreenMA({Key? key, this.selectedProject, required this.navigationMenu,})
      : super(key: key);

  @override
  State<ProjectTimelineScreenMA> createState() =>
      _ProjectTimelineScreenMAState();
}

class _ProjectTimelineScreenMAState
    extends State<ProjectTimelineScreenMA>
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
                        appBar: buildAppBar(context),
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

  buildAppBar(BuildContext context) {
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
              fontSize: MediaQuery.of(context).size.width * 0.05,
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
                (readTasksJsonFileContent.length * screenSize.height * 0.0328) +
                    readProjectsJsonFileContent.phases!.length *
                        (screenSize.height * 0.078 +
                            screenSize.height * 0.0008 +
                            screenSize.height * 0.0034),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: PhasesTasksGanttChartMA(
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
              fontSize: MediaQuery.of(context).size.width * 0.05,
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
                (readTasksJsonFileContent.length * screenSize.height * 0.0328) +
                    memberWithTasks.length *
                        (screenSize.height * 0.078 +
                            screenSize.height * 0.0008 +
                            screenSize.height * 0.0034),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: MembersTasksGanttChartMA(
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
              fontSize: MediaQuery.of(context).size.width * 0.05,
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
                    0.0328) +
                screenSize.height * 0.078 +
                screenSize.height * 0.0008 +
                screenSize.height * 0.0034,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: PhasesGanttChartMA(
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
