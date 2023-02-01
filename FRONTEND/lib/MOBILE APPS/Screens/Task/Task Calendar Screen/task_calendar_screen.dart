import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class TaskCalendarScreenMA extends StatefulWidget {
  static const String id = 'task_calendar_screen';

  const TaskCalendarScreenMA({Key? key}) : super(key: key);

  @override
  _TaskCalendarScreenMAState createState() => _TaskCalendarScreenMAState();
}

class _TaskCalendarScreenMAState extends State<TaskCalendarScreenMA>
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

  /// Task Variables
  late Map<DateTime, List<TaskModel>> allTasks = {};

  late final ValueNotifier<List<TaskModel>> _selectedTasks;

  late List<TaskModel> readJsonFileContent = <TaskModel>[];

  final CalendarFormat _calendarFormat = CalendarFormat.week;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future<List<TaskModel>> readingTasksJsonData() async {
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
      readJsonFileContent = taskModelFromJson(response.body)
          .where(
              (element) => element.assignedTo!.contains(UserProfile.username))
          .toList();
      //print("ALL  tasks: allTasks");

      return readJsonFileContent;
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
      readJsonFileContent = taskModelFromJson(response.body)
          .where(
              (element) => element.assignedTo!.contains(UserProfile.username))
          .toList();
      //print("ALL  tasks: allTasks");

    } else {
      throw Exception('Unable to fetch products from the REST API');
    }

    Map<DateTime, List<TaskModel>> mapFetch = {};

    for (int i = 0; i < readJsonFileContent.length; i++) {
      DateTime createTime = DateTime(
        DateTime.parse(readJsonFileContent[i].deadlineDate!).year,
        DateTime.parse(readJsonFileContent[i].deadlineDate!).month,
        DateTime.parse(readJsonFileContent[i].deadlineDate!).day,
      );

      List<TaskModel>? original = mapFetch[createTime];

      if (original == null) {
        mapFetch[createTime] = [readJsonFileContent[i]];
      } else {
        mapFetch[createTime] = List.from(original)
          ..addAll(
            [readJsonFileContent[i]],
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
    readJsonFileContent = [];

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
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: primaryColour,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: logInAndRegistrationButtonColour),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close, size: 32, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Task Calendar',
        style: TextStyle(
          letterSpacing: 3,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  buildBody() {
    return FutureBuilder(
      future: readingTasksJsonData(),
      builder: (context, data) {
        return Column(
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
              child: buildSavedEventList(),
            ),
          ],
        );
      },
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
      eventLoader: (day) => readJsonFileContent
          .where((task) => isSameDay(DateTime.parse(task.deadlineDate!), day))
          .toList(),

      /// Calendar Header Styling
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 32.0,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 32.0,
        ),
      ),

      ///To style the Days of Week
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        weekendStyle: TextStyle(
          color: Colors.white,
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
          color: Colors.white,
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

  buildSavedEventList() {
    var tasksFilter = readJsonFileContent.where(
      (element) =>
          DateTime.parse(element.deadlineDate!).year == _selectedDate?.year &&
          DateTime.parse(element.deadlineDate!).month == _selectedDate?.month &&
          DateTime.parse(element.deadlineDate!).day == _selectedDate?.day,
    );

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
                    ? const Color.fromRGBO(250, 250, 250, 1)
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
                        return ListView(
                          children: tasksFilter
                              .map(
                                (task) => Container(
                                    child: (task is TaskModel)
                                        ? TaskCardMA(
                                            taskTitle: task.taskName!,
                                            taskProjectName: task.projectName!,
                                            taskDueDateTime: task.deadlineDate!,
                                            colour: labelColours![
                                                task.criticalityColour!],
                                            taskStatus: task.status!,
                                            navigationMenu: NavigationMenu
                                                .taskCalendarScreen,
                                            taskAssignedTo:
                                                task.assignedTo == null
                                                    ? null
                                                    : task.assignedTo!,
                                            taskProgressPercentage:
                                                task.percentageDone == null
                                                    ? 0.0
                                                    : task.percentageDone!,
                                          )
                                        : null),
                              )
                              .toList(),
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
