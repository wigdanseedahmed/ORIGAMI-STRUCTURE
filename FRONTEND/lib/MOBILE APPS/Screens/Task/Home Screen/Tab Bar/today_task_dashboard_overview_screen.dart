import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class TodayTaskDashboardOverviewScreen extends StatefulWidget {
  static const String id = 'today_task_dashboard_overview_screen';

  final String? username;

  const TodayTaskDashboardOverviewScreen({Key? key, this.username})
      : super(key: key);

  @override
  _TodayTaskDashboardOverviewScreenState createState() =>
      _TodayTaskDashboardOverviewScreenState();
}

class _TodayTaskDashboardOverviewScreenState
    extends State<TodayTaskDashboardOverviewScreen>
    with TickerProviderStateMixin {
  List<TaskModel> _todayTasks = <TaskModel>[];

  DateTime current = DateTime.now();

  Future<List<TaskModel>> readingTodayTasksJsonData() async {
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
      _todayTasks = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return _todayTasks;
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
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: readingTodayTasksJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              return _buildSameTodayTaskList();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSameTodayTaskList() {
    var todayTasksFilter = _todayTasks.where(
      (element) =>
          element.assignedTo!.contains(widget.username) &&
          DateTime.parse(element.deadlineDate!).year == current.year &&
          DateTime.parse(element.deadlineDate!).month == current.month &&
          DateTime.parse(element.deadlineDate!).day == current.day,
    );

    return Scaffold(
      body: (todayTasksFilter.isEmpty)
          ? const Text(
              "No tasks are due today!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            )
          : ListView(
              children: todayTasksFilter
                  .map(
                    (task) => Container(
                      child: (task is TaskModel)
                          ? TaskCardMA(
                              taskTitle: task.taskName,
                              taskProjectName: task.projectName,
                              taskDueDateTime: task.deadlineDate,
                              colour: labelColours![task.criticalityColour!],
                              taskStatus: task.status,
                              navigationMenu: NavigationMenu.dashboardScreen,
                              taskAssignedTo: task.assignedTo,
                              taskProgressPercentage: task.percentageDone,
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
