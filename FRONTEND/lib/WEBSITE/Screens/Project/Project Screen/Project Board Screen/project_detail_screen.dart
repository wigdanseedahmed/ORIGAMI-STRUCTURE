import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class ProjectDetailScreenWS extends StatefulWidget {
  static const String id = 'project_board_detail_screen';

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectDetailScreenWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _ProjectDetailScreenWSState createState() => _ProjectDetailScreenWSState();
}

class _ProjectDetailScreenWSState extends State<ProjectDetailScreenWS>
    with TickerProviderStateMixin {
  ///VARIABLES USED TO RETRIEVE AND FILTER THROUGH DATA FROM BACKEND

  late String? typeOfIntervention = "";

  TextEditingController taskSearchBarTextEditingController =
      TextEditingController();

  /// VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;

  /// VARIABLES USED TO RETRIEVE AND FILTER THROUGH PROJECT MAP LOCATION FROM BACKEND
  late AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 750));
  late CurvedAnimation _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  late MapZoomPanBehavior _zoomPanBehavior =
      MapZoomPanBehavior(minZoomLevel: 6.0);

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "General Information";

  /// VARIABLES FOR PROJECT
  ProjectModel readProjectJsonFileContent = ProjectModel();

  Future<ProjectModel> readProjectInformationJsonData() async {
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

  @override
  void initState() {
    readProjectInformationJsonData();

    /// VARIABLES USED FORT MAP LOCATION
    _zoomPanBehavior = MapZoomPanBehavior(minZoomLevel: 6.0);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.repeat(min: 0.15, max: 1.0, reverse: true);

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectInformationJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                body: buildBody(context, screenSize),
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

  buildBody(BuildContext context, Size screenSize) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopBarMenuAfterLoginWS(
              isSelectedPage:
                  widget.navigationMenu == NavigationMenu.dashboardScreen
                      ? 'Dashboard'
                      : 'Projects',
              user: widget.selectedUser!,
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: ResponsiveWidget.isLargeScreen(context) ? 2 : 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: buildSideMenu(),
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: buildBodyCentre(context, screenSize),
                ),
                Flexible(
                  flex: ResponsiveWidget.isLargeScreen(context) ? 2 : 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: buildProjectDetailSideMenu(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  late String selectedSideMenuItem = "About";
  late int selectedSideMenuItemInt = 3;

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
                              selectedUser: widget.selectedUser!,
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
                              : value.title == "About"
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailScreenWS(
                                          selectedUser: widget.selectedUser,
                                          selectedProject:
                                              widget.selectedProject,
                                          navigationMenu: widget.navigationMenu,
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProjectDetailScreenWS(
                                          selectedUser: widget.selectedUser!,
                                          selectedProject:
                                              widget.selectedProject,
                                          navigationMenu: widget.navigationMenu,
                                        ),
                                      ),
                                    );

                  // selectedSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: 3,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  late String selectedProjectDetailSideMenuItem = "General Information";
  late int selectedProjectDetailSideMenuItemInt = 0;

  buildProjectDetailSideMenu() {
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
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "General Information",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.pin,
                  icon: EvaIcons.pinOutline,
                  title: "Location",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  title: "Skills Required",
                  totalNotification: null,
                ),
                readProjectJsonFileContent.status != "Suggested"
                    ? SelectionButtonData(
                        activeIcon: EvaIcons.people,
                        icon: EvaIcons.peopleOutline,
                        title: "Members",
                        totalNotification: null,
                      )
                    : SelectionButtonData(
                        activeIcon: EvaIcons.people,
                        icon: EvaIcons.peopleOutline,
                        title: "People Allowed to View Project",
                        totalNotification: null,
                      ),
                SelectionButtonData(
                  activeIcon: EvaIcons.flag,
                  icon: EvaIcons.flagOutline,
                  title: "Milestones",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.flag,
                  icon: EvaIcons.flagOutline,
                  title: "Phases",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.layers,
                  icon: EvaIcons.layersOutline,
                  title: "Resources",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: Icons.monetization_on,
                  icon: Icons.monetization_on_outlined,
                  title: "Budget",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  title: "Donors",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  title: "Executing Agency",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedProjectDetailSideMenuItem = value.title;

                  selectedProjectDetailSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: selectedProjectDetailSideMenuItemInt,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  buildBodyCentre(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        readProjectJsonFileContent.projectPhotoFile == null
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 250.0,
                    width: screenSize.width - 40.0,
                    color: const Color.fromRGBO(202, 202, 202, 1),
                    child: Center(
                      child: Text(
                        readProjectJsonFileContent.projectName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 8,
                          fontFamily: 'Electrolize',
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(76, 75, 75, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.memory(
                    base64Decode(readProjectJsonFileContent.projectPhotoFile!),
                    height: 250.0,
                    width: screenSize.width - 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        const SizedBox(height: 20),
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                readProjectJsonFileContent.projectName!,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: screenSize.width * 0.03,
                ),
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.access_time_sharp,
                  size: 15,
                  color: primaryColour,
                ),
                const SizedBox(width: 3),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${readProjectJsonFileContent.duration == null ? 0 : readProjectJsonFileContent.duration!} Weeks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.01,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: primaryColour,
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Priority: ${impactLabel![readProjectJsonFileContent.criticalityColour == null ? 0 : readProjectJsonFileContent.criticalityColour!]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.01,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: primaryColour,
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Status: ${readProjectJsonFileContent.status == null ? "Unknown" : readProjectJsonFileContent.status!}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.01,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            selectedProjectDetailSideMenuItem == "General Information"
                ? ProjectGeneralInformationWS(
                    selectedUser: widget.selectedUser,
                    selectedProject: readProjectJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  )
                : selectedProjectDetailSideMenuItem == "Location"
                    ? ProjectLocationsWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: readProjectJsonFileContent,
                        navigationMenu: widget.navigationMenu,
                      )
                    : selectedProjectDetailSideMenuItem == "Skills Required"
                        ? ProjectSkillsRequiredWS(
                            selectedUser: widget.selectedUser,
                            selectedProject: readProjectJsonFileContent,
                            navigationMenu: widget.navigationMenu,
                          )
                        : selectedProjectDetailSideMenuItem == "Members"
                            ? ProjectMembersWS(
                                selectedUser: widget.selectedUser,
                                selectedProject: readProjectJsonFileContent,
                                navigationMenu: widget.navigationMenu,
                              )
                            : selectedProjectDetailSideMenuItem == "Milestones"
                                ? ProjectMilestonesWS(
                                    selectedUser: widget.selectedUser,
                                    selectedProject: readProjectJsonFileContent,
                                    navigationMenu: widget.navigationMenu,
                                  )
                                : selectedProjectDetailSideMenuItem == "Phases"
                                    ? ProjectPhasesWS(
                                        selectedUser: widget.selectedUser,
                                        selectedProject:
                                            readProjectJsonFileContent,
                                        navigationMenu: widget.navigationMenu,
                                      )
                                    : selectedProjectDetailSideMenuItem ==
                                            "Resources"
                                        ? ProjectResourcesWS(
                                            selectedUser: widget.selectedUser,
                                            selectedProject:
                                                readProjectJsonFileContent,
                                            navigationMenu:
                                                widget.navigationMenu,
                                          )
                                        : selectedProjectDetailSideMenuItem ==
                                                "Budget"
                                            ? ProjectBudgetWS(
                                                selectedUser:
                                                    widget.selectedUser,
                                                selectedProject:
                                                    readProjectJsonFileContent,
                                                navigationMenu:
                                                    widget.navigationMenu,
                                              )
                                            : selectedProjectDetailSideMenuItem ==
                                                    "Donors"
                                                ? ProjectDonorWS(
                                                    selectedUser:
                                                        widget.selectedUser,
                                                    selectedProject:
                                                        readProjectJsonFileContent,
                                                    navigationMenu:
                                                        widget.navigationMenu,
                                                  )
                                                : selectedProjectDetailSideMenuItem ==
                                                        "Executing Agency"
                                                    ? ProjectExecutingAgencyWS(
                                                        selectedUser:
                                                            widget.selectedUser,
                                                        selectedProject:
                                                            readProjectJsonFileContent,
                                                        navigationMenu: widget
                                                            .navigationMenu,
                                                      )
                                                    : PeopleWhoAreAllowedToViewProjectWS(
                                                        selectedUser:
                                                            widget.selectedUser,
                                                        selectedProject:
                                                            readProjectJsonFileContent,
                                                        navigationMenu: widget
                                                            .navigationMenu,
                                                      ),
          ],
        )
      ],
    );
  }
}
