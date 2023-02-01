import 'dart:ui';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class TaskCalendarScreenWS extends StatefulWidget {
  static const String id = 'task_calendar_screen';

  const TaskCalendarScreenWS({
    Key? key,
    required this.user,
    required this.allUsers,
  }) : super(key: key);

  final UserModel user;
  final List<UserModel> allUsers;

  @override
  _TaskCalendarScreenWSState createState() => _TaskCalendarScreenWSState();
}

class _TaskCalendarScreenWSState extends State<TaskCalendarScreenWS>
    with TickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  /// Task Variables
  late Map<DateTime, List<TaskModel>> allTasks = {};

  late final ValueNotifier<List<TaskModel>> _selectedTasks;

  late List<TaskModel> readTasksData = <TaskModel>[];

  final CalendarFormat _calendarFormat = CalendarFormat.week;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future<List<TaskModel>> readingTasksData() async {
    /// Read Local Json File Directly
    /*String jsonString = await DefaultAssetBundle.of(context)
        .loadString('jsonFile/task_data.json');*/
    //print(jsonString);

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
      readTasksData = taskModelFromJson(response.body)
          .where(
              (element) => element.assignedTo!.contains(UserProfile.username))
          .toList();
      //print("ALL  tasks: allTasks");

      return readTasksData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<Map<DateTime, List<TaskModel>>> getTask1() async {
    /// Read Local Json File Directly
    /*String jsonString = await DefaultAssetBundle.of(context)
        .loadString('jsonFile/task_data.json');*/
    //print(jsonString);

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
      readTasksData = taskModelFromJson(response.body)
          .where(
              (element) => element.assignedTo!.contains(UserProfile.username))
          .toList();
      //print("ALL  tasks: allTasks");

    } else {
      throw Exception('Unable to fetch products from the REST API');
    }

    Map<DateTime, List<TaskModel>> mapFetch = {};

    for (int i = 0; i < readTasksData.length; i++) {
      DateTime createTime = DateTime(
        DateTime.parse(readTasksData[i].deadlineDate!).year,
        DateTime.parse(readTasksData[i].deadlineDate!).month,
        DateTime.parse(readTasksData[i].deadlineDate!).day,
      );

      List<TaskModel>? original = mapFetch[createTime];

      if (original == null) {
        mapFetch[createTime] = [readTasksData[i]];
      } else {
        mapFetch[createTime] = List.from(original)
          ..addAll(
            [readTasksData[i]],
          );
      }
    }
    return mapFetch;
  }

  List<TaskModel> _getTasksForDay(DateTime dateTime) {
    return allTasks[dateTime] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDate, selectedDay)) {
      setState(() {
        _selectedDate = selectedDay;
        _focusedDate = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedTasks.value = _getTasksForDay(_selectedDate!);
    }
  }

  List<TaskModel> _getTasksForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRangeForTask(start, end);

    return [
      for (final d in days) ..._getTasksForDay(d),
    ];
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDate = null;
      _focusedDate = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedTasks.value = _getTasksForRange(start, end);
    } else if (start != null) {
      _selectedTasks.value = _getTasksForDay(start);
    } else if (end != null) {
      _selectedTasks.value = _getTasksForDay(end);
    }
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
              (element) => element.memberUsername! == widget.user.username))
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

  late OverlayEntry _overlayEntry;
  late OverlayState _overlay;

  @override
  void initState() {
    super.initState();

    getTask1();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask1().then((val) => setState(() {
            allTasks = val;
          }));
    });

    _selectedDate = _focusedDate;
    _selectedTasks = ValueNotifier(_getTasksForDay(_selectedDate!));
    readTasksData = [];

    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _overlay = Overlay.of(context)!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _projectNameController.dispose();
    _taskController.dispose();
    _selectedTasks.dispose();
    super.dispose();
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
      child: FutureBuilder<List<UserModel>?>(
        future: readAllUsersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<UserModel>(
                future: readingUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return FutureBuilder<List<TaskModel>>(
                        future: readingTasksData(),
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
        child: Column(
          children: [
            TopBarMenuAfterLoginWS(
              isSelectedPage: 'Home',
              user: readUserContent,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width / 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 9,
                    child: SizedBox(
                      height: screenSize.height * 1.2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            //color: primaryColour,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: logInAndRegistrationButtonColour)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: buildTableCalendarWithBuilders(),
                            ),
                          ),
                          Container(
                            height: 15.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: logInAndRegistrationButtonColour,
                              ),
                            ),
                          ),
                          Expanded(
                            child: buildTasksList(
                              crossAxisCount: 6,
                              crossAxisCellCount:
                              ResponsiveWidget.isLargeScreen(context) ? 3 : 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTableCalendarWithBuilders() {
    return TableCalendar<TaskModel>(
      /// earliest possible date
      firstDay: kFirstDayTask,

      /// latest allowed date
      lastDay: kLastDayTask,

      /// today's date
      focusedDay: _focusedDate,

      /// as per the documentation 'selectedDayPredicate' needs to determine current selected day.
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,

      /// default view when displayed
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,

      /// default is Sunday but can be changed according to locale
      startingDayOfWeek: StartingDayOfWeek.saturday,

      /// default is Saturday & Sunday but can be set to any day.
      /// instead of day, a number can be mentioned as well.
      weekendDays: const [DateTime.friday],

      /// height between the day row and 1st date row, default is 16.0
      daysOfWeekHeight: 20.0,

      /// height between the date rows, default is 52.0
      rowHeight: 60.0,

      ///Day Changed
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,

      /// this property needs to be added to show events
      eventLoader: (day) => readTasksData
          .where((task) => isSameDay(DateTime.parse(task.deadlineDate!), day))
          .toList(),

      /// Calendar Header Styling
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 32.0,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.black,
          size: 32.0,
        ),
      ),

      ///To style the Days of Week
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        weekendStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),

      ///To style the Calendar
      calendarStyle: const CalendarStyle(
        /// Use `CalendarStyle` to customize the UI
        outsideDaysVisible: false,
        isTodayHighlighted: true,

        /// highlighted color for today
        todayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),

        /// highlighted color for selected day
        selectedTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),

        /// highlighted color for weekend day
        weekendTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        defaultTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
      ),

      ///
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, tasks) {
          if (tasks.isNotEmpty) {
            return Positioned(
              left: 1,
              bottom: 1,
              child: buildEventsMarker(date, tasks),
            );
          }
          return null;
        },
      ),
    );
  }

  buildTasksList({
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,}) {
    var tasksFilter = readTasksData.where(
      (element) =>
          DateTime.parse(element.deadlineDate!).year == _selectedDate?.year &&
          DateTime.parse(element.deadlineDate!).month == _selectedDate?.month &&
          DateTime.parse(element.deadlineDate!).day == _selectedDate?.day,
    ).toList();

    // print(readJsonFileContent);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: logInAndRegistrationButtonColour,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60.0),
                  topRight: Radius.circular(60.0),
                ),
                color: DynamicTheme.of(context)?.brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF303030),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 30.0),
              child: (tasksFilter == null || tasksFilter.isEmpty)
                  ? const Text(
                      "No tasks are due this month!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  : ValueListenableBuilder<List<TaskModel>>(
                      valueListenable: _selectedTasks,
                      builder: (context, value, _) {
                        return Column(
                          children: [
                            StaggeredGridView.countBuilder(
                              crossAxisCount: crossAxisCount,
                              itemCount: tasksFilter.length,
                              addAutomaticKeepAlives: false,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TaskCardWS(
                                    taskData: tasksFilter[index],
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => EditTaskScreenWS(
                                          selectedProject: allProjectsData
                                              .where((element) =>
                                          element.projectName ==
                                              tasksFilter[index].projectName)
                                              .toList()[0],
                                          taskTitle: tasksFilter[index].taskName,
                                          projectName: tasksFilter[index].projectName,
                                          listStatus: tasksFilter[index].status,
                                          checkListItem: tasksFilter[index].checklist,
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
                                    allUserData: allUsersData!,
                                  ),
                                );
                              },
                              staggeredTileBuilder: (int index) => StaggeredTile.fit(
                                  (index == 0) ? crossAxisCount : crossAxisCellCount),
                            ),
                          ],
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      width: 20.0,
      height: 20.0,
      // child: Center(
      //   child: Text(
      //     '${events.length}',
      //     style: TextStyle().copyWith(
      //       color: Colors.white,
      //       fontSize: 12.0,
      //     ),
      //   ),
      // ),
    );
  }
}
