import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class MonthTaskDashboardOverviewScreen extends StatefulWidget {
  static const String id = 'month_task_dashboard_overview_screen';

  final String? username;

  const MonthTaskDashboardOverviewScreen({Key? key, this.username}) : super(key: key);
  @override
  _MonthTaskDashboardOverviewScreenState createState() => _MonthTaskDashboardOverviewScreenState();
}

class _MonthTaskDashboardOverviewScreenState extends State<MonthTaskDashboardOverviewScreen>
    with TickerProviderStateMixin {
  late List<TaskModel> _sameMonthTasks = <TaskModel>[];

  DateTime current = DateTime.now();

  Future<List<TaskModel>> readingMonthTasksJsonData() async {
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
      _sameMonthTasks = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return _sameMonthTasks;
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
          future: readingMonthTasksJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              return _buildSameMonthTaskList();
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

  Widget _buildSameMonthTaskList() {
    var sameMonthTasksFilter = _sameMonthTasks.where((element) => element.assignedTo!.contains(widget.username) &&
    DateTime.parse(element.deadlineDate!).year == current.year
        && DateTime.parse(element.deadlineDate!).month == current.month,
    );

    // print(_sameMonthTasks);

    return Scaffold(
      body: (sameMonthTasksFilter.isEmpty)
          ? const Text(
        "No tasks are due this month!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 16,),)
          : ListView(
        children: sameMonthTasksFilter
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