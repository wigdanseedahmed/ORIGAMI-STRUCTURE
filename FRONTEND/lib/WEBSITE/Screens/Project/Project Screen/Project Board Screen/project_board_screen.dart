import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectBoardScreenWS extends StatefulWidget {
  static const String id = 'project_board_screen';

  final UserModel selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectBoardScreenWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _ProjectBoardScreenWSState createState() => _ProjectBoardScreenWSState();
}

class _ProjectBoardScreenWSState extends State<ProjectBoardScreenWS> {
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
  late ProjectModel readProjectJsonFileContent = ProjectModel();

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
      readProjectJsonFileContent = projectModelFromJson(response.body)
          .where((element) =>
              element.projectName == widget.selectedProject!.projectName)
          .toList()[0];
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

      return readProjectJsonFileContent;
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

  Future<TaskModel> updateTaskJsonData(TaskModel selectedTaskInformation) async {
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
              tasksStatusList =
              readProjectJsonFileContent.tasksStatusList!;
              //print(tasksStatusList);
              return FutureBuilder<List<TaskModel>>(
                future: _futureTasksListInformation,
                //readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Scaffold(
                        // appBar: buildAppBar(context),
                        body: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width /
                                  10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TopBarMenuAfterLoginWS(
                                isSelectedPage: widget.navigationMenu ==
                                    NavigationMenu.dashboardScreen
                                    ? 'Dashboard'
                                    : 'Projects',
                                user: widget.selectedUser,
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex:
                                    ResponsiveWidget.isLargeScreen(
                                        context)
                                        ? 2
                                        : 1,
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight:
                                        Radius.circular(20),
                                      ),
                                      child: buildSideMenu(),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 9,
                                    child: SizedBox(
                                      height: screenSize.height * 0.8,
                                      child: DragAndDropLists(
                                        listPadding:
                                        const EdgeInsets.all(16),
                                        listInnerDecoration:
                                        BoxDecoration(
                                          color: DynamicTheme.of(
                                              context)
                                              ?.brightness ==
                                              Brightness.light
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        children:
                                        buildProjectTaskList(),
                                        itemDivider: Divider(
                                          thickness: 10,
                                          height: 10,
                                          color: DynamicTheme.of(
                                              context)
                                              ?.brightness ==
                                              Brightness.light
                                              ? const Color.fromARGB(
                                              255, 243, 242, 248)
                                              : Colors.grey.shade900,
                                        ),
                                        itemDecorationWhileDragging:
                                        BoxDecoration(
                                          color: DynamicTheme.of(
                                              context)
                                              ?.brightness ==
                                              Brightness.light
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                          boxShadow: [
                                            BoxShadow(
                                              color: DynamicTheme.of(
                                                  context)
                                                  ?.brightness ==
                                                  Brightness.light
                                                  ? Colors.black12
                                                  : Colors.white12,
                                              blurRadius: 4,
                                            )
                                          ],
                                        ),
                                        onItemReorder: (int
                                        oldItemIndex,
                                            int oldListIndex,
                                            int newItemIndex,
                                            int newListIndex) async {
                                          List<TaskModel>
                                          selectedTasks =
                                          readTasksJsonFileContent
                                              .where((element) =>
                                          element.status ==
                                              tasksStatusList[
                                              oldListIndex])
                                              .toList();
                                          selectedTasks[oldItemIndex]
                                              .status =
                                          tasksStatusList[
                                          newListIndex];

                                          await updateTaskJsonData(
                                              selectedTasks[
                                              oldItemIndex]);
                                          setState(() {
                                            _futureTasksListInformation =
                                                readingTasksJsonData();
                                          });
                                        },
                                        onListReorder: onReorderList,
                                        axis: Axis.horizontal,
                                        listWidth:
                                        screenSize.width * 0.16,
                                        listDraggingWidth:
                                        screenSize.width * 0.1,
                                        listGhost: TextFormField(
                                          autofocus: true,
                                          cursorColor: primaryColour,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: screenSize.width *
                                                0.002,
                                            color: primaryColour,
                                          ),
                                          onFieldSubmitted: (v) {
                                            //_addList(_cardTextController.text.trim());
                                            isListEnable = false;
                                            setState(() {});
                                          },
                                          controller:
                                          _cardTextController,
                                          decoration:
                                          commentTaskTextFieldInputDecoration(
                                            hintText: 'Add List',
                                            color: Colors.black,
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

  late String selectedSideMenuItem = "Board";
  late int selectedSideMenuItemInt = 0;

  buildSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.folder,
                  icon: EvaIcons.folderOutline,
                  title: "Board",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.closeSquare,
                  icon: EvaIcons.closeSquareOutline,
                  title: "Dashboard",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.archiveOutline,
                  title: "Timeline",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "About",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.edit,
                  icon: EvaIcons.editOutline,
                  title: "Edit Information",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedSideMenuItem = value.title;

                  value.title == "Board"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectBoardScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : value.title == "Dashboard"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectDashboardScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : value.title == "Timeline"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectTimelineScreenWS(
                            selectedUser: widget.selectedUser,
                            selectedProject: widget.selectedProject,
                            navigationMenu: widget.navigationMenu,
                          ),
                    ),
                  )
                      :value.title == "About"
                      ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  )
                      : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProjectDetailScreenWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: widget.selectedProject,
                        navigationMenu: widget.navigationMenu,
                      ),
                    ),
                  );

                  // selectedSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: 0,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
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

    return readProjectJsonFileContent.tasksStatusList!.map(
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => EditTaskScreenWS(
                        projectName: readProjectJsonFileContent.projectName,
                        taskTitle: task.taskName!,
                        listStatus: taskStatus,
                        checkListItem: task.checklist,
                        selectedProject: readProjectJsonFileContent,
                        navigationMenu: NavigationMenu.projectBoardScreen,
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      task.taskName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        bottom: 7.0,
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
                          SizedBox(width: screenSize.width * 0.015),
                          task.percentageDone == null
                              ? Container()
                              : Text(
                                  "${task.percentageDone}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                          SizedBox(width: screenSize.width * 0.015),
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
                                        fontSize: 12,
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
                    ..projectName = readProjectJsonFileContent.projectName
                    ..projectStatus = readProjectJsonFileContent.status
                    ..projectDeadline = readProjectJsonFileContent.dueDate
                    ..projectType = readProjectJsonFileContent.typeOfProject
                    ..projectLeader = readProjectJsonFileContent.projectLeader
                    ..assignedBy = UserProfile.username
                    ..status = taskStatus
                    ..dateCreated = DateTime.now();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddNewTaskScreenWS(
                          newTask: newTask,
                          selectedProject: readProjectJsonFileContent,
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
