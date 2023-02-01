import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class WeekTaskDashboardOverviewScreen extends StatefulWidget {
  static const String id = 'week_task_dashboard_overview_screen';

  final String? username;

  const WeekTaskDashboardOverviewScreen({Key? key, this.username}) : super(key: key);
  @override
  _WeekTaskDashboardOverviewScreenState createState() => _WeekTaskDashboardOverviewScreenState();
}

class _WeekTaskDashboardOverviewScreenState extends State<WeekTaskDashboardOverviewScreen>
    with TickerProviderStateMixin {
  List<TaskModel> _sameWeekTasks = <TaskModel>[];

  DateTime current = DateTime.now();

  Future<List<TaskModel>> readingWeekTasksJsonData() async {
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
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      _sameWeekTasks = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return _sameWeekTasks;
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
          future: readingWeekTasksJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              return _buildSameWeekTaskList();
            }
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSameWeekTaskList() {
    var sameWeekTasksFilter = _sameWeekTasks.where((element) => element.assignedTo!.contains(widget.username) &&
    DateTime.parse(element.deadlineDate!).year == current.year && DateTime.parse(element.deadlineDate!).month == current.month
        && DateTime.parse(element.deadlineDate!).day >= current.day && DateTime.parse(element.deadlineDate!).day < current.day + 8,);

    return Scaffold(
      body: (sameWeekTasksFilter.isEmpty)
          ? const Text(
        "No tasks are due this week!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 16,),)
          : ListView(
        children: sameWeekTasksFilter
            .map((task) => Container(
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
            ) : null),).toList(),
      ),
    );
  }
}