import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class SuggestedProjectScreenMA extends StatefulWidget {
  static const String id = 'suggested_project_screen';

  final String username;

  const SuggestedProjectScreenMA({Key? key, required this.username}) : super(key: key);
  @override
  _SuggestedProjectScreenMAState createState() => _SuggestedProjectScreenMAState();
}

class _SuggestedProjectScreenMAState extends State<SuggestedProjectScreenMA>
    with TickerProviderStateMixin {
  late List<ProjectModel> _suggestedProjects = <ProjectModel>[];

  Future<List<ProjectModel>> readingSuggestedProjectJsonData() async {
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
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      _suggestedProjects = projectModelFromJson(response.body).where((element) => element.members!.any((element) =>
      element.memberUsername == widget.username))
          .toList();
      // print("ALL  projects: $_allProjects");

      return _suggestedProjects;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR USERS
  List<UserModel>? _allUserData = <UserModel>[];

  Future<List<UserModel>?> readAllUsersJsonData() async {
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
      _allUserData = userModelListFromJson(response.body);
      // print("User Model Info : ${readJsonFileContent}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR TASKS
  List<TaskModel>? _allTaskData = <TaskModel>[];

  Future<List<TaskModel>?> readAllTasksJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.tasks);

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
      _allTaskData = taskModelFromJson(response.body);
      // print("User Model Info : ${_allTaskData}");

      return _allTaskData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    readAllUsersJsonData();
    readAllTasksJsonData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<ProjectModel>>(
          future: readingSuggestedProjectJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              return FutureBuilder(
                future: readAllTasksJsonData(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Center(child: Text("${data.error}"));
                  } else if (data.hasData) {
                    return FutureBuilder(
                      future: readAllUsersJsonData(),
                      builder: (context, data) {
                        if (data.hasError) {
                          return Center(child: Text("${data.error}"));
                        } else if (data.hasData) {
                          return _buildSuggestedProjectList();
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
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

  Widget _buildSuggestedProjectList() {
    var suggestedProjectFilter = _suggestedProjects.where((element) =>
    element.status == 'Suggested',);

    return Scaffold(
      body: (suggestedProjectFilter.isEmpty)
          ? const Text(
        "No projects found!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 16,),)
          : ListView(
        children: suggestedProjectFilter
            .map((project) => Container(
            child: (project is ProjectModel)
                ? GestureDetector(
              onTap: (){
                ProjectBoardScreenMA(
                  selectedProject: project,
                  navigationMenu: NavigationMenu.projectScreen,
                ).launch(context);
              },
              child: ProjectDetailCardMA(
                projectTitle: project.projectName!,
                projectDescription: project.projectDescription == null? null : project.projectDescription!,
                projectProgressPercentage: project.progressPercentage == null? 0.0: project.progressPercentage!,

                projectTaskNumber: project.tasksNumber == null? 0 : project.tasksNumber!,
                projectTaskDone: _allTaskData!.where((element) => element.projectName == project.projectName && element.status == "Done" ).toList().isEmpty? 0 : _allTaskData!.where((element) => element.projectName == project.projectName && element.status == "Done" ).toList().length,
                projectTaskUnDone:_allTaskData!.where((element) => element.projectName == project.projectName && element.status != "Done" ).toList().isEmpty? 0 : _allTaskData!.where((element) => element.projectName == project.projectName && element.status != "Done" ).toList().length,

                projectStartDateTime: project.dueDate == null? null :  project.startDate!,
                projectDueDateTime: project.dueDate == null? null :  project.dueDate!,

                colour: labelColours![project.criticalityColour == null? 5 : project.criticalityColour!],

                totalProjectMembers: project.totalProjectMembers == null? 0 : project.totalProjectMembers!,

                projectManager: project.projectManager == null? null: project.projectManager!,
                projectLeader: project.projectLeader == null? null: project.projectLeader!,
                projectCoordinator: project.projectAssistantOrCoordinator == null? null: project.projectAssistantOrCoordinator!,

                projectManagerInfo: project.projectManager == null? null: _allUserData!.where((element) => element.username == project.projectManager).toList()[0],
                projectLeaderInfo: project.projectLeader == null? null: _allUserData!.where((element) => element.username == project.projectLeader).toList()[0],
                projectCoordinatorInfo: project.projectAssistantOrCoordinator == null? null: _allUserData!.where((element) => element.username == project.projectAssistantOrCoordinator).toList()[0],
              ),
            ) : null),).toList(),
      ),
    );
  }
}