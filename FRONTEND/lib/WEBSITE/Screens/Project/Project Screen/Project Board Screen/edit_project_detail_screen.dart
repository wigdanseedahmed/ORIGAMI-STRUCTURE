import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class EditProjectDetailScreenWS extends StatefulWidget {
  static const String id = 'project_board_edit_detail_screen';

  final UserModel selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const EditProjectDetailScreenWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _EditProjectDetailScreenWSState createState() =>
      _EditProjectDetailScreenWSState();
}

class _EditProjectDetailScreenWSState extends State<EditProjectDetailScreenWS>
    with TickerProviderStateMixin {
  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  /// VARIABLES FOR PROJECT
  ProjectModel readProjectJsonFileContent = ProjectModel();

  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readProjectData() async {
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

  Future<ProjectModel> writeProjectGeneralInformationJsonData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName!}");

    print(selectedProjectInformation);

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
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      readProjectJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
      return readProjectJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "General Information";

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _futureProjectInformation = readProjectData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
        : 1;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
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
            horizontal: MediaQuery.of(context).size.width / 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopBarMenuAfterLoginWS(
              isSelectedPage:
                  widget.navigationMenu == NavigationMenu.dashboardScreen
                      ? 'Dashboard'
                      : 'Projects',
              user: widget.selectedUser,
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

  late String selectedSideMenuItem = "Edit Information";
  late int selectedSideMenuItemInt = 4;

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
                                          selectedUser: widget.selectedUser,
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
              initialSelected: 4,
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
                  activeIcon: EvaIcons.map,
                  icon: EvaIcons.mapOutline,
                  title: "Location",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
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
                  activeIcon: EvaIcons.flag,
                  icon: EvaIcons.flagOutline,
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
                  activeIcon: EvaIcons.flag,
                  icon: EvaIcons.flagOutline,
                  title: "Donor",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.flag,
                  icon: EvaIcons.flagOutline,
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
    //print(readJsonFileContent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        EditProjectProfileAvatarWidgetWS(
          onClicked: () {},
          projectName: readProjectJsonFileContent.projectName!,
          imagePath: readProjectJsonFileContent.projectPhotoName == null
              ? null
              : readProjectJsonFileContent.projectPhotoName!,
        ),
        const SizedBox(height: 20),
        selectedMenuItem == "General Information"
            ? Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "NAME",
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 38),
                        SizedBox(
                          width: screenSize.width * 0.25,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 250,
                            autofocus: false,
                            cursorColor: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.grey[100]
                                : Colors.grey[600],
                            initialValue:
                                readProjectJsonFileContent.projectName == null
                                    ? ""
                                    : readProjectJsonFileContent.projectName!,
                            style: subTitleTextStyleMA,
                            decoration: InputDecoration(
                              //hintText: "Description",
                              //hintStyle: subTitleTextStyle,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            onChanged: (newName) {
                              setState(() {
                                readProjectJsonFileContent.projectName =
                                    newName;
                                _futureProjectInformation =
                                    writeProjectGeneralInformationJsonData(
                                        readProjectJsonFileContent);
                              });
                            },
                            onFieldSubmitted: (newName) {
                              setState(() {
                                readProjectJsonFileContent.projectName =
                                    newName;
                                _futureProjectInformation =
                                    writeProjectGeneralInformationJsonData(
                                        readProjectJsonFileContent);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                         Text(
                          "STATUS",
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: screenSize.width * 0.25,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter dropDownState) {
                              return DropdownSearch<String>(
                                popupElevation: 0.0,
                                showClearButton: true,
                                dropdownSearchDecoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                  labelStyle: subTitleTextStyleMA,
                                ),
                                ////dropdownButtonSplashRadius: 1.0,
                                //mode of dropdown
                                mode: Mode.MENU,
                                //to show search box
                                showSearchBox: true,
                                //list of dropdown items
                                items: projectStatusLabel,
                                onChanged: (String? newValue) {
                                  dropDownState(() {
                                    setState(() {
                                      readProjectJsonFileContent.status =
                                          newValue;
                                      _futureProjectInformation =
                                          writeProjectGeneralInformationJsonData(
                                              readProjectJsonFileContent);
                                    });
                                  });
                                },
                                //show selected item
                                selectedItem:
                                    readProjectJsonFileContent.status == null
                                        ? ""
                                        : readProjectJsonFileContent.status!,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 20),
            selectedProjectDetailSideMenuItem == "General Information"
                ? EditProjectGeneralInformationWS(
                    selectedUser: widget.selectedUser,
                    selectedProject: readProjectJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  )
                : selectedProjectDetailSideMenuItem == "Location"
                    ? EditProjectLocationsWS(
                        selectedUser: widget.selectedUser,
                        selectedProject: readProjectJsonFileContent,
                        navigationMenu: widget.navigationMenu,
                      )
                    : selectedProjectDetailSideMenuItem == "Skills Required"
                        ? EditProjectSkillsRequiredWS(
                            selectedUser: widget.selectedUser,
                            selectedProject: readProjectJsonFileContent,
                            navigationMenu: widget.navigationMenu,
                          )
                        : selectedProjectDetailSideMenuItem == "Members"
                            ? EditProjectMembersWS(
                                selectedUser: widget.selectedUser,
                                selectedProject: readProjectJsonFileContent,
                                navigationMenu: widget.navigationMenu,
                              )
                            : selectedProjectDetailSideMenuItem == "Milestones"
                                ? EditProjectMilestonesWS(
                                    selectedUser: widget.selectedUser,
                                    selectedProject: readProjectJsonFileContent,
                                    navigationMenu: widget.navigationMenu,
                                  )
                                : selectedProjectDetailSideMenuItem == "Phases"
                                    ? EditProjectPhasesWS(
                                        selectedUser: widget.selectedUser,
                                        selectedProject:
                                            readProjectJsonFileContent,
                                        navigationMenu: widget.navigationMenu,
                                      )
                                    : selectedProjectDetailSideMenuItem == "Resources"
                                        ? EditProjectResourcesWS(
                                            selectedUser: widget.selectedUser,
                                            selectedProject:
                                                readProjectJsonFileContent,
                                            navigationMenu:
                                                widget.navigationMenu,
                                          )
                                        : selectedProjectDetailSideMenuItem == "Budget"
                                            ? EditProjectBudgetWS(
                                                selectedUser:
                                                    widget.selectedUser,
                                                selectedProject:
                                                    readProjectJsonFileContent,
                                                navigationMenu:
                                                    widget.navigationMenu,
                                              )
                                            : selectedProjectDetailSideMenuItem == "Donor"
                                                ? EditProjectDonorsWS(
                                                    selectedUser:
                                                        widget.selectedUser,
                                                    selectedProject:
                                                        readProjectJsonFileContent,
                                                    navigationMenu:
                                                        widget.navigationMenu,
                                                  )
                                                : selectedProjectDetailSideMenuItem ==
                                                        "Executing Agency"
                                                    ? EditProjectExecutingAgencyWS(
                                                        selectedUser:
                                                            widget.selectedUser,
                                                        selectedProject:
                                                            readProjectJsonFileContent,
                                                        navigationMenu: widget
                                                            .navigationMenu,
                                                      )
                                                    : EditPeopleWhoAreAllowedToViewProjectWS(
                                                        selectedUser:
                                                            widget.selectedUser,
                                                        selectedProject:
                                                            readProjectJsonFileContent,
                                                        navigationMenu: widget
                                                            .navigationMenu,
                                                      ),
          ],
        ),
      ],
    );
  }
}
