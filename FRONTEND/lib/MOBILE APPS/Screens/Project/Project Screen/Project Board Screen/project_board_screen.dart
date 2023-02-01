import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectBoardScreenMA extends StatefulWidget {
  static const String id = 'project_board_screen';

  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectBoardScreenMA({
    Key? key,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _ProjectBoardScreenMAState createState() => _ProjectBoardScreenMAState();
}

class _ProjectBoardScreenMAState extends State<ProjectBoardScreenMA> {
  late List<String> tasksStatusList;

  //List<DraggableList> draggableList = [];
  //List<List<DraggableListItem>> draggableListItem = [];

  final TextEditingController _cardTextController = TextEditingController();
  bool isListEnable = false;
  bool isCardEnable = false;

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
  Future<List<TaskModel>>? _futureTasksListInformation;

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

  Future<TaskModel> updateTaskJsonData(
      TaskModel selectedTaskInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateTaskByTaskName}${selectedTaskInformation.taskName}");

    /// Create Request to get data and response to read data
    final response = await http.put(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
      body: json.encode(selectedTaskInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      return taskFromJson(response.body);
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

    readingProjectsJsonData();

    _futureTasksListInformation = readingTasksJsonData();

    super.initState();
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
      child: FutureBuilder<ProjectModel>(
        future: readingProjectsJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              tasksStatusList = readProjectsJsonFileContent.tasksStatusList!;
              //print(tasksStatusList);
              return FutureBuilder<List<TaskModel>>(
                future: _futureTasksListInformation, //readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Scaffold(
                        appBar: buildAppBar(context),
                        body: DragAndDropLists(
                          listPadding: const EdgeInsets.all(16),
                          listInnerDecoration: BoxDecoration(
                            color: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: buildProjectTaskList(),
                          itemDivider: Divider(
                            thickness: 10,
                            height: 10,
                            color: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? const Color.fromARGB(255, 243, 242, 248)
                                : Colors.grey.shade900,
                          ),
                          itemDecorationWhileDragging: BoxDecoration(
                            color: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.grey.shade800,
                            boxShadow: [
                              BoxShadow(
                                color: DynamicTheme.of(context)?.brightness ==
                                        Brightness.light
                                    ? Colors.black12
                                    : Colors.white12,
                                blurRadius: 4,
                              )
                            ],
                          ),
                          onItemReorder: (int oldItemIndex, int oldListIndex,
                              int newItemIndex, int newListIndex) async {
                            List<TaskModel> selectedTasks =
                                readTasksJsonFileContent
                                    .where((element) =>
                                        element.status ==
                                        tasksStatusList[oldListIndex])
                                    .toList();
                            selectedTasks[oldItemIndex].status =
                                tasksStatusList[newListIndex];

                            await updateTaskJsonData(
                                selectedTasks[oldItemIndex]);
                            setState(() {
                              _futureTasksListInformation =
                                  readingTasksJsonData();
                            });
                          },
                          onListReorder: onReorderList,
                          axis: Axis.horizontal,
                          listWidth: 330,
                          listDraggingWidth: 130,
                          listGhost: TextFormField(
                            autofocus: true,
                            cursorColor: primaryColour,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColour,
                            ),
                            onFieldSubmitted: (v) {
                              //_addList(_cardTextController.text.trim());
                              isListEnable = false;
                              setState(() {});
                            },
                            controller: _cardTextController,
                            decoration: commentTaskTextFieldInputDecoration(
                              hintText: 'Add List',
                              color: Colors.black,
                            ),
                          ),
                        ),
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
          widget.navigationMenu == NavigationMenu.dashboardScreen
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenMA(),
                  ),
                  (route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectScreenMA(),
                  ),
                  (route) => false);
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            toast('Coming Soon');
            //TODO: NotificationComponents().launch(context);
          },
          icon: Icon(
            Icons.notifications_none_outlined,
            color: primaryColour,
          ),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert_sharp,
            color: primaryColour,
          ),
          onSelected: (result) {
            if (result == 'About') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreenMA(
                    selectedProject: readProjectsJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  ),
                ),
              );
            } else if (result == 'Dashboard') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDashboardScreenMA(
                    selectedProject: readProjectsJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  ),
                ),
              );
            } else if (result == 'Timeline') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectTimelineScreenMA(
                    selectedProject: readProjectsJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  ),
                ),
              );
            } else if (result == 'Watch') {
              toast('Coming Soon');
            }
          },
          itemBuilder: (context) {
            List<PopupMenuEntry<Object>> list = [];
            list.add(
              const PopupMenuItem(
                value: 'Dashboard',
                child: Text('Dashboard'),
              ),
            );
            list.add(
              const PopupMenuItem(
                value: 'Timeline',
                child: Text('Timeline'),
              ),
            );
            list.add(
              const PopupMenuItem(
                value: 'About',
                child: Text('About'),
              ),
            );
            list.add(
              const PopupMenuItem(
                value: 'Watch',
                child: Text('Watch'),
              ),
            );
            return list;
          },
        ),
      ],
    );
  }

  buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? primaryColour : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.more_horiz, color: color),
      ),
    );
  }

  buildProjectTaskList() {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return readProjectsJsonFileContent.tasksStatusList!.map(
      (taskStatus) {
        return DragAndDropList(
          header: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                taskStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primaryColour,
                ),
              ),
              const Divider(),
            ],
          ),
          children: readTasksJsonFileContent
              .where((element) => element.status == taskStatus)
              .toList()
              .map(
            (task) {
              //print(task);
              return DragAndDropItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditTaskScreenMA(
                            projectName:
                                readProjectsJsonFileContent.projectName,
                            taskTitle: task.taskName!,
                            listStatus: taskStatus,
                            checkListItem: task.checklist,
                            selectedProject: readProjectsJsonFileContent,
                            navigationMenu: NavigationMenu.projectBoardScreen,
                          );
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(task.taskName!),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: Row(
                        children: [
                          task.criticalityColour == null
                              ? Container()
                              : Container(
                                  height: 20,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        labelColours![task.criticalityColour!],
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1,
                                      color: labelColours![
                                          task.criticalityColour!],
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 55.0),
                          task.percentageDone == null
                              ? Container()
                              : Text(
                                  "${task.percentageDone}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                          const SizedBox(width: 55.0),
                          task.checklist == null
                              ? Container()
                              : Row(
                                  children: [
                                    const Icon(
                                      Icons.checklist_outlined,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "${task.checklist!.length}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          footer: Column(
            children: <Widget>[
              const Divider(),
              GestureDetector(
                onTap: () {
                  var newTask = TaskModel()
                    ..projectName = readProjectsJsonFileContent.projectName
                    ..projectStatus = readProjectsJsonFileContent.status
                    ..projectDeadline = readProjectsJsonFileContent.dueDate
                    ..projectType = readProjectsJsonFileContent.typeOfProject
                    ..projectLeader = readProjectsJsonFileContent.projectLeader
                    ..assignedBy = UserProfile.username
                    ..status = taskStatus
                    ..dateCreated = DateTime.now();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddNewTaskScreenMA(
                          newTask: newTask,
                          selectedProject: readProjectsJsonFileContent,
                          navigationMenu: widget.navigationMenu,
                        );
                      },
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color: primaryColour,
                  ),
                  title: Text(
                    'Add Task',
                    style: TextStyle(
                      color: primaryColour,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  void onReorderList(int oldListIndex, int newListIndex) {
    setState(() {
      final movedList = buildProjectTaskList().removeAt(
          oldListIndex); //draggableList.map(buildTaskList).toList().removeAt(oldListIndex);
      buildProjectTaskList().insert(newListIndex, movedList);
      print(tasksStatusList[oldListIndex]);
      print(tasksStatusList[newListIndex]);
      //draggableList.map(buildTaskList).toList().insert(newListIndex, movedList);
    });
  }

  void onReorderListItem(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      // final oldListTasks = draggableList.map(buildTaskList).toList()[oldListIndex].children;
      // final newListTasks = draggableList.map(buildTaskList).toList()[newListIndex].children;

      final oldListTasks = buildProjectTaskList()[oldListIndex].children;
      final newListTasks = buildProjectTaskList()[newListIndex].children;

      final movedItem = oldListTasks.removeAt(oldItemIndex);
      newListTasks.insert(newItemIndex, movedItem);
      print(tasksStatusList[oldListIndex]);
      print(tasksStatusList[newListIndex]);
    });
  }
}
