import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectListViewBuilder extends StatefulWidget {
  final String username;

  const ProjectListViewBuilder({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _ProjectListViewBuilderState createState() => _ProjectListViewBuilderState();
}

class _ProjectListViewBuilderState extends State<ProjectListViewBuilder>
    with TickerProviderStateMixin {
  /// VARIABLES FOR ALL PROJECTS
  late List<ProjectModel> allProjects = <ProjectModel>[];

  Future<List<ProjectModel>> readingAllProjectJsonData() async {
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
      allProjects = projectModelFromJson(response.body).where((element) => element.members!.any((element) => element.memberUsername! == widget.username))
          .toList();

      return allProjects;
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

  @override
  void initState() {
    readAllUsersJsonData();
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
        child: FutureBuilder(
          future: readAllUsersJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              return FutureBuilder(
                future: readingAllProjectJsonData(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Center(child: Text("${data.error}"));
                  } else if (data.hasData) {
                    return _buildProjectList();
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

  Widget _buildProjectList() {
    var allProjectFilter = allProjects.where(
      (element) =>
          element.status == 'Open' &&
          element.members!
              .any((members) => members.memberUsername == widget.username),
    );

    return Scaffold(
      body: (allProjectFilter.isEmpty)
          ? const Text(
              "No projects found!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: allProjectFilter
                  .map(
                    (project) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 2.0),
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: (project is ProjectModel)
                            ? HomeProjectCard(
                                selectedProject: project,
                                projectTitle: project.projectName,
                                projectTaskNumber: project.tasksNumber == null? 0: project.tasksNumber!,
                                projectProgressPercentage:
                                project.progressPercentage == null? 0: project.progressPercentage!,
                                colour: project.criticalityColour == null? Colors.transparent:
                                    labelColours![project.criticalityColour!],
                          projectManager: project.projectManager == null? null: project.projectManager!,
                          projectLeader: project.projectLeader == null? null: project.projectLeader!,
                          projectCoordinator: project.projectAssistantOrCoordinator == null? null: project.projectAssistantOrCoordinator!,
                            totalProjectMembers: project.totalProjectMembers == null? null: project.totalProjectMembers!,
                          projectManagerInfo: project.projectManager == null? null: _allUserData!.singleWhere((element) => element.username == project.projectManager),
                          projectLeaderInfo: project.projectLeader == null? null: _allUserData!.singleWhere((element) => element.username == project.projectLeader),
                          projectCoordinatorInfo: project.projectAssistantOrCoordinator == null? null: _allUserData!.singleWhere((element) => element.username == project.projectAssistantOrCoordinator),
                              )
                            : null),
                  )
                  .toList(),
            ),
    );
  }
}
