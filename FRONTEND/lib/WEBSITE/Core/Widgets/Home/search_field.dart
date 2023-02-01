import 'package:origami_structure/imports.dart';

class SearchField extends StatelessWidget {
  SearchField({required this.onSearch, Key? key}) : super(key: key);

  final controller = TextEditingController();
  final Function(String value)? onSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(EvaIcons.search),
        hintText: "Search..",
        isDense: true,
        fillColor: Theme.of(context).cardColor,
      ),
      /*onEditingComplete: () {
        FocusScope.of(context).unfocus();
        if (onSearch != null) onSearch!(controller.text);
        // print(onSearch);
      },*/
      onChanged: onSearch,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Color.fromRGBO(210, 210, 210, 1)),
    );
  }
}

///---------------------------------------- HOME SCREEN ----------------------------------------///

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    Key? key,
    this.taskList,
    this.allUsersData,
    this.allProjectsData,
  }) : super(key: key);

  final List<TaskModel>? taskList;
  final List<UserModel>? allUsersData;
  final List<ProjectModel>? allProjectsData;

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final FocusNode focusNode = FocusNode();
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();

  late List<TaskModel> filteredTaskList = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (!focusNode.hasFocus) {
        controller.text = '';
        filteredTaskList.clear();
      }
    });

    // OPTIMIZE THIS
    controller.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createOverlayEntry();
        Overlay.of(context)!.insert(overlayEntry!);
      } else {
        overlayEntry!.remove();
      }
      setState(() {});
    });
  }

  OverlayEntry createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: TransformFollower(
          offset: Offset(0.0, size.height + 5),
          link: layerLink,
          child: Material(
            elevation: 1.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            child: filteredTaskList.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: filteredTaskList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCardWS(
                          allUserData: widget.allUsersData!,
                          taskData: filteredTaskList[index],
                          onTap: () {
                            overlayEntry!.remove();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) => EditTaskScreenWS(
                                selectedProject: widget.allProjectsData!
                                    .where((element) =>
                                        element.projectName ==
                                        filteredTaskList[index].projectName)
                                    .toList()[0],
                                taskTitle: filteredTaskList[index].taskName,
                                projectName: filteredTaskList[index].projectName,
                                listStatus: filteredTaskList[index].status,
                                checkListItem: filteredTaskList[index].checklist,
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
                        );
                      },
                    ),
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    // debugPrint('>>> ${searchCommand.searchedResults.toString()}');

    return CompositedTransformTarget(
      link: layerLink,
      child: RoundedShape(
        textController: controller,
        bgColor: Colors.white,
        iconColor: primaryColour,
        focusNode: focusNode,
        cursorColor: primaryColour,
        textColor: Colors.black,
        onChanged: (term) => setState(() {
          filteredTaskList = widget.taskList!
              .where((element) =>
                  element.taskName!.toLowerCase().contains(term.toLowerCase()))
              .toList();
        }),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    // controller?.dispose();
    super.dispose();
  }
}

///---------------------------------------- ALL PROJECTS SCREEN ----------------------------------------///

class AllProjectsSearchBar extends StatefulWidget {
  const AllProjectsSearchBar({
    Key? key,
    this.allUsersData,
    this.allProjectsData,
  }) : super(key: key);

  final List<UserModel>? allUsersData;
  final List<ProjectModel>? allProjectsData;

  @override
  _AllProjectsSearchBarState createState() => _AllProjectsSearchBarState();
}

class _AllProjectsSearchBarState extends State<AllProjectsSearchBar> {
  final FocusNode focusNode = FocusNode();
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();

  late List<ProjectModel> filteredProjectList = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (!focusNode.hasFocus) {
        controller.text = '';
        filteredProjectList.clear();
      }
    });

    // OPTIMIZE THIS
    controller.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createOverlayEntry();
        Overlay.of(context)!.insert(overlayEntry!);
      } else {
        overlayEntry!.remove();
      }
      setState(() {});
    });
  }

  OverlayEntry createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: filteredProjectList.isEmpty
            ? Container()
            : TransformFollower(
                offset: Offset(0.0, size.height + 5),
                link: layerLink,
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: filteredProjectList.length,
                    itemBuilder: (BuildContext context, int index) { return ProjectCardWS(
                      projectTitle: filteredProjectList[index].projectName,
                      projectDescription: filteredProjectList[index].projectDescription,
                      projectDueDateTime: filteredProjectList[index].dueDate,
                      projectTaskNumber: filteredProjectList[index].tasksNumber,
                      projectProgressPercentage: filteredProjectList[index].progressPercentage,
                      projectManager: filteredProjectList[index].projectManager,
                      projectLeader: filteredProjectList[index].projectLeader,
                      projectCoordinator: filteredProjectList[index].projectAssistantOrCoordinator,
                      totalProjectMembers: filteredProjectList[index].totalProjectMembers,
                      projectManagerInfo: widget.allUsersData!.where((element) => element.username == filteredProjectList[index].projectManager).toList()[0],
                      projectLeaderInfo: widget.allUsersData!.where((element) => element.username == filteredProjectList[index].projectLeader).toList()[0],
                      projectCoordinatorInfo: widget.allUsersData!.where((element) => element.username == filteredProjectList[index].projectAssistantOrCoordinator).toList()[0],
                      projectTaskDone: filteredProjectList[index].doneTasksCount,
                      projectTaskUnDone: filteredProjectList[index].todoTasksCount! + filteredProjectList[index].inProgressTasksCount!,
                      projectStartDateTime: filteredProjectList[index].startDate,
                    ); },
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    // debugPrint('>>> ${searchCommand.searchedResults.toString()}');

    return CompositedTransformTarget(
      link: layerLink,
      child: RoundedShape(
        textController: controller,
        bgColor: Colors.white,
        iconColor: primaryColour,
        focusNode: focusNode,
        cursorColor: primaryColour,
        textColor: Colors.black,
        onChanged: (term) => setState(() {
          filteredProjectList = widget.allProjectsData!
              .where((element) => element.projectName!
                  .toLowerCase()
                  .contains(term.toLowerCase()))
              .toList();
        }),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}

///---------------------------------------- COMMON ----------------------------------------///

class TransformFollower extends StatelessWidget {
  const TransformFollower({
    Key? key,
    required this.child,
    required this.offset,
    this.link,
  }) : super(key: key);

  final Widget child;
  final LayerLink? link;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      offset: offset,
      link: link!,
      showWhenUnlinked: false,
      child: child,
    );
  }
}

