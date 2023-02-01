import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:nb_utils/nb_utils.dart';

import 'package:path/path.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart' show FlutterIcons;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class AddNewTaskScreenWS extends StatefulWidget {
  static const String id = 'add_new_task_screen';

  final TaskModel? newTask;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const AddNewTaskScreenWS({
    Key? key,
    this.newTask,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _AddNewTaskScreenWSState createState() => _AddNewTaskScreenWSState();
}

class _AddNewTaskScreenWSState extends State<AddNewTaskScreenWS> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedEmoji = '';

  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  /// User Model information Variables
  getUserInfo() async {
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

  UserModel readUserContent = UserModel();

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

  bool showSpinner = false;

  late String errorText = "Error Text";
  late String msg = "";

  /// Variables used to store Task parameters
  final storage = const FlutterSecureStorage();

  checkTask() async {
    if (readTaskContent.taskName == null || readTaskContent.taskName!.isEmpty) {
      setState(() {
        // circular = false;
        errorText = "Project name can't be empty";
      });
    } else {
      var response = await networkHandler.get(
          "${AppUrl.checkTaskExistsByProjectName}${readTaskContent.taskName!}");
      if (response['Status'] == true) {
        setState(() {
          // circular = false;
          errorText = "Project name already taken";
          toast(errorText);
        });
      } else {
        setState(() {
          // circular = false;
        });
      }
    }
  }

  /// VARIABLES FOR ALL USERS
  List<UserModel>? _allUserData = <UserModel>[];

  // List<String>? _allUserNameList = <String>[];
  // List<String>? _allUserFullNameList = <String>[];

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

    // _allUserNameList = <String>[];
    // _allUserFullNameList = <String>[];

    if (response.statusCode == 200) {
      _allUserData = userModelListFromJson(response.body);
      // print("User Model Info : ${_allUserData}");
      //
      // for (int i = 0; i < _allUserData!.length; i++) {
      //   _allUserNameList!.add(_allUserData![i].username!);
      //   _allUserFullNameList!.add(
      //       "${_allUserData![i].firstName!} ${_allUserData![i].lastName!}");
      // }

      //print("User Model Name : ${_allUserFullNameList}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR ALL PROJECT INFO
  List<String>? _allMilestonesList = <String>[];
  List<String>? _allPhasesList = <String>[];
  List<String>? _allSkillsRequiredList = <String>[];

  List<String> _allMembersUsername = <String>[];
  List<String> _allMembersName = <String>[];

  ProjectModel readProjectContent = ProjectModel();

  Future<ProjectModel> readProjectData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.getProjectByProjectName}${widget.newTask!.projectName!}");

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

    _allMilestonesList = <String>[];
    _allPhasesList = <String>[];
    _allSkillsRequiredList = <String>[];
    _allMembersUsername = <String>[];
    _allMembersName = <String>[];

    if (response.statusCode == 200) {
      readProjectContent = projectModelFromJson(response.body)[0];

      //print("Project Info : ${readJsonFileContent}");
      //print (readProjectJsonFileContent.milestones!.length);

      if (readProjectContent.milestones != null) {
        for (int i = 0;
            i < readProjectContent.milestones!.length;
            i++) {
          _allMilestonesList!
              .add(readProjectContent.milestones![i].milestones!);
        }
      }

      if (readProjectContent.phases != null) {
        for (int j = 0; j < readProjectContent.phases!.length; j++) {
          _allPhasesList!.add(readProjectContent.phases![j].phase!);
        }
      }

      if (readProjectContent.skillsRequired != null) {
        for (int k = 0;
            k < readProjectContent.skillsRequired!.length;
            k++) {
          _allSkillsRequiredList!
              .add(readProjectContent.skillsRequired![k].skillName!);
        }
      }

      if (readProjectContent.members == null) {
        _allMembersUsername = <String>[];
      } else {
        for (int i = 0; i < readProjectContent.members!.length; i++) {
          _allMembersUsername
              .add(readProjectContent.members![i].memberUsername!);
          _allMembersName
              .add(readProjectContent.members![i].memberUsername!);
        }
      }

      return readProjectContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR TASKS
  TaskModel readTaskContent = TaskModel();

  Future<TaskModel> createTaskData(TaskModel selectedProjectInformation) async {
    String? token = await storage.read(key: "token");

    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.createTask);
    //print(selectedProjectInformation);

    /// Create Request to get data and response to read data
    final response = await http.post(
      uri,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT, PATCH"
      },
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      readTaskContent = taskFromJson(response.body);
      //print(readJsonFileContent);
      return readTaskContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    readTaskContent = TaskModel();

    readAllUsersData();
    readProjectData();

    readTaskContent = widget.newTask!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition <screenSize.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
        : 1;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: readingUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<UserModel>?>(
                future: readAllUsersData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder<ProjectModel>(
                        future: readProjectData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return AlertDialog(
                                scrollable: true,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: screenSize.width * 0.4,
                                        child: TextFormField(
                                          initialValue:
                                          readTaskContent.taskName == null
                                              ? "Task Name"
                                              : readTaskContent.taskName!,
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          cursorColor: DynamicTheme.of(context)
                                              ?.brightness ==
                                              Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          style: subTitleTextStyleMA,
                                          decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: primaryColour,
                                                width: 0.5,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: primaryColour,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              newValue == "Task Name"
                                                  ? readTaskContent.taskName = null
                                                  : readTaskContent.taskName =
                                                  newValue;
                                            });
                                          },
                                          onFieldSubmitted: (newValue) {
                                            setState(() {
                                              newValue == "Task Name"
                                                  ? readTaskContent.taskName = null
                                                  : readTaskContent.taskName =
                                                  newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            readTaskContent.dateChanged =
                                                DateTime.now();
                                            readTaskContent.projectStatus =
                                                readProjectContent.status;
                                          });
                                          if (readTaskContent.taskName != null) {
                                            await checkTask();

                                            // Hive.box<ProjectModel>('todos').add(todo);
                                            await createTaskData(readTaskContent);
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProjectBoardScreenMA(
                                                    selectedProject: widget.selectedProject,
                                                    navigationMenu: widget.navigationMenu,
                                                  ),
                                                ),
                                                    (route) => false);
                                          }
                                          else if (readTaskContent.taskName == "Task Name") {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProjectBoardScreenMA(
                                                    selectedProject: widget.selectedProject,
                                                    navigationMenu: widget.navigationMenu,
                                                  ),
                                                ),
                                                    (route) => false);
                                          }
                                          else {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProjectBoardScreenMA(
                                                    selectedProject: widget.selectedProject,
                                                    navigationMenu: widget.navigationMenu,
                                                  ),
                                                ),
                                                    (route) => false);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                          size: 24,
                                          color: primaryColour,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding:
                                const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 10.0, 10.0),
                                content: buildBody(context, screenSize),
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
  
  buildBody(BuildContext context, Size screenSize) {
    return SingleChildScrollView(
      child: SizedBox(
        width: screenSize.width * 0.5,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: screenSize.width * 0.001),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Flexible(
                            flex: (screenSize.width < 1360) ? 4 : 3,
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
                    child: Container(
                      height: screenSize.height * 0.7,
                      //width: screenSize.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.001),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "STATUS",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.15,
                                  height: 50,
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                      StateSetter dropDownState) {
                                    return DropdownSearch<String>(
                                      popupElevation: 0.0,
                                      showClearButton: true,
                                      dropdownSearchDecoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        labelStyle: subTitleTextStyleMA,
                                      ),
                                      //mode of dropdown
                                      mode: Mode.MENU,
                                      //to show search box
                                      showSearchBox: true,
                                      //list of dropdown items
                                      items: taskStatusLabel,
                                      onChanged: (String? newValue) {
                                        dropDownState(() {
                                          newValue == null ||
                                              newValue.isEmptyOrNull
                                              ? readTaskContent.status = null
                                              : readTaskContent.status =
                                              newValue;

                                          newValue == "Todo"
                                              ? readTaskContent.percentageDone =
                                          0.0
                                              : readTaskContent.status == "Done"
                                              ? readTaskContent
                                              .percentageDone = 100.0
                                              : readTaskContent
                                              .percentageDone;
                                        });
                                      },
                                      //show selected item
                                      selectedItem:
                                      readTaskContent.status == null
                                          ? ""
                                          : readTaskContent.status!,
                                      key: Key(readTaskContent.status == null
                                          ? ""
                                          : readTaskContent.status!),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "TASK SCHEDULE",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.15,
                                  height: 60,
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                      StateSetter dropDownState) {
                                    return DropdownSearch<String>(
                                      popupElevation: 0.0,
                                      showClearButton: true,
                                      dropdownSearchDecoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        labelStyle: subTitleTextStyleMA,
                                      ),
                                      //mode of dropdown
                                      mode: Mode.MENU,
                                      //to show search box
                                      showSearchBox: true,
                                      //list of dropdown items
                                      items: taskProgressCategoriesList,
                                      onChanged: (String? newValue) {
                                        dropDownState(() {
                                          newValue == null ||
                                              newValue.isEmptyOrNull
                                              ? readTaskContent
                                              .progressCategories = null
                                              : readTaskContent
                                              .progressCategories =
                                              newValue;
                                        });
                                      },
                                      key: Key(
                                        readTaskContent.progressCategories ==
                                            null
                                            ? ""
                                            : readTaskContent
                                            .progressCategories!,
                                      ),
                                      //show selected item
                                      selectedItem: readTaskContent
                                          .progressCategories ==
                                          null
                                          ? ""
                                          : readTaskContent.progressCategories!,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            colorChipsForTaskImpact(screenSize),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: screenSize.width / 50),
                                Text(
                                  "PROJECT DATES",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "START DATE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //const SizedBox(width: 105),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "DUE DATE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //const SizedBox(width: 105),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "SUBMISSION DATE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenSize.width * 0.1,
                                  child: CupertinoDateTextBox(
                                    fontSize: screenSize.width * 0.01,
                                    color:
                                    DynamicTheme.of(context)?.brightness ==
                                        Brightness.light
                                        ? Colors.grey[700]!
                                        : Colors.grey[400]!,
                                    initialValue: readTaskContent.startDate ==
                                        null
                                        ? DateTime.now()
                                        : DateFormat("yyyy-MM-dd")
                                        .parse(readTaskContent.startDate!),
                                    onDateChange: (DateTime? newDate) {
                                      //print(newDate);
                                      setState(() {
                                        newDate == DateTime.now() ||
                                            newDate == null
                                            ? readTaskContent.startDate = null
                                            : readTaskContent.startDate =
                                            newDate.toIso8601String();
                                      });
                                    },
                                    hintText: readTaskContent.startDate == null
                                        ? DateFormat().format(DateTime.now())
                                        : readTaskContent.startDate!,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.1,
                                  child: CupertinoDateTextBox(
                                    fontSize: screenSize.width * 0.01,
                                    color:
                                    DynamicTheme.of(context)?.brightness ==
                                        Brightness.light
                                        ? Colors.grey[700]!
                                        : Colors.grey[400]!,
                                    initialValue:
                                    readTaskContent.deadlineDate == null
                                        ? DateTime.now()
                                        : DateFormat('yyyy-MM-dd').parse(
                                        readTaskContent.deadlineDate!),
                                    onDateChange: (DateTime? newDate) {
                                      // print(newDate);
                                      setState(
                                            () {
                                          newDate == DateTime.now() ||
                                              newDate == null
                                              ? readTaskContent.deadlineDate =
                                          null
                                              : readTaskContent.deadlineDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(newDate);

                                          if (readTaskContent.deadlineDate ==
                                              null) {
                                            readTaskContent.progressCategories =
                                            null;
                                          } else {
                                            if (DateTime.parse(readTaskContent
                                                .deadlineDate!)
                                                .isBefore(DateTime.now()) &&
                                                readTaskContent
                                                    .percentageDone !=
                                                    100.0) {
                                              readTaskContent
                                                  .progressCategories =
                                              "Behind schedule";
                                            } else if (DateTime.parse(
                                                readTaskContent
                                                    .deadlineDate!)
                                                .isAfter(DateTime.now())) {
                                              if (readTaskContent
                                                  .percentageDone ==
                                                  readTaskContent
                                                      .plannedPercentageDone) {
                                                readTaskContent
                                                    .progressCategories =
                                                "On schedule";
                                              } else if (readTaskContent
                                                  .percentageDone! >
                                                  readTaskContent
                                                      .plannedPercentageDone!) {
                                                readTaskContent
                                                    .progressCategories =
                                                "Ahead of schedule";
                                              } else {
                                                readTaskContent
                                                    .progressCategories =
                                                "Behind schedule";
                                              }
                                            }
                                          }
                                        },
                                      );
                                    },
                                    hintText: readTaskContent.deadlineDate ==
                                        null
                                        ? DateFormat().format(DateTime.now())
                                        : readTaskContent.deadlineDate!,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.1,
                                  child: CupertinoDateTextBox(
                                    fontSize: screenSize.width * 0.01,
                                    color:
                                    DynamicTheme.of(context)?.brightness ==
                                        Brightness.light
                                        ? Colors.grey[700]!
                                        : Colors.grey[400]!,
                                    initialValue: readTaskContent
                                        .submissionDate ==
                                        null
                                        ? DateTime.now()
                                        : DateFormat("yyyy-MM-dd").parse(
                                        readTaskContent.submissionDate!),
                                    onDateChange: (DateTime? newDate) {
                                      //print(newDate);
                                      setState(() {
                                        newDate == DateTime.now() ||
                                            newDate == null
                                            ? readTaskContent.submissionDate =
                                        null
                                            : readTaskContent.submissionDate =
                                            newDate.toIso8601String();
                                      });
                                    },
                                    hintText: readTaskContent.submissionDate ==
                                        null
                                        ? DateFormat().format(DateTime.now())
                                        : readTaskContent.submissionDate!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "DURATION (IN WEEKS)",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    //fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  //padding: const EdgeInsets.only(top: 5.0),
                                  width: screenSize.width * 0.15,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    minLines: 1,
                                    maxLines: 250,
                                    autofocus: false,
                                    initialValue: readTaskContent.duration ==
                                        null
                                        ? "0"
                                        : readTaskContent.duration!.toString(),
                                    cursorColor:
                                    DynamicTheme.of(context)?.brightness ==
                                        Brightness.light
                                        ? Colors.grey[100]
                                        : Colors.grey[600],
                                    onChanged: (newValue) {
                                      newValue == "0"
                                          ? readTaskContent.duration = null
                                          : readTaskContent.duration =
                                          double.parse(newValue);
                                    },
                                    onFieldSubmitted: (newValue) {
                                      newValue.isEmptyOrNull
                                          ? readTaskContent.duration = null
                                          : readTaskContent.duration =
                                          double.parse(newValue);
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColour,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenSize.width * 0.15,
                                  child: Text(
                                    "PERCENTAGE COMPLETE",
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    width: screenSize.width * 0.15,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: readTaskContent
                                          .percentageDone ==
                                          null
                                          ? "0.0"
                                          : "${readTaskContent.percentageDone!}",
                                      key: Key(
                                        readTaskContent.percentageDone == null
                                            ? "0.0"
                                            : "${readTaskContent.percentageDone!}",
                                      ),
                                      minLines: 1,
                                      maxLines: 250,
                                      autofocus: false,
                                      cursorColor: DynamicTheme.of(context)
                                          ?.brightness ==
                                          Brightness.light
                                          ? Colors.grey[100]
                                          : Colors.grey[600],
                                      style: subTitleTextStyleMA,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          newValue.isEmptyOrNull
                                              ? readTaskContent.percentageDone =
                                          null
                                              : readTaskContent.percentageDone =
                                              newValue.toDouble();

                                          newValue.isEmptyOrNull
                                              ? readTaskContent.status = "Todo"
                                              : newValue.toDouble() == 0.0
                                              ? readTaskContent.status =
                                          "Todo"
                                              : newValue.toDouble() == 100.0
                                              ? readTaskContent.status =
                                          "Done"
                                              : newValue.toDouble();

                                          if (readTaskContent.deadlineDate ==
                                              null ||
                                              readTaskContent
                                                  .plannedPercentageDone ==
                                                  null ||
                                              newValue.isEmptyOrNull) {
                                            readTaskContent.progressCategories =
                                            null;
                                          } else {
                                            if (DateTime.parse(readTaskContent
                                                .deadlineDate!)
                                                .isBefore(
                                                DateTime.now()) ==
                                                true &&
                                                newValue.toDouble() != 100.0) {
                                              readTaskContent
                                                  .progressCategories =
                                              "Behind schedule";
                                            } else if (DateTime.parse(
                                                readTaskContent
                                                    .deadlineDate!)
                                                .isAfter(DateTime.now())) {
                                              if (newValue.toDouble() ==
                                                  readTaskContent
                                                      .plannedPercentageDone) {
                                                readTaskContent
                                                    .progressCategories =
                                                "On schedule";
                                              } else if (newValue.toDouble() >
                                                  readTaskContent
                                                      .plannedPercentageDone!) {
                                                readTaskContent
                                                    .progressCategories =
                                                "Ahead of schedule";
                                              } else {
                                                readTaskContent
                                                    .progressCategories =
                                                "Behind schedule";
                                              }
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenSize.width * 0.15,
                                  child: Text(
                                    "PLANNED PERCENTAGE COMPLETE",
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    width: screenSize.width * 0.15,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: readTaskContent
                                          .plannedPercentageDone ==
                                          null
                                          ? "0.0"
                                          : "${readTaskContent.plannedPercentageDone!}",
                                      key: Key(readTaskContent
                                          .plannedPercentageDone ==
                                          null
                                          ? "0.0"
                                          : "${readTaskContent.plannedPercentageDone!}"),
                                      minLines: 1,
                                      maxLines: 250,
                                      autofocus: false,
                                      cursorColor: DynamicTheme.of(context)
                                          ?.brightness ==
                                          Brightness.light
                                          ? Colors.grey[100]
                                          : Colors.grey[600],
                                      style: subTitleTextStyleMA,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          newValue.isEmptyOrNull
                                              ? readTaskContent
                                              .plannedPercentageDone = null
                                              : readTaskContent
                                              .plannedPercentageDone =
                                              newValue.toDouble();

                                          newValue.isEmptyOrNull
                                              ? readTaskContent
                                              .plannedPercentageDone = null
                                              : readTaskContent
                                              .plannedPercentageDone =
                                              newValue.toDouble();

                                          if (readTaskContent.deadlineDate ==
                                              null ||
                                              readTaskContent.percentageDone ==
                                                  null ||
                                              newValue.isEmptyOrNull) {
                                            readTaskContent.progressCategories =
                                            null;
                                          } else {
                                            if (DateTime.parse(readTaskContent
                                                .deadlineDate!)
                                                .isAfter(DateTime.now()) &&
                                                readTaskContent
                                                    .percentageDone !=
                                                    100.0) {
                                              readTaskContent
                                                  .progressCategories =
                                              "Behind schedule";
                                            } else {
                                              if (DateTime.parse(readTaskContent
                                                  .deadlineDate!)
                                                  .isBefore(
                                                  DateTime.now()) &&
                                                  readTaskContent
                                                      .percentageDone !=
                                                      100.0) {
                                                readTaskContent
                                                    .progressCategories =
                                                "Behind schedule";
                                              } else if (DateTime.parse(
                                                  readTaskContent
                                                      .deadlineDate!)
                                                  .isAfter(DateTime.now())) {
                                                if (readTaskContent
                                                    .percentageDone ==
                                                    newValue.toDouble()) {
                                                  readTaskContent
                                                      .progressCategories =
                                                  "On schedule";
                                                } else if (readTaskContent
                                                    .percentageDone! >
                                                    newValue.toDouble()) {
                                                  readTaskContent
                                                      .progressCategories =
                                                  "Ahead of schedule";
                                                } else {
                                                  readTaskContent
                                                      .progressCategories =
                                                  "Behind schedule";
                                                }
                                              }
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenSize.width * 0.15,
                                  child: Text(
                                    "WEIGHT GIVE (BASED ON PHASES)",
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    width: screenSize.width * 0.15,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: readTaskContent
                                          .weightGiven ==
                                          null
                                          ? "0.0\%"
                                          : "${readTaskContent.weightGiven!}\%",
                                      minLines: 1,
                                      maxLines: 250,
                                      autofocus: false,
                                      cursorColor: DynamicTheme.of(context)
                                          ?.brightness ==
                                          Brightness.light
                                          ? Colors.grey[100]
                                          : Colors.grey[600],
                                      style: subTitleTextStyleMA,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          newValue.isEmptyOrNull
                                              ? readTaskContent.weightGiven =
                                          null
                                              : readTaskContent.weightGiven =
                                              newValue.toDouble();
                                        });
                                      },
                                      onFieldSubmitted: (newValue) {
                                        setState(() {
                                          newValue.isEmptyOrNull
                                              ? readTaskContent.weightGiven =
                                          null
                                              : readTaskContent.weightGiven =
                                              newValue.toDouble();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            NewTaskInputFieldWS(
                              title: null,
                              initialValue: readTaskContent.taskDetail == null
                                  ? "TASK DESCRIPTION"
                                  : readTaskContent.taskDetail!,
                              controller: null,
                              widget: const Icon(
                                FlutterIcons.md_menu_ion,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull
                                      ? readTaskContent.taskDetail = null
                                      : readTaskContent.taskDetail = newValue;
                                });
                              },
                              onFieldSubmitted: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull
                                      ? readTaskContent.taskDetail = null
                                      : readTaskContent.taskDetail = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            buildMilestonesTitle(screenSize),
                            const SizedBox(height: 20),
                            buildPhasesTitle(screenSize),
                            const SizedBox(height: 20),
                            buildSkillsRequiredForTaskTitle(screenSize),
                            const SizedBox(height: 20),
                            buildAssignedToTitle(screenSize),
                            const SizedBox(height: 30),
                            buildAssignedByTitle(screenSize),
                            const SizedBox(height: 20),
                            NewTaskInputFieldWS(
                              title: null,
                              initialValue: readTaskContent.deliverable == null
                                  ? "DELIVERABLES"
                                  : readTaskContent.deliverable!,
                              controller: null,
                              widget: const Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull
                                      ? readTaskContent.deliverable = null
                                      : readTaskContent.deliverable = newValue;
                                });
                              },
                              onFieldSubmitted: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull
                                      ? readTaskContent.deliverable = null
                                      : readTaskContent.deliverable = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            NewTaskInputFieldWS(
                              title: null,
                              initialValue: readTaskContent.risks == null
                                  ? "INITIAL RISKS"
                                  : readTaskContent.risks!,
                              controller: null,
                              widget: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull ||
                                      newValue == "INITIAL RISKS"
                                      ? readTaskContent.risks = null
                                      : readTaskContent.risks = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "TYPE OF ISSUES",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 270,
                                  height: 50,
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                      StateSetter dropDownState) {
                                    return DropdownSearch<String>(
                                      popupElevation: 0.0,
                                      showClearButton: true,
                                      dropdownSearchDecoration:
                                      InputDecoration(
                                        focusedBorder:
                                        UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder:
                                        UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        labelStyle: subTitleTextStyleMA,
                                      ),
                                      //mode of dropdown
                                      mode: Mode.MENU,
                                      //to show search box
                                      showSearchBox: true,
                                      //list of dropdown items
                                      items: taskIssuesCategoryList,
                                      onChanged: (String? newValue) {
                                        dropDownState(() {
                                          newValue == null ||
                                              newValue.isEmptyOrNull
                                              ? readTaskContent
                                              .issuesCategory = null
                                              : readTaskContent
                                              .issuesCategory =
                                              newValue;
                                        });
                                      },
                                      //show selected item
                                      selectedItem: readTaskContent
                                          .issuesCategory ==
                                          null
                                          ? ""
                                          : readTaskContent
                                          .issuesCategory!,
                                      key: Key(readTaskContent
                                          .issuesCategory ==
                                          null
                                          ? ""
                                          : readTaskContent
                                          .issuesCategory!),
                                    );
                                  }),
                                ),
                              ],
                            )
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? const SizedBox(height: 20)
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? NewTaskInputFieldWS(
                              title: null,
                              initialValue: readTaskContent
                                  .rootCauseOfIssues ==
                                  null
                                  ? "ROOT CAUSE OF ISSUES*"
                                  : readTaskContent.rootCauseOfIssues!,
                              controller: null,
                              widget: const Icon(
                                Icons.report_problem_outlined,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue == "ROOT CAUSE OF ISSUES*" ||
                                      newValue.isEmptyOrNull
                                      ? readTaskContent
                                      .rootCauseOfIssues = null
                                      : readTaskContent
                                      .rootCauseOfIssues = newValue;
                                });
                              },
                            )
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? const SizedBox(height: 20)
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? NewTaskInputFieldWS(
                              title: null,
                              initialValue:
                              readTaskContent.remarks == null
                                  ? "REMARKS"
                                  : readTaskContent.remarks!,
                              controller: null,
                              widget: const Icon(
                                Icons.comment,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull ||
                                      newValue == "REMARKS"
                                      ? readTaskContent.remarks = null
                                      : readTaskContent.remarks =
                                      newValue;
                                });
                              },
                            )
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? const SizedBox(height: 20)
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? NewTaskInputFieldWS(
                              title: null,
                              initialValue:
                              readTaskContent.nextWeekOutlook == null
                                  ? "NEXT WEEK OUTLOOK"
                                  : readTaskContent.nextWeekOutlook!,
                              controller: null,
                              widget: const Icon(
                                Icons.next_week,
                                color: Colors.grey,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  newValue.isEmptyOrNull ||
                                      newValue == "NEXT WEEK OUTLOOK"
                                      ? readTaskContent.nextWeekOutlook =
                                  null
                                      : readTaskContent.nextWeekOutlook =
                                      newValue;
                                });
                              },
                            )
                                : Container(),
                            widget.navigationMenu ==
                                NavigationMenu.weeklyMeetingReportScreen
                                ? const SizedBox(height: 20)
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "CHECKLIST",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: screenSize.width * 0.01,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      EvaIcons.plus,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        readTaskContent.checklist == null
                                            ? readTaskContent.checklist =
                                        <ChecklistModel>[]
                                            : readTaskContent.checklist!;

                                        readTaskContent.checklist!
                                            .add(ChecklistModel());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            readTaskContent.checklist == null ||
                                readTaskContent.checklist!.isEmpty
                                ? Container()
                                : buildChecklists(
                              fullChecklistList:
                              readTaskContent.checklist,
                              screenSize: screenSize,
                              crossAxisCount: 6,
                              crossAxisCellCount:
                              ResponsiveWidget.isLargeScreen(context)
                                  ? 3
                                  : 2,
                            ),
                            buildCommentOrActivityOrFileTitle(screenSize),
                            const SizedBox(height: 20),
                            showActivities == true
                                ? readTaskContent.activities == null ||
                                readTaskContent.activities!.isEmpty
                                ? const SizedBox(height: 240)
                                : buildActivities(screenSize)
                                : showComments == true
                                ? readTaskContent.comments == null ||
                                readTaskContent.comments!.isEmpty
                                ? const SizedBox(height: 240)
                                : buildComments(screenSize)
                                : showFiles == true
                                ? readTaskContent.taskFiles == null ||
                                readTaskContent
                                    .taskFiles!.isEmpty
                                ? const SizedBox(height: 240)
                                : buildUploadFiles()
                                : const SizedBox(height: 240),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildAddComment(context, screenSize),
          ],
        ),
      ),
    );
  }

  /// IMPACT ///

  colorChipsForTaskImpact(Size screenSize) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: Icon(
          FontAwesomeIcons.tag,
          color: Colors.grey[600],
          size: 20,
        ),
      ),
      const SizedBox(
        width: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          4,
              (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  readTaskContent.criticalityColour = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? criticalLabel
                      : index == 1
                      ? highLabel
                      : index == 2
                      ? mediumLabel
                      : lowLabel,
                  child: index == readTaskContent.criticalityColour
                      ? Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

  /// MILESTONES ///

  buildMilestonesTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Icon(
              EvaIcons.flagOutline,
              color: Colors.grey,
              size: 28,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: buildMilestones(screenSize),
          ),
        ],
      ),
    );
  }

  buildMilestones(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.45,
      height: 65,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter dropDownState) {
          return DropdownSearch<String>(
            showClearButton: true,
            popupElevation: 0.0,
            dropdownSearchDecoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColour,
                  width: 0.5,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColour,
                  width: 0.5,
                ),
              ),
              labelStyle: subTitleTextStyleMA,
            ),
            //mode of dropdown
            mode: Mode.MENU,
            //to show search box
            showSearchBox: true,
            //list of dropdown items
            items: _allMilestonesList,
            onChanged: (String? newValue) {
              dropDownState(() {
                newValue == null || newValue.isEmptyOrNull
                    ? readTaskContent.projectMilestone = null
                    : readTaskContent.projectMilestone = newValue;
                // print(readTaskContent.projectMilestone );
              });
            },
            onSaved: (String? newValue) {
              dropDownState(() {
                newValue == null || newValue.isEmptyOrNull
                    ? readTaskContent.projectMilestone = null
                    : readTaskContent.projectMilestone = newValue;
                // print(readTaskContent.projectMilestone );
              });
            },
            //show selected item
            selectedItem: readTaskContent.projectMilestone == null
                ? "MILESTONES"
                : readTaskContent.projectMilestone!,
          );
        },
      ),
    );
  }

  /// PHASES ///

  buildPhasesTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.width * 0.02,
            height: 40,
            child: const Image(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/icons/phases.png",
              ),
              color: Colors.grey,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: buildPhases(screenSize),
          ),
        ],
      ),
    );
  }

  buildPhases(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.45,
      height: 65,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter dropDownState) {
            return DropdownSearch<String>(
              popupElevation: 0.0,
              showClearButton: true,
              dropdownSearchDecoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.5,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.5,
                  ),
                ),
                labelStyle: subTitleTextStyleMA,
              ),
              //mode of dropdown
              mode: Mode.MENU,
              //to show search box
              showSearchBox: true,
              //list of dropdown items
              items: _allPhasesList,
              onChanged: (String? newValue) {
                dropDownState(() {
                  newValue == null || newValue.isEmptyOrNull
                      ? readTaskContent.projectPhase = null
                      : readTaskContent.projectPhase = newValue;
                  // print(readTaskContent.projectPhase );
                });
              },
              onSaved: (String? newValue) {
                dropDownState(() {
                  newValue == null || newValue.isEmptyOrNull
                      ? readTaskContent.projectPhase = null
                      : readTaskContent.projectPhase = newValue;
                  // print(readTaskContent.projectPhase );
                });
              },
              //show selected item
              selectedItem: readTaskContent.projectPhase == null
                  ? "PHASES"
                  : readTaskContent.projectPhase!,
            );
          }),
    );
  }

  /// SKILLS REQUIRED FOR TASK ///

  buildSkillsRequiredForTaskTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SKILLS REQUIRED FOR TASK",
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: screenSize.width * 0.01,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    readTaskContent.assignedTo == null
                        ? readTaskContent.assignedTo = []
                        : readTaskContent.assignedTo!;

                    readTaskContent.skillsAssigned == null
                        ? readTaskContent.skillsAssigned = []
                        : readTaskContent.skillsAssigned!;

                    readTaskContent.skillsAssigned!.add("");
                    readTaskContent.assignedTo!.add("");
                  });

                  // skillsRequiredContainerList.add(
                  //   addNewSkillsRequiredForTask(""),);
                },
              ),
            ],
          ),
          readTaskContent.skillsAssigned == null
              ? Container()
              : Align(
            alignment: Alignment.topRight,
            child: buildSkillsRequiredForTask(screenSize),
          ),
        ],
      ),
    );
  }

  buildSkillsRequiredForTask(Size screenSize) {
    return ListView.builder(
        itemCount: readTaskContent.skillsAssigned!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SKILL ${index + 1}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.35,
                  height: 50,
                  child: StatefulBuilder(builder:
                      (BuildContext context, StateSetter dropDownState) {
                    return DropdownSearch<String>(
                      popupElevation: 0.0,
                      showClearButton: true,
                      dropdownSearchDecoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      //mode of dropdown
                      mode: Mode.MENU,
                      //to show search box
                      showSearchBox: true,
                      //list of dropdown items
                      items: _allSkillsRequiredList,
                      onChanged: (String? newValue) {
                        dropDownState(() {
                          setState(() {
                            /// SKILLS LIST
                            newValue == null
                                ? readTaskContent.skillsAssigned![index] = ""
                                : readTaskContent.skillsAssigned![index] =
                                newValue;

                            /// ASSIGNED TO LIST
                            String? assignedTo = "";

                            if (readTaskContent.skillsAssigned![index] != "") {
                              assignedTo = readProjectContent.skillsRequired!
                                  .where((element) =>
                              element.skillName ==
                                  readTaskContent.skillsAssigned![index])
                                  .toList()[0]
                                  .assignedTo;
                            }

                            if (readTaskContent.skillsAssigned![index] == "") {
                              if (assignedTo != null) {
                                if (readTaskContent.assignedTo == null) {
                                  readTaskContent.assignedTo!;
                                } else {
                                  if (readTaskContent.assignedTo!
                                      .contains(assignedTo)) {
                                    readTaskContent.assignedTo!;
                                  } else {
                                    readTaskContent.assignedTo![index] = "";
                                  }
                                }
                              }
                            } else {
                              if (assignedTo != null) {
                                if (readTaskContent.assignedTo == null) {
                                  readTaskContent.assignedTo = [];
                                  readTaskContent.assignedTo!.add(assignedTo);
                                } else {
                                  if (readTaskContent.assignedTo!
                                      .contains(assignedTo)) {
                                    readTaskContent.assignedTo!;
                                  } else {
                                    readTaskContent.assignedTo![index] =
                                        assignedTo;
                                  }
                                }
                              }
                            }

                            // print(readTaskContent.projectPhase );
                          });
                        });
                      },

                      key: Key(readTaskContent.skillsAssigned![index] == null
                          ? ""
                          : readTaskContent.skillsAssigned![index]),
                      //show selected item
                      selectedItem:
                      readTaskContent.skillsAssigned![index] == null
                          ? ""
                          : readTaskContent.skillsAssigned![index],
                    );
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (readTaskContent.assignedTo != null) {
                        if (readTaskContent.skillsAssigned!.length ==
                            readTaskContent.assignedTo!.length) {
                          readTaskContent.assignedTo!
                              .remove(readTaskContent.assignedTo![index]);
                        }
                      }
                      readTaskContent.skillsAssigned!
                          .remove(readTaskContent.skillsAssigned![index]);

                      readTaskContent.assignedTo == null ||
                          readTaskContent.assignedTo!.isEmpty
                          ? readTaskContent.assignedTo = null
                          : readTaskContent.assignedTo;

                      readTaskContent.skillsAssigned == null ||
                          readTaskContent.skillsAssigned!.isEmpty
                          ? readTaskContent.skillsAssigned = null
                          : readTaskContent.skillsAssigned;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  /// ASSIGNED TO ///

  buildAssignedToTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16.0),
      child: FutureBuilder(
        future: readAllUsersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ASSIGNED TO",
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: screenSize.width * 0.01,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              readTaskContent.assignedTo == null
                                  ? readTaskContent.assignedTo = []
                                  : readTaskContent.assignedTo!;

                              readTaskContent.skillsAssigned == null
                                  ? readTaskContent.skillsAssigned = []
                                  : readTaskContent.skillsAssigned!;

                              readTaskContent.skillsAssigned!.add("");
                              readTaskContent.assignedTo!.add("");
                            });

                            // skillsRequiredContainerList.add(
                            //   addNewSkillsRequiredForTask(""),);
                          },
                        ),
                      ),
                    ],
                  ),
                  readTaskContent.assignedTo == null
                      ? Container()
                      : Align(
                    alignment: Alignment.topRight,
                    child: buildAssignedTo(screenSize),
                  ),
                ],
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

  buildAssignedTo(Size screenSize) {
    return ListView.builder(
        itemCount: readTaskContent.assignedTo!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(
                    EvaIcons.personOutline,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.35,
                  height: 50,
                  child: StatefulBuilder(builder:
                      (BuildContext context, StateSetter dropDownState) {
                    return DropdownSearch<String>(
                      popupElevation: 0.0,
                      showClearButton: true,
                      //show selected item
                      selectedItem: readTaskContent.assignedTo![index] == ""
                          ? ""
                          : _allMembersName[_allMembersUsername.indexWhere(
                              (element) =>
                          element ==
                              readTaskContent.assignedTo![index])],
                      //show selected item
                      key: Key(readTaskContent.assignedTo![index] == ""
                          ? ""
                          : _allMembersName[_allMembersUsername.indexWhere(
                              (element) =>
                          element ==
                              readTaskContent.assignedTo![index])]),
                      dropdownSearchDecoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        labelStyle: subTitleTextStyleMA,
                      ),
                      //mode of dropdown
                      mode: Mode.MENU,
                      //to show search box
                      showSearchBox: true,
                      //list of dropdown items
                      items: _allMembersName,
                      onChanged: (String? newValue) {
                        dropDownState(() {
                          setState(() {
                            /// ASSIGNED TO LIST
                            newValue == null
                                ? readTaskContent.assignedTo![index] = ""
                                : readTaskContent.assignedTo![index] =
                            _allMembersUsername[
                            _allMembersName.indexWhere(
                                    (element) => element == newValue)];

                            /// SKILLS LIST
                            String? skillName = "";
                            if (readTaskContent.assignedTo![index] != "") {
                              skillName = readProjectContent.skillsRequired!
                                  .where((element) =>
                              element.assignedTo ==
                                  readTaskContent.assignedTo![index])
                                  .toList()[0]
                                  .skillName;
                            }

                            if (readTaskContent.assignedTo![index] == "") {
                              if (skillName != null) {
                                if (readTaskContent.skillsAssigned == null) {
                                  readTaskContent.skillsAssigned!;
                                } else {
                                  if (readTaskContent.skillsAssigned!
                                      .contains(skillName)) {
                                    readTaskContent.skillsAssigned!;
                                  } else {
                                    readTaskContent.skillsAssigned![index] = "";
                                  }
                                }
                              }
                            } else {
                              if (skillName != null) {
                                if (readTaskContent.skillsAssigned == null) {
                                  readTaskContent.skillsAssigned = [];
                                  readTaskContent.skillsAssigned!
                                      .add(skillName);
                                } else {
                                  if (readTaskContent.skillsAssigned!
                                      .contains(skillName)) {
                                    readTaskContent.skillsAssigned!;
                                  } else {
                                    readTaskContent.skillsAssigned![index] =
                                        skillName;
                                  }
                                }
                              }
                            }
                          });
                        });
                      },
                    );
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (readTaskContent.skillsAssigned != null) {
                        if (readTaskContent.skillsAssigned!.length ==
                            readTaskContent.assignedTo!.length) {
                          readTaskContent.skillsAssigned!
                              .remove(readTaskContent.skillsAssigned![index]);
                        }
                      }
                      readTaskContent.assignedTo!
                          .remove(readTaskContent.assignedTo![index]);

                      readTaskContent.assignedTo == null ||
                          readTaskContent.assignedTo!.isEmpty
                          ? readTaskContent.assignedTo = null
                          : readTaskContent.assignedTo;

                      readTaskContent.skillsAssigned == null ||
                          readTaskContent.skillsAssigned!.isEmpty
                          ? readTaskContent.skillsAssigned = null
                          : readTaskContent.skillsAssigned;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  /// ASSIGNED BY ///

  buildAssignedByTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16.0),
      child: FutureBuilder(
        future: readAllUsersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6.0),
                        child: Icon(
                          EvaIcons.personOutline,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                          width: screenSize.width * 0.05,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                            ),
                            child: Text(
                              "ASSIGNED BY",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.005,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: buildAssignedBy(screenSize),
                  ),
                ],
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

  buildAssignedBy(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.35,
      height: 50,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter dropDownState) {
            return DropdownSearch<String>(
              popupElevation: 0.0,
              showClearButton: true,
              dropdownSearchDecoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.5,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.5,
                  ),
                ),
                labelStyle: subTitleTextStyleMA,
              ),
              //mode of dropdown
              mode: Mode.MENU,
              //to show search box
              showSearchBox: true,
              //list of dropdown items
              items: _allMembersName,
              onChanged: (String? newValue) {
                dropDownState(() {
                  newValue == ""
                      ? readTaskContent.assignedBy = null
                      : readTaskContent.assignedBy = _allMembersUsername[
                  _allMembersName
                      .indexWhere((element) => element == newValue!)];

                  //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                });
              },
              //show selected item
              selectedItem: readTaskContent.assignedBy == null
                  ? ""
                  : _allMembersName[_allMembersUsername.indexWhere(
                      (element) => element == readTaskContent.assignedBy)],
            );
          }),
    );
  }

  /// CHECKLIST ///

  /// CHECKLIST ~ LIST
  buildChecklists({
    List<ChecklistModel>? fullChecklistList,
    required Size screenSize,
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,
  }) {
    int totalItems = 0;
    if (fullChecklistList == null) {
      totalItems = 0;
    } else {
      for (var i = 0; i < fullChecklistList.length; i++) {
        // print(fullChecklistList.length);
        if (fullChecklistList[i].checklistItems == null) {
          totalItems = 0;
        } else {
          for (var j = 0;
          j < fullChecklistList[i].checklistItems!.length;
          j++) {
            //print(fullChecklistList[i].checklistItems!.length);
            totalItems = totalItems + 1;
          }
        }
      }
    }

    return Column(
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: fullChecklistList!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.width * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: fullChecklistList![index].isChecked == false
                                    ? const Icon(
                                    Icons.check_box_outline_blank_outlined)
                                    : const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    fullChecklistList![index].isChecked !=
                                        fullChecklistList![index].isChecked;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.1,
                              child: TextFormField(
                                initialValue: fullChecklistList![index]
                                    .checklistTitle ==
                                    null
                                    ? "Checklist ${index + 1}"
                                    : fullChecklistList![index].checklistTitle!,
                                minLines: 1,
                                maxLines: 250,
                                autofocus: false,
                                cursorColor:
                                DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                    ? Colors.grey[100]
                                    : Colors.grey[600],
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.01,
                                  decoration:
                                  fullChecklistList![index].isChecked == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    fullChecklistList![index].checklistTitle =
                                        newValue;
                                  });
                                },
                                onFieldSubmitted: (newValue) {
                                  setState(() {
                                    fullChecklistList![index].checklistTitle =
                                        newValue;
                                  });
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    fullChecklistList!
                                        .remove(fullChecklistList![index]);

                                    fullChecklistList == []
                                        ? fullChecklistList = null
                                        : fullChecklistList;
                                    // print(fullChecklistList);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "CHECKLIST ITEM",
                                style: TextStyle(
                                    fontSize: screenSize.width * 0.01,
                                    color: primaryColour,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    fullChecklistList![index].checklistItems ==
                                        null
                                        ? fullChecklistList![index]
                                        .checklistItems = []
                                        : fullChecklistList![index]
                                        .checklistItems!;
                                    fullChecklistList![index]
                                        .checklistItems!
                                        .add(ChecklistItemModel());
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: primaryColour,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        fullChecklistList![index].checklistItems == null
                            ? Container()
                            : SizedBox(
                          height: fullChecklistList![index]
                              .checklistItems!
                              .length *
                              65,
                          child: buildChecklistItems(
                              fullChecklistItemsList:
                              fullChecklistList![index].checklistItems,
                              screenSize: screenSize),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(crossAxisCellCount),
        ),
      ],
    );
  }

  buildChecklistsOld({List<ChecklistModel>? fullChecklistList, required Size screenSize}) {
    int totalItems = 0;
    if (fullChecklistList == null) {
      totalItems = 0;
    } else {
      for (var i = 0; i < fullChecklistList.length; i++) {
        // print(fullChecklistList.length);
        if (fullChecklistList[i].checklistItems == null) {
          totalItems = 0;
        } else {
          for (var j = 0;
          j < fullChecklistList[i].checklistItems!.length;
          j++) {
            //print(fullChecklistList[i].checklistItems!.length);
            totalItems = totalItems + 1;
          }
        }
      }
    }

    return SizedBox(
      height: fullChecklistList!.length * 150 +
          (totalItems * 65) +
          ((fullChecklistList.length - 1) * 30),
      child: ListView.builder(
        itemCount: fullChecklistList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                color: Colors.black12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: fullChecklistList![index].isChecked == false
                                ? const Icon(
                                Icons.check_box_outline_blank_outlined)
                                : const Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                fullChecklistList![index].isChecked !=
                                    fullChecklistList![index].isChecked;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.15,
                          child: TextFormField(
                            initialValue:
                            fullChecklistList![index].checklistTitle == null
                                ? "Checklist ${index + 1}"
                                : fullChecklistList![index].checklistTitle!,
                            minLines: 1,
                            maxLines: 250,
                            autofocus: false,
                            cursorColor: DynamicTheme.of(context)?.brightness ==
                                Brightness.light
                                ? Colors.grey[100]
                                : Colors.grey[600],
                            style: TextStyle(
                              fontSize: screenSize.width * 0.01,
                              decoration:
                              fullChecklistList![index].isChecked == true
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                fullChecklistList![index].checklistTitle =
                                    newValue;
                              });
                            },
                            onFieldSubmitted: (newValue) {
                              setState(() {
                                fullChecklistList![index].checklistTitle =
                                    newValue;
                              });
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                fullChecklistList!
                                    .remove(fullChecklistList![index]);

                                fullChecklistList == []
                                    ? fullChecklistList = null
                                    : fullChecklistList;
                                // print(fullChecklistList);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CHECKLIST ITEM",
                            style: TextStyle(
                                fontSize: screenSize.width * 0.01,
                                color: primaryColour,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                fullChecklistList![index].checklistItems == null
                                    ? fullChecklistList![index].checklistItems =
                                []
                                    : fullChecklistList![index].checklistItems!;
                                fullChecklistList![index]
                                    .checklistItems!
                                    .add(ChecklistItemModel());
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: primaryColour,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    fullChecklistList![index].checklistItems == null
                        ? Container()
                        : SizedBox(
                      height: fullChecklistList![index]
                          .checklistItems!
                          .length *
                          65,
                      child: buildChecklistItems(
                          fullChecklistItemsList:
                          fullChecklistList![index].checklistItems,
                          screenSize: screenSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  /// CHECKLIST ~ ITEMS
  buildChecklistItems({List<ChecklistItemModel>? fullChecklistItemsList, required Size screenSize}) {
    return ListView.builder(
      itemCount: fullChecklistItemsList!.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, checklistItemIndex) {
        return Container(
          color: Colors.black12,
          height: 65,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: fullChecklistItemsList![checklistItemIndex]
                          .isChecked ==
                          false
                          ? const Icon(Icons.check_box_outline_blank_outlined)
                          : const Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          fullChecklistItemsList![checklistItemIndex]
                              .isChecked !=
                              fullChecklistItemsList![checklistItemIndex]
                                  .isChecked;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.12,
                    child: TextFormField(
                      initialValue: fullChecklistItemsList![checklistItemIndex]
                          .checklistItem ==
                          null
                          ? "Checklist Item ${checklistItemIndex + 1}"
                          : fullChecklistItemsList![checklistItemIndex]
                          .checklistItem!,
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      style: TextStyle(
                        fontSize: screenSize.width * 0.01,
                        decoration: fullChecklistItemsList![checklistItemIndex]
                            .isChecked ==
                            true
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColour,
                            width: 0.5,
                          ),
                        ),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          newValue == "Checklist Item ${checklistItemIndex + 1}"
                              ? fullChecklistItemsList![checklistItemIndex]
                              .checklistTitle = null
                              : fullChecklistItemsList![checklistItemIndex]
                              .checklistTitle = newValue;
                        });
                      },
                      onFieldSubmitted: (newValue) {
                        setState(() {
                          newValue == "Checklist Item ${checklistItemIndex + 1}"
                              ? fullChecklistItemsList![checklistItemIndex]
                              .checklistTitle = null
                              : fullChecklistItemsList![checklistItemIndex]
                              .checklistTitle = newValue;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          fullChecklistItemsList!.remove(
                              fullChecklistItemsList![checklistItemIndex]);
                          fullChecklistItemsList == []
                              ? fullChecklistItemsList = null
                              : fullChecklistItemsList;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ACTIVITY ///
  bool? showActivities = false;
  bool? showComments = false;
  bool? showFiles = false;

  buildCommentOrActivityOrFileTitle(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ACTIVITY",
            style: TextStyle(
              letterSpacing: 1,
              fontSize: screenSize.width * 0.01,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.grey,
              size: 20,
            ),
            itemBuilder: (context) {
              List<PopupMenuEntry<Object>> list = [];
              list.add(
                PopupMenuItem(
                  child: StatefulBuilder(builder: (context, _setState) {
                    return CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: primaryColour,
                        title: Text(
                          'Show Activity',
                          style: subTitleTextStyleMA,
                        ),
                        onChanged: (bool? value) {
                          _setState(() {
                            setState(() {
                              showComments = false;
                              showFiles = false;
                            });
                            showActivities = value;
                            Navigator.of(context).pop();
                          });
                        },
                        value: showActivities);
                  }),
                ),
              );
              list.add(
                PopupMenuItem(
                  child: StatefulBuilder(builder: (context, _setState) {
                    return CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: primaryColour,
                        title: Text(
                          'Show Comment',
                          style: subTitleTextStyleMA,
                        ),
                        onChanged: (bool? value) {
                          _setState(() {
                            setState(() {
                              showActivities = false;
                              showFiles = false;
                            });
                            showComments = value;
                            Navigator.of(context).pop();
                          });
                        },
                        value: showComments);
                  }),
                ),
              );
              list.add(
                PopupMenuItem(
                  child: StatefulBuilder(builder: (context, _setState) {
                    return CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: primaryColour,
                        title: Text(
                          'Show Files',
                          style: subTitleTextStyleMA,
                        ),
                        onChanged: (bool? value) {
                          _setState(() {
                            setState(() {
                              showActivities = false;
                              showComments = false;
                            });
                            showFiles = value;
                            Navigator.of(context).pop();
                          });
                        },
                        value: showFiles);
                  }),
                ),
              );
              return list;
            },
          ),
        ],
      ),
    );
  }

  /// ACTIVITY ~ ACTIVITIES

  buildActivities(Size screenSize) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        CommentModel commentData = readTaskContent.comments![index];
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commentData.image == null
                  ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: CircleAvatar(
                  radius: 20,
                  child: Text(
                    "${commentData.firstName![0]}${commentData.lastName![0]}",
                    style: const TextStyle(
                        fontSize: 10.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  Image.memory(base64Decode(commentData.image!))
                      .image,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          commentData.username.validate(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            List<PopupMenuEntry<Object>> list = [];
                            list.add(
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Text(
                                  'Edit',
                                ),
                              ),
                            );
                            list.add(
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text(
                                  'Delete',
                                ),
                              ),
                            );
                            return list;
                          },
                          onSelected: (dynamic v) {
                            if (v == 'Edit') {
                              commentData.focus = true;
                            } else {
                              readTaskContent.comments!.remove(commentData);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller:
                      TextEditingController(text: commentData.content),
                      maxLines: 6,
                      minLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: commentData.focus!,
                      onSubmitted: (v) {
                        commentData.content = v;
                        commentData.focus = false;
                        setState(() {});
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: DynamicTheme.of(context)?.brightness ==
                            Brightness.light
                            ? Colors.white
                            : Colors.white12,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor:
                                DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                    ? Colors.white
                                    : Colors.white12,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.emoji_emotions_sharp,
                                color: Colors.grey[600],
                              ).onTap(() {
                                // showDialog(
                                //   useSafeArea: true,
                                //   builder: (_) => EmojiPicker(
                                //     buttonMode: ButtonMode.CUPERTINO,
                                //     rows: 3,
                                //     columns: 7,
                                //     recommendKeywords: ["racing", "horse"],
                                //     numRecommended: 5,
                                //     onEmojiSelected: (Emoji emoji, Category category) {
                                //       data.selectedEmoji = emoji.emoji;
                                //       setState(() {});
                                //       finish(context);
                                //     },
                                //   ),
                                //   context: context,
                                // );
                              }))
                              .visible(
                            commentData.selectedEmoji == null ||
                                commentData.selectedEmoji!.isEmpty,
                            defaultWidget: Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                commentData.selectedEmoji!,
                                style: boldTextStyle(size: 20),
                              ).onTap(
                                    () {
                                  /*    showDialog(
                                                    useSafeArea: true,
                                                    builder: (_) => EmojiPicker(
                                                      buttonMode: ButtonMode.CUPERTINO,
                                                      rows: 3,
                                                      columns: 7,
                                                      recommendKeywords: ["racing", "horse"],
                                                      numRecommended: 5,
                                                      onEmojiSelected: (Emoji emoji, Category category) {
                                                        data.selectedEmoji = emoji.emoji;
                                                        setState(() {});
                                                        finish(context);
                                                      },
                                                    ),
                                                    context: context,
                                                  );*/
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            commentData.time.validate(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: readTaskContent.comments == null
          ? 0
          : readTaskContent.comments!.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  /// ACTIVITY ~ COMMENT

  buildAddComment(BuildContext context, Size screenSize) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 20,
      ),
      //height: 65,
      child: Row(
        children: [
          Icon(
            Icons.messenger_outline_outlined,
            color: Colors.grey[600],
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: TextFormField(
              controller: TextEditingController(
                text: '',
              ),
              style: TextStyle(
                fontSize: screenSize.width * 0.01,
              ),
              cursorColor: Colors.grey[600],
              minLines: 1,
              decoration: commentTaskTextFieldInputDecoration(
                  color: Colors.grey.shade600,
                  hintText: 'Add comment',
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8)),
              onFieldSubmitted: (comment) {
                readTaskContent.comments == null
                    ? readTaskContent.comments = <CommentModel>[]
                    : readTaskContent.comments!;
                readTaskContent.comments!.add(
                  CommentModel(
                    username: UserProfile.username,
                    firstName: UserProfile.firstName,
                    lastName: UserProfile.lastName,
                    image: UserProfile.userPhotoURL,
                    content: comment,
                    focus: false,
                    selectedEmoji: selectedEmoji,
                    taskTitle: readTaskContent.taskName,
                    time: DateFormat('d/M HH:mm').format(
                      DateTime.now(),
                    ),
                  ),
                );
                selectedEmoji = '';
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context, screenSize)),
              );
            },
          ),
        ],
      ),
    );
  }

  buildComments(Size screenSize) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        CommentModel commentData = readTaskContent.comments![index];
        return InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commentData.image == null
                    ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    child: Text(
                      "${commentData.firstName![0]}${commentData.lastName![0]}",
                      style: const TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    Image.memory(base64Decode(commentData.image!))
                        .image,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            commentData.username.validate(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) {
                              List<PopupMenuEntry<Object>> list = [];
                              list.add(
                                const PopupMenuItem(
                                  value: 'Edit',
                                  child: Text(
                                    'Edit',
                                  ),
                                ),
                              );
                              list.add(
                                const PopupMenuItem(
                                  value: 'Delete',
                                  child: Text(
                                    'Delete',
                                  ),
                                ),
                              );
                              return list;
                            },
                            onSelected: (dynamic v) {
                              if (v == 'Edit') {
                                commentData.focus = true;
                              } else {
                                readTaskContent.comments!.remove(commentData);
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      TextField(
                        controller:
                        TextEditingController(text: commentData.content),
                        maxLines: 6,
                        minLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: commentData.focus!,
                        onSubmitted: (v) {
                          commentData.content = v;
                          commentData.focus = false;
                          setState(() {});
                        },
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          fillColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.white12,
                          filled: true,
                          isDense: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Row(
                          children: [
                            ReactionButton<String>(
                              onReactionChanged: (String? value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selected value: $value'),
                                  ),
                                );
                              },
                              reactions: reactionsList,
                              initialReaction: Reaction<String>(
                                value: null,
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                ),
                              ),
                              boxColor: Colors.black.withOpacity(0.5),
                              boxRadius: 10,
                              boxDuration: const Duration(milliseconds: 500),
                              itemScaleDuration:
                              const Duration(milliseconds: 200),
                            ),
                            Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: DynamicTheme.of(context)
                                      ?.brightness ==
                                      Brightness.light
                                      ? Colors.white
                                      : Colors.white12,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.emoji_emotions_sharp,
                                  color: Colors.grey[600],
                                ).onTap(() {
                                  // showDialog(
                                  //   useSafeArea: true,
                                  //   builder: (_) => EmojiPicker(
                                  //     buttonMode: ButtonMode.CUPERTINO,
                                  //     rows: 3,
                                  //     columns: 7,
                                  //     recommendKeywords: ["racing", "horse"],
                                  //     numRecommended: 5,
                                  //     onEmojiSelected: (Emoji emoji, Category category) {
                                  //       data.selectedEmoji = emoji.emoji;
                                  //       setState(() {});
                                  //       finish(context);
                                  //     },
                                  //   ),
                                  //   context: context,
                                  // );
                                }))
                                .visible(
                              commentData.selectedEmoji == null ||
                                  commentData.selectedEmoji!.isEmpty,
                              defaultWidget: Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding:
                                const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  commentData.selectedEmoji!,
                                  style: boldTextStyle(size: 20),
                                ).onTap(
                                      () {
                                    /*    showDialog(
                                                      useSafeArea: true,
                                                      builder: (_) => EmojiPicker(
                                                        buttonMode: ButtonMode.CUPERTINO,
                                                        rows: 3,
                                                        columns: 7,
                                                        recommendKeywords: ["racing", "horse"],
                                                        numRecommended: 5,
                                                        onEmojiSelected: (Emoji emoji, Category category) {
                                                          data.selectedEmoji = emoji.emoji;
                                                          setState(() {});
                                                          finish(context);
                                                        },
                                                      ),
                                                      context: context,
                                                    );*/
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              commentData.time.validate(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: readTaskContent.comments == null
          ? 0
          : readTaskContent.comments!.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  /// ACTIVITY ~ FILE

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  final FileType _pickingType = FileType.any;
  final TextEditingController _controller = TextEditingController();

  List<Map> toBase64(List<File> fileList) {
    List<Map> s = <Map>[];
    if (fileList.isNotEmpty) {
      fileList.forEach((element) {
        Map a = {
          'taskFileName': element.path,
          'taskBase64File': base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    }
    return s;
  }

  List<FileModel> uploadedFiles = <FileModel>[];

  void fileUpload({PlatformFile? file, TaskModel? selectedTask}) {
    if (file == null) return;

    uploadedFiles.add(
      FileModel(
        username: UserProfile.username,
        firstName: UserProfile.firstName,
        lastName: UserProfile.lastName,
        image: UserProfile.userPhotoURL,
        taskBase64File: base64Encode(Io.File(file.path!).readAsBytesSync()),
        taskFileSize: file.size.toDouble(),
        taskTitle: readTaskContent.taskName,
        taskFileName: file.name,
        selectedEmoji: "emoji",
        time: DateTime.now().toIso8601String(),
        focus: false,
      ),
    );

    // print(uploadedFiles[0].taskBase64File);

    var uri = Uri.parse("${AppUrl.addAndUpdateTaskFiles}${readTaskContent.taskName}");

    http.post(uri, body: {
      "taskFiles": jsonEncode(uploadedFiles),
    }).then((res) {
      print(res.statusCode);
      print(res.body);
    }).catchError((err) {
      print(err);
    });

    // _futureTaskInformation = updateTasksJsonData(readTaskContent);
    // print(readTaskContent.taskFiles![0].taskBase64File);
  }

  void _pickFiles() async {
    _resetState();

    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) {
          //print(status);
        },
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;

      for (var i = 0; i < _paths!.length; i++) {
        fileUpload(file: _paths![i]);
      } //base64Encode used to convert bytes in base64URL
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
      // _saveFile();
    });
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();

      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
        //_saveFile();
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    // print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _clearCachedFiles(BuildContext context) async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );

      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;

        for (var i = 0; i < _paths!.length; i++) {
          uploadedFiles.add(
            FileModel(
              username: UserProfile.username,
              firstName: UserProfile.firstName,
              lastName: UserProfile.lastName,
              image: UserProfile.userPhotoURL,
              taskFile: _paths![i].path!,
              taskFileSize: _paths![i].size.toDouble(),
              taskTitle: readTaskContent.taskName,
              taskFileName: _saveAsFileName,
              selectedEmoji: "emoji",
              time: DateTime.now().toIso8601String(),
              focus: false,
            ),
          );
        }
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bottomSheet(context, screenSize) {
    return Container(
      height: 100.0,
      width: screenSize.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose File(s)",
            style: TextStyle(
              fontSize: 20.0,
              color: primaryColour,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.insert_drive_file, color: primaryColour),
                onPressed: () {
                  setState(() {
                    _pickFiles();
                    Navigator.pop(context);
                  });
                },
                label: Text('Pick file(s)',
                    style: TextStyle(color: primaryColour)),
              ),
              const SizedBox(width: 5),
              TextButton.icon(
                icon: Icon(Icons.folder, color: primaryColour),
                onPressed: () {
                  setState(() {
                    _selectFolder();
                    Navigator.pop(context);
                  });
                },
                label:
                Text('Pick folder', style: TextStyle(color: primaryColour)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildUploadFiles() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        FileModel fileData = uploadedFiles[index];
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fileData.image == null
                  ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: CircleAvatar(
                  radius: 20,
                  child: Text(
                    fileData.firstName == null
                        ? fileData.lastName == null
                        ? ""
                        : fileData.firstName![0]
                        : "${fileData.firstName![0]}${fileData.lastName![0]}",
                    style: const TextStyle(
                        fontSize: 10.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  Image.memory(base64Decode(fileData.image!)).image,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          fileData.username.validate(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            List<PopupMenuEntry<Object>> list = [];
                            list.add(
                              PopupMenuItem(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                            );
                            list.add(
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            );
                            return list;
                          },
                          onSelected: (dynamic v) {
                            if (v == 'Edit') {
                              fileData.focus = true;
                            } else {
                              uploadedFiles.remove(fileData);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller:
                      TextEditingController(text: fileData.taskFileName),
                      //TODO: USER Change File
                      maxLines: 6,
                      minLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus:
                      fileData.focus == null ? false : fileData.focus!,
                      onSubmitted: (v) {
                        fileData.taskBase64File = v;
                        fileData.focus = false;
                        setState(() {});
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: DynamicTheme.of(context)?.brightness ==
                            Brightness.light
                            ? Colors.white
                            : Colors.white12,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor:
                                DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                    ? Colors.white
                                    : Colors.white12,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.emoji_emotions_sharp,
                                color: Colors.grey[600],
                              ).onTap(() {
                                // showDialog(
                                //   useSafeArea: true,
                                //   builder: (_) => EmojiPicker(
                                //     buttonMode: ButtonMode.CUPERTINO,
                                //     rows: 3,
                                //     columns: 7,
                                //     recommendKeywords: ["racing", "horse"],
                                //     numRecommended: 5,
                                //     onEmojiSelected: (Emoji emoji, Category category) {
                                //       data.selectedEmoji = emoji.emoji;
                                //       setState(() {});
                                //       finish(context);
                                //     },
                                //   ),
                                //   context: context,
                                // );
                              }))
                          /*.visible(
                            fileData.selectedEmoji!.isEmpty || fileData.selectedEmoji == null,
                            defaultWidget: Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                fileData.selectedEmoji!,
                                style: boldTextStyle(size: 20),
                              ).onTap(
                                () {
                                  */
                          /*    showDialog(
                                                    useSafeArea: true,
                                                    builder: (_) => EmojiPicker(
                                                      buttonMode: ButtonMode.CUPERTINO,
                                                      rows: 3,
                                                      columns: 7,
                                                      recommendKeywords: ["racing", "horse"],
                                                      numRecommended: 5,
                                                      onEmojiSelected: (Emoji emoji, Category category) {
                                                        data.selectedEmoji = emoji.emoji;
                                                        setState(() {});
                                                        finish(context);
                                                      },
                                                    ),
                                                    context: context,
                                                  );*/ /*
                                },
                              ),
                            ),
                          ),*/
                          ,
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd – kk:mm').format(
                                DateTime.parse(fileData.time.validate())),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: uploadedFiles == null ? 0 : uploadedFiles.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  /// ACTIVITY ~ FILE
// variable section
  late List<Widget> fileListThumb;
  List<File> fileList = <File>[];

  Future pickFiles() async {
    List<Widget> thumbs = <Widget>[];
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx'],
    ).then((files) {
      if (files != null && files.count > 0) {
        files.files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

          if (picExt.contains(extension(element.path!))) {
            thumbs.add(Padding(
                padding: const EdgeInsets.all(1),
                child: Image.file(Io.File(element.path!))));
          } else {
            thumbs.add(Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(Icons.insert_drive_file),
                  Text(extension(element.path!))
                ])));
          }
          fileList.add(Io.File(element.path!));
        });
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });
  }

  List<Map> toBase64Old(List<File> fileList) {
    List<Map> s = <Map>[];
    if (fileList.isNotEmpty) {
      fileList.forEach((element) {
        Map a = {
          'taskFileName': basename(element.path),
          'taskBase64File': base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    }
    return s;
  }

  Future<bool> httpSend(Map params) async {
    String endpoint = 'yourphpscript.php';
    return await http
        .post(
            Uri.parse(
                "${AppUrl.updateTaskByTaskName}${readTaskContent.taskName}"),
            body: params)
        .then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'OK') {
          return true;
        }
      }
      return false;
    });
  }
}
