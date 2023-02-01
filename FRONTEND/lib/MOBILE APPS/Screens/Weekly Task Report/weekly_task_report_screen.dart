import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:http/http.dart' as http;

class WeeklyTaskReportScreenMA extends StatefulWidget {

  const WeeklyTaskReportScreenMA({Key? key}) : super(key: key);

  @override
  State<WeeklyTaskReportScreenMA> createState() => _WeeklyTaskReportScreenMAState();
}

class _WeeklyTaskReportScreenMAState extends State<WeeklyTaskReportScreenMA> {
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
      //print("User Model Info : ${readUsersContent.firstName}");

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
      readTasksContent = taskModelFromJson(response.body).where((task) => task.assignedTo!.contains(readUserContent.username) && task.projectStatus == "Open").toList();
      //print("ALL  tasks: allTasks");

      return readTasksContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR ALL PROJECT INFO

  List<ProjectModel> readProjectsContent = <ProjectModel>[];

  Future<List<ProjectModel>> readingProjectsData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri =
    Uri.parse(AppUrl.getProjects);

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
      readProjectsContent = projectModelFromJson(response.body)
          .where((project) => project.status == "Open" && project.members!
          .where((member) =>
      member.memberUsername == readUserContent.username)
          .isNotEmpty)
          .toList();

      return readProjectsContent;
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
    readingTasksData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.430
        ? _scrollPosition / (screenSize.height * 0.430)
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
                        future: readingProjectsData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Scaffold(
                                appBar: appBar(),
                                body: buildBody(screenSize),
                                bottomNavigationBar: buildBottomNavigationBar(),
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

  appBar() {
    return AppBar(
      toolbarHeight: 100.0,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "WEEKLY PROGRESS REPORT",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: primaryColour,
                  ),
                ),
                IconButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const WeeklyTaskReportDashboardScreenMA(),
                          ),
                      );
                    },
                    icon:  Icon(
                      Icons.dashboard_outlined,
                      size: 32.0,
                      color: primaryColour,
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildBody(Size screenSize) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: buildEachTask(readTasksContent, screenSize),
    );
  }


  List<Widget> buildTaskBars(List<TaskModel> taskData, Size screenSize) {
    List<Widget> taskBars = [];

    for (int i = 0; i < taskData.length; i++) {
      taskBars.add(
        Container(
          height: screenSize.height * 0.9 ,
          width: screenSize.width,
          alignment: Alignment.centerLeft,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenSize.height * 0.02,
              ),
              child: Container(
                decoration:  BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  // border: Border.all(color: Colors.grey.shade400),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          taskData[i].status == "Done"
                              ? SizedBox(
                            width: screenSize.width * 0.2,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                            ),
                          )
                              : taskData[i].status == "In Progress"
                              ? SizedBox(
                            width: screenSize.width * 0.2,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.redAccent,
                            ),
                          )
                              : taskData[i].status == "On Hold"
                              ? SizedBox(
                            width: screenSize.width * 0.2,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.blueGrey,
                            ),
                          )
                              : SizedBox(
                            width: screenSize.width * 0.2,
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].projectName!,
                                style: TextStyle(
                                  color: primaryColour,
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.2,
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditTaskScreenMA(
                                        projectName: taskData[i].projectName,
                                        taskTitle: taskData[i].taskName!,
                                        listStatus: taskData[i].status,
                                        checkListItem: taskData[i].checklist,
                                        selectedProject: readProjectsContent.where((element) => element.projectName == taskData[i].projectName).toList()[0],
                                        navigationMenu: NavigationMenu.weeklyMeetingReportScreen,
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
                          )
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PHASE",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].projectPhase == null ? "" : taskData[i].projectPhase!,
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PHASE\nDEADLINE",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].projectPhaseDeadline == null ? "" :
                                DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(taskData[i].projectPhaseDeadline!)),
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "TASK NAME",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].taskName == null ? "" : taskData[i].taskName!,
                                style: TextStyle(
                                  color: primaryColour,
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "STATUS",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].status == null ? "" : taskData[i].status!,
                                style: TextStyle(
                                  color:  taskData[i].status == "Todo" ?
                                  Colors.orange
                                      : taskData[i].status == "In Progress" ?
                                  Colors.yellow
                                      : taskData[i].status == "On Hold" ?
                                  Colors.grey
                                      : Colors.green,
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PRIORITY",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].criticalityColour == null ? "" : impactLabel![taskData[i].criticalityColour!],
                                style: TextStyle(
                                  color:  labelColours![taskData[i].criticalityColour!],
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "WEIGHT GIVEN",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].weightGiven == null? ""
                                    : "${taskData[i].weightGiven!}%",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "START",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "DEADLINE",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].startDate == null ? "" :
                                DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(taskData[i].startDate!)),
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].deadlineDate == null ? "" :
                                DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(taskData[i].deadlineDate!)),
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.03,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "DURATION",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].duration == null ? "" : "${taskData[i].duration!} Weeks",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PROGRESS COMPLETED",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PROGRESS PLANNED",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].percentageDone == null? ""
                                    : "${taskData[i].percentageDone!}%",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].plannedPercentageDone == null? ""
                                    : "${taskData[i].plannedPercentageDone!}%",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "SCHEDULE",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].progressCategories == null? ""
                                    : taskData[i].progressCategories!,
                                style: TextStyle(
                                    color:  taskData[i].progressCategories == "Behind schedule" ?
                                    Colors.red
                                        : taskData[i].progressCategories == null ?
                                    Colors.black
                                        : Colors.green,

                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ISSUE TYPE",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                taskData[i].issuesCategory == null? "No Issue"
                                    : taskData[i].issuesCategory!,
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ROOT CAUSE\nOF ISSUE *",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width  * 0.43,
                            child: Padding(
                              padding: EdgeInsets.only(left: screenSize.width * 0.08),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  taskData[i].rootCauseOfIssues == null? ""
                                      : taskData[i].rootCauseOfIssues!,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "REMARKS",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width  * 0.43,
                            child: Padding(
                              padding: EdgeInsets.only(left: screenSize.width * 0.08),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  taskData[i].remarks == null? ""
                                      : taskData[i].remarks!,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.04,
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
                            width: screenSize.width * 0.43,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "NEXT WEEK OUTLOOK",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.43,
                            child: Padding(
                              padding: EdgeInsets.only(left: screenSize.width * 0.08),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  taskData[i].nextWeekOutlook == null? ""
                                      : taskData[i].nextWeekOutlook!,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.04,
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
          ),
        ),
      );
    }
    return taskBars;
  }

  Widget buildEachTask(List<TaskModel> taskData, Size screenSize) {
    var taskBars = buildTaskBars(taskData, screenSize);

    return SizedBox(
      height:
          taskData.length * screenSize.height * 0.9 + screenSize.height * 0.06,
      width: screenSize.width,
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

  buildBottomNavigationBar() {
    return const CustomBottomNavBarMA(
      selectedMenu: MenuState.weeklyMeetingReportScreen,
    );
  }
}