class RoundedShape extends StatefulWidget {
  ///Creates the rounded shape widget..
  const RoundedShape({
    Key? key,
    required this.bgColor,
    this.iconColor = Colors.white,
    this.cursorColor = Colors.white,
    this.textColor = Colors.white,
    this.onChanged,
    this.focusNode,
    this.initialValue = '',
    this.textController,
  }) : super(key: key);

  final Color? bgColor;
  final Color? iconColor;
  final Color? cursorColor;
  final Color? textColor;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextEditingController? textController;

  String? get _initValue => initialValue;

  TextEditingController? get _widgetTextController => _textController;

  TextEditingController? get _textController {
    if (textController != null) {
      return textController;
    }
    return null;
  }

  @override
  _RoundedShapeState createState() => _RoundedShapeState();
}

class _RoundedShapeState extends State<RoundedShape> {
  FocusNode? get _focusNode => _checkFocusNode;

  FocusNode? get _checkFocusNode => widget.focusNode;
  final _debouncer = Debouncer(milliseconds: 0);
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget._initValue);
  }

  @override
  Widget build(BuildContext context) {
    //
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 0.5),
              blurRadius: 5.0,
              spreadRadius: 0.3,
            )
          ],
        ),
        width: 0.35 * width,
        child: TextField(
          controller: widget._widgetTextController ?? _textController,
          cursorColor: widget.cursorColor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 13.0,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: widget.iconColor,
              size: 18.0,
            ),
          ),
          focusNode: _focusNode,
          onChanged: (val) {
            _debouncer.run(() {
              if (widget.onChanged != null) widget.onChanged!(val);
            });
          },
          style: TextStyle(color: widget.textColor),
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
